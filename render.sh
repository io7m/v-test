#!/bin/sh

fatal()
{
  echo "fatal: $1" 1>&2
  exit 1
}

info()
{
  echo "info: $1" 1>&2
}

if [ $# -ne 2 ]
then
  fatal "usage: node-index node-count"
fi

NODE_INDEX="$1"
shift
NODE_COUNT="$1"
shift

if [ -z "${NODE_INDEX}" ]
then
  fatal "node index must be non-empty string"
fi
if [ -z "${NODE_COUNT}" ]
then
  fatal "node count must be non-empty string"
fi

info "node index ${NODE_INDEX}"
info "node count ${NODE_COUNT}"
