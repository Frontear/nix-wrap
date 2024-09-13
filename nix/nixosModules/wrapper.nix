{
  lib,
  writeShellApplication,
  bubblewrap,

  program,
  paths,
}:
writeShellApplication {
  name = "${lib.getName program}-wrapper";
  runtimeInputs = [ bubblewrap ];

  text = ''
    home="/home/$(whoami)"

    declare -a ro_mounts
    declare -a hm_mounts

    while read -r mnt; do
      ro_mounts+=(--ro-bind "$mnt" "$mnt")
    done < <(find / -mindepth 1 -maxdepth 1 -type d -not -name "home" -a -not -name "dev" -a -not -name "sys")

    ${lib.concatStringsSep "\n" (lib.forEach paths (p:
      ''hm_mounts+=(--ro-bind "${p.src}" "$home/${p.dest}")''
    ))}

    cmd=(
      bwrap
      --die-with-parent
      --tmpfs "$home"
      --dir "$home/.cache"
      --dir "$home/.config"
      --dir "$home/.local"
      --dev-bind /dev /dev
      --dev-bind /sys /sys
      "''${ro_mounts[@]}"
      "''${hm_mounts[@]}"
      bash
    )

    exec "''${cmd[@]}"
  '';
}
