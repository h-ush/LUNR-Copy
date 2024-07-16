#!/bin/bash

##############################################################
#
# OFFICIAL RSYNC TRANSPORT SCRIPT
#
# Functionality:
#   This program will send files and directories across
#   devices on the same network to seamlessly allow users
#   have files stored in two locations. The program will
#   create a log file on both devices so users are aware
#   of the Copy Activity that has perspired on their
#   device using this tool.
#
# Notes:
#   1. Must create checks for files
#   2. Must make sure script is compatible with Windows
#   3. Set proper permissions on files as they are being
#      transferred across systems
#   4. Write a hash function to maintain integrity and
#      verify if hashes of files match
#   5. Write an encryption function to encrypt log data
#   6. GO CRAZY HAVE FUN!
#
# Date Created: 07-03-2024
#
# Created by
#   Craig Edelin Jr
#
#                                           VERSION 1.0
#
##############################################################
SUDO_PATH="/usr/bin/sudo"
DATE_MADE=$(date "+%d-%m-%Y") # Gets the current date from the device
LINUX_IP=$(hostname -I | cut -f1 -d ' ') # Gets the IP address of the SENDER

##############################################################
#
# Imports other shell scripts to the file
#
# ############################################################
source $(pwd)/transfer.sh
source $(pwd)/utility.sh
source $(pwd)/logging.sh

function main() {
  title_for_program

  environment_check

  transfer_to_destination_device

  log

  # transfer_log_data_to_destination_device

  find_log_file

  move_log_file_to_logs
  # hash_creation ${DIRECTORY}/*
}

main
