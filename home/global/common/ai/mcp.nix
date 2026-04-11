{ pkgs, lib, ... }:
let
  # Central MCP server definitions in programs.mcp format.
  # Add new servers here and they'll be picked up by all supported tools.
  mcpServers = {
    context7 = {
      command = lib.getExe pkgs.unstable.context7-mcp;
      args = [
        "--transport"
        "stdio"
      ];
    };
    mcp-nixos = {
      command = lib.getExe pkgs.mcp-nixos;
    };
    # Requires GITHUB_PERSONAL_ACCESS_TOKEN in the environment (set via sops/shell init).
    # OAuth alternative: replace this stdio entry with the remote HTTP server instead —
    #   { url = "https://api.githubcopilot.com/mcp/"; }
    # The remote server supports OAuth in VS Code 1.101+ (no token needed) but requires
    # an Authorization: Bearer header for claude-code and opencode. Use the local binary
    # until sops wiring for the PAT header is in place.
    github-mcp-server = {
      command = lib.getExe pkgs.github-mcp-server;
    };
    mcp-server-git = {
      command = lib.getExe pkgs.mcp-server-git;
    };
    mcp-server-memory = {
      command = lib.getExe pkgs.mcp-server-memory;
    };
    # meta.mainProgram is wrong in nixpkgs for this package, use getExe' explicitly.
    mcp-server-sequential-thinking = {
      command = lib.getExe' pkgs.mcp-server-sequential-thinking "mcp-server-sequential-thinking";
    };
  };

  # programs.claude-code.mcpServers requires an explicit type field.
  toClaudeMcpServers = lib.mapAttrs (
    _: server:
    if server ? url then
      {
        type = "http";
        inherit (server) url;
      }
      // lib.optionalAttrs (server ? headers) { inherit (server) headers; }
    else
      {
        type = "stdio";
        inherit (server) command;
      }
      // lib.optionalAttrs (server ? args) { inherit (server) args; }
      // lib.optionalAttrs (server ? env) { inherit (server) env; }
  );
in
{
  # Writes ~/.config/mcp/mcp.json — the shared MCP config consumed by opencode
  # (via enableMcpIntegration) and any other tool that follows the MCP standard.
  programs.mcp = {
    enable = true;
    servers = mcpServers;
  };

  # claude-code manages its own MCP config via --mcp-config flag.
  programs.claude-code.mcpServers = toClaudeMcpServers mcpServers;

  # opencode reads from programs.mcp.servers when this is true.
  programs.opencode.enableMcpIntegration = true;
}
