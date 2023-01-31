#
#  Home-manager configuration for macbook
#
#  flake.nix
#   ├─ ./darwin
#   │   ├─ ./default.nix
#   │   └─ ./home.nix *
#   └─ ./modules
#       └─ ./programs
#           └─ ./alacritty.nix
#

{ pkgs, ... }:

{
  #config = {
  #  allowUnfree = true;
  #  allowBroken = false;
  #  allowUnsupportedSystem = true;
  #};
  home = {                                        
    # Specific packages for macbook
    packages = with pkgs; [
      # Terminal
      pfetch
      ripgrep
      fd
      curl
      less
      emacs
      # obsidian
      # vscode
    ];

    sessionVariables = {
      PAGER = "less";
      CLICLOLOR = 1;
      EIDTOR = "nvim";
    };
    file = {
      ".config/karabiner/assets/complex_modifications/custom-capslock.json" = {
        enable = true;
        text = ''
          {
            "title": "Change caps_lock to Esc and Control",
            "rules": [
          	{
          	  "description": "Post Esc if Caps is tapped, Control if held.",
          	  "manipulators": [
                  {
              "type": "basic",
              "from": {
                  "key_code": "left_control",
                  "modifiers": {
                      "optional": [
                          "any"
                      ]
                  }
              },
              "to": [
                  {
                      "key_code": "left_control",
                      "lazy": true
                  }
              ],
              "to_if_alone": [
                  {
                      "key_code": "escape"
                  }
              ]
          }
          	  ]
          	}
            ]
          }
        '';
      };
    };
    stateVersion = "22.11";
  };

  programs = {
    zsh = {                                       
      enable = true;
      # Auto suggest options and highlights syntax. It searches in history for options
      enableCompletion = true;
      enableAutosuggestions = true;               
      enableSyntaxHighlighting = true;
      history.size = 10000;

      oh-my-zsh = {                               # Extra plugins for zsh
        enable = true;
        plugins = [ "git" ];
        # custom = "$HOME/.config/zsh_nix/custom";
      };
      # Zsh theme
      initExtra = ''
        # Spaceship
        source ${pkgs.spaceship-prompt}/share/zsh/site-functions/prompt_spaceship_setup
        autoload -U promptinit; promptinit
        pfetch
      '';                                         
      shellAliases = { ls = "ls --color=auto -F"; };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [

        # Syntax
        vim-nix
        vim-markdown

        # Quality of life
        vim-lastplace                             # Opens document where you left it
        auto-pairs                                # Print double quotes/brackets/etc.
        vim-gitgutter                             # See uncommitted changes of file :GitGutterEnable

        # File Tree
        nerdtree                                  # File Manager - set in extraConfig to F6

        # Customization 
        wombat256-vim                             # Color scheme for lightline
        srcery-vim                                # Color scheme for text

        lightline-vim                             # Info bar at bottom
        indent-blankline-nvim                     # Indentation lines
      ];

      extraConfig = ''
        syntax enable                             " Syntax highlighting
        colorscheme srcery                        " Color scheme text

        let g:lightline = {
          \ 'colorscheme': 'wombat',
          \ }                                     " Color scheme lightline

        highlight Comment cterm=italic gui=italic " Comments become italic
        hi Normal guibg=NONE ctermbg=NONE         " Remove background, better for personal theme
        
        set number                                " Set numbers

        nmap <F6> :NERDTreeToggle<CR>             " F6 opens NERDTree
      '';
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
    };

    alacritty = {
      enable = true;
      settings.font.normal.family = "MesloLGS Nerd Font Mono"; 
      settings.font.size = 16;
    };

    gpg = {
      enable = true;
    };

    zathura = {
      enable = true;
    };

    git = {
      enable = true;
    };

    bat = {
      enable = true;
      config.theme = "TwoDark";
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    exa = {
      enable = true;
    };
  };
}
