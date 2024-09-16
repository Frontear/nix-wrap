{
  lib,
  writeShellApplication,
  bubblewrap,

  program,
  paths,
}:
let
  homeExcludes = lib.pipe paths [
    (map (p: p.dest))
    (map (p: lib.splitString "/" p))
    (map (x: lib.elemAt x 0))
    (map (p: "$HOME/${p}"))
    (lib.concatStringsSep " ")
  ];
in writeShellApplication {
  name = "${lib.getName program}";
  runtimeInputs = [ bubblewrap ];

  text = ''
    declare -a root_args
    declare -a home_args

    # Mount all available entries in '/',
    # ignoring a few that we specially handle.
    for mnt in "/"*; do
      if [[ ! "/dev /home /nix" =~ $mnt ]]; then
        root_args+=(--bind "$mnt" "$mnt")
      fi
    done

    # Mount all entries from paths into '$HOME'.
    # TODO: this can get dangerously long and
    # cause bwrap to fail.
    # see: https://github.com/containers/bubblewrap/issues/413
    for mnt in "$HOME"/{.*,*}; do
      if [[ ! "${homeExcludes}" =~ $mnt ]]; then
        home_args+=(--bind "$mnt" "$mnt")
      else
        for entry in "$mnt"/*; do
          home_args+=(--bind "$entry" "$entry")
        done
      fi
    done

    cmd=(
      bwrap
      --die-with-parent

      --tmpfs "$HOME"

      --dev-bind /dev /dev
      --bind /nix /nix
      --remount-ro /nix/store

      ${lib.concatStringsSep "\n" (lib.forEach paths (p:
        ''--bind "${p.src}" "$HOME/${p.dest}"''
      ))}

      "''${root_args[@]}"
      "''${home_args[@]}"

      ${lib.getExe program}
    )

    exec "''${cmd[@]}"
  '';
}
