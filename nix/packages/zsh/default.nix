{
  pkgs,
  ...
}:
{
  wrappers.zsh = {
    program = pkgs.zsh;

    paths = [
      {
        src = ./zshrc;
        dest = ".config/zsh/.zshrc";
      }
      {
        src = ./zshenv;
        dest = ".zshenv";
      }
    ];
  };
}
