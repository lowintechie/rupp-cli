#!/bin/bash

# rupp-cli - Main script for Network Security CLI Tool


LIB_DIR="/usr/share/rupp-cli"

source "$LIB_DIR/config.sh"
source "$LIB_DIR/banner.sh"
source "$LIB_DIR/checks.sh"
source "$LIB_DIR/status.sh"
source "$LIB_DIR/firewall.sh"
source "$LIB_DIR/selinux.sh"
source "$LIB_DIR/ssh.sh"
source "$LIB_DIR/ids.sh"
source "$LIB_DIR/updates.sh"
source "$LIB_DIR/audit.sh"
source "$LIB_DIR/harden.sh"
source "$LIB_DIR/help.sh"

main() {
    show_banner
    check_root
    check_dependencies

    local command=$1
    shift

    case "$command" in
        status) check_system_status ;;
        audit) run_security_audit ;;
        firewall) manage_firewall "$@" ;;
        selinux) manage_selinux "$@" ;;
        ssh) harden_ssh "$@" ;;
        ids) manage_ids "$@" ;;
        updates) manage_updates "$@" ;;
        harden) one_click_hardening "$@" ;;
        help) show_help "$1" ;;
        *)
            echo -e "${RED}Error: Unknown command '$command'${NC}"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
