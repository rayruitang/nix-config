#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix *
#       ├─ configuration.nix
#       └─ home.nix
#

{ lib, inputs, nur, nixpkgs, home-manager, darwin, user, ...}:

let
  # System architecture
  system = "aarch64-darwin";
  eachSupportedSystem = nixpkgs.lib.genAttrs [
    system
  ];
  legacyPackages = eachSupportedSystem (system:
  import nixpkgs {
    inherit system;
    config = {allowUnfree = true;};
    overlays = [
      inputs.nur.overlay
      #inputs.emacs-overlay.overlay
      (import (builtins.fetchTarball {
         url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
         sha256 = "0ca6qlnmi3y3gagvlw44ddk223rf9iz3nr57imm3xag9shgrfa83";
      }))
      ];
    });
in
{
  macbookpro = darwin.lib.darwinSystem {    
    pkgs = legacyPackages.${system};
    inherit system;
    specialArgs = { inherit user inputs; };
    # Modules that are used
    modules = [                                             
      #nur.nixosModules.nur
      ./configuration.nix
      # Home-Manager module that is used
      home-manager.darwinModules.home-manager {             
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user; };  # Pass flake variable
        home-manager.users.${user} = import ./home.nix;
      }
    ];
  };
}
