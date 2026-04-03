{ lib, den, inputs, ... }:
{
  # All users get homeManager class by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];

  # Enable bidirectional host↔user config via .provides.*
  den.ctx.user.includes = [ den._.mutual-provider ];

  # Apply define-user (users.users.* + HM home.username/homeDirectory) and hostname globally
  den.default.includes = [
    den._.define-user
    den._.hostname
  ];

  # NixOS state version and pkgs.unstable overlay for all hosts
  den.default.nixos = { ... }: {
    system.stateVersion = "25.05";
    nixpkgs.overlays = [
      (final: prev: {
        unstable = inputs.nixpkgs-unstable.legacyPackages.${prev.system};
      })
    ];
  };

  # HM state version for all users
  den.default.homeManager.home.stateVersion = "24.05";

  # Make flake inputs available to HM modules as extraSpecialArgs,
  # enabling `{ inputs, ... }:` and `imports = [ inputs.*.homeManagerModules.* ]`.
  den.ctx.hm-host.nixos.home-manager.extraSpecialArgs = { inherit inputs; };
}
