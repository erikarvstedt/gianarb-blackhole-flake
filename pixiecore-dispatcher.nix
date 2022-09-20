{ config, pkgs, lib, modulesPath, ... }: with lib; {
  imports = [
    (modulesPath + "/installer/netboot/netboot-base.nix")
    # ./tailscale.nix
  ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-"
  ];

  environment.systemPackages = [ pkgs.pixiecore pkgs.lab.blackhole ];

  services.pixiecore.enable = true;
  services.pixiecore.openFirewall = true;

  ## Some useful options for setting up a new system
  services.getty.autologinUser = mkForce "root";

  networking.dhcpcd.enable = true;
  networking.hostName = "pixiecore-dispatcher";

  services.openssh.enable = true;
  services.tailscale.enable = true;

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;

  system.stateVersion = "22.05";
}
