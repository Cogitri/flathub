#!/bin/bash

set -e

POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -a|--add-udev-rule)
        ADD_UDEV_RULE=true
        shift
        ;;
        *)
        POSITIONAL+=("$1")
        shift
        ;;
    esac
done
set -- "${POSITIONAL[@]}"

if [ "x$ADD_UDEV_RULE" = "xtrue" ]; then
    pkexec sh -c "echo 'SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666"' > '/etc/udev/rules.d/60-sidequest.rules'  && udevadm control --reload-rules && udevadm trigger --subsystem-match=usb --attr-match=idVendor=2833 --action=add"
    exit 0
fi

export TMPDIR="$XDG_RUNTIME_DIR"/app/$FLATPAK_ID

exec zypak-wrapper "/app/sidequest/sidequest" "$@"
