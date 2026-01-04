{ config, lib, ... }:
{
  # Security configuration for the system

  # Enable GNOME Keyring for desktop systems only
  # This provides a secure storage for passwords, SSH keys, and other secrets
  # integrated with PAM (Pluggable Authentication Modules)
  security.pam.services.${config.hostSpec.username}.enableGnomeKeyring = lib.mkIf (
    !config.hostSpec.isMinimal
  ) true;

  # Enable PolicyKit for desktop systems only
  # This allows unprivileged processes to communicate with privileged processes
  # in a secure way, essential for desktop environments and user-friendly admin tasks
  security.polkit.enable = lib.mkIf (!config.hostSpec.isMinimal) true;
}
