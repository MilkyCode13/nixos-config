{ config, lib, pkgs, modulesPath, utils, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "nvme" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/97f49ed9-2952-451f-97b6-94256bff9a7b";

  boot.initrd.systemd.services.recreate-root = {
    description = "Rolling over and creating new filesystem root";

    wantedBy = [ "initrd.target" ];
    requires = [ "${utils.escapeSystemdPath "/dev/mapper/cryptroot"}.device" ];
    after = [
      "initrd-root-device.target"
      "local-fs-pre.target"
    ];
    before = [
      "sysroot.mount"
    ];

    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";

    script = ''
      mkdir /btrfs_tmp
      mount /dev/mapper/cryptroot /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };

  boot.initrd.postResumeCommands = lib.mkAfter ''
  '';

  fileSystems."/persistent" = {
    device = "/dev/mapper/cryptroot";
    neededForBoot = true;
    fsType = "btrfs";
    options = [ "subvol=persistent" ];
  };

  #fileSystems."/home" =
  #  { device = "/dev/mapper/cryptroot";
  #    fsType = "btrfs";
  #    options = [ "subvol=home" ];
  #  };

  fileSystems."/nix" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=nix" ];
    };

  fileSystems."/swap" =
    { device = "/dev/mapper/cryptroot";
      fsType = "btrfs";
      options = [ "subvol=swap" ];
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2290-E235";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.npu.enable = true;
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
