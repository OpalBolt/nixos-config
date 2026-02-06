{
  config,
  pkgs,
  inputs,
  lib,
  hostSpec,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets.outPath;
  # Use a user-accessible directory for reports
  reportDir = "${config.home.homeDirectory}/.local/share/lynis-reports";
  logFile = "${reportDir}/upload_status.log";

  # Custom Lynis profile to handle NixOS-specific architectural differences.
  lynisProfile = pkgs.writeText "nixos.prf" ''
    # NixOS stores kernels in the Nix store, not /boot, which triggers a false positive in KRNL-5830.
    skip-test=KRNL-5830

    # Virtual machine interfaces (vnet0, etc.) often run in promiscuous mode for bridging.
    # Skipping NETW-3012 prevents these expected VM interfaces from being flagged as security errors.
    skip-test=NETW-3012
  '';

  workAuditScript = pkgs.writeShellScriptBin "work-audit" ''
    # 1. Retrieve Secrets
    USERNAME=$(cat ${config.sops.secrets."lynis/username".path})
    PASSWORD=$(cat ${config.sops.secrets."lynis/password".path})
    USERID=$(cat ${config.sops.secrets."lynis/userid".path})

    # 2. Setup Variables
    CURRENT_DATE=$(date +%m_%Y)
    FILENAME="''${USERID}_''${CURRENT_DATE}"
    FILEPATH="${reportDir}/$FILENAME"

    # Lynis identifies security software by searching for their binaries in the system PATH.
    # On NixOS, we must explicitly provide these binaries (fail2ban, clamav, iptables)
    # so Lynis can verify their rules/status and mark these categories as "green".
    export PATH=$PATH:${
      lib.makeBinPath [
        pkgs.iptables
        pkgs.nftables
        pkgs.systemd
        #pkgs.fail2ban
        pkgs.clamav
      ]
    }

    UPLOAD=true
    for arg in "$@"; do
      if [ "$arg" == "--no-upload" ]; then
        UPLOAD=false
      fi
    done

    # Ensure report directory exists
    mkdir -p ${reportDir}

    # 3. Run Audit
    echo "Starting Lynis audit..."
    # pkexec is picky about the SHELL variable and usually cleans the environment.
    # We wrap the command in '/bin/sh -c' to ensure the PATH we exported above 
    # is preserved and available to the Lynis process running as root.
    SHELL=/bin/sh /run/wrappers/bin/pkexec /bin/sh -c "PATH=$PATH ${pkgs.lynis}/bin/lynis audit system --quick --profile ${lynisProfile}" > "$FILEPATH" 2>&1

    # 4. Upload
    if [ "$UPLOAD" = true ]; then
        echo "Uploading to Eficloud..."
        if ${pkgs.curl}/bin/curl -g -T "$FILEPATH" -u "$USERNAME:$PASSWORD" -H 'X-Requested-With: XMLHttpRequest' https://eficloud.eficode.com/public.php/webdav/; then
            echo "$(date): Upload of $FILENAME - SUCCESS" >> "${logFile}"
            echo "Upload successful."
        else
            echo "$(date): Upload of $FILENAME - FAILURE" >> "${logFile}"
            echo "Upload failed."
            exit 1
        fi
    else
        echo "Skipping upload as requested."
        echo "Report saved to: $FILEPATH"
    fi
  '';
in
{
  home.packages = [
    workAuditScript
    pkgs.lynis
    pkgs.curl
  ];

  sops.secrets = {
    "lynis/username" = {
      sopsFile = "${secretspath}/secrets/${hostSpec.hostname}.yaml";
    };
    "lynis/password" = {
      sopsFile = "${secretspath}/secrets/${hostSpec.hostname}.yaml";
    };
    "lynis/userid" = {
      sopsFile = "${secretspath}/secrets/${hostSpec.hostname}.yaml";
    };
  };

  systemd.user.services.work-audit = {
    Unit = {
      Description = "Monthly Eficode Lynis Audit and Upload";
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${workAuditScript}/bin/work-audit";
      Restart = "on-failure";
      RestartSec = "1h";
    };
  };

  systemd.user.timers.work-audit = {
    Unit = {
      Description = "Trigger work-audit service on the last day of every month at 08:00";
    };
    Timer = {
      OnCalendar = "*-*~01 08:00:00";
      Persistent = true;
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
