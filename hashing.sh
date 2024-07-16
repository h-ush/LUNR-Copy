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
    printf "%s\n" "----"
    printf "%s" "$hashes"
    printf "%s\n" "----"
  else
    hashes=$(sha256sum "$@/"*; printf .)
    hashes=${hashes%.}
    printf "%s\n" "----"
    printf "%s" "$hashes"
    printf "%s\n" "----"
  fi
}
