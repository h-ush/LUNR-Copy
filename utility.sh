#!/bin/bash

##############################################################
function title_for_program() {
  GREEN '                                                                                   '
  GREEN '@@@       @@@  @@@  @@@  @@@  @@@@@@@       @@@@@@@   @@@@@@   @@@@@@@   @@@ @@@  '
  GREEN '@@@       @@@  @@@  @@@@ @@@  @@@@@@@@     @@@@@@@@  @@@@@@@@  @@@@@@@@  @@@ @@@  '
  GREEN '@@!       @@!  @@@  @@!@!@@@  @@!  @@@     !@@       @@!  @@@  @@!  @@@  @@! !@@  '
  GREEN '!@!       !@!  @!@  !@!!@!@!  !@!  @!@     !@!       !@!  @!@  !@!  @!@  !@! @!!  '
  GREEN '@!!       @!@  !@!  @!@ !!@!  @!@!!@!      !@!       @!@  !@!  @!@@!@!    !@!@!   '
  GREEN '!!!       !@!  !!!  !@!  !!!  !!@!@!       !!!       !@!  !!!  !!@!!!      @!!!   '
  GREEN '!!:       !!:  !!!  !!:  !!!  !!: :!!      :!!       !!:  !!!  !!:         !!:    '
  GREEN ':!:      :!:  !:!  :!:  !:!  :!:  !:!     :!:       :!:  !:!  :!:         :!:    '
  GREEN ':: ::::  ::::: ::   ::   ::  ::   :::      ::: :::  ::::: ::   ::          ::    '
  GREEN ': :: : :   : :  :   ::    :    :   : :      :: :: :   : :  :    :           :     '
  GREEN '                                                                                   '
}

##############################################################
#
# Output Color Functions
#
# GREEN --> SUCCESS
# WHITE --> STANDARD OUTPUT
# YELLOW --> WARNING
# RED --> ERROR
#
##############################################################
function GREEN() {
  # echo -e "\e[32m$@\e[0m" # REGULAR GREEN

  echo -e "\e[1;32m$@\e[0m" # BOLD GREEN
}

function WHITE() {
  echo -e "\e[37m$@\e[0m" # REGULAR WHITE

  # echo -e "\e[1;37m$@\e[0m" # BOLD WHIE
}

function YELLOW() {
  # echo -e "\e[33m$@\e[0m" # REGULAR YELLOW

  echo -e "\e[1;33m$@\e[0m" # BOLD YELLOW
}

function RED() {
  # echo -e "\e[31m$@\e[0m" # REGULAR RED

  echo -e "\e[1;31m$@\e[0m" # BOLD RED
}

##############################################################
#
# Checks if script is being run in sudo mode
#
##############################################################
function environment_check() {
  if [ $(id -u) == 0 ]; then
    RED "THIS SCRIPT CANNOT BE RUN AS ROOT. PLEASE RE-RUN THE SCRIPT AS A NORMAL USER"
    exit -1
  fi
}
