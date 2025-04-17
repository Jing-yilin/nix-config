{ config, pkgs, lib, inputs, system, username, ... }:

let
  Follow = pkgs.stdenv.mkDerivation {
    pname = "Follow";
    version = "0.4.2";
    
    src = pkgs.fetchurl {
      url = "https://github.com/RSSNext/Folo/releases/download/v0.4.2/Folo-0.4.2-macos-arm64.dmg";
      sha256 = "27be83538c56cd2de62d143fdf6add7913e6b90f1215938929958eea61447b17";
    };
    
    nativeBuildInputs = [ pkgs.undmg ];
    
    sourceRoot = ".";
    
    installPhase = ''
      mkdir -p $out/Applications
      cp -r *.app $out/Applications
    '';
    
    meta = {
      description = "Follow RSS Reader";
      homepage = "https://github.com/RSSNext/Follow";
      platforms = lib.platforms.darwin;
    };
  };
in
{
  # Darwin specific settings
  fonts.fontconfig.enable = false;  # Disable font installation on Darwin

  home = {
    username = username;
    homeDirectory = lib.mkForce "/Users/${username}";
    stateVersion = "25.05";
    enableNixpkgsReleaseCheck = false;
    
    activation = {
      setupNvim = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
        # 确保父目录存在并设置权限
        mkdir -p "$HOME/.config"
        chmod 755 "$HOME/.config"
        
        # 清理并重建 nvim 相关目录
        rm -rf "$HOME/.config/nvim"
        rm -rf "$HOME/.local/share/nvim"
        rm -rf "$HOME/.cache/nvim"
        
        mkdir -p "$HOME/.config/nvim"
        mkdir -p "$HOME/.local/share/nvim/lazy"
        mkdir -p "$HOME/.cache/nvim"
        
        # 设置目录所有权和权限
        chown -R $USER "$HOME/.config/nvim"
        chown -R $USER "$HOME/.local/share/nvim"
        chown -R $USER "$HOME/.cache/nvim"
        
        chmod -R 755 "$HOME/.config/nvim"
        chmod -R 755 "$HOME/.local/share/nvim"
        chmod -R 755 "$HOME/.cache/nvim"
        
        # 创建并设置 lazy-lock.json 权限
        touch "$HOME/.config/nvim/lazy-lock.json"
        chown $USER "$HOME/.config/nvim/lazy-lock.json"
        chmod 644 "$HOME/.config/nvim/lazy-lock.json"
        
        # 安装 lazy.nvim
        LAZY_NVIM_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
        if [ ! -d "$LAZY_NVIM_DIR" ]; then
          ${pkgs.git}/bin/git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$LAZY_NVIM_DIR"
        fi
      '';
    };
    
    packages = with pkgs; [
      direnv
      ripgrep
      fd
      fzf
      zsh
      zsh-autosuggestions
      zsh-syntax-highlighting
      htop
      bottom
      duf
      procs
      glances
      obsidian
      jq
      tree
      ffmpeg
      zoxide
      Follow
      rustup
      coreutils
      gh
      nodejs
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
    
    extraPackages = with pkgs; [
      # LSP servers
      nodePackages.typescript-language-server
      lua-language-server
      nil # Nix LSP
      marksman
      
      # Optional: Node.js for certain plugins
      nodejs
      
      # 必要的依赖
      git
      gcc
      coreutils
      
      # Rust development
      rust-analyzer
    ];
  };

  # 管理 Neovim 配置文件
  home.file.".config/nvim" = {
    source = ./nvim;
    recursive = true;
    force = true;
  };

  # Git 配置
  programs.git = {
    enable = true;
    userName = "Jing-yilin";
    userEmail = "yilin.jing@outlook.com";
    includes = [
      { path = "~/dotfiles/git/config"; }
    ];
    ignores = [
      ".DS_Store"
      "*.swp"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";
    };
  };

  # ZSH 配置
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    
    # 使用 home-manager 的插件管理而不是 oh-my-zsh 的
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.7.1";
          sha256 = "sha256-gOG0NLlaJfotJfs+SUhGgLTNOnGLjoqnUp54V9aFJg8=";
        };
      }
    ];

    # Add oh-my-zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"                # Git 命令缩写
        "docker"            # Docker 命令补全
        "docker-compose"    # Docker-compose 命令补全
        "npm"              # NPM 命令补全
        "python"           # Python 命令补全
        "sudo"             # 双击 ESC 添加 sudo
        "vscode"           # VSCode 命令
        "z"                # 快速跳转目录
        "colored-man-pages"      # 给 man 页面添加颜色
        "command-not-found"      # 命令未找到时提供建议
        "extract"               # 一键解压各种格式
        "history"              # 历史命令增强
        "jsontools"           # JSON 格式化工具
        "web-search"         # 快速搜索
        "copypath"          # 复制当前路径
        "copyfile"          # 复制文件内容
        "dirhistory"        # 目录导航历史
        "aliases"           # 别名管理
      ];
      theme = "robbyrussell";
    };

    initExtraFirst = ''
      # Custom functions
      mkcd() {
        mkdir -p "$1" && cd "$1"
      }
    '';

    initExtra = ''
      # History configuration
      HISTFILE="$HOME/.zsh_history"
      HISTSIZE=50000
      SAVEHIST=50000

      # History options
      setopt EXTENDED_HISTORY
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_REDUCE_BLANKS
      setopt HIST_VERIFY
      setopt SHARE_HISTORY
      unsetopt BANG_HIST

      # Other options
      setopt AUTO_CD
      setopt CORRECT

      # Key bindings
      bindkey -e
      bindkey '\e\e[C' forward-word
      bindkey '\e\e[D' backward-word

      # Initialize direnv
      eval "$(direnv hook zsh)"

      # Initialize zoxide
      eval "$(zoxide init zsh)"

      # Conda initialization
      __conda_setup="$(~/anaconda3/bin/conda 'shell.zsh' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "~/anaconda3/etc/profile.d/conda.sh" ]; then
              . "~/anaconda3/etc/profile.d/conda.sh"
          fi
      fi
      unset __conda_setup

      # Rust environment
      [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
    '';

    shellAliases = {
      # Compression
      gz = "tar -xzvf";
      tgz = "tar -xzvf";
      bz2 = "tar -xjvf";

      # Applications
      mate = "open -a \"TextMate\"";
      crm = "open -a \"Google Chrome\"";
      webstorm = "open -a \"WebStorm\"";
      idea = "open -a \"IntelliJ IDEA\"";
      markdown = "open -a \"Typora\"";
      code = "open -a \"Visual Studio Code\"";

      # General
      his = "history";
      ll = "ls -alh";
      la = "ls -a";
      l = "ls -lh";
      ls = "ls --color=auto";
      vim = "nvim";

      # Tree
      t = "tree -L 1";
      t2 = "tree -L 2";
      t3 = "tree -L 3";

      # Python
      pv = "python -m venv .venv";

      # System
      zz = "source ~/.zshrc";

      # Wave
      wv = "wsh view";
      we = "wsh edit";
      ww = "wsh web open";
      wsv = "wsh setvar";
      wr = "wsh run";
      wrx = "wsh run -x";
      wm = "wsh getmeta";
      wa = "wsh ai";

      # Common apps
      c = "cursor";
      v = "nvim";
      p = "python";

      # System monitoring
      top = "htop";
      btm = "bottom";
      df = "duf";
      ps = "procs";
      gl = "glances";
      cpu = "htop -s PERCENT_CPU";
      mem = "htop -s PERCENT_MEM";
      disk = "duf";
      sys = "glances";
    };
  };

  # 让 home-manager 管理自己
  programs.home-manager.enable = true;

  home.file.".config/pip/pip.conf" = {
    source = ./pip/pip.conf;
    force = true;
  };
} 