{ ... }:

{
  environment.systemPackages = with pkgs; [
    restic
    rclone
  ];
  # services.restic.backups = {
  #   gdrive = {
  #     user = "backups";
  #     repository = "rclone:gdrive:/backups";
  #     initialize = true; # initializes the repo, don't set if you want manual control
  #     passwordFile = "<path>";
  #   };
  # };
}
