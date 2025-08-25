{ pkgs, config, ... }:
{
  # Security configuration for the system

  # Enable GNOME Keyring for password and secret management
  # This provides a secure storage for passwords, SSH keys, and other secrets
  # integrated with PAM (Pluggable Authentication Modules)
  security.pam.services.${config.hostSpec.username}.enableGnomeKeyring = true;

  # Enable PolicyKit for privilege escalation
  # This allows unprivileged processes to communicate with privileged processes
  # in a secure way, essential for desktop environments and user-friendly admin tasks
  security.polkit.enable = true;

  # ClamAV antivirus configuration
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
    updater.interval = "hourly";
  };
}
