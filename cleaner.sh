#!/bin/bash

# ========= DEFAULT CONFIGURATION =========
CLEAN_PATH="/var/log"
THRESHOLD=80
OLDER_THAN_DAYS=7
LARGER_THAN=100
DRY_RUN=false
LOG_FILE="./cleanup.log"

# ========= FUNCTION: Check Disk ==========
check_disk_usage() {
    USAGE=$(df "$CLEAN_PATH" | awk 'NR==2 {print $5}' | tr -d '%')
    echo "$USAGE"
}

# ========= FUNCTION: Alert Only ==========
alert_disk_usage() {
    USAGE=$(check_disk_usage)
    echo "Disk usage at $CLEAN_PATH is ${USAGE}%"
    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        echo "⚠️  ALERT: Disk usage is above ${THRESHOLD}%!"
        echo "$(date): ALERT - Disk usage at $USAGE% in $CLEAN_PATH" >> "$LOG_FILE"
    else
        echo "✅ Disk usage is normal. No action needed."
    fi
}

# ======== FUNCTION: Interactive Prompt ========
run_interactive_mode() {
    read -rp "Enter folder to clean: " CLEAN_PATH
    read -rp "Delete files older than how many days? " OLDER_THAN_DAYS
    read -rp "Delete files larger than how many MB? " LARGER_THAN
    read -rp "Enable dry run mode? (yes/no): " dry

    if [[ "$dry" == "yes" ]]; then
        DRY_RUN=true
    else
        DRY_RUN=false
    fi

    echo "🔍 You chose:"
    echo " - Path: $CLEAN_PATH"
    echo " - Older than: $OLDER_THAN_DAYS days"
    echo " - Larger than: ${LARGER_THAN}MB"
    echo " - Dry Run: $DRY_RUN"
}

# ========= FUNCTION: Find Files ==========
find_files_to_delete() {
    find "$CLEAN_PATH" -type f -mtime +"$OLDER_THAN_DAYS" -size +"${LARGER_THAN}"M
}

# ========= FUNCTION: Delete Files =========

delete_files() {
    FILES=$(find_files_to_delete)

    if [ -z "$FILES" ]; then
        echo "No files matched the criteria."
        return
    fi

    echo "$FILES" | while read -r file; do
        if [ "$DRY_RUN" = true ]; then
            echo " Dry Run: would delete file -> $file"
        else
            echo "Deleting file -> $file"
            echo "$(date): Deleted file -> $file" >> "$LOG_FILE"
            rm -f "$file"
        fi
    done
}

# ========== MAIN ENTRY POINT ===========
MODE=$1

case "$MODE" in
    --alert)
        alert_disk_usage
        ;;

    --interactive)
        run_interactive_mode
        USAGE=$(check_disk_usage)
        echo "Disk usage at $CLEAN_PATH is ${USAGE}%"
        if [ "$USAGE" -ge "$THRESHOLD" ]; then
            echo "Disk usage above $THRESHOLD%, cleaning now..."
            delete_files
        else
            echo "Disk usage below threshold. No cleaning needed."
        fi
        ;;

    --dry-run)
        DRY_RUN=true
        USAGE=$(check_disk_usage)
        echo "Disk usage at $CLEAN_PATH is ${USAGE}%"
        if [ "$USAGE" -ge "$THRESHOLD" ]; then
            echo "Disk usage above $THRESHOLD%, simulating cleaning..."
            delete_files
        else
            echo "Disk usage below threshold. No cleaning needed."
        fi
        ;;

    *)
        USAGE=$(check_disk_usage)
        echo "Disk usage at $CLEAN_PATH is ${USAGE}%"
        if [ "$USAGE" -ge "$THRESHOLD" ]; then
            echo "Disk usage above $THRESHOLD%, cleaning now..."
            delete_files
        else
            echo "Disk usage below threshold. No cleaning needed."
        fi
        ;;
esac
