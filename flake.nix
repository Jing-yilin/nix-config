{
  description = "Yilin's Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, emacs-overlay, home-manager }:
  let
    system = "aarch64-darwin";
    userConfig = import ./config.nix;
    username = userConfig.username;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ emacs-overlay.overlay ];  # Add emacs overlay
    };
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      # Set the nixbld group ID to match the actual value
      ids.gids.nixbld = 350;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        home-manager.packages.${system}.default
        mkalias
        gh
      ];

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          upgrade = true;
        };
        brews = [
          "mas"
          "git-lfs"
          "node"
          "yarn"
          "yazi"
          "cliclick"
          "imagemagick"
          "yt-dlp"
        ];
        casks = [
          "alt-tab"
          "warp"
          "wave"
          "orbstack"
          "termius"
          "iina"
          "postman"
          # "chatgpt"
          # "whatsapp"
          # "element"
          # "wechat"
          "mac-mouse-fix"
          # "qlmarkdown"
          # "lulu"
          # "zipic"
          # "only-switch"
          "zed"
          "anydesk"
        ];
        masApps = {
          # "Yoink" = 457622435;
          # "Quantumult X" = 1443988620;
          # "Things" = 904280696;
          # "Bob" = 1630034110;
        };
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
        pkgs.nerd-fonts.hack
        pkgs.nerd-fonts.meslo-lg
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
      pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';

      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          # "${pkgs.obsidian}/Applications/Obsidian.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
          "/Applications/Arc.app"
        ];
        finder.FXPreferredViewStyle = "clmv";
        loginwindow.GuestEnabled = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        # NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      # Auto upgrade nix package and the daemon service.
      # services.nix-daemon.enable = true;  # Remove this line as it's no longer needed
      nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix = {
        enable = true;  # Add this line to explicitly enable nix
        optimise = {
          automatic = true;
          interval = {
            Hour = 0;
            Weekday = 0; # 每周日
          };
        };
        
        settings = {
          experimental-features = ["nix-command" "flakes"];
          trusted-users = ["root" "zephyr"];
          substituters = [
            "https://cache.nixos.org"
            "https://nix-community.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          ];
        };
      };

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."default" = nix-darwin.lib.darwinSystem {
      inherit system;
      modules = [ 
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = { 
              inherit inputs system username; 
            };
            users.${username} = import ./home.nix;
          };
        }
        {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            enable = true;

            # Apple Silicon Only
            enableRosetta = true;

            # User owning the Homebrew prefix
            user = username;
            autoMigrate = true;

            # Optional: Declarative tap management
            # taps = {
            #  "homebrew/homebrew-core" = homebrew-core;
            #  "homebrew/homebrew-cask" = homebrew-cask;
            #};
  
            # Optional: Enable fully-declarative tap management
            #
            # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
            # mutableTaps = false;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."default".pkgs;

    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgs;
      extraSpecialArgs = { inherit inputs username; };
      modules = [ ./home.nix ];
    };
  };
}
