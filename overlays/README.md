# Overlays in Nix

This README explains what Nix overlays are, how they work, and how they're implemented in this configuration.

## What Are Overlays?

In Nix, an overlay is a function that takes the final package set (`final`) and the previous package set (`prev`) as arguments, and returns a set of packages to be added or modified in the package set.

Think of overlays as layers of modifications applied on top of the standard Nixpkgs collection. Each overlay can:

- Add new packages
- Modify existing packages
- Create composite packages
- Provide convenient access to packages from different sources

## Why Use Overlays?

Overlays provide several benefits:

1. **Modularity**: Keep package modifications organized and isolated
2. **Composition**: Apply multiple overlays in a specific order
3. **Reusability**: Use the same overlay across different configurations
4. **Consistency**: Ensure all your systems get the same modifications

## How Overlays Work

Overlays follow this signature:

```nix
final: prev: { ... }
```

Where:

- `final`: The complete package set after all overlays are applied
- `prev`: The package set as it exists before this overlay is applied

Inside the overlay function, you return an attribute set (a key-value map) of packages to add or modify.

### Examples from This Repository

#### Adding Custom Packages

```nix
# From our additions overlay
additions = final: prev:
  let 
    # Check if pkgs directory exists, otherwise return empty set
    pkgsPath = ../pkgs;
    pkgsExists = builtins.pathExists pkgsPath;
  in
  if pkgsExists then 
    import pkgsPath { pkgs = final; }
  else
    { };
```

#### Making VS Code Extensions Available

```nix
# From our vscode-extensions overlay
vscode-extensions = final: prev: {
  vscode-extensions = inputs.nix-vscode-extensions.extensions.${prev.system};
};
```

#### Adding Unstable Packages

```nix
# From our unstable-packages overlay
unstable-packages = final: _prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit (final) system;
    config.allowUnfree = true;
  };
};
```

## Overlays in This Configuration

Our overlays system is structured as follows:

### Main Overlay File (`default.nix`)

This file combines multiple overlay components into a single overlay using the `//` operator (which merges attribute sets).

### Overlay Components

1. **additions**
   - Adds custom packages from the `/pkgs` directory
   - Uses `packagesFromDirectoryRecursive` to automatically include all packages

2. **linuxModifications**
   - Contains Linux-specific package modifications
   - Uses `mkIf` to conditionally apply modifications only on Linux systems

3. **modifications**
   - General package overrides and customizations
   - Where you'd put custom versions, patches, or compile flags

4. **vscode-extensions**
   - Makes VS Code extensions available from the nix-vscode-extensions input
   - Accessible via `pkgs.vscode-extensions`

5. **stable-packages**
   - Makes stable packages available under `pkgs.stable`
   - Allows explicitly referencing stable packages even when using unstable for other things

6. **unstable-packages**
   - Makes unstable packages available under `pkgs.unstable`
   - Allows using bleeding-edge packages where needed

### How It All Fits Together

The `default.nix` file exports a default overlay that combines all the components:

```nix
{
  default = final: prev:
    (additions final prev)
    // (modifications final prev)
    // (linuxModifications final prev)
    // (vscode-extensions final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev);
}
```

This structure allows each component to focus on a specific task, making the overlays more maintainable.

## How to Use These Overlays

### In the flake.nix

The overlays are imported and made available in the flake:

```nix
overlays = import ./overlays { inherit inputs; };
```

And then applied in the NixOS configuration:

```nix
nixpkgs.overlays = [ self.overlays.default ];
```

### Using the Packages

Once applied, you can use the packages as follows:

- **Custom packages**: `pkgs.your-package-name`
- **Modified packages**: Used just like regular packages
- **VS Code extensions**: `pkgs.vscode-extensions.<extension-name>`
- **Stable packages**: `pkgs.stable.<package-name>`
- **Unstable packages**: `pkgs.unstable.<package-name>`

## Adding Your Own Overlays

To add your own package modifications or custom packages:

1. **For package modifications**

   Add your modifications to the `modifications` function in `default.nix`. For example, if you wanted to modify Neovim to include vim aliases:

   ```nix
   # Example of how you could add to the modifications section in default.nix
   modifications = final: prev: {
     # Existing code from our repository
     # example = prev.example.overrideAttrs (oldAttrs: rec {
     # ...
     # });
     
     # New modification example
     neovim = prev.neovim.override {
       viAlias = true;
       vimAlias = true;
     };
   };
   ```

2. **For custom packages**

   Create a new package definition in the `pkgs/common` directory, and it will be automatically included.

---

With overlays, you have a powerful tool for customizing your Nix packages while keeping your configuration clean and maintainable.
