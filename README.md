# Nix Home-Manager Config

**This is experimental.**

When using this, clone somewhere and then link to `~/.config/nixpkgs` -- or just clone to that path. Either way.

```
docker run -it nixos/nix
git clone https://github.com/zmre/nix-config.git
nix-shell -p git
git clone https://github.com/zmre/nix-config.git
nix-instantiate '<nixpkgs>' -A hello
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
zsh
```
