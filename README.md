# 安装指南 (Installation Guide)

本指南提供了如何在新的机器上安装和配置您的 Nix 环境的步骤。

This guide provides steps on how to install and configure your Nix environment on a new machine.

---

## 前提条件 (Prerequisites)

在开始之前，请确保您已经将 `~/.config/nix` 目录复制到新机器上的相同位置。

Before you begin, make sure you have copied the `~/.config/nix` directory to the same location on the new machine.

---

## 安装步骤 (Installation Steps)

1. **修改必要的变量 (Modify Necessary Variables)**

   在运行安装脚本之前，请根据您的环境修改以下文件中的变量：

   - **`env.nix`**

     修改以下环境变量以适应您的系统：

     - `JAVA_HOME`：设置为您系统上 Java 的安装路径。
     - `GOROOT`：设置为您系统上 Go 的安装路径。
     - `NVM_DIR`：如果您使用 NVM，请设置为 NVM 的安装路径。
     - `MODULAR_HOME`：设置为您的 Modular 安装路径。
     - `PATH`：根据您的需求，添加或修改路径。

   - **`home.nix`**

     - `home.username`：修改为您的用户名。
     - `home.homeDirectory`：修改为您的主目录路径（通常为 `/Users/<your_username>`）。
     - 在 `programs.git` 部分，更新：

       - `userName`：您的 Git 用户名。
       - `userEmail`：您的 Git 邮箱。

   - **`flake.nix`**

     - 在 `darwinConfigurations` 中，确认主机名（如 `"mac-m1"`）是否与您的机器匹配，或者根据需要修改。

2. **安装 Home Manager**

   由于您的配置使用了 `home-manager`，请按照以下步骤安装：

   ```bash
   nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
   nix-channel --update
   nix-shell '<home-manager>' -A install
   ```

   **注意：** 根据您的 Nix 和 `home-manager` 版本，可能需要调整以上命令。请参阅 [Home Manager 文档](https://nix-community.github.io/home-manager/) 以获取最新的安装说明。

3. **运行安装脚本 (Run Installation Script)**

   运行提供的 `install.sh` 脚本进行一键安装：
   ```bash
   chmod +x install.sh
   ./install.sh   ```

   该脚本将执行以下操作：

   - 安装 Nix 包管理器
   - 加载 Nix 配置
   - 检查并安装 Xcode 命令行工具（如果未安装）
   - 安装 `nix-darwin`
   - 应用您的 `flake.nix` 配置

---

## 重新加载配置 (Reload Configuration)

当您修改了配置文件后，需要重新加载配置才能使更改生效。根据修改的内容，使用以下相应的命令：

1. **修改了 `flake.nix` 或系统级配置**

   ```bash
   darwin-rebuild switch --flake .#mac-m1
   ```

2. **仅修改了 `home.nix` 或用户级配置**

   ```bash
   home-manager switch --flake .#zephyr
   ```

3. **同时修改了 `flake.nix` 和 `home.nix`**

   ```bash
   darwin-rebuild switch --flake .#mac-m1 && home-manager switch --flake .#zephyr
   ```

4. **如果遇到缓存问题，可以添加 `--impure` 标志**

   ```bash
   darwin-rebuild switch --flake .#mac-m1 --impure
   ```

**注意：** 重新加载配置后，某些更改可能需要重新登录或重启系统才能完全生效。

---

## 注意事项 (Notes)

- **Xcode 命令行工具**

  如果您的系统尚未安装 Xcode 命令行工具，脚本将在安装过程中提示您。请按照屏幕指示完成安装，然后继续执行脚本。

- **权限问题**

  如果在执行过程中遇到权限问题，请确保您具有必要的权限，或者使用 `sudo` 提升权限（仅在必要时）。

- **故障排除**

  - 确保您的 Nix 配置文件（如 `flake.nix`、`home.nix` 等）中的语法正确。
  - 如果遇到任何错误，请查看错误信息，并根据提示进行修复。

---

## 参考资料 (References)

- [Nix 官方网站](https://nixos.org/)
- [nix-darwin 仓库](https://github.com/LnL7/nix-darwin)
- [Home Manager 仓库](https://github.com/nix-community/home-manager)

---

**最后，感谢您使用此安装指南，希望对您有所帮助！**

---

Thank you for using this installation guide. We hope it helps! 