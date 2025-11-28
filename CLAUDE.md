# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a cross-platform Nix configuration repository using flakes to manage:
- **macOS (Darwin)** - via nix-darwin for system configuration
- **NixOS (Linux)** - for system configuration
- **Home-Manager** - for user-level configuration and dotfiles across all platforms

The configuration supports multiple systems:
- `attolia` - macOS (aarch64-darwin)
- `volantis` - NixOS Framework laptop (x86_64-linux)
- `nixos` - ARM Linux VM (aarch64-linux)
- `nixos-pw-vm` - x86_64 Linux Parallels VM

## Repository Structure

### Core Configuration Files

- `flake.nix` - Main entry point defining all inputs, outputs, and system configurations
- `config.nix` - Nixpkgs configuration (allowUnfree, etc.)
- `default.nix` - Flake compatibility shim for nixd LSP completions
- `modules/common.nix` - Shared configuration for all platforms (timezone, nix settings, shell config)
- `modules/overlays.nix` - Package overlays for custom builds and flake inputs

### Platform-Specific Modules

- `modules/darwin/` - macOS system configuration via nix-darwin
  - `core.nix` - System-level settings, fonts, launch daemons
  - `brew.nix` - Homebrew declarative configuration via nix-homebrew
  - `preferences.nix` - macOS defaults and system preferences
  - `pam.nix` - Touch ID sudo authentication with tmux support

- `modules/nixos/` - NixOS system configuration
  - Main config in `default.nix` with i3 window manager setup

- `modules/home-manager/` - User environment configuration
  - `default.nix` - Core package lists and dotfiles (27000+ lines)
  - `home-darwin.nix` - Darwin-specific home config (app aliasing)
  - `home-linux.nix` - Linux-specific home config
  - `home-security.nix` - Security tools (only on volantis)
  - `shell-scripts.nix` - Custom shell script derivations
  - `dotfiles/` - Managed dotfiles (wezterm, lf, zsh, etc.)

### Hardware Configurations

- `modules/hardware/` - Hardware-specific configurations
  - `framework-volantis.nix` - Framework laptop 11th gen Intel
  - `parallels*.nix` - Parallels VM configurations
  - `volantis.nix` - Host-specific settings

## Building and Deployment

### macOS (Darwin) - Current System

Apply changes to the current system (`attolia`):
```bash
darwin-rebuild switch --flake ~/.config/nixpkgs#attolia
```

Build without switching:
```bash
nix build './#darwinConfigurations.attolia.system' --show-trace
```

Build with verbose logging:
```bash
nix --extra-experimental-features 'nix-command flakes' build './#darwinConfigurations.attolia.system' --log-format raw --verbose --show-trace
```

### NixOS

Build and switch a NixOS configuration:
```bash
sudo nixos-rebuild switch --flake .#volantis
sudo nixos-rebuild switch --flake .#nixos
sudo nixos-rebuild switch --flake .#nixos-pw-vm
```

### Home Manager Standalone

If using home-manager directly (less common with this config):
```bash
home-manager switch --flake .
```

### Flake Operations

Update flake inputs:
```bash
nix flake update
```

Update specific input:
```bash
nix flake lock --update-input nixpkgs-unstable
```

Show flake metadata:
```bash
nix flake metadata ~/.config/nixpkgs
```

Check flake:
```bash
nix flake check
```

## Architecture Patterns

### Dual Channel Strategy

The configuration uses both stable and unstable nixpkgs:
- `nixpkgs-unstable` - Default for most packages and follows `nixos-unstable`
- `nixpkgs-stable` - For packages needing stability (follows `nixos-25.05`)
- `nixpkgs-stable-darwin` - Darwin-specific stable channel (`nixpkgs-25.05-darwin`)

Access stable packages in modules via `pkgs.stable.packageName`.

### Overlay Architecture

Overlays in `modules/overlays.nix` provide:
1. **Channel exposure** - Makes `pkgs.stable` available everywhere
2. **Custom package builds** - Wrapped or patched packages (aichat-wrapped, hackernews-tui)
3. **Flake input packages** - Exposes external flake packages (pwnvim, ghostty, ironhide, pwai, etc.)
4. **Build fixes** - Platform-specific build adjustments (darwin frameworks, vendorHash updates)

### Home Manager Integration

Uses the `mkHome` helper function in `flake.nix` to create home-manager configurations:
```nix
mkHome username [module1 module2 ...]
```

This pattern ensures:
- `useGlobalPkgs = true` - Shares nixpkgs instance
- `useUserPackages = true` - Installs to user profile
- `backupFileExtension = "bak"` - Backs up conflicting files
- Passes `inputs` and `username` as specialArgs

### Homebrew Declarative Management

Uses `nix-homebrew` to pin Homebrew taps and make them rollback-compatible:
- Taps pinned as flake inputs (homebrew-core, homebrew-cask, etc.)
- `mutableTaps = false` - Prevents imperative `brew tap`
- Configured in `modules/darwin/brew.nix`

### Application Linking (macOS)

Custom activation script in `home-darwin.nix` uses `mkalias` instead of symlinks:
- Creates aliases in `~/Applications/Home Manager Apps/`
- Avoids Finder permission issues with symlinks
- Uses the `mkalias` flake package

## Key Custom Packages

Several packages come from external flakes (defined in `flake.nix` inputs):
- **pwnvim** - Custom neovim configuration as a flake (github:zmre/pwnvim)
- **pwneovide** - Neovide wrapper for pwnvim with macOS app bundle
- **pwai** - Private AI assistant (private repo)
- **pwaerospace** - Aerospace + Sketchybar + JankyBorders configs (github:zmre/aerospace-sketchybar-nix-lua-config)
- **ironhide** / **ironoxide-cli** - IronCore Labs security tools
- **ghostty** - Terminal emulator
- **mkalias** - Creates macOS aliases without Finder permissions

## Utility Scripts

### System Status
```bash
./status.sh
```
Shows nixpkgs update date, generation count, and vulnerable packages via vulnix.

### Show Recent Updates
```bash
./updated.sh
```
Runs `dwshowupdates` function showing diff between last two generations.

### Cleanup
```bash
./cleanup.sh
```
Likely for garbage collection (not read in detail).

## Important Environment Variables

Set in `modules/home-manager/default.nix`:
- `NIX_PATH` - Points to unstable and stable channels in `/etc`
- `EDITOR=nvim`, `VISUAL=nvim`, `GIT_EDITOR=nvim`
- `PAGER="page -WO -q 90000"` - Uses `page` (nvim-based pager)
- `ZK_NOTEBOOK_DIR` - Points to iCloud Notes on macOS, `~/Notes` on Linux

## Security Considerations

- Uses StevenBlack hosts file (with IPv6 localhost stripped via patch)
- Touch ID sudo via custom PAM module with tmux reattach support
- Separate security profile for `volantis` (`home-security.nix`)
- Regular vulnerability scanning via vulnix in `status.sh`

## Testing and Verification

After making changes, verify with:
```bash
# Check for build errors
nix flake check

# Test build without switching
nix build './#darwinConfigurations.attolia.system'

# View changes before applying
./updated.sh  # after rebuild to see diff
```

## Common Patterns

### Adding a New Package

1. For system packages: Add to `environment.systemPackages` in relevant module
2. For user packages: Add to package list in `modules/home-manager/default.nix`
3. For packages needing stable: Use `pkgs.stable.packageName`
4. For external flakes: Add input in `flake.nix`, expose via overlay in `modules/overlays.nix`

### Modifying Dotfiles

Dotfiles are managed in `modules/home-manager/dotfiles/`:
- Wezterm: `dotfiles/wezterm/wezterm.lua`
- ZSH configurations spread across multiple modules
- Terminfo definitions in `dotfiles/terminfo/`

### Working with Overlays

When adding custom builds or fixing package issues:
1. Add overlay function to `modules/overlays.nix`
2. Use `prev.packageName.overrideAttrs` for attribute changes
3. Use `prev.buildRustPackage` or similar for new packages
4. Update `vendorHash` with `prev.lib.fakeHash`, then fix with real hash from error

## Username Conventions

- macOS (Darwin): `pwalsh`
- NixOS: `zmre`

These are defined in the respective `darwinConfigurations` and `nixosConfigurations` sections of `flake.nix`.
