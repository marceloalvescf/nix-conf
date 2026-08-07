{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;

    # RX 7600 é gfx1102, mas as libs ROCm oficiais miram gfx1100.
    # Sem esse override o Ollama costuma não reconhecer a GPU e cair para CPU.
    rocmOverrideGfx = "11.0.0";

    # Escuta em todas as interfaces para que os pods do kind alcancem o host.
    # O acesso é restringido pelo firewall, não pelo bind.
    host = "0.0.0.0";
    port = 11434;

    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "16384";

      # Antes: "-1" (residente para sempre). Libera a VRAM quando ocioso.
      OLLAMA_KEEP_ALIVE = "10m";

      OLLAMA_NUM_PARALLEL = "1";
      OLLAMA_MAX_LOADED_MODELS = "1";

      # KV cache quantizado: ~2,4GB -> ~1,2GB. Exige flash attention.
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_KV_CACHE_TYPE = "q8_0";
    };

    # Baixa o modelo na ativação, em vez de no primeiro prompt.
    loadModels = [ "qwen3:8b" ];
  };
}
