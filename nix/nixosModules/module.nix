{
  lib,
  pkgs,
  ...
}:
let
  pathsSubmodule = {
    options = {
      src = lib.mkOption {
        default = null;
        description = "todo";

        type = with lib.types; path;
      };

      dest = lib.mkOption {
        default = null;
        description = "todo";

        type = with lib.types; str;
      };
    };
  };

  wrappersSubmodule = ({ config, ... }: {
    options = {
      package = lib.mkOption {
        readOnly = true;
        internal = true;

        type = with lib.types; package;
      };

      program = lib.mkOption {
        default = null;
        description = "todo";

        type = with lib.types; package;
      };

      paths = lib.mkOption {
        default = [];
        description = "todo";

        type = with lib.types; listOf (submodule pathsSubmodule);
      };
    };

    config = {
      package = pkgs.callPackage ./wrapper.nix { inherit (config) program paths; };
    };
  });
in {
  options = {
    wrappers = lib.mkOption {
      default = {};
      description = "todo";

      type = with lib.types; attrsOf (submodule wrappersSubmodule);
    };
  };
}
