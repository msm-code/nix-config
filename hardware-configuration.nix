{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/mapper/enc0";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."enc0".device = "/dev/disk/by-uuid/6151d390-7815-4619-a415-0425b326b0bb";
  boot.initrd.luks.devices."enc1".device = "/dev/disk/by-uuid/c16473ce-e52a-4a8f-a96c-4bcb8a818dc7";

  fileSystems."/home" =
    {
      device = "/dev/mapper/enc0";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/mapper/enc0";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/11F7-F22F";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/830f7262-a3de-4c2a-83e9-321ffcdf0494"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
