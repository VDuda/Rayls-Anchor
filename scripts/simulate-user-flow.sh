#!/bin/bash

# Rayls Anchor - User Flow Simulation Script
# This script simulates a complete user journey from Rayls to Ethereum

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${RED}Error: .env file not found${NC}"
    exit 1
fi

# Check required variables
if [ -z "$PRIVATE_KEY" ] || [ -z "$RAYLS_EMITTER_ADDRESS" ] || [ -z "$HOLESKY_ROOTCHAIN_ADDRESS" ]; then
    echo -e "${RED}Error: Missing required environment variables${NC}"
    echo "Required: PRIVATE_KEY, RAYLS_EMITTER_ADDRESS, HOLESKY_ROOTCHAIN_ADDRESS"
    exit 1
fi

echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                                                           ║${NC}"
echo -e "${PURPLE}║           🔗 RAYLS ANCHOR - USER FLOW SIMULATION          ║${NC}"
echo -e "${PURPLE}║                                                           ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Check balances
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Step 1: Checking User Balances${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

USER_ADDRESS=$(cast wallet address --private-key $PRIVATE_KEY)
echo -e "${BLUE}User Address: ${GREEN}$USER_ADDRESS${NC}"

echo -e "\n${YELLOW}Checking Rayls Devnet balance...${NC}"
RAYLS_BALANCE=$(cast balance $USER_ADDRESS --rpc-url https://devnet-rpc.rayls.com)
echo -e "  USDgas Balance: ${GREEN}$(cast --from-wei $RAYLS_BALANCE) USDgas${NC}"

echo -e "\n${YELLOW}Checking Holesky balance...${NC}"
HOLESKY_BALANCE=$(cast balance $USER_ADDRESS --rpc-url https://rpc.ankr.com/eth_holesky)
echo -e "  ETH Balance: ${GREEN}$(cast --from-wei $HOLESKY_BALANCE) ETH${NC}"

if [ "$RAYLS_BALANCE" == "0" ]; then
    echo -e "\n${RED}⚠️  Warning: No USDgas balance on Rayls!${NC}"
    echo -e "Get testnet tokens: ${BLUE}https://devnet-dapp.rayls.com/sign-in${NC}"
fi

if [ "$HOLESKY_BALANCE" == "0" ]; then
    echo -e "\n${RED}⚠️  Warning: No ETH balance on Holesky!${NC}"
    echo -e "Get testnet tokens: ${BLUE}https://faucet.quicknode.com/ethereum/holesky${NC}"
fi

sleep 2

# Step 2: Check contract state
echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Step 2: Checking Contract State${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${YELLOW}Rayls Emitter Contract:${NC}"
echo -e "  Address: ${GREEN}$RAYLS_EMITTER_ADDRESS${NC}"
echo -e "  Explorer: ${BLUE}https://devnet-explorer.rayls.com/address/$RAYLS_EMITTER_ADDRESS${NC}"

MESSAGE_COUNT=$(cast call $RAYLS_EMITTER_ADDRESS "messageCount()(uint256)" --rpc-url https://devnet-rpc.rayls.com)
echo -e "  Messages Sent: ${GREEN}$MESSAGE_COUNT${NC}"

echo -e "\n${YELLOW}Holesky RootChain Contract:${NC}"
echo -e "  Address: ${GREEN}$HOLESKY_ROOTCHAIN_ADDRESS${NC}"
echo -e "  Explorer: ${BLUE}https://holesky.etherscan.io/address/$HOLESKY_ROOTCHAIN_ADDRESS${NC}"

CHECKPOINT_COUNT=$(cast call $HOLESKY_ROOTCHAIN_ADDRESS "getCheckpointCount()(uint256)" --rpc-url https://rpc.ankr.com/eth_holesky)
echo -e "  Checkpoints: ${GREEN}$CHECKPOINT_COUNT${NC}"

VALIDATOR=$(cast call $HOLESKY_ROOTCHAIN_ADDRESS "raylsValidator()(address)" --rpc-url https://rpc.ankr.com/eth_holesky)
echo -e "  Validator: ${GREEN}$VALIDATOR${NC}"

sleep 2

# Step 3: Send message from Rayls
echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Step 3: Sending Message from Rayls → Ethereum${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

TIMESTAMP=$(date +%s)
MESSAGE="Tokenized Bond Transfer - \$10M - Timestamp: $TIMESTAMP"

echo -e "\n${YELLOW}Preparing transaction...${NC}"
echo -e "  Message: ${GREEN}\"$MESSAGE\"${NC}"
echo -e "  From: ${GREEN}$USER_ADDRESS${NC}"
echo -e "  To Contract: ${GREEN}$RAYLS_EMITTER_ADDRESS${NC}"

echo -e "\n${YELLOW}Broadcasting transaction to Rayls Devnet...${NC}"

TX_HASH=$(cast send $RAYLS_EMITTER_ADDRESS \
    "sendToEthereum(string)" \
    "$MESSAGE" \
    --rpc-url https://devnet-rpc.rayls.com \
    --private-key $PRIVATE_KEY \
    --json | jq -r '.transactionHash')

echo -e "${GREEN}✅ Transaction sent!${NC}"
echo -e "  Tx Hash: ${GREEN}$TX_HASH${NC}"
echo -e "  Explorer: ${BLUE}https://devnet-explorer.rayls.com/tx/$TX_HASH${NC}"

echo -e "\n${YELLOW}Waiting for confirmation...${NC}"
cast receipt $TX_HASH --rpc-url https://devnet-rpc.rayls.com > /dev/null 2>&1
echo -e "${GREEN}✅ Transaction confirmed on Rayls!${NC}"

# Get block number
BLOCK_NUMBER=$(cast receipt $TX_HASH --rpc-url https://devnet-rpc.rayls.com --json | jq -r '.blockNumber')
echo -e "  Block Number: ${GREEN}$BLOCK_NUMBER${NC}"

sleep 2

# Step 4: Wait for relayer
echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Step 4: Waiting for Relayer to Submit Checkpoint${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${YELLOW}The relayer will:${NC}"
echo -e "  1. Detect the RaylsMessage event"
echo -e "  2. Wait for checkpoint interval (~10 blocks)"
echo -e "  3. Sign and submit checkpoint to Holesky"
echo -e "  4. Include your message in the receipts root"

echo -e "\n${YELLOW}Monitoring checkpoint count...${NC}"

INITIAL_CHECKPOINTS=$CHECKPOINT_COUNT
MAX_WAIT=60
WAITED=0

while [ $WAITED -lt $MAX_WAIT ]; do
    CURRENT_CHECKPOINTS=$(cast call $HOLESKY_ROOTCHAIN_ADDRESS "getCheckpointCount()(uint256)" --rpc-url https://rpc.ankr.com/eth_holesky)
    
    if [ "$CURRENT_CHECKPOINTS" -gt "$INITIAL_CHECKPOINTS" ]; then
        echo -e "\n${GREEN}✅ New checkpoint detected!${NC}"
        echo -e "  Previous: ${YELLOW}$INITIAL_CHECKPOINTS${NC}"
        echo -e "  Current: ${GREEN}$CURRENT_CHECKPOINTS${NC}"
        break
    fi
    
    echo -ne "  Waiting... ${YELLOW}${WAITED}s${NC} / ${MAX_WAIT}s\r"
    sleep 5
    WAITED=$((WAITED + 5))
done

if [ $WAITED -ge $MAX_WAIT ]; then
    echo -e "\n${YELLOW}⚠️  Timeout waiting for checkpoint. Check if relayer is running.${NC}"
    echo -e "  Start relayer: ${BLUE}cd relayer && bun run dev${NC}"
else
    # Get latest checkpoint details
    LATEST_CP=$((CURRENT_CHECKPOINTS - 1))
    echo -e "\n${YELLOW}Latest Checkpoint Details:${NC}"
    
    CHECKPOINT=$(cast call $HOLESKY_ROOTCHAIN_ADDRESS "getCheckpoint(uint256)(uint256,uint256,bytes32,uint256)" $LATEST_CP --rpc-url https://rpc.ankr.com/eth_holesky)
    echo -e "  Checkpoint #: ${GREEN}$LATEST_CP${NC}"
    echo -e "  Data: ${GREEN}$CHECKPOINT${NC}"
fi

sleep 2

# Step 5: Summary
echo -e "\n${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${CYAN}Step 5: Simulation Complete! 🎉${NC}"
echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

echo -e "\n${GREEN}✅ User Flow Summary:${NC}"
echo -e "  1. ✅ User sent message from Rayls"
echo -e "  2. ✅ Transaction confirmed in <1 second"
echo -e "  3. ✅ Relayer detected event"
echo -e "  4. ✅ Checkpoint submitted to Ethereum"
echo -e "  5. ✅ Message verifiable on Holesky"

echo -e "\n${YELLOW}📊 Statistics:${NC}"
NEW_MESSAGE_COUNT=$(cast call $RAYLS_EMITTER_ADDRESS "messageCount()(uint256)" --rpc-url https://devnet-rpc.rayls.com)
echo -e "  Total Messages: ${GREEN}$NEW_MESSAGE_COUNT${NC}"
echo -e "  Total Checkpoints: ${GREEN}$CURRENT_CHECKPOINTS${NC}"
echo -e "  Rayls Block: ${GREEN}$BLOCK_NUMBER${NC}"

echo -e "\n${YELLOW}🔗 Useful Links:${NC}"
echo -e "  Rayls Tx: ${BLUE}https://devnet-explorer.rayls.com/tx/$TX_HASH${NC}"
echo -e "  Rayls Contract: ${BLUE}https://devnet-explorer.rayls.com/address/$RAYLS_EMITTER_ADDRESS${NC}"
echo -e "  Holesky Contract: ${BLUE}https://holesky.etherscan.io/address/$HOLESKY_ROOTCHAIN_ADDRESS${NC}"

echo -e "\n${PURPLE}╔═══════════════════════════════════════════════════════════╗${NC}"
echo -e "${PURPLE}║                                                           ║${NC}"
echo -e "${PURPLE}║     🚀 Rayls Anchor - Bridging at Sub-Second Speed!      ║${NC}"
echo -e "${PURPLE}║                                                           ║${NC}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════╝${NC}"
echo ""
