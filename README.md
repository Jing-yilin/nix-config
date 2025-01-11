# Nix Configuration

这是我的个人 Nix 配置文件，用于快速配置 macOS 系统环境。

This is my personal Nix configuration for quickly setting up macOS environment.

## 快速开始 (Quick Start)

1. **克隆仓库 (Clone Repository)**

   ```bash
   git clone https://github.com/Jing-yilin/nix-config.git ~/.config/nix
   cd ~/.config/nix
   ```

2. **运行安装脚本 (Run Install Script)**

   ```bash
   chmod +x install.sh
   ./install.sh
   ```

安装脚本会自动完成以下操作：
- 安装 Nix 包管理器
- 配置 Nix Flakes
- 安装 Xcode Command Line Tools
- 安装并配置 Home Manager
- 安装并配置 nix-darwin
- 应用系统配置

## 配置更新 (Configuration Updates)

当修改配置文件后，使用以下命令应用更改：

```bash
darwin-rebuild switch --flake .#default
```

## 故障排除 (Troubleshooting)

如果遇到权限问题，请确保：
1. 已经安装了 Xcode Command Line Tools
2. 具有 ~/.config/nix 目录的写入权限
3. 具有执行 install.sh 的权限

如果遇到 Nix 相关错误，可以尝试：
```bash
# 使用 --impure 标志
darwin-rebuild switch --flake .#default --impure

# 或者清理并重建
nix-collect-garbage -d
darwin-rebuild switch --flake .#default
```

## 目录结构 (Directory Structure)

```
.
├── flake.nix          # Nix Flakes 配置
├── home.nix           # Home Manager 配置
├── env.nix            # 环境变量配置
└── install.sh         # 安装脚本
```

## 参考资料 (References)

- [Nix](https://nixos.org/)
- [nix-darwin](https://github.com/LnL7/nix-darwin)
- [Home Manager](https://github.com/nix-community/home-manager) 