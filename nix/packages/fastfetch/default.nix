{
  pkgs,
  ...
}:
{
  wrappers.fastfetch = {
    program = pkgs.fastfetch;

    paths = [
      {
        src = ./config.jsonc;
        dest = ".config/fastfetch/config.jsonc";
      }
    ];
  };
}
