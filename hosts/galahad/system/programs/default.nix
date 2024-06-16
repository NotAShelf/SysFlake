{
  pkgs,
  username,
  ...
}: {
  environment.systemPackages = with pkgs; [
    deluge
    pavucontrol
    mpv
    via
    keepassxc
    bambu-studio
    libreoffice-qt
    plexamp
    vesktop
  ];

  programs = {
    partition-manager.enable = true;
    noisetorch.enable = true;
    oc.enable = true;
    art.enable = true;
    customNeovim.enable = true;
    utils.enable = true;
    obs-studio.enable = true;
    syncthing.usermodeEnable = true;
    vscodium.enable = true;

    nh = {
      enable = true;
      flake = "/home/${username}/.nixos-conf";
    };

    firefox = {
      enable = true;
      customPreferences = true;
      customExtensions = true;
      customPolicies = true;
      customSearchEngine = true;
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
      anyrun.enable = true;

      # Look into the module, this adds alot of shit
      defaults = {
        enable = true;

        additional = {
          exec-once = [
            #Autostart
            "[workspace 2 silent] vesktop"
            "[workspace 2 silent] plexamp"
            "[workspace 3 silent] firefox-esr"
            "[workspace 5 silent] keepassxc"

            "noisetorch -i"
          ];

          windowrules = [
            "workspace 2, plexamp"
            "workspace 2, vesktop"
            "workspace 5, keepassxc"
          ];
        };
      };
    };

    zsh = {
      enable = true;
      customConf = true;
    };

    foot = {
      enable = true;
      customConf = true;
    };

    dev = {
      git.enable = true;
      utils.enable = true;
      java.enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        # Unusued, but it's here when I need it
      ];
    };

    game = {
      utils.enable = true; # Misc game programs
      steam.enable = true;
      mangohud.enable = true;
    };
  };
}
