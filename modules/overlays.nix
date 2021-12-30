{ inputs, nixpkgs, stable, ... }: {
  nixpkgs.overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable = import stable {
        system = prev.system;
        config.allowUnfree = true;
        nix.package = inputs.nixos-stable.nix_2_4;
      };
      #trunk = import inputs.trunk { system = prev.system; };
      #small = import inputs.small { system = prev.system; };
    })
    inputs.nur.overlay
  ];
}
