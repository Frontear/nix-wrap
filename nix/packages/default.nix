{
  self,
  lib,
  ...
}:
{
  perSystem = { pkgs, ... }:
  let
    wrappers = (lib.evalModules {
      modules = [
        ({ _module.args.pkgs = pkgs; })
        self.nixosModules.default
        ./bash
        ./fastfetch
      ];
    }).config.wrappers;
  in {
    packages.wrapped-bash = wrappers.bash.package;
    packages.wrapped-fastfetch = wrappers.fastfetch.package;
  };
}
