#!/bin/bash

DEBUG=1
LOG_LOCATION="/logs/"
LOG_FILE=$(date "+%d-%m-%Y")_$(date +%T | sed s/':'/''/g)

##############################################################
#
# Imports
#
##############################################################
source $(pwd)/utility.sh

##############################################################
#
# Debug statements to organize the log file
#
# MASTER LOG:
#    $1 --> ANSI COLOR CODE IN LOGS
#    $2 --> LOGGING INFORMATION
#    $3 --> EXTRA VARIABLES FOR LOGGING
#
# OTHER LOGS:
#    $1 --> LOGGING INFORMATION
#    $2 --> EXTRA VARIABLES FOR LOGGING
#
# COLORS:
#    $1 --> TEXT TO CHANGE TO SPECIFIED COLOR
#    $2 --> EXTRA VARIABLES
#
# ############################################################
function masterLog() {
  echo -e "[$(date)] : [ $1 ] : $2 $3\n" >> ${LOG_FILE}
}

function logSUCCESS() {
  if [[ $DEBUG == 1 ]]; then
    GREEN $1 $2
  fi
  masterLog "\e[1;32mSUCCESS\e[0m" "$1" "$2"
}

# Keeps track of basic input and output from the users entries
function logBASIC() {
  if [[ $DEBUG == 1 ]]; then
    WHITE $1 $2
  fi
  masterLog "\e[37mOUTPUT\e[0m" "$1" "$2"
}

# Keeps track of necessary info used during application use
function logINFO() {
  if [[ $DEBUG == 1 ]]; then
    YELLOW $1 $2
  fi
  masterLog "\e[1;33mINFO\e[0m" "$1" "$2"
}


function logERROR() {
  if [[ $DEBUG == 1 ]]; then
    RED $1 $2
  fi
  masterLog "\e[1;31mERROR\e[0m" "$1" "$2"
}


##############################################################
#
# Creates the log directory and file with sudo priviledges
#
##############################################################
function create_log_file() {
  if ! [ -f $LOGFILE ]; then
      if ! [ -d "${LOG_LOCATION}" ]; then
        ${SUDO_PATH} mkdir -p "${LOG_LOCATION}"
        logSUCCESS "LOG DIRECTORY ${LOG_LOCATION} CREATED!"
      fi
      touch ${LOG_FILE}
  fi
}

##############################################################
function move_log_file_to_logs() {
  ${SUDO_PATH} mv ${LOG_FILE} ${LOG_LOCATION}
}

##############################################################
#
# Creates the log directory and file with sudo priviledges
# It then takes all SENDER ACTIVITY && SENDER INFO and puts
# their information within the log file
#
# SENDER ACTIVITY --> The directory or file sent and where it
#                     went
#
# SENDER INFO --> The SENDER's username, hostname, and IP
#
##############################################################
function log() {
  echo "----------------------------------------------------"
  logINFO "BEGINNING LOGGING: $(date)"

  create_log_file

  echo ""
  logBASIC "DESIRED DIRECTORY    || " ${DIRECTORY_PATH}
  logBASIC "DESTINATION USERNAME || " ${USERNAME}
  logBASIC "DESTINATION IP       || " ${IP}
  logBASIC "DESTINATION LOCATION || " ${LOCATION}
  echo ""
  logBASIC "SENDER USERNAME || " $(whoami)
  logBASIC "SENDER HOSTNAME || " $(hostname)
  logBASIC "SENDER IP       || " ${LINUX_IP}

  echo ""
  # Moving the file to the destination so other user has log
  # ${SUDO_PATH} mv transport.log "${LOG_DIRECTORY}/${DATE_MADE}"
  logINFO "ESTABLISHING RSYNC SSH CONNECTION"
  # rsync -a "${LOG_DIRECTORY}/${DATE_MADE}/transport.log" "${USERNAME}"@"${IP}":"/tmp/"
  logSUCCESS "LOGGING COMPLETED"
  echo "----------------------------------------------------"
}

##############################################################
function find_log_file() {
  echo ""
  logBASIC "Your log file is saved at ${LOG_LOCATION}${LOG_FILE}"
  echo ""
}
