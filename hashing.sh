#!/bin/bash

##############################################################
#
# Creates a SHA256 Hash of a file to maintain integrity of
# both log data and sent information
#
##############################################################
function hash_creation() {
  FILE=$1

  if [ -f ${FILE} ]; then
    hashes=$(sha256sum "$@"; printf .)
    hashes=${hashes%.}
    echo "----------------------------------------------------"
    echo "FILE HASHES"
    echo "----------------------------------------------------"
    printf "%s" "$hashes"
  else
    hashes=$(sha256sum "$@/"*; printf .)
    hashes=${hashes%.}
    echo "----------------------------------------------------"
    echo "DIRECTORY FILE HASHES"
    echo "----------------------------------------------------"
    printf "%s" "$hashes"
  fi
}
