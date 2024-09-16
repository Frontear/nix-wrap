{
  pkgs,
  ...
}:
{
  wrappers.bash = {
    program = pkgs.bash;
    paths = {
      ".bashrc" = ./bashrc;
    };
  };
}
