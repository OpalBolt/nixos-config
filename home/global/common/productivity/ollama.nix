{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    #acceleration = "rocm";
    package = pkgs.unstable.ollama;
  };
  home.packages = with pkgs; [
    aichat
  ];

}
