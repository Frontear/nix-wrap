# Nix Wrap
A powerful wrapping alternative for Nix/OS.

The main goal of this is to provide isolated filesystems powered by Bubblewrap that keep program configurations. This provides a cleaner home alongside a more pure and isolated approach to configuration.

## Installing
1. Add `nix-wrap` to your flake inputs and `nix-wrap.nixosModules.default` to your configuration(s):
```nix
{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.nix-wrap.url = "github:Frontear/nix-wrap";

  outputs = { nixpkgs, nix-wrap, ... } @ inputs: {
    nixosConfigurations."my-host123" = nixpkgs.lib.nixosSystem {
      modules = [
        nix-wrap.nixosModules.default

        ./configuration.nix
      ];
    };
  };
}
```

## Usage
1. Declare a new `wrapper.<name>` block in your configuration, following the provided format:
```nix
{
  config,
  pkgs,
  ...
}:
{
  wrappers.my-app = {
    # This app will be immediately run when accessing the drv.
    program = pkgs.my-app;

    # Paths are of format { src = ...; dest = ...; }, where
    #   - src is a relative path to your config file
    #   - dest is a string path that is bind mounted to the bwrap.
    paths = [
      {
        src = ./config.json;
        dest = ".config/my-app/config.json";
      }
    ];
  };

  environment.systemPackages = [
    # Adds the final wrapped package to your environment
    config.wrappers.my-app.package
  ];
}
```
2. Run your program via `<name>-wrapper`. The above example would be run via `my-app-wrapper`, which will drop you into a bwrap that exists immediately when the program closes.

## License
All code in this project is licensed under the MIT License. This was an intentional choice to hopefully ease integration into [nixpkgs](https://github.com/NixOS/nixpkgs).
