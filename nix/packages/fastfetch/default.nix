{
  pkgs,
  ...
}:
{
  wrappers.fastfetch = {
    program = pkgs.fastfetch;
    paths = {
      ".config/fastfetch/config.jsonc" = ./config.jsonc;
    };
  };
}
