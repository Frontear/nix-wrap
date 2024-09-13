{
  writeShellApplication,

  writeTextFile,

  bubblewrap,
}:
let
  drv = writeTextFile {
    name = "bashrc-drv";
    # Expected packaging.
    destination = "/home/.bashrc";

    text = ''
      PS1="(in-bwrap) $PS1"
    '';
  };
in writeShellApplication {
  name = "drv-wrapper";

  runtimeInputs = [
    bubblewrap
  ];

  text = ''
    declare -a ro_mounts
    declare -a hm_mounts

    while read -r mnt; do
      ro_mounts+=(--ro-bind "$mnt" "$mnt")
    done < <(find / -mindepth 1 -maxdepth 1 -type d -not -name "home" -a -not -name "dev" -a -not -name "sys")

    while read -r mnt; do
      hm_mounts+=(--ro-bind "$mnt" "/home/$(whoami)/''${mnt//*\/home\//}")
    done < <(find ${drv}/home -mindepth 1 -maxdepth 1)

    cmd=(
      bwrap
      --die-with-parent
      --tmpfs "/home/$(whoami)"
      --dir "/home/$(whoami)/.cache"
      --dir "/home/$(whoami)/.conig"
      --dir "/home/$(whoami)/.local"
      --dev-bind /dev /dev
      --dev-bind /sys /sys
      "''${ro_mounts[@]}"
      "''${hm_mounts[@]}"
      bash
    )

    exec "''${cmd[@]}"
  '';
}
