{ config, pkgs, inputs, lib, osConfig, ... }:
let
  secretspath = toString inputs.nix-secrets.outPath;
  hostname = osConfig.networking.hostName;
  reportDir = "${config.home.homeDirectory}/.local/share/lynis-reports";
  logFile = "${reportDir}/upload_status.log";

  lynisProfile = pkgs.writeText "nixos.prf" ''
    skip-test=KRNL-5830
    skip-test=NETW-3012
  '';

  workAuditScript = pkgs.writeShellScriptBin "work-audit" ''
    USERNAME=$(cat ${config.sops.secrets."lynis/username".path})
    PASSWORD=$(cat ${config.sops.secrets."lynis/password".path})
    USERID=$(cat ${config.sops.secrets."lynis/userid".path})

    CURRENT_DATE=$(date +%m_%Y)
    FILENAME="''${USERID}_''${CURRENT_DATE}"
    FILEPATH="${reportDir}/$FILENAME"

    export PATH=$PATH:${
      lib.makeBinPath [
        pkgs.iptables
        pkgs.nftables
        pkgs.systemd
        pkgs.fail2ban
        pkgs.clamav
      ]
    }

    UPLOAD=true
    for arg in "$@"; do
      if [ "$arg" == "--no-upload" ]; then
        UPLOAD=false
      fi
    done

    mkdir -p ${reportDir}

    echo "Starting Lynis audit..."
    if ! SHELL=/bin/sh /run/wrappers/bin/pkexec /bin/sh -c "PATH=$PATH ${pkgs.lynis}/bin/lynis audit system --quick --profile ${lynisProfile}" > "$FILEPATH" 2>&1; then
        echo "Audit failed or was cancelled. Cleaning up..."
        rm -f "$FILEPATH"
        exit 1
    fi

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
    "lynis/username".sopsFile = "${secretspath}/secrets/${hostname}.yaml";
    "lynis/password".sopsFile = "${secretspath}/secrets/${hostname}.yaml";
    "lynis/userid".sopsFile = "${secretspath}/secrets/${hostname}.yaml";
  };

  systemd.user.services.work-audit = {
    Unit.Description = "Monthly Eficode Lynis Audit and Upload";
    Service = {
      Type = "oneshot";
      ExecStart = "${workAuditScript}/bin/work-audit";
      Restart = "on-failure";
      RestartSec = "1h";
    };
  };

  systemd.user.timers.work-audit = {
    Unit.Description = "Trigger work-audit service on the last day of every month at 08:00";
    Timer = {
      OnCalendar = "*-*~01 08:00:00";
      Persistent = true;
    };
    Install.WantedBy = [ "timers.target" ];
  };
}
