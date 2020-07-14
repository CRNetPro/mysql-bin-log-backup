#!/bin/bash

# Backup time range
START_TIME=$(date -d '480 minutes ago' "+%Y-%m-%d %H:%M:%S") # Last per 8 Hours
END_TIME=$(date "+%Y-%m-%d %H:%M:%S")

# Default configuration parameters
FILE_TIME=$(date "+%Y%m%d%H%M")
BACKUP_DIR="/dir"
BACKUP_FILE="$BACKUP_DIR/backup-file.$FILE_TIME"
LOG_DIR="/dir/backup-binlog.log"
ROTATE_DAYS=1
VERBOSE=false

# MySQL index file
INDEX="/dir/mysql-bin.index"

# Write log
log () {
    local level="INFO"
    if [[ -n $2 ]]; then
        level=$2
    fi
    local msg="[$(date +'%Y-%m-%d %H:%M:%S')][$level] $1"
    echo "$msg" >> "$LOG_DIR"

    if [[ $VERBOSE == true ]]; then
        echo "$msg"
    fi
}

/usr/bin/mysqlbinlog \
    --base64-output=decode-rows \
    --start-datetime="$START_TIME" --stop-datetime="$END_TIME" \
    -vv $(tail -n1 $INDEX) \
    > $BACKUP_FILE

# Rotate older backups
ROTATED_FILES=$(find $BACKUP_DIR -name "database-binlog-backup.*" ! -name *.tar.gz -mtime +$ROTATE_DAYS)
for filename in $ROTATED_FILES
do
    log "Rotation: $filename"
    tar zcvf $filename.tar.gz $filename --remove-files
done
