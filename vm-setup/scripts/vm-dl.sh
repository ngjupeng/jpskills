#!/bin/bash
# Download file from VM to local machine and open it
# Usage: vm-dl /path/on/vm/file.pdf
#        vm-dl /path/on/vm/file.pdf ~/Desktop/  (custom local destination)

VM_HOST="dev-vm-1"
REMOTE_PATH="${1:?Usage: vm-dl <remote-path> [local-destination]}"
LOCAL_DIR="${2:-$HOME/Downloads}"

FILENAME=$(basename "$REMOTE_PATH")
LOCAL_PATH="${LOCAL_DIR}/${FILENAME}"

echo "Downloading ${FILENAME} from ${VM_HOST}..."
scp "${VM_HOST}:${REMOTE_PATH}" "${LOCAL_PATH}"

if [ $? -eq 0 ]; then
  echo "Saved to ${LOCAL_PATH}"
  open "${LOCAL_PATH}"
else
  echo "Download failed. Check the path: ${REMOTE_PATH}"
  exit 1
fi
