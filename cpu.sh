#!/bin/bash

# -----------------------------
# JETSKI QUBIC AUTO MINER
# -----------------------------

URL="https://github.com/jtskxx/JETSKI-QUBIC-POOL/releases/download/latest/qjetski.PPLNS-3.4.4-Linux.tar.gz"
ARCHIVE="qjetski.PPLNS-3.4.4-Linux.tar.gz"
FOLDER="qjetski.PPLNS-3.4.4-Linux"
JSON_FILE="$FOLDER/appsettings.json"
RETRY_INTERVAL=60

# Retry function
download_with_retries() {
    local url=$1
    local file=$2
    while true; do
        wget -O "$file" "$url"
        if [ $? -eq 0 ] && [ -s "$file" ]; then
            echo "✅ Downloaded $file successfully."
            break
        else
            echo "⚠️ Download failed or empty file. Retrying in $RETRY_INTERVAL seconds..."
            rm -f "$file"
            sleep $RETRY_INTERVAL
        fi
    done
}

# Download and extract
if [ ! -d "$FOLDER" ]; then
    echo "📦 Downloading JETSKI miner..."
    download_with_retries "$URL" "$ARCHIVE"
    tar -xf "$ARCHIVE" || { echo "❌ Extraction failed"; exit 1; }
    rm -f "$ARCHIVE"
else
    echo "📂 Folder $FOLDER already exists. Skipping download."
fi

# Create config file
echo "⚙️ Creating appsettings.json..."
cat > "$JSON_FILE" <<'EOF'
{
    "ClientSettings": {
        "poolAddress": "wss://pplnsjetski.xyz/ws/TIMUNHUGVSKMPATIJPQEULVTHZQDNUEYJCUHMXQRSDIPAOQTGJPCHDSEURUC",
        "alias": "gigaspot",
        "accessToken": "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6ImZiZDRlODYyLTkxZWEtNDM1NS04YzFlLTA5Y2M2MmQwNjA2MiIsIk1pbmluZyI6IiIsIm5iZiI6MTc1NTcxMTY2MiwiZXhwIjoxNzg3MjQ3NjYyLCJpYXQiOjE3NTU3MTE2NjIsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.qPA6YWsSenUztyObsghbeePK28zNQ7iY3kazWsk9fJgegbcMo58SLal5Q1ytzPxfaMZIyLhActlzxjBT3G4mwayrzAiyh9IDqXh4CUWNQ54W1LPCzv-uQPuyjy8HNr7qJUFDI-fl54kBXBXGbkCfvghvkX0eP5w1pD0WAmpGTbUmCyead2U3NGDbs2a6DrdRi86uFVp8Pxzg_cwVuFuKFhJx5oVitBCIPPcYSSDz8m9l2C6B1icvwTWGXJnchlOIJ12cjFXpkq_DHhp_M4lWwpMpJGGsl1YKWQ22OrpVheJZM22z-rsgQ4RU3LVbGU1BoY3ssOFmtCnzIE_D5ekATg",
        "pps": true,
        "trainer": {
            "cpu": true,
            "gpu": false
        },
        "xmrSettings": {
            "disable": false,
            "enableGpu": false,
            "poolAddress": "qxmr.jetskipool.ai:3333",
            "customParameters": "",
            "stratumBridge": {
                "disable": true
            }
        },
        "idling": {
            "command": "",
            "arguments": ""
        }
    }
}
EOF

# Run miner in a loop for stability
cd "$FOLDER" || exit 1
chmod +x qjetski-Client

while true; do
    echo "🚀 Starting JETSKI QUBIC Miner..."
    ./qjetski-Client
    echo "⚠️ Miner stopped or crashed. Restarting in 10 seconds..."
    sleep 10
done
