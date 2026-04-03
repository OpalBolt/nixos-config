{ ... }:
{
  den.aspects.security = {
    nixos = { lib, pkgs, ... }: {
      environment.systemPackages = [ pkgs.seahorse ];
      services.gnome.gnome-keyring.enable = true;
      services.gnome.gcr-ssh-agent.enable = lib.mkForce false;
      security.polkit.enable = true;
      security.loginDefs.settings = {
        SHA_CRYPT_MIN_ROUNDS = 500000;
        SHA_CRYPT_MAX_ROUNDS = 500000;
      };
      environment.etc."issue".text =
        "Authorized access only. All activities are monitored and recorded.\n";
      security.audit.enable = false;
      security.audit.backlogLimit = 8192;
      security.audit.rules = [
        "-a exit,always -F arch=b64 -S adjtimex -S settimeofday -k time-change"
        "-a exit,always -F arch=b64 -S clock_settime -k time-change"
        "-w /etc/localtime -p wa -k time-change"
        "-w /etc/group -p wa -k identity"
        "-w /etc/passwd -p wa -k identity"
        "-w /etc/gshadow -p wa -k identity"
        "-w /etc/shadow -p wa -k identity"
        "-w /etc/hosts -p wa -k system-locale"
        "-w /etc/network -p wa -k system-locale"
      ];
    };

    homeManager = { ... }: {
      services.gnome-keyring = {
        enable = true;
        components = [ "pkcs11" "secrets" "ssh" ];
      };
    };
  };
}
