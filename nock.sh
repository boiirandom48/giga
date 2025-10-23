#!/bin/bash
# =========================================
# Golden Miner Nockchain GPU Miner Script
# Delegated Endpoint for Clore/GigaSPOT
# =========================================

# Exit immediately if a command fails
set -e

# Variables
MINER_URL="https://github.com/GoldenMinerNetwork/golden-miner-nockchain-gpu-miner/releases/download/v0.1.5%2B1/golden-miner-pool-prover"
MINER_FILE="golden-miner-pool-prover"
PUBKEY="3ZfpCpfQtF1GWN5D4VTDyaaxKwuyg2hduBsPTp6xwYM5mUyx4HUKjmCWsgBeEnRpMDEYDJPQNVGx22k2s9EXHiNi8YDf7kKyCjQvFKXjt4oJQbAvxhPsuPDNkwEvSaBPFtVy"

# Download miner if it doesn't exist
if [ ! -f "$MINER_FILE" ]; then
    echo "[INFO] Downloading Golden Miner..."
    wget -q "$MINER_URL" -O "$MINER_FILE"
fi

# Make executable
chmod +x "$MINER_FILE"

# Run miner
echo "[INFO] Starting Golden Miner..."
./"$MINER_FILE" --pubkey="$PUBKEY"
