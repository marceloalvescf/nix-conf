{
  zramSwap = {
    enable = true;
    memoryMax = 16 * 1024 * 1024 * 1024;
  };

  # Tuned for swap on zram: swapping is cheap, so prefer it over dropping page
  # cache, skip swap read-ahead, and wake kswapd earlier to avoid direct reclaim.
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.page-cluster" = 0;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
  };
}
