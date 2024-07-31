#include <cuda_runtime.h>
#include <mma.h>
#include <cuda/pipeline>
#include <iostream>
#include <vector>
#include <random>
#include <algorithm>
#include <cmath>
#include <chrono>
#include "helpers.cu"
#include <iostream>
#include <vector>
#include <cstdint>
#include "configs.cu"
#include "cublas_v2.h"

#define div_ru(a, b) (((a) + (b) - 1) / (b))

#define WARP_SIZE 32
#define DEBUG false

// M is not constexpr-d because tokens * batch can vary, but the rest of the problem size is fixed for specific configs
template <int BlockRowWarps, int BlockColWarps, int WarpRowTiles, int WarpColTiles, int PatchM, int PatchN, int ChunkK, int NumStages, int PipelineStrategy, int kWMMA_M, int kWMMA_N, int kWMMA_K, int kN, int kK>
struct IGemmConfig
{
    static constexpr int kBlockRowWarps = BlockRowWarps;
    static constexpr int kBlockColWarps = BlockColWarps;
    static constexpr int kWarpRowTiles = WarpRowTiles;
    static constexpr int kWarpColTiles = WarpColTiles;
    static constexpr int kChunkK = ChunkK;
    static constexpr int kNumStages = NumStages;
    static constexpr int kPipelineStrategy = PipelineStrategy;

    static constexpr int kPatchM = PatchM;
    static constexpr int kPatchN = PatchN;

    // Derived constants
    static constexpr int kBlockRowTiles = kWarpRowTiles * kBlockRowWarps;
    static constexpr int kBlockColTiles = kWarpColTiles * kBlockColWarps;

    static constexpr int kTileSizeM = kWMMA_M * kBlockRowTiles;
    static constexpr int kTileSizeN = kWMMA_N * kBlockColTiles;
    static constexpr int kTileSizeK = kWMMA_K * kChunkK;

    static constexpr int K = kK;
    static constexpr int N = kN;
    static constexpr int WMMA_M = kWMMA_M;
    static constexpr int WMMA_N = kWMMA_N;
    static constexpr int WMMA_K = kWMMA_K;
};

// 128-bit vector type for efficient memory loads
using Data128B = int4;
using Data64B = int2;
constexpr int ALIGN_SIZE_A = 16;
constexpr int ALIGN_SIZE_B = 32;
#define PRESHUFFLE false

template <typename Config>
__global__ void igemm(const int8_t *A, const uint8_t *B, int32_t *C, int M)
{
    extern __shared__ int8_t shared_memory[];

    using FragA = nvcuda::wmma::fragment<nvcuda::wmma::matrix_a, Config::WMMA_M, Config::WMMA_N, Config::WMMA_K, int8_t, nvcuda::wmma::row_major>;
    using FragB = nvcuda::wmma::fragment<nvcuda::wmma::matrix_b, Config::WMMA_M, Config::WMMA_N, Config::WMMA_K, int8_t, nvcuda::wmma::col_major>;
    using FragC = nvcuda::wmma::fragment<nvcuda::wmma::accumulator, Config::WMMA_M, Config::WMMA_N, Config::WMMA_K, int32_t>;

    // Set up shared memory tensors for A and B with multiple stages
    SmemTensor3D<int8_t, Config::kNumStages, Config::kTileSizeM, Config::kTileSizeK>
        smemA(shared_memory);
    SmemTensor3D<uint8_t, Config::kNumStages, Config::kTileSizeN, Config::kTileSizeK / 2> smemB(smemA.endPtr);

    // Set up global memory tensors for A, B, and C
    GMemTensor2D<int8_t> gmemA((int8_t *)A, M, Config::K);
    GMemTensor2D<uint8_t> gmemB((uint8_t *)B, Config::N, Config::K / 2); // Note: B is transposed and bit packed int4
    GMemTensor2D<int32_t> gmemC(C, M, Config::N);

    // Calculate warp and lane IDs
    int warp_id = threadIdx.x / WARP_SIZE;
    // int warp_row = warp_id / Config::kBlockColWarps;
    // int warp_col = warp_id % Config::kBlockColWarps;

    int warp_row = warp_id / (Config::kBlockColWarps / Config::kPatchN);
    int warp_col = warp_id % (Config::kBlockColWarps / Config::kPatchN);

    // Calculate starting positions for this block
    int block_row_start = blockIdx.x * Config::kTileSizeM;
    int block_col_start = blockIdx.y * Config::kTileSizeN;

    FragA a_frag[Config::kPatchM][Config::kWarpRowTiles];
    FragB b_frag[Config::kPatchN][Config::kWarpColTiles];
    FragC c_frag[Config::kPatchM][Config::kPatchN][Config::kWarpRowTiles][Config::kWarpColTiles];

    for (int pm = 0; pm < Config::kPatchM; pm++)
    {

        for (int pn = 0; pn < Config::kPatchN; pn++)
        {

            for (int i = 0; i < Config::kWarpRowTiles; i++)
            {

                for (int j = 0; j < Config::kWarpColTiles; j++)
                {
                    nvcuda::wmma::fill_fragment(c_frag[pm][pn][i][j], 0);
                }
            }
        }
    }

    auto load_A_tile = [&](int stage, int k_offset)
    {
        for (int i = threadIdx.x; i < (Config::kTileSizeM * Config::kTileSizeK) / ALIGN_SIZE_A; i += blockDim.x)
        {
            int row = (i * ALIGN_SIZE_A) / Config::kTileSizeK;
            int col = (i * ALIGN_SIZE_A) % Config::kTileSizeK;
            if (block_row_start + row < M && k_offset + col + ALIGN_SIZE_A - 1 < Config::K)
            {
                int8_t *shared_ptr = smemA.get_ptr(stage, row, col);
                int8_t *global_ptr = gmemA.get_ptr(block_row_start + row, k_offset + col);
                __pipeline_memcpy_async(shared_ptr, global_ptr, ALIGN_SIZE_A);
            }
        }
    };

    auto load_B_tile = [&](int stage, int k_offset)
    {
        for (int i = threadIdx.x; i < (Config::kTileSizeN * Config::kTileSizeK) / ALIGN_SIZE_B; i += blockDim.x)
        {
            int row = (i * ALIGN_SIZE_B) / Config::kTileSizeK;
            int col = (i * ALIGN_SIZE_B) % Config::kTileSizeK;
            int global_row = block_col_start + row;
            int global_col = k_offset + col;

            if (global_row < Config::N && global_col < Config::K)
            {
                uint8_t *shared_ptr = smemB.get_ptr(stage, row, col / 2);
                uint8_t *global_ptr = gmemB.get_ptr(global_row, global_col / 2);
                __pipeline_memcpy_async(shared_ptr, global_ptr, ALIGN_SIZE_B / 2);
            }
        }
    };

    auto store_C_tile = [&]()
    {
        for (int pm = 0; pm < Config::kPatchM; pm++)
        {

            for (int pn = 0; pn < Config::kPatchN; pn++)
            {

                for (int i = 0; i < Config::kWarpRowTiles; i++)
                {

                    for (int j = 0; j < Config::kWarpColTiles; j++)
                    {
                        int row = block_row_start + ((warp_row * Config::kPatchM + pm) * Config::kWarpRowTiles + i) * Config::WMMA_M;
                        int col = block_col_start + ((warp_col * Config::kPatchN + pn) * Config::kWarpColTiles + j) * Config::WMMA_N;

                        if (row < M && col < Config::N)
                        {
                            nvcuda::wmma::store_matrix_sync(
                                gmemC.get_ptr(row, col),
                                c_frag[pm][pn][i][j],
                                Config::N,
                                nvcuda::wmma::mem_row_major);
                        }
                    }
                }
            }
        }
        __syncthreads();
    };

    auto unpack_and_load_frag = [&](int stage, int warp_col, int pn, int j, int kk)
    {
        const uint8_t *packed_ptr = smemB.get_ptr(stage,
                                                  warp_col * Config::kWarpColTiles * Config::WMMA_N + j * Config::WMMA_N,
                                                  kk / 2);
        int lane_id = threadIdx.x % WARP_SIZE;
        constexpr int numel = b_frag[pn][j].num_elements / 2;

        constexpr size_t tile_size = Config::WMMA_K * Config::WMMA_N / 2 * Config::kChunkK;

        // I don't know why this works, but it does.
        constexpr int factor = ((Config::kChunkK - 1) * 16);
        const int shift = (lane_id / 4) * factor;

        const int base1 = lane_id * numel + shift;
        const int base2 = tile_size + base1;

        for (int packed_idx = base1; packed_idx < base1 + numel; packed_idx++)
        {
            uint8_t packed = packed_ptr[packed_idx / 2];
            if (packed_idx % 2 == 0)
            {
                b_frag[pn][j].x[packed_idx - base1] = (packed & 0x0F) - 8;
            }
            else
            {
                b_frag[pn][j].x[packed_idx - base1] = (packed >> 4) - 8;
            }
        }
        for (int packed_idx = base2; packed_idx < base2 + numel; packed_idx++)
        {
            uint8_t packed = packed_ptr[packed_idx / 2];
            if (packed_idx % 2 == 0)
            {
                b_frag[pn][j].x[packed_idx - base2 + numel] = (packed & 0x0F) - 8;
            }
            else
            {
                b_frag[pn][j].x[packed_idx - base2 + numel] = (packed >> 4) - 8;
            }
        }
    };

    auto pipeline_strategy_1 = [&]()
    {
        load_A_tile(0, 0);
        load_B_tile(0, 0);
        __pipeline_commit();
        __pipeline_wait_prior(0);
        __syncthreads();

        int current_stage = 0;
        for (int k = 0; k < Config::K; k += Config::kTileSizeK)
        {
            // Start loading next stage if available
            if (k + Config::kTileSizeK < Config::K)
            {
                int next_stage = 1 - current_stage;
                load_A_tile(next_stage, k + Config::kTileSizeK);
                load_B_tile(next_stage, k + Config::kTileSizeK);
                __pipeline_commit();
            }

            for (int kk = 0; kk < Config::kTileSizeK; kk += Config::WMMA_K)
            {

                for (int pm = 0; pm < Config::kPatchM; pm++)
                {

                    for (int i = 0; i < Config::kWarpRowTiles; i++)
                    {
                        nvcuda::wmma::load_matrix_sync(
                            a_frag[pm][i],
                            smemA.get_ptr(current_stage, (warp_row * Config::kPatchM + pm) * Config::kWarpRowTiles * Config::WMMA_M + i * Config::WMMA_M, kk),
                            Config::kTileSizeK);
                    }
                }

                for (int pn = 0; pn < Config::kPatchN; pn++)
                {

                    for (int j = 0; j < Config::kWarpColTiles; j++)
                    {
                        unpack_and_load_frag(current_stage, warp_col * Config::kPatchN + pn, pn, j, kk);
                    }
                }

                for (int pm = 0; pm < Config::kPatchM; pm++)
                {

                    for (int pn = 0; pn < Config::kPatchN; pn++)
                    {

                        for (int i = 0; i < Config::kWarpRowTiles; i++)
                        {

                            for (int j = 0; j < Config::kWarpColTiles; j++)
                            {
                                nvcuda::wmma::mma_sync(c_frag[pm][pn][i][j], a_frag[pm][i], b_frag[pn][j], c_frag[pm][pn][i][j]);
                            }
                        }
                    }
                }
            }

            // Wait for next stage to finish loading
            __pipeline_wait_prior(0);
            __syncthreads();

            // Swap stages
            current_stage = 1 - current_stage;
        }
    };

    pipeline_strategy_1();

    store_C_tile();
}

template <typename Config>
void launch_igemm(const int8_t *A, const uint8_t *B, int32_t *C, int M, cudaStream_t stream)
{
    dim3 grid_dim(div_ru(M, Config::kTileSizeM), div_ru(Config::N, Config::kTileSizeN));
    dim3 block_dim(WARP_SIZE * (Config::kBlockRowWarps / Config::kPatchM) * (Config::kBlockColWarps / Config::kPatchN));

    size_t shared_mem_size = Config::kNumStages * (Config::kTileSizeM * Config::kTileSizeK * sizeof(int8_t) + Config::kTileSizeN * Config::kTileSizeK * sizeof(int8_t) / 2);

    igemm<Config><<<grid_dim, block_dim, shared_mem_size, stream>>>(A, B, C, M);
}

#define LAUNCH_KERNEL_IF_CONDITION(config, mCond, nCond, kCond)                        \
    else if (n == nCond && m == mCond && k == kCond)                                   \
    {                                                                                  \
        using ThisConfig = IGemmConfig<config.BlockRowWarps, config.BlockColWarps,     \
                                       config.WarpRowTiles, config.WarpColTiles,       \
                                       config.PatchM, config.PatchN, config.ChunkK,    \
                                       config.NumStages, config.PipelineStrategy,      \
                                       config.kWMMA_M, config.kWMMA_N, config.kWMMA_K, \
                                       config.N, config.K>;                            \
        launch_igemm<ThisConfig>(A_ptr, B_ptr, C_ptr, m, stream);                      \
        return;                                                                        \
    }

void wrapper(void *A, void *B, void *C, const int m, const int n, const int k, cudaStream_t stream)
{
    const int8_t *A_ptr = reinterpret_cast<const int8_t *>(A);
    const uint8_t *B_ptr = reinterpret_cast<const uint8_t *>(B);
    int32_t *C_ptr = reinterpret_cast<int32_t *>(C);

    if (false)
    {
    }
    LAUNCH_KERNEL_IF_CONDITION(octomul_64_6144_4096, 64, 6144, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_64_8192_8192, 64, 8192, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_64_10240_8192, 64, 10240, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_64_28672_4096, 64, 28672, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_64_4096_14336, 64, 4096, 14336)
    LAUNCH_KERNEL_IF_CONDITION(octomul_64_8192_28672, 64, 8192, 28672)
    LAUNCH_KERNEL_IF_CONDITION(octomul_64_57344_8192, 64, 57344, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_128_6144_4096, 128, 6144, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_128_8192_8192, 128, 8192, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_128_10240_8192, 128, 10240, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_128_28672_4096, 128, 28672, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_128_4096_14336, 128, 4096, 14336)
    LAUNCH_KERNEL_IF_CONDITION(octomul_128_8192_28672, 128, 8192, 28672)
    LAUNCH_KERNEL_IF_CONDITION(octomul_128_57344_8192, 128, 57344, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_256_6144_4096, 256, 6144, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_256_8192_8192, 256, 8192, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_256_10240_8192, 256, 10240, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_256_28672_4096, 256, 28672, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_256_4096_14336, 256, 4096, 14336)
    LAUNCH_KERNEL_IF_CONDITION(octomul_256_8192_28672, 256, 8192, 28672)
    LAUNCH_KERNEL_IF_CONDITION(octomul_256_57344_8192, 256, 57344, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_512_6144_4096, 512, 6144, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_512_8192_8192, 512, 8192, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_512_10240_8192, 512, 10240, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_512_28672_4096, 512, 28672, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_512_4096_14336, 512, 4096, 14336)
    LAUNCH_KERNEL_IF_CONDITION(octomul_512_8192_28672, 512, 8192, 28672)
    LAUNCH_KERNEL_IF_CONDITION(octomul_512_57344_8192, 512, 57344, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_1024_6144_4096, 1024, 6144, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_1024_8192_8192, 1024, 8192, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_1024_10240_8192, 1024, 10240, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_1024_28672_4096, 1024, 28672, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_1024_4096_14336, 1024, 4096, 14336)
    LAUNCH_KERNEL_IF_CONDITION(octomul_1024_8192_28672, 1024, 8192, 28672)
    LAUNCH_KERNEL_IF_CONDITION(octomul_1024_57344_8192, 1024, 57344, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_2048_6144_4096, 2048, 6144, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_2048_8192_8192, 2048, 8192, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_2048_10240_8192, 2048, 10240, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_2048_28672_4096, 2048, 28672, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_2048_4096_14336, 2048, 4096, 14336)
    LAUNCH_KERNEL_IF_CONDITION(octomul_2048_8192_28672, 2048, 8192, 28672)
    LAUNCH_KERNEL_IF_CONDITION(octomul_2048_57344_8192, 2048, 57344, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_4096_6144_4096, 4096, 6144, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_4096_8192_8192, 4096, 8192, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_4096_10240_8192, 4096, 10240, 8192)
    LAUNCH_KERNEL_IF_CONDITION(octomul_4096_28672_4096, 4096, 28672, 4096)
    LAUNCH_KERNEL_IF_CONDITION(octomul_4096_4096_14336, 4096, 4096, 14336)
    LAUNCH_KERNEL_IF_CONDITION(octomul_4096_8192_28672, 4096, 8192, 28672)
    LAUNCH_KERNEL_IF_CONDITION(octomul_4096_57344_8192, 4096, 57344, 8192)
}

cublasHandle_t g_cublas_handle = nullptr;

void init_cublas()
{
    if (g_cublas_handle == nullptr)
    {
        cublasStatus_t status = cublasCreate(&g_cublas_handle);
        if (status != CUBLAS_STATUS_SUCCESS)
        {
            printf("cuBLAS initialization failed with error code %d\n", status);
        }
    }
}

void destroy_cublas()
{
    if (g_cublas_handle != nullptr)
    {
        cublasDestroy(g_cublas_handle);
        g_cublas_handle = nullptr;
    }
}

void cublas_igemm(const int8_t *A, const int8_t *B, int32_t *C, int M, int N, int K, cudaStream_t stream)
{
    if (g_cublas_handle == nullptr)
    {
        printf("cuBLAS handle not initialized\n");
        return;
    }

    cublasStatus_t status = cublasSetStream(g_cublas_handle, stream);
    if (status != CUBLAS_STATUS_SUCCESS)
    {
        printf("cuBLAS set stream failed with error code %d\n", status);
        return;
    }

    const int32_t alpha = 1;
    const int32_t beta = 0;

    status = cublasGemmEx(g_cublas_handle, CUBLAS_OP_T, CUBLAS_OP_N,
                          N, M, K,
                          &alpha,
                          B, CUDA_R_8I, K,
                          A, CUDA_R_8I, K,
                          &beta,
                          C, CUDA_R_32I, N,
                          CUDA_R_32I, CUBLAS_GEMM_DEFAULT_TENSOR_OP);

    if (status != CUBLAS_STATUS_SUCCESS)
    {
        printf("cuBLAS GEMM failed with error code %d\n", status);
    }
}
