#!/bin/bash
set -euxo pipefail

function get_noip_duc() {
  wget -c http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz
  tar zxf noip-duc-linux.tar.gz
  echo $(find . -maxdepth 1 -mindepth 1 -type d -name 'noip*' | cut -d "-" -f2-)
}

function get_arch() {
  local arch
  case ${1} in
    x86_64)
      arch="amd64"
      ;;
    ppc64le)
      arch="ppc64le"
      ;;
    s390x)
      arch="s390x"
      ;;
    aarch64)
      arch="arm64v8"
      ;;
    arm)
      arch="arm32v6"
      ;;
    i386)
      arch="i386"
      ;;
    *)
      echo "$0 does not support architecture ${1} ... aborting"
      exit 1
      ;;
  esac

  echo "${arch}"
}
