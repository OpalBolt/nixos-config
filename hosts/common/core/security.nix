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

  # ---------------------------------------------------------------------------------------
  # AUDIT & ACCOUNTING
  # ---------------------------------------------------------------------------------------
  # WARNING: This configuration is the "Lighter" version.
  # The strict version (logging all 'execve' calls) causes massive log volume and
  # performance issues (micro-stutters) on desktop systems.
  #
  # IF YOU EXPERIENCE PERFORMANCE ISSUES:
  # 1.  Disable auditing by setting: `security.audit.enable = false;`
  # 2.  Or remove specific rules from `security.audit.rules`.
  # ---------------------------------------------------------------------------------------

  # Enable the Linux Audit subsystem (auditd)
  security.audit.enable = true;
  security.audit.rules = [
    # Log changes to critical system time (prevents tampering with log timestamps)
    "-a exit,always -F arch=b64 -S adjtimex -S settimeofday -k time-change"
    "-a exit,always -F arch=b64 -S clock_settime -k time-change"
    "-w /etc/localtime -p wa -k time-change"

    # Log changes to user/group information (critical security events)
    "-w /etc/group -p wa -k identity"
    "-w /etc/passwd -p wa -k identity"
    "-w /etc/gshadow -p wa -k identity"
    "-w /etc/shadow -p wa -k identity"

    # Log changes to network environment (optional, low noise)
    "-w /etc/hosts -p wa -k system-locale"
    "-w /etc/network -p wa -k system-locale"

    # -----------------------------------------------------------------------------------
    # HEAVY RULES - DISABLED FOR PERFORMANCE
    # Uncommenting the following line would log EVERY command executed.
    # DO NOT ENABLE unless specifically debugging an intrusion.
    # "-a exit,always -F arch=b64 -S execve -k exec_log"
    # -----------------------------------------------------------------------------------
  ];

  # Enable process accounting
  # Starts the 'acct' service. This logs a summary of every process that closes.
  # It is generally lightweight, but writes to disk constantly.
  # Set to 'false' if disk I/O is a bottleneck.
  security.acct.enable = true;
}
