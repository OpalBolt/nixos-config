{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  secretspath = builtins.toString inputs.nix-secrets.outPath;

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
      command = lib.getExe pkgs.unstable.mcp-nixos;
    };
    # GITHUB_PERSONAL_ACCESS_TOKEN is exported from sops below.
    # OAuth alternative (no token needed for VS Code 1.101+, but requires
    # Authorization header for claude-code/opencode — not yet wired):
    #   { url = "https://api.githubcopilot.com/mcp/"; }
    github-mcp-server = {
      command = lib.getExe pkgs.unstable.github-mcp-server;
    };
    mcp-server-git = {
      command = lib.getExe pkgs.unstable.mcp-server-git;
    };
    mcp-server-memory = {
      command = lib.getExe pkgs.unstable.mcp-server-memory;
    };
    # meta.mainProgram is wrong in nixpkgs for this package, use getExe' explicitly.
    mcp-server-sequential-thinking = {
      command = lib.getExe' pkgs.unstable.mcp-server-sequential-thinking "mcp-server-sequential-thinking";
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
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops.secrets."github/pat" = {
    sopsFile = "${secretspath}/secrets/personal.yaml";
  };

  # Export the PAT so github-mcp-server (and gh CLI) can pick it up.
  programs.zsh.initContent = ''
    if [ -f "${config.sops.secrets."github/pat".path}" ]; then
      export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat ${config.sops.secrets."github/pat".path})
    fi
  '';

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

  # GitHub Copilot CLI reads from ~/.copilot/mcp-config.json.
  # It requires `args` to be present (even if empty) for stdio servers.
  home.file.".copilot/mcp-config.json".text = builtins.toJSON {
    mcpServers = lib.mapAttrs (
      _: server:
      if server ? url then
        server
      else
        { args = [ ]; } // server
    ) mcpServers;
  };
}
