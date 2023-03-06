{
  description = "My Personal Darwin System Flake Configuration";
  # All flake references used to build the system setup. These are dependecies.
  inputs =                               
    { # Nix Packages
      nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";                  
      # User Package Management
      home-manager = {                                                      
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      # MacOS Package Management
      darwin = {
        url = "github:lnl7/nix-darwin/master";                              
        inputs.nixpkgs.follows = "nixpkgs";
      };
      # NUR Packages
      nur = {
        url = "github:nix-community/NUR";                                   
      };
      # Emacs Overlays
      #emacs-overlay = {                                 
      #  url = "github:nix-community/emacs-overlay";
      #  inputs.nixpkgs.follows = "nixpkgs";
      #};
    };
  # Function that tells my flake which to use and what do what to do with the dependencies.
  outputs = inputs @ { self, nur, nixpkgs, home-manager, darwin, ... }:   
    let                                                                     
      # Variables that can be used in the config files.
      user = "ruitang";
      # system = "aarch64-darwin";
      # pkgs = import nixpkgs {
      #   inherit system;
      #   config = {
      #     allowUnfree = true;
      #   };
      # };

      # lib = nixpkgs.lib;
      # location = "$HOME/.setup";
    in                                                                      
    # Use above variables in ...
    {
      # Darwin Configurations
      darwinConfigurations = (                                              
        import ./darwin {
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nur home-manager darwin user;
        }
      );
    };
}
