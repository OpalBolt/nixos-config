# Host specifications for differentiating hosts
{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.hostSpec = {
    # System variables
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "Hostname of the system";
    };

    system = lib.mkOption {
      type = lib.types.str;
      description = "System architecture (e.g., x86_64-linux)";
    };

    timezone = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Copenhagen";
      description = "System timezone";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_DK.UTF-8";
      description = "System locale";
    };

    extraLocale = lib.mkOption {
      type = lib.types.str;
      default = "da_DK.UTF-8";
      description = "Additional system locale";
    };

    kbdLayout = lib.mkOption {
      type = lib.types.str;
      default = "dk";
      description = "Keyboard layout";
    };

    consoleKbdKeymap = lib.mkOption {
      type = lib.types.str;
      default = "dk-latin1";
      description = "Console keyboard keymap";
    };

    # User variables
    username = lib.mkOption {
      type = lib.types.str;
      description = "Username for the primary user";
    };

    name = lib.mkOption {
      type = lib.types.str;
      description = "Short name for the primary user";
    };

    userFullName = lib.mkOption {
      type = lib.types.str;
      description = "Full name of the primary user";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "Email address of the primary user";
    };

    rootHashedPassword = lib.mkOption {
      type = lib.types.str;
      description = "Hashed password for the root user";
    };

    hashedPassword = lib.mkOption {
      type = lib.types.str;
      description = "Hashed password for the primary user";
    };

    home = lib.mkOption {
      type = lib.types.str;
      description = "The home directory of the user";
      default =
        let
          user = config.hostSpec.username;
        in
        "/home/${user}";
    };

    dotfilesDir = lib.mkOption {
      type = lib.types.str;
      default = "~/.dotfiles";
      description = "Directory containing dotfiles";
    };

    font = lib.mkOption {
      type = lib.types.str;
      default = "IosevkaTerm Nerd Font Mono";
      description = "Primary font for the user";
    };

    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "Default text editor";
    };

    fontSize = lib.mkOption {
      type = lib.types.int;
      default = 10;
      description = "Default font size";
    };

    shell = lib.mkOption {
      type = lib.types.enum [
        pkgs.zsh
        pkgs.bash
      ];
      default = pkgs.zsh;
      description = "Default shell (pkgs.zsh or pkgs.bash)";
    };

    # Configuration flags (inspired by the example)
    isMinimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a minimal host";
    };

    isMobile = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a mobile host";
    };

    isServer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a server host";
    };

    isWork = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a host that uses work resources";
    };

    useYubikey = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate if the host uses a yubikey";
    };

    useWindowManager = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Used to indicate a host that uses a window manager";
    };

    scaling = lib.mkOption {
      type = lib.types.str;
      default = "1";
      description = "Used to indicate what scaling to use. Floating point number";
    };
  };

  # Optional: Add any assertions you want to enforce
  config = {
    assertions = [
      {
        assertion = !config.hostSpec.isWork || config.hostSpec.hostname != "";
        message = "hostname must be set for work hosts";
      }
    ];
  };
}
