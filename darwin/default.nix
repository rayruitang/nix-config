#
#  These are the different profiles that can be used when building on MacOS
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix *
#       ├─ configuration.nix
#       └─ home.nix
#

{ lib, inputs, nur, nixpkgs, home-manager, darwin, doom-emacs, user, ...}:

let
  # System architecture
  system = "aarch64-darwin";                                 
in
{
  macbookpro = darwin.lib.darwinSystem {                       
    inherit system;
    specialArgs = { inherit user inputs; };
    # Modules that are used
    modules = [                                             
      nur.nixosModules.nur
      ./configuration.nix

      # Home-Manager module that is used
      home-manager.darwinModules.home-manager {             
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit user doom-emacs; };  # Pass flake variable
        home-manager.users.${user} = import ./home.nix;
      }
    ];
  };
}
