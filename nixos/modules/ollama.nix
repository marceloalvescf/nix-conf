{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    # O ROCm 7.2 embarcado já traz kernel nativo para gfx1102 (ver
    # lib/ollama/rocm_v7_2/rocblas). Reative se a GPU deixar de ser detectada.
    # rocmOverrideGfx = "11.0.0";

    # Escuta em todas as interfaces para que os pods do kind alcancem o host.
    # O acesso é restringido pelo firewall, não pelo bind.
    host = "0.0.0.0";
    port = 11434;

    environmentVariables = {
      # A atenção híbrida do qwen3.5 mantém KV em 8 das 32 layers, ~9 MiB por
      # 1k tokens. Espaço para logs e manifests sem estourar os 8 GB de VRAM.
      OLLAMA_CONTEXT_LENGTH = "32768";

      # Libera a VRAM quando ocioso.
      OLLAMA_KEEP_ALIVE = "10m";

      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";

      # Teto de alocação do ollama, não reserva efetiva de VRAM. Não morde em
      # 32k (6,4 GiB de 7,0 GiB); segura o modelo se o contexto subir rumo ao
      # teto de ~60k desta GPU.
      OLLAMA_GPU_OVERHEAD = "1073741824";

      # KV em q4_0: 288 MiB em 32k, contra 1152 MiB em f16. Exige flash attention.
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q4_0";
    };

    # Baixa o modelo na ativação, em vez de no primeiro prompt.
    loadModels = [ "qwen3.5:9b" ];

    # Lista declarativa de modelos
    syncModels = true;
  };
}
