let
  pkgs = import <nixpkgs> {};
  lib = pkgs.lib;
in (lib.evalModules {
  modules = [
    ({ _module.args = { inherit pkgs; }; })
    (builtins.getFlake (toString ../.)).nixosModules.default
    ({
      wrappers.bash = {
        program = pkgs.bash;

        paths = [
          ({
            src = ./bashrc;
            dest = ".bashrc";
          })
        ];
      };
    })
  ];
}).config.wrappers.bash.package
