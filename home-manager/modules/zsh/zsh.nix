{ pkgs, lib, config, ... }:
{

home.packages = with pkgs; [
    bat
    eza
    less
    macchina # neofetch alternative in rust
    micro
    ncdu
    tmux
    tree
    zsh-powerlevel10k
  ]

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    #".justfile".source = dotfiles/justfile;
    #".config/topgrade/topgrade.toml".source = dotfiles/topgrade.toml;
    ".config/zsh/.zsh_plugins.txt".source = dotfiles/zsh_plugins.txt;    
    ".config/zsh/zshrc.d" = {
      source = ./zshrc.d;
      recursive = true;
    };

    ".config/macchina/themes/birdie.toml".source = dotfiles/macchina_birdie.toml;
    ".config/macchina/themes/birdie.ascii".source = dotfiles/macchina_birdie.ascii;
    ".config/macchina/macchina.toml".source = dotfiles/macchina.toml;
  };
 
 programs.zsh = {
    enable = true;
    autocd = false;
    plugins = [
      {
        name = "antidote";
        src = pkgs.antidote;
        file = "share/antidote/antidote.zsh";
      }
      # {
      #   name = "powerlevel10k";
      #   src = pkgs.zsh-powerlevel10k;
      #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      # }
      {
        name = "powerlevel10k-config";
        src = lib.cleanSource ./;
        file = "p10k.zsh";
      }
    ];

    initExtraFirst = ''
      # This part is commented out for nixos
      #if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
      #  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
      #  . /nix/var/nix/profiles/default/etc/profile.d/nix.sh
      #fi

      # Define variables for directories
      #export PATH=$HOME/.local/share/bin:$PATH
      #export XDG_CONFIG_HOME=''${XDG_CONFIG_HOME:-$HOME/.config}
      #export XDG_DATA_HOME=''${XDG_DATA_HOME:-$HOME/.local/share}
      #export XDG_CACHE_HOME=''${XDG_CACHE_HOME:-$HOME/.cache}
      export ZDOTDIR=''${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}

      # Remove history data we don't want to see
      export HISTIGNORE="pwd:ls:cd"

      # Emacs is my editor
      export ALTERNATE_EDITOR=""
      export EDITOR="nano"
      export VISUAL="nano"

      e() {
          nano "$@"
      }

      # nix shortcuts
      shell() {
          nix-shell '<nixpkgs>' -A "$1"
      }

      # Use difftastic, syntax-aware diffing
      alias diff=difft
      alias nix="noglob nix"

      # Always color ls and group directories
      alias ls='ls --color=auto'
    '';

    initExtra = ''
      antidote load
      #
      # source local zsrc.d/* files if they exist
      #


      typeset -ga _zshrcd=(
        ''$ZSHRCD
        ''${ZDOTDIR:-/dev/null}/zshrc.d(N)
        ''${HOME}/.zshrc.d(N)
        ''${ZDOTDIR:-$HOME}/.config/zsh/zshrc.d(N)
      )
      if [[ ! -e "''$_zshrcd[1]" ]]; then
        echo >&2 "zshrc.d: dir not found HOME or ZDOTDIR path!"
        return 1
      fi

      typeset -ga _zshrcd=("''$_zshrcd[1]"/*.{sh,zsh}(N))
      typeset -g _zshrcd_file
      for _zshrcd_file in ''${(o)_zshrcd}; do
        [[ ''${_zshrcd_file:t} != '~'* ]] || continue  # ignore tilde files
        source "''$_zshrcd_file"
      done
      unset _zshrcd{,_file}

      # load direnv
      eval "$(direnv hook zsh)"
    '';
  };

}
