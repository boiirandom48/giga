#!/bin/bash

# -------------------------
# lolMiner Auto Miner
# -------------------------

# Configurable variables
URL="https://github.com/Lolliedieb/lolMiner-releases/releases/download/1.98/lolMiner_v1.98_Lin64.tar.gz"
FILENAME="lolMiner_v1.98_Lin64.tar.gz"
DEST_DIR="/root"
CHECK_FILE="$DEST_DIR/1.98/lolMiner"   # Check inside extracted folder
RETRY_INTERVAL=120

# Ensure WORKER_NAME is set
if [ -z "$WORKER_NAME" ]; then
    echo "Environment variable WORKER_NAME is not set. Exiting."
    exit 1
fi

# Error handler
error_exit() {
    echo "$1" >&2
    exit 1
}

# Retry download until success
download_with_retries() {
    while true; do
        wget -O "$FILENAME" "$URL"
        if [ $? -eq 0 ] && [ -s "$FILENAME" ]; then
            return 0
        else
            echo "Download failed or empty file. Retrying in $RETRY_INTERVAL seconds..."
            rm -f "$FILENAME"
            sleep $RETRY_INTERVAL
        fi
    done
}

# Download and extract if needed
if [ -f "$CHECK_FILE" ]; then
    echo "lolMiner already exists. Skipping download."
else
    download_with_retries
    tar -xzf "$FILENAME" -C "$DEST_DIR" || error_exit "Extraction failed"
    rm -f "$FILENAME"
fi

# -------------------------
# Run mining in loop
# -------------------------
while true; do
    echo "Starting lolMiner..."
    $DEST_DIR/1.98/lolMiner \
        --coin ZEL \
        --pool ru.flux.herominers.com:1200 \
        --user t1Yyhrpgue1GWVyhNuTA734dX6BMYQXba9i.$WORKER_NAME
    echo "Miner crashed or exited. Restarting in 10 seconds..."
    sleep 10
done
