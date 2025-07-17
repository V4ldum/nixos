{ pkgs, username, ... }:

{
  # Set Fish as the default shell for everyone
  #programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Solution to avoid setting fish as login shell which could cause issues
  programs.bash.interactiveShellInit = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';

  # To ignore the warning about fish not being enabled
  users.users.${username}.ignoreShellProgramCheck = true; 
  users.users.root.ignoreShellProgramCheck = true;

  # Configuration
  environment.etc."fish/config.fish".text = ''
    set -g fish_greeting ""

    if status is-interactive
      # Aliases
      alias ..="cd ..";
      alias ...="cd ../..";

      alias ls="eza";
      alias ll="ls -l";
      alias lla="ls -la";
      alias la="ls -a";

      alias find="fd";
    end

    # Prompt setup
    function symbol
      if fish_is_root_user
        set -f symbol '#'
      else
        set -f symbol '$'
      end
      string join ${"''"} -- (set_color normal) $symbol ' '
    end

    function username_hostname
      if fish_is_root_user
        set -f color brred
      else
        set -f color brgreen
      end
      string join ${"''"} -- (set_color -o $color) $USER '@' (hostname) (set_color normal) ':'
    end

    function working_dir
      string join ${"''"} --  (set_color -o brblue) (string replace $HOME '~' $PWD)
    end

    function fish_prompt
      string join ${"''"} -- (username_hostname) (working_dir) (symbol)
    end

    zoxide init --cmd cd fish | source
  '';
}
