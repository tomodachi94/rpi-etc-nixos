{ lib, pkgs, nixos-hardware, ... }: {
  imports = [
    ./networks.nix # This file contains secrets.
  ];

  system.stateVersion = "23.05";

  boot.tmp.cleanOnBoot = true;

  boot.loader.grub.enable = lib.mkDefault false;
  boot.loader.grub.device = "nodev";

  boot.loader.systemd-boot.enable = lib.mkDefault false;

  boot.loader.raspberryPi = {
#    enable = lib.mkForce true;
    version = 3;
    uboot.enable = true;
    firmwareConfig = ''
      dtparam=audio=on
    '';
  };

  nix = {
    enable = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  environment.systemPackages = with pkgs; [
    libraspberrypi
  ];

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
  };

  # bzip2 compression takes loads of time with emulation, skip it.
  sdImage.compressImage = false;

  # OpenSSH is forced to have an empty 'wantedBy' on the installer system[1], this won't allow it
  # to be started. Override it with the normal value.
  # [1] https://github.com/NixOS/nixpkgs/blob/9e5aa25/nixos/modules/profiles/installation-device.nix#L76
  systemd.services.sshd.wantedBy = lib.mkOverride 40 [ "multi-user.target" ];
  
  # Enable bluetooth
  systemd.services.btattach = {
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyAMA0.device" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    };
  };

  # Enable OpenSSH out of the box.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };
}
