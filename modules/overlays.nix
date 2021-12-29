{ inputs, nixpkgs, stable, ... }: {
  nixpkgs.overlays = [
    # channels
    (final: prev: {
      # expose other channels via overlays
      stable = import stable { system = prev.system; };
      #trunk = import inputs.trunk { system = prev.system; };
      #small = import inputs.small { system = prev.system; };
    })
    inputs.nur.overlay
  ];
}
