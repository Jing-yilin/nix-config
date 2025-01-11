#!/bin/bash

# Check if the script is running from ~/.config/nix
if [[ "$PWD" != "$HOME/.config/nix" ]]; then
    echo "❌[Error] Please run this script from ~/.config/nix directory"
    echo "📝[Info] First clone the repository:"
    echo "git clone https://github.com/Jing-yilin/nix-config.git ~/.config/nix"
    echo "cd ~/.config/nix"
    echo "./install.sh"
    exit 1
fi

# Install Nix
if ! command -v nix &>/dev/null; then
    echo "🚀[Install] Starting Nix installation..."
    curl -L https://nixos.org/nix/install | sh
    
    # Load Nix configuration for the current shell
    echo "🔄[Config] Loading Nix configuration..."
    . ~/.nix-profile/etc/profile.d/nix.sh
else
    echo "✓[Check] Nix is already installed"
fi

# Enable Flakes and Nix Command
echo "⚙️[Config] Enabling Nix features..."
mkdir -p ~/.config/nix
if ! grep -q "experimental-features" ~/.config/nix/nix.conf 2>/dev/null; then
    echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
fi

# Check and install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
    echo "🛠️[Tools] Installing Xcode Command Line Tools..."
    xcode-select --install
    read -p "🛠️[Tools] Please complete the installation of Xcode Command Line Tools and then press any key to continue..."
else
    echo "✓[Check] Xcode Command Line Tools already installed"
fi

# Install Home Manager
if ! command -v home-manager &>/dev/null; then
    echo "🏠[Install] Installing Home Manager..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
    nix-channel --update
    export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
    nix-shell '<home-manager>' -A install
else
    echo "✓[Check] Home Manager already installed"
fi

# Install nix-darwin
if [ ! -d "$HOME/.nix-defexpr/darwin" ]; then
    echo "🌟[Install] Installing nix-darwin..."
    git clone https://github.com/LnL7/nix-darwin ~/.nix-defexpr/darwin

    echo "🔧[Build] Building nix-darwin installer..."
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer

    echo "💻[Install] Running nix-darwin installer..."
    ./result/bin/darwin-installer
else
    echo "✓[Check] nix-darwin already installed"
fi

# Apply your nix-darwin configuration
echo "⚙️[Config] Applying nix-darwin configuration..."
darwin-rebuild switch --flake .#default

# Done
echo "✅[Complete] Installation finished!"
echo "🎉[Success] Your Nix environment is ready to use!" 