{ config, pkgs, lib, ... }:

{
  home.sessionVariables = {
    # 基础环境变量
    EDITOR = "nvim";
    VISUAL = "nvim";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    HIST_STAMPS = "%Y-%m-%d %H:%M:%S";
    
    # Java 环境
    JAVA_HOME = "/Library/Java/JavaVirtualMachines/jdk1.8.0_331.jdk/Contents/Home";
    CLASSPATH = "$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.";
    
    # Go 环境
    GOROOT = "/Users/zephyr/go1.22/go1.22.2";
    GO111MODULE = "auto";
    
    # Node 环境
    NVM_DIR = "$HOME/.nvm";
    
    # 其他环境变量
    JUPYTER_PLATFORM_DIRS = "1";
    
    # Mojo 环境
    MODULAR_HOME = "/Users/zephyr/.modular";
    
    # PATH 配置
    PATH = with lib; concatStringsSep ":" [
      "$JAVA_HOME/bin"
      "$GOROOT/bin"
      "$GOROOT"
      "/Applications/CMake.app/Contents/bin"
      "~/.npm-global/bin"
      "/Library/apache-maven-3.8.6/bin"
      "/Users/zephyr/.local/bin"
      "/Users/zephyr/anaconda3/bin"
      "/Users/zephyr/.modular/pkg/packages.modular.com_mojo/bin"
      "$PATH"
      "."
    ];
  };
} 