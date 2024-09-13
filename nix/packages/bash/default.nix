{
  pkgs,
  ...
}:
{
  wrappers.bash = {
    program = pkgs.bash;

    paths = [
      {
        src = ./bashrc;
        dest = ".bashrc";
      }
    ];
  };
}
