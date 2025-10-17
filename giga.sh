#!/bin/bash

# -------------------------
# GPU Miner (WildRig-Multi)
# -------------------------
GPU_CHECK_FILE="/root/wildrig-multi"
GPU_WORKER="gigaspot"
GPU_WALLET="bc1qse4agv63zhr8akyptzlze53tc5wnrp9070k3qc"
GPU_ALGO="qhash"
GPU_POOL="qubitcoin.luckypool.io:8610"

# -------------------------
# CPU Miner (JETSKI-QUBIC)
# -------------------------
CPU_DIR="/root/qjetski.PPLNS-3.4.4-Linux"
CPU_BIN="$CPU_DIR/qjetski-Client"

# -------------------------
# Create Jetski config automatically
# -------------------------
echo "Generating appsettings.json for Jetski..."
mkdir -p "$CPU_DIR"
cat > "$CPU_DIR/appsettings.json" <<EOF
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

# -------------------------
# Function to start miners inside screen sessions
# -------------------------
start_miners() {
    echo "Starting GPU miner in screen session 'gpu'..."
    screen -dmS gpu "$GPU_CHECK_FILE" --algo "$GPU_ALGO" --url "$GPU_POOL" --user "$GPU_WALLET.$GPU_WORKER" --pass x

    echo "Starting CPU miner in screen session 'cpu'..."
    screen -dmS cpu "$CPU_BIN"
}

# -------------------------
# Main loop: restart if sessions die
# -------------------------
while true; do
    GPU_RUNNING=$(screen -list | grep -c "\.gpu")
    CPU_RUNNING=$(screen -list | grep -c "\.cpu")

    if [ $GPU_RUNNING -eq 0 ] || [ $CPU_RUNNING -eq 0 ]; then
        echo "One or both miners are not running. Restarting..."
        screen -S gpu -X quit >/dev/null 2>&1
        screen -S cpu -X quit >/dev/null 2>&1
        start_miners
    fi

    sleep 30
done
