# Defunct Nix Config [ARCHIVED / RELOCATED]

I experimented with a new format for building nix configs that has a much more modular approach without a lot of the ugly boilerplate of classic modular setups.  It uses a "dendritic" pattern with flake-parts.  Because it was such a huge change, I just started it in a fresh repo.  This repo is getting archived.

## 🚨🚨 New Repo: [pw-nix-dendritic](https://github.com/zmre/pw-nix-dendritic)

---


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
