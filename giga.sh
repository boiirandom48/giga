#!/bin/bash

# -------------------------
# WildRig-Multi Auto Miner
# -------------------------

# Configurable variables
URL="https://github.com/andru-kun/wildrig-multi/releases/download/0.45.8/wildrig-multi-linux-0.45.8.tar.xz"
FILENAME="wildrig-multi-linux-0.45.8.tar.xz"
DEST_DIR="/root"
CHECK_FILE="$DEST_DIR/wildrig-multi"
RETRY_INTERVAL=120

# Ensure WORKER_NAME is set
if [ -z "$WORKER_NAME" ]; then
    echo "Environment variable WORKER_NAME is not set. Exiting."
    exit 1
fi

# Ensure WALLET is set
if [ -z "$WALLET" ]; then
    echo "Environment variable WALLET is not set. Exiting."
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
    echo "WildRig-Multi already exists. Skipping download."
else
    download_with_retries
    tar -xJf "$FILENAME" -C "$DEST_DIR" || error_exit "Extraction failed"
    rm -f "$FILENAME"
fi

# -------------------------
# Run mining in loop
# -------------------------
while true; do
    echo "Starting WildRig-Multi miner..."
    $DEST_DIR/wildrig-multi \
        --algo qhash \
        --url ru.luckypool.io:8610 \
        --user $WALLET.$WORKER_NAME \
        --pass x
    echo "Miner crashed or exited. Restarting in 10 seconds..."
    sleep 10
done
