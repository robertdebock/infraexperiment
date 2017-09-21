#!/bin/bash

# A script to read information from Digital Ocean.

usage() {
  echo "Usage: $0 [-t TOKEN] -(i|s|k|r)"
  echo
  echo "  -t TOKEN"
  echo "    The token to authenticate with."
  echo "    Either use -t or set DO_API_TOKEN."
  echo "  -i"
  echo "    Show images."
  echo "  -s"
  echo "    Show sizes."
  echo "  -k"
  echo "    Show keys."
  echo "  -r"
  echo "    Show regions."
  exit 1
}

readargs() {
  while [ "$#" -gt 0 ] ; do
    case "$1" in
      -t)
        if [ "$2" ] ; then
          token="$2"
          shift ; shift
        else
          echo "Missing a value for $1."
          echo
          shift
          usage
        fi
      ;;
      -i)
        object="images"
        shift
      ;;
      -s)
        object="sizes"
        shift
      ;;
      -k)
        object="account/keys"
        shift
      ;;
      -r)
	object="regions"
	shift
      ;;
      *)
        echo "Unknown option, argument or switch: $1."
        echo
        shift
        usage
      ;;
    esac
  done
}

checkargs() {
  if [ "${DO_API_TOKEN}" ] ; then
    token="${DO_API_TOKEN}"
  fi
  if [ ! "${token}" ] ; then
    echo "Missing token."
    usage
  fi
  if [ ! "${object}" ] ; then
    echo "No object specified."
    usage
  fi
}

main() {
  curl \
    --request GET \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer ${token}" \
    https://api.digitalocean.com/v2/"${object}"
}

readargs "$@"
checkargs
main
