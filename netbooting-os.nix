{ modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/netboot/netboot-base.nix")
  ];

  system.stateVersion = "22.05";
}
