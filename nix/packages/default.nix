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
        ./zsh
      ];
    }).config.wrappers;
  in {
    packages = {
      wrapped-bash = wrappers.bash.package;
      wrapped-fastfetch = wrappers.fastfetch.package;
      wrapped-zsh = wrappers.zsh.package;
    };
  };
}
