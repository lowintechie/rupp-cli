#!/bin/bash

source "$(dirname "$0")/config.sh"



show_banner() {
    clear
    echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║                                                                   ║${NC}"
    echo -e "${BLUE}║${WHITE}                ██████╗ ██╗   ██╗██████╗ ██████╗                  ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                ██╔══██╗██║   ██║██╔══██╗██╔══██╗                 ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                ██████╔╝██║   ██║██████╔╝██████╔╝                 ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                ██╔══██╗██║   ██║██╔═══╝ ██╔═══╝                  ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                ██║  ██║╚██████╔╝██║     ██║                      ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝                      ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                       ██████╗██╗     ██╗                         ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                      ██╔════╝██║     ██║                         ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                      ██║     ██║     ██║                         ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                      ██║     ██║     ██║                         ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                      ╚██████╗███████╗██║                         ${BLUE}║${NC}"
    echo -e "${BLUE}║${WHITE}                       ╚═════╝╚══════╝╚═╝                         ${BLUE}║${NC}"
    echo -e "${BLUE}║                                                                   ║${NC}"
    echo -e "${BLUE}║  ${GREEN}Network Security Tool - v1.0.0                                    ${BLUE}║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}