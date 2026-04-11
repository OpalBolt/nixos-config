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
