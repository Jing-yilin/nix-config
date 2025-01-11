{ config, pkgs, lib, inputs, system, username, ... }:

let
  Follow = pkgs.stdenv.mkDerivation {
    pname = "Follow";
    version = "0.3.1-beta.0";
    
    src = pkgs.fetchurl {
      url = "https://github.com/RSSNext/Follow/releases/download/v0.3.1-beta.0/Follow-0.3.1-beta.0-macos-arm64.dmg";
      sha256 = "ed08f999dab97bca404e71b78cb7b46e10763997c8afad0dcb5e844f203b53e9";
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
  imports = [
    ./env.nix
    ./zsh.nix
  ];

  home = {
    username = username;
    homeDirectory = lib.mkForce "/Users/${username}";
    stateVersion = "23.11";
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
      ripgrep
      fd
      fzf
      zsh
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-powerlevel10k
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

  # 让 home-manager 管理自己
  programs.home-manager.enable = true;

  home.file.".config/karabiner/karabiner.json" = {
    source = ./karabiner/karabiner.json;
    force = true;
  };

  home.file.".config/sketchybar" = {
    source = ./sketchybar;
    recursive = true;
    force = true;
  };

  home.file.".config/pip/pip.conf" = {
    source = ./pip/pip.conf;
    force = true;
  };
} 