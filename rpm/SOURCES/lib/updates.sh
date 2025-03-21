#!/bin/bash

manage_updates() {
    local action=$1
    case "$action" in
        check)
            dnf check-update
            ;;
        apply)
            dnf -y upgrade
            ;;
        security-only)
            dnf -y upgrade --security
            ;;
        schedule)
            dnf -y install dnf-automatic
            sed -i 's/^apply_updates.*/apply_updates = yes/' /etc/dnf/automatic.conf
            systemctl enable --now dnf-automatic.timer
            ;;
        *)
            echo "Unknown updates action"
            ;;
    esac
}