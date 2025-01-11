{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    # 基础环境变量
    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    HIST_STAMPS = "%Y-%m-%d %H:%M:%S";
    
    # Node 环境
    NVM_DIR = "$HOME/.nvm";
    
    # 其他环境变量
    JUPYTER_PLATFORM_DIRS = "1";
    
    # PATH 配置
    PATH = with lib; concatStringsSep ":" [
      "~/.npm-global/bin"
      "~/.local/bin"
      "~/anaconda3/bin"
      "$PATH"
      "."
    ];
  };
} 