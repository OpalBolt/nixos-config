{ pkgs, ... }:

{
  home.packages = with pkgs.unstable; [
    context7-mcp
    mcp-nixos
    mcp-server-git
    mcp-server-memory
    #mcp-server-sequential-thinking
  ];
}
