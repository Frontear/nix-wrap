{
  mkShellNoCC,

  bubblewrap,
  nil,
}:
mkShellNoCC {
  packages = [
    bubblewrap
    nil
  ];
}
