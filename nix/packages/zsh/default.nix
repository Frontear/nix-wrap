{
  pkgs,
  ...
}:
{
  wrappers.zsh = {
    program = pkgs.zsh;
    paths = {
      ".zshenv" = ./zshenv;
      ".config/zsh/zshrc" = ./zshrc;
    };
  };
}
