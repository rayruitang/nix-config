#
#  Specific system configuration settings for MacBook
#
#  flake.nix
#   └─ ./darwin
#       ├─ ./default.nix
#       └─ ./configuration.nix *
#

{ config, pkgs, user, ... }:

{
  #nixpkgs= {
  #  config = {
  #    allowUnfree = true;
  #    allowBroken = false;
  #    allowUnsupportedSystem = true;
  #  }; 
  #  overlays = [
  #    (import (builtins.fetchTarball {
  #      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #      sha256 = "0ca6qlnmi3y3gagvlw44ddk223rf9iz3nr57imm3xag9shgrfa83";
  #  }))
  #  ];
  #};
  #imports = [
  #  ./modules/yabai.nix
  #  ./modules/skhd.nix
  #];
  # macOS user
  users.users."${user}" = {               
    home = "/Users/${user}";
    # Default shell
    shell = pkgs.zsh;                     
  };

  # Host name
  networking = {
    computerName = "MacBookPro";             
    hostName = "MacBookPro";
    localHostName = "MacBookPro";
  };

  # Fonts
  fonts = {                               
    fontDir.enable = true;
    fonts = with pkgs; [
      source-code-pro
      font-awesome
      julia-mono
      ibm-plex
      jetbrains-mono
      (nerdfonts.override {
        fonts = [
          "Meslo"
          "FiraCode"
          "DroidSansMono"
          "Iosevka"
          "Overpass"
        ];
      })
    ];
  };

  environment = {
    shells = with pkgs; [ bash zsh ];          # Default shell
    loginShell = pkgs.zsh;
    variables = {                         # System variables
      EDITOR = "emacsclient";
      VISUAL = "emacsclient";
    };
    systemPackages = with pkgs; [         # Installed Nix packages
      # Standard toolsets
      coreutils-full
      texlive.combined.scheme-full
      emacs
    ];
    systemPath = [ 
      "/opt/homebrew/bin" 
      "$HOME/.config/emacs/bin"
    ];
    pathsToLink = [ "/Applications" ];
  };
  # Shell needs to be enabled
  programs.zsh = {                            
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
  };

  services = {
    # Auto upgrade daemon
    nix-daemon.enable = true;             
    #emacs.package = pkgs.emacs;
    emacs = {
      enable = true;
      defaultEditor = true;
    };
  };
  # Declare Homebrew using Nix-Darwin
  homebrew = {                            
    enable = true;
    caskArgs.no_quarantine = true;
    global.brewfile = true;
    masApps = {};
    onActivation = {
      # Auto update packages
      autoUpdate = true;                 
      upgrade = true;
      # Uninstall not listed packages and casks
      cleanup = "zap";                    
    };
    taps = [
      "d12frosted/emacs-plus"
      "homebrew/cask"
    ];
    #brews = [
    #  {
    #    name = "emacs-plus@28";
    #    args = [
    #      "with-debug"
    #      "with-native-comp"
    #      "with-modern-doom3-icon"
    #      "with-dbus"
    #      "with-ctags"
    #      "with-mailutils"
    #    ];
    #  }
    #];
    casks = [
      #"parsec"
      "raycast"
      "amethyst"
      "karabiner-elements"
      "firefox"
      "spotify"
      "discord"
      "slack"
      "mathpix-snipping-tool"
      "zoom"
      "obsidian"
      "texmacs"
      "lyx"
      "pdf-expert"
      "citrix-workspace"
      "zotero"
      "xquartz"
      # "mysqlworkbench"
      #"plex-media-player"
    ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    package = pkgs.nix;
    # Garbage collection
    gc = {                                
      automatic = true;
      interval.Day = 7;
      options = "--delete-older-than 7d";
    };
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  system = {
    defaults = {
      # Global macOS system settings
      NSGlobalDomain = {                  
        KeyRepeat = 1;
        InitialKeyRepeat = 14;
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
      };
      # Dock settings
      dock = {                            
        autohide = true;
        orientation = "bottom";
        showhidden = true;
        tilesize = 40;
      };
      # Finder settings
      finder = {                          
        # I believe this probably will need to be true if using spacebar
        QuitMenuItem = true;             
        AppleShowAllExtensions = true;
        _FXShowPosixPathInTitle = true;
      };  
      # Trackpad settings
      trackpad = {                        
        Clicking = true;
        TrackpadRightClick = true;
      };
    };
    #activationScripts.postActivation.text = ''sudo chsh -s ${pkgs.zsh}/bin/zsh''; # Since it's not possible to declare default shell, run this command after build
    stateVersion = 4;
  };
}
