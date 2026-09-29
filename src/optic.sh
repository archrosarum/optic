#!/bin/bash

case "$1" in
    init)
        dir="${2:-.}"
        mkdir -p -- "$dir"
        shopt -s nullglob dotglob
        for entry in "$dir"/*; do
            [ "${entry##*/}" = ".DS_Store" ] && continue
            printf '%s: path "%s" is not empty\n' "${0##*/}" "$dir" >&2
            exit 1
        done
        touch "$dir/.optic"
        ;;
    *)
        printf '%s: "%s" is not an optic command\n' "${0##*/}" "$1"
        ;;
esac