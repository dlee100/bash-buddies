#!/usr/bin/env bash

# TODO:
# + elif grep arch
# + fwd/cp output to log
# + output summary of updates made

all() {
    if [[ $(grep -iw "fedora" /etc/os-release) ]]; then
        echo "Updating DNF"
        upd_dnf
    elif [[ $(grep -iw "ubuntu\|debian" /etc/os-release) ]]; then
        echo "Updating APT"
        upd_apt
    else
        echo "Should not be here"
        exit 1
    fi

    sleep 1
    upd_flatpak
    sleep 1
    upd_fw
    sleep 1
    echo "System updates completed."
}

allForce() {
    echo "Force updating DNF packages ...";
    sudo dnf update -y ; 
    echo "DNF is up to date FORCEFULLY.";
    echo "Force updating FLATPAK packages ..."; 
    sudo flatpak update -y ; 
    echo "FLATPAK is up to date FORCEFULLY."
    echo "Updating Firmware"
    sudo fwupdmgr get-devices 
    sudo fwupdmgr refresh --force 
    sudo fwupdmgr get-updates 
    sudo fwupdmgr update
    echo "Firmware is up to date."
    echo "Force update complete."
}

upd_dnf() {
    echo "Receiving signing keys from repos and updating packages ...";
    sudo dnf upgrade --refresh; 
    echo "DNF is up to date."; 
}

dnfForce() {
    sudo dnf update -y;
}

upd_apt() {
    echo "Updating and Upgrading APT."
    sudo apt update && sudo apt upgrade
    echo "APT update/upgrade complete."
}

aptForce() {
    sudo apt update -y && sudo apt upgrade -y
}

upd_flatpak() {
    echo "Updating FLATPAK packages ..."; 
    sudo flatpak update; 
    echo "FLATPAK is up to date."
}

flatpakForce() {
    sudo flatpak update -y;
}

upd_fw() {
    echo "Updating Firmware"
    sudo fwupdmgr get-devices 
    sudo fwupdmgr refresh --force 
    sudo fwupdmgr get-updates 
    sudo fwupdmgr update
    echo "Firmware is up to date."
}

case "${1}" in
    all)
        all
    ;;
    all-force)
        allForce
    ;;
    dnf)
        upd_dnf
    ;;
    dnf-force)
        dnfForce
    ;;
    apt)
        upd_apt
    ;;
    apt-force)
        aptForce
    ;;
    flatpak)
        upd_flatpak
    ;;
    flatpak-force)
        flatpakForce
    ;;
    fw)
        upd_fw
    ;;
esac

