#!/bin/bash
# For these hacks please see https://www.kali.org/news/official-kali-linux-docker-images/
debootstrapScripts=/usr/share/debootstrap/scripts/

if [ ! -e "$debootstrapScripts/kali" ]; then
    pushd $debootstrapScripts

    curl "http://git.kali.org/gitweb/?p=packages/debootstrap.git;a=blob_plain;f=scripts/kali;hb=HEAD" > kali
    for i in "kali-rolling kali-dev kali-bleeding-edge kali-last-snapshot kali-experimental"; do
        ln -s kali $i
    done
fi

