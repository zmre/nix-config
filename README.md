# Nix Home-Manager Config

**This is experimental.**

When using this, clone somewhere and then link to `~/.config/nixpkgs` -- or just clone to that path. Either way.

```bash
docker run -it nixos/nix
git clone https://github.com/zmre/nix-config.git
nix-shell -p git
git clone https://github.com/zmre/nix-config.git
mkdir .config
ln -s nix-config .config/nixpkgs
nix-instantiate '<nixpkgs>' -A hello
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch
zsh
```

If you get segfaults, try this:

```bash
nix-store --verify --check-contents --repair
```

And a direct build looks something like:

```bash
nix --extra-experimental-features 'nix-command flakes' build './#darwinConfigurations.attolia.system' --log-format raw --verbose --show-trace
```
