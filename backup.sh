#!/bin/bash
#
# Nick Pisani - a very basic backup script used for backing up a linux/mac computer
# to a remote location 
#
SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "$SCRIPT_DIR/conf.cfg"
# -a archive mode (recursive + retain attributes)
# -x dont crost device boundaries
# -S handle sparse files efficiently
# --delete deletes files on the remote server if they dont exist locally
# --delete-excluded deletes any files the remote system in the excluded file
RSYNC_CMD="/usr/local/bin/rsync -avx -S --delete $RSYNC_ARGS_EXTRA"

SEMAPHORE_FILE="$SCRIPT_DIR/$0.semaphore"
if [ -e "$SEMAPHORE_FILE" ] ;
then
	echo "$SEMAPHORE_FILE already exists exiting"
	exit 1;
fi
echo `date` > "$SEMAPHORE_FILE"


if [ -z "$LOG_FILE" ];
then
	LOG_FILE="/dev/null"
fi

$RSYNC_CMD --exclude-from $SCRIPT_DIR/excludes.txt $LOCAL_BACKUP_DIR/ $REMOTE_BACKUP_DIR > "$LOG_FILE" 2>&1

rm -f "$SEMAPHORE_FILE"
exit 0

