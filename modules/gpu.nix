{ config, pkgs, p4net, lib, nixpkgs-latest, ... }:
{
  # My GPU config is a bit of a mess.
  # There are three mutually incompatible configs, that require
  # reboot to switch. Annoying, but virtualising GPUs is a pain.

  # --- VARIANT 1: virtio_gpu ---
  # boot = {
  #   kernelModules = [ "virtio_gpu" ];
  # };

  # --- VARIANT 2: nvidia drivers ---
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.config.cudaSupport = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;

  # --- VARIANT 3: vfio compatible, for gpu passthrough to VM ---
  # boot = {
  #   # VFIO: disable nvidia and nouveau drives
  #   blacklistedKernelModules = [ "nvidia" "nouveau" ];

  #   # kernel modules required for VFIO
  #   kernelModules = [ "vfio_virqfd" "vfio_pci" "vfio_iommu_type1" "vfio" ];

  #   extraModprobeConfig =
  #      let nvidia_pci_id = "10de:1fb8";
  #      in "options vfio-pci ids=${nvidia_pci_id}";
  # };
}
