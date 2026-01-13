{
  config,
  lib,
  ...
}:

{

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$all"
      ];
      right_format = "\${custom.timewarrior}";

      # Custom Timewarrior module
      custom.timewarrior = {
        command = "~/scripts/timew_status.sh";
        when = "true";
        shell = [
          "bash"
          "--noprofile"
          "--norc"
        ];
        format = " [$output]($style)";
        style = "bold green";
      };
    };
  };
}
