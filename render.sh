#!/usr/bin/env bash

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

if [ -z "${WORKSPACE}" ]
then
  WORKSPACE=.
fi

TIME_START=$(date "+%Y-%m-%dT%H:%M:%S")
OUTPUT="${WORKSPACE}/renders/"
LOG_FILE="${OUTPUT}/"$(date "+%Y%m%dT%H%M%S.log")
mkdir -p "${OUTPUT}" || exit 1

(
env | sort
echo

cat <<EOF
Rendering started ${TIME_START}
------------------------------------------------------------------------
EOF
) | tee -a "${LOG_FILE}"

# time blender \
#   --background \
#   master.blend \
#   --scene Scene \
#   --render-output "${OUTPUT}/" \
#   --render-format PNG \
#   --frame-start "${NODE_INDEX}" \
#   --frame-end 120 \
#   --frame-jump "${NODE_COUNT}" \
#   --render-anim 2>&1 | tee "${LOG_FILE}"

sleep 1

(
cat <<EOF
------------------------------------------------------------------------
Rendering finished ${TIME_END}
EOF
) | tee -a "${LOG_FILE}"

echo "Time: ${DIFF}"

RENDER_TARGET="jenkins-renders@mustard.int.arc7.info:/shared/jenkins-renders/${JOB_BASE_NAME}/${BUILD_ID}/"

echo rsync -avz --progress "${OUTPUT}/" "${RENDER_TARGET}"
