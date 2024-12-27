#!/bin/bash

# Install Nix
echo "🚀[Install] Starting Nix installation..."
curl -L https://nixos.org/nix/install | sh

# Load Nix configuration for the current shell
echo "🔄[Config] Loading Nix configuration..."
. ~/.nix-profile/etc/profile.d/nix.sh

# Enable Flakes and Nix Command
echo "⚙️[Config] Enabling Nix features..."
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Check and install Xcode Command Line Tools
if ! xcode-select -p &>/dev/null; then
  echo "🛠️[Tools] Installing Xcode Command Line Tools..."
  xcode-select --install
  read -p "🛠️[Tools] Please complete the installation of Xcode Command Line Tools and then press any key to continue..."
fi

# Install Home Manager
echo "🏠[Install] Installing Home Manager..."
nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install

# Install nix-darwin
echo "🌟[Install] Installing nix-darwin..."
git clone https://github.com/LnL7/nix-darwin ~/.nix-defexpr/darwin

echo "🔧[Build] Building nix-darwin installer..."
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer

echo "💻[Install] Running nix-darwin installer..."
./result/bin/darwin-installer

# Navigate to nix configuration directory
echo "📂[Config] Navigating to nix configuration directory..."
cd ~/.config/nix

# Apply your nix-darwin configuration
echo "⚙️[Config] Applying nix-darwin configuration..."
darwin-rebuild switch --flake .#mac-m1

# Done
echo "✅[Complete] Installation finished!" 