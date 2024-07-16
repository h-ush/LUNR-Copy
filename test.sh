#!/bin/bash

function transfer_to_destination_device() {
  echo "----------------------------------------------------"
  read -p "[+] DESIRED DIRECTORY    || " DIRECTORY_PATH
  read -p "[+] DESTINATION USERNAME || " USERNAME
  read -p "[+] DESTINATION IP       || " IP
  read -p "[+] DESTINATION LOCATION || " LOCATION
  echo "----------------------------------------------------"

  rsync_content_check "$DIRECTORY_PATH" "$USERNAME" "$IP" "$LOCATION"
}

function rsync_content_check() {
  local DIRECTORY_PATH="$1"
  local USERNAME="$2"
  local IP="$3"
  local LOCATION="$4"

  # Get the base name of the directory
  local DIRECTORY_NAME=$(basename "$(readlink -f "/home/$(logname)/${DIRECTORY_PATH}")")

  # Find the directory under /home/$(logname)
  local FIND_DIRECTORY=$(find "/home/$(logname)" -type d -name "${DIRECTORY_NAME}" | grep "${DIRECTORY_PATH}")


  # Debug output to verify values
  echo "DIRECTORY_PATH: $DIRECTORY_PATH"
  echo "DIRECTORY_NAME: $DIRECTORY_NAME"
  echo "FIND_DIRECTORY: $FIND_DIRECTORY"

  # Example: Check if directory exists
  if [[ ! -d "${FIND_DIRECTORY}" ]]; then
    echo ""
    echo "ERROR: Directory '${DIRECTORY_PATH}' does not exist under /home/$(logname)."
    echo ""

    read -p "Would you like to try again (y/n)? " AGAIN
    case $AGAIN in
        y)
          transfer_to_destination_device
          ;;
        *)
          exit 1
          ;;
    esac
  else
    logINFO "ESTABLISHING RSYNC SSH CONNECTION"
    rsync --timeout=10 -a "${FIND_DIRECTORY}" "${USERNAME}@${IP}:${LOCATION}"

    # Check the return code of rsync
    if [[ $? -ne 0 ]]; then
      logERROR "RSYNC SSH HAS FAILED... ENDING SCRIPT"
      exit 1
    else
      logINFO "FILES HAVE BEEN TRANSFERRED TO TARGET DEVICE"
      # logSUCCESS "RSYNC COPY HAS COMPLETED!!!"  # Uncomment if needed
    fi
  fi
}

# Example usage:
transfer_to_destination_device
