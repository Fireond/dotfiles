#!/usr/bin/env sh

scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
pkgChk=("htop" "btop" "top")

for sysMon in "${!pkgChk[@]}"; do
    [ "${sysMon}" -gt 0 ] && term="kitty --class=system_monitor"
    if pkg_installed "${pkgChk[sysMon]}" ; then
        pkill -x "${pkgChk[sysMon]}" || ${term} "${pkgChk[sysMon]}" &
        break
    fi
done

