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

  # Enforce stronger password hashing
  security.pam.services.passwd.passwordAuth = true;

  security.loginDefs.settings = {
    # Increase rounds significantly from default (5000), but keep it
    # fast enough (approx 200-300ms) to avoid timeouts in apps.
    SHA_CRYPT_MIN_ROUNDS = 500000;
    SHA_CRYPT_MAX_ROUNDS = 500000;
    
    # DISABLE password aging (0 or -1 usually disables, but omitting these keys 
    # lets them default to "forever" or system defaults which are usually safe).
    # We explicitly do NOT set PASS_MAX_DAYS here to avoid forced expiry.
  };
}
