#!/usr/bin/env bash

declare -a extra_mounts
declare -a home_mounts

for m in $(find / -mindepth 1 -maxdepth 1 -type d -not -name "dev" -a -not -name "home" -a -not -name "nix" -not -name "proc" -a -not -name "run" -a -not -name "tmp" -print); do
    extra_mounts+=(--ro-bind $m $m)
done

for m in $(find fake-drv -mindepth 1 -maxdepth 1 -print); do
    dir=$(basename $m)
    home_mounts+=(--bind $m /home/$(whoami)/$dir)
done

cmd=(
    bwrap
    --chdir /home/$(whoami)
    --dev-bind /dev /dev
    --ro-bind /nix /nix
    --ro-bind /run /run
    --proc /proc
    --tmpfs /home/$(whoami)
    --tmpfs /tmp
    --die-with-parent
    "${extra_mounts[@]}"
    "${home_mounts[@]}"
    bash
)

exec "${cmd[@]}"
