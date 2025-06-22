# Define system and user variables as NixOS options
{
  lib,
  pkgs ? null,
  ...
}:
{
  # Module definition that can be imported
  mkVarsModule =
    { config, lib, ... }:
    {
      options = {
        systemVars = {
          # Required system variables
          hostname = lib.mkOption {
            type = lib.types.str;
            description = "Hostname of the system";
          };

          system = lib.mkOption {
            type = lib.types.str;
            description = "System architecture (e.g., x86_64-linux)";
          };

          # Optional system variables with defaults
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

          isMinimal = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this is a minimal installation";
          };
        };

        userVars = {
          # Required user variables
          userName = lib.mkOption {
            type = lib.types.str;
            description = "Username for the primary user";
          };

          name = lib.mkOption {
            type = lib.types.str;
            description = "Short name for the primary user";
          };

          fullName = lib.mkOption {
            type = lib.types.str;
            description = "Full name of the primary user";
          };

          email = lib.mkOption {
            type = lib.types.str;
            description = "Email address of the primary user";
          };
          rootHashedPassword = lib.mkOption {
            type = lib.types.str;
            description = "Hashed password for the host's user";
          };
          hashedPassword = lib.mkOption {
            type = lib.types.str;
            description = "Hashed password for the host's user";
          };

          home = lib.mkOption {
            type = lib.types.str;
            description = "The home directory of the user";
            default =
              let
                user = config.userVars.userName;
              in
              "/home/${user}";
          };

          # Optional user variables with defaults
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
        };
      };
    };
}
