struct KernelConfig
{
    const int BlockRowWarps;
    const int BlockColWarps;
    const int WarpRowTiles;
    const int WarpColTiles;
    const int PatchM;
    const int PatchN;
    const int ChunkK;
    const int NumStages;
    const int PipelineStrategy;
    const int kWMMA_M;
    const int kWMMA_N;
    const int kWMMA_K;
    const int K;
    const int N;
};

constexpr KernelConfig octomul_4096_57344_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 2,
    /* ChunkK */ 4,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 57344};

constexpr KernelConfig octomul_4096_8192_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 8192};

constexpr KernelConfig octomul_4096_28672_4096 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 4,
    /* ChunkK */ 2,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 28672};

constexpr KernelConfig octomul_4096_10240_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 6,
    /* PatchM */ 1,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 10240};

constexpr KernelConfig octomul_4096_6144_4096 = {
    /* BlockRowWarps */ 6,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 6144};

constexpr KernelConfig octomul_2048_8192_28672 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 28672,
    /* N */ 8192};

constexpr KernelConfig octomul_2048_10240_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 4,
    /* ChunkK */ 2,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 10240};

constexpr KernelConfig octomul_2048_28672_4096 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 6,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 28672};

constexpr KernelConfig octomul_2048_6144_4096 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 6,
    /* WarpColTiles */ 4,
    /* PatchM */ 1,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 6144};

constexpr KernelConfig octomul_1024_8192_28672 = {
    /* BlockRowWarps */ 6,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 28672,
    /* N */ 8192};

constexpr KernelConfig octomul_1024_8192_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 8192};

constexpr KernelConfig octomul_128_10240_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 10240};

constexpr KernelConfig octomul_128_57344_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 2,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 57344};

constexpr KernelConfig octomul_512_8192_28672 = {
    /* BlockRowWarps */ 6,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 28672,
    /* N */ 8192};

constexpr KernelConfig octomul_4096_4096_14336 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 14336,
    /* N */ 4096};

constexpr KernelConfig octomul_128_28672_4096 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 4,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 28672};

constexpr KernelConfig octomul_1024_10240_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 10240};

constexpr KernelConfig octomul_64_57344_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 4,
    /* PatchM */ 1,
    /* PatchN */ 2,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 57344};

constexpr KernelConfig octomul_256_10240_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 10240};

constexpr KernelConfig octomul_1024_4096_14336 = {
    /* BlockRowWarps */ 6,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 14336,
    /* N */ 4096};

constexpr KernelConfig octomul_1024_28672_4096 = {
    /* BlockRowWarps */ 6,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 28672};

constexpr KernelConfig octomul_256_57344_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 57344};

constexpr KernelConfig octomul_64_8192_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 8192};

constexpr KernelConfig octomul_256_28672_4096 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 28672};

constexpr KernelConfig octomul_128_8192_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 8192};

constexpr KernelConfig octomul_64_28672_4096 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 4,
    /* ChunkK */ 2,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 28672};

constexpr KernelConfig octomul_512_6144_4096 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 6144};

constexpr KernelConfig octomul_2048_8192_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 6,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 8192};

constexpr KernelConfig octomul_64_4096_14336 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 14336,
    /* N */ 4096};

constexpr KernelConfig octomul_256_6144_4096 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 6144};

constexpr KernelConfig octomul_64_6144_4096 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 6144};

constexpr KernelConfig octomul_64_8192_28672 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 28672,
    /* N */ 8192};

constexpr KernelConfig octomul_128_6144_4096 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 6144};

constexpr KernelConfig octomul_128_8192_28672 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 28672,
    /* N */ 8192};

constexpr KernelConfig octomul_1024_6144_4096 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 6144};

constexpr KernelConfig octomul_64_10240_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 10240};

constexpr KernelConfig octomul_256_4096_14336 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 14336,
    /* N */ 4096};

constexpr KernelConfig octomul_2048_57344_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 57344};

constexpr KernelConfig octomul_1024_57344_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 57344};

constexpr KernelConfig octomul_256_8192_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 8192};

constexpr KernelConfig octomul_2048_4096_14336 = {
    /* BlockRowWarps */ 6,
    /* BlockColWarps */ 6,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 14336,
    /* N */ 4096};

constexpr KernelConfig octomul_512_57344_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 6,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 57344};

constexpr KernelConfig octomul_128_4096_14336 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 14336,
    /* N */ 4096};

constexpr KernelConfig octomul_256_8192_28672 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 28672,
    /* N */ 8192};

constexpr KernelConfig octomul_512_28672_4096 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 6,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 4,
    /* NumStages */ 2,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 4096,
    /* N */ 28672};

constexpr KernelConfig octomul_4096_8192_28672 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 6,
    /* WarpColTiles */ 2,
    /* PatchM */ 1,
    /* PatchN */ 2,
    /* ChunkK */ 2,
    /* NumStages */ 3,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 28672,
    /* N */ 8192};

constexpr KernelConfig octomul_512_4096_14336 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 4,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 14336,
    /* N */ 4096};

constexpr KernelConfig octomul_512_8192_8192 = {
    /* BlockRowWarps */ 2,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 4,
    /* WarpColTiles */ 2,
    /* PatchM */ 2,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 8192};

constexpr KernelConfig octomul_512_10240_8192 = {
    /* BlockRowWarps */ 4,
    /* BlockColWarps */ 2,
    /* WarpRowTiles */ 2,
    /* WarpColTiles */ 2,
    /* PatchM */ 4,
    /* PatchN */ 1,
    /* ChunkK */ 2,
    /* NumStages */ 4,
    /* PipelineStrategy */ 1,
    /* kWMMA_M */ 16,
    /* kWMMA_N */ 16,
    /* kWMMA_K */ 16,
    /* K */ 8192,
    /* N */ 10240};
