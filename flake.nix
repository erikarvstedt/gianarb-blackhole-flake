{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
  };
  outputs = { self, nixpkgs }: let
    pkgs-x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.extend (_: _:
      { lab = self.packages.x86_64-linux; }
    );
    mkNixosSystem_x86_64-linux = modules: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = modules ++ [ { nixpkgs.pkgs = pkgs-x86_64-linux; } ];
    };
  in {
    nixosConfigurations = {
      # This is an utility to test with:
      # $ nix build-vm
      # In reality what I want to build here is a package. In this way I can
      # deploy such OS via pixecore
      blackhole = mkNixosSystem_x86_64-linux [
        ./netbooting-os.nix
      ];
      # This is the machine that distribute netbooting images via Pixiecore.
      # It distributes the one we have just built for now but as a follow up
      # I will write some software that integrates with pixiecore api
      # https://github.com/danderson/netboot/blob/master/pixiecore/README.api.md
      pixiecore-dispatcher = mkNixosSystem_x86_64-linux [
        ./pixiecore-dispatcher.nix
      ];
    };
    packages.x86_64-linux.blackhole = pkgs-x86_64-linux.symlinkJoin {
      name = "blackhole";
      paths = with self.nixosConfigurations.blackhole.config.system.build; [
        netbootRamdisk
        kernel
        netbootIpxeScript
      ];
    };
  };
}
