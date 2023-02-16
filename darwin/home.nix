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
  home = {                                        
    # Specific packages for macbook
    packages = with pkgs; [
      # Terminal
      pfetch
      ripgrep
      fd
      curl
      less
      # spotify
      wget
      # Terminal
      ansible
      ranger
      # Languages
      python3
      mysql
      # emacs
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
      shellAliases = { 
        ls = "ls --color=auto -F"; 
        cat = "bat";
        g = "git";
        gl = "git log";
        gc = "git commit -m";
        gca = "git commit -am";
        nixinfo = "nix-shell -p nix-info --run \"nix-info -m\"";
        drs = "darwin-rebuild switch --flake .#macbookpro";
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [

        # TODO: add and remove plugins.
        # treesitter
        nvim-treesitter.withAllGrammars
        # Luasnip
        luasnip
        # telescope
        telescope-nvim
        # Syntax
        vim-nix
        vim-markdown

        # Quality of life
        vim-lastplace                             
        auto-pairs                                
        vim-gitgutter                             

        # File Tree
        nerdtree                                  

        # Customization 
        wombat256-vim                             
        srcery-vim                                

        lightline-vim                             
        indent-blankline-nvim                     
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
      settings = {
        command_timeout = 1000;
        character = {
          success_symbol = " [λ](bold green)";
          error_symbol = " [λ](bold red)";
        };
      };
    };

    alacritty = {
      enable = true;
      # settings.font.normal.family = "MesloLGS Nerd Font Mono"; 
      settings.font.normal = {
        family = "FiraCode Nerd Font Mono"; 
        style = "Retina";
      };
      settings.font.size = 16;
    };

    gpg = {
      enable = true;
    };

    emacs = {
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

    htop = {
      enable = true;
    };
    pandoc = {
      enable = true;
    };
  };
}
