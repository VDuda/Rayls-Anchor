# Deployment Guide

## Step-by-Step Deployment Instructions

### 1. Prerequisites Setup

#### Install Required Tools
```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup

# Install Bun
curl -fsSL https://bun.sh/install | bash

# Verify installations
forge --version
bun --version
```

#### Get Testnet Funds
- **Rayls Devnet**: Visit https://devnet-dapp.rayls.com/sign-in and claim USDgas
- **Holesky Testnet**: Use https://faucet.quicknode.com/ethereum/holesky to get ETH

### 2. Environment Configuration

```bash
# Create .env file in root
cp .env.example .env

# Edit .env with your values
PRIVATE_KEY=your_private_key_here
VALIDATOR_ADDRESS=your_wallet_address_here

# Contract addresses will be filled after deployment
RAYLS_EMITTER_ADDRESS=
HOLESKY_ROOTCHAIN_ADDRESS=
```

### 3. Deploy Smart Contracts

#### Deploy RaylsCheckpointEmitter on Rayls Devnet

```bash
forge script script/DeployEmitter.s.sol:DeployEmitter \
  --rpc-url https://devnet-rpc.rayls.com \
  --broadcast \
  --private-key $PRIVATE_KEY \
  -vvvv
```

**Expected Output:**
```
==============================================
RaylsCheckpointEmitter deployed to: 0x...
Chain ID: 123123
Deployer: 0x...
==============================================
```

**Action Required:**
1. Copy the deployed address
2. Add to `.env`: `RAYLS_EMITTER_ADDRESS=0x...`
3. Verify on explorer: https://devnet-explorer.rayls.com/address/0x...

#### Deploy RaylsRootChain on Ethereum Holesky

```bash
forge script script/DeployRootChain.s.sol:DeployRootChain \
  --rpc-url https://rpc.ankr.com/eth_holesky \
  --broadcast \
  --private-key $PRIVATE_KEY \
  -vvvv
```

**Expected Output:**
```
==============================================
RaylsRootChain deployed to: 0x...
Chain ID: 17000
Validator: 0x...
Deployer: 0x...
Challenge Window: 60 seconds
==============================================
```

**Action Required:**
1. Copy the deployed address
2. Add to `.env`: `HOLESKY_ROOTCHAIN_ADDRESS=0x...`
3. Verify on explorer: https://holesky.etherscan.io/address/0x...

### 4. Configure Relayer

```bash
cd relayer

# Copy environment template
cp .env.example .env

# Edit .env with your deployed addresses
nano .env
```

Add:
```bash
PRIVATE_KEY=your_private_key_here
VALIDATOR_ADDRESS=your_wallet_address_here
RAYLS_EMITTER_ADDRESS=0x_from_step_3
HOLESKY_ROOTCHAIN_ADDRESS=0x_from_step_3
CHECKPOINT_INTERVAL_BLOCKS=10
CHECKPOINT_INTERVAL_MS=10000
```

### 5. Install Dependencies

```bash
# Install relayer dependencies
cd relayer
bun install

# Install frontend dependencies
cd ../frontend
bun install

# Back to root
cd ..
```

### 6. Start the Relayer

```bash
cd relayer
bun run dev
```

**Expected Output:**
```
🚀 Rayls Anchor Relayer Starting...

==================================================
Rayls RPC: https://devnet-rpc.rayls.com
Holesky RPC: https://rpc.ankr.com/eth_holesky
Validator: 0x...
Relayer: 0x...
Emitter: 0x...
RootChain: 0x...
Checkpoint Interval: 10 blocks (~10000ms)
==================================================

👀 Watching for RaylsMessage events...
✅ Relayer initialized at block 12345
⏰ Checkpoint interval: 10000ms
```

### 7. Test the Bridge

#### Send a Test Message

```bash
# Using cast (Foundry)
cast send $RAYLS_EMITTER_ADDRESS \
  "sendToEthereum(string)" \
  "Hello from Rayls!" \
  --rpc-url https://devnet-rpc.rayls.com \
  --private-key $PRIVATE_KEY
```

**What to Watch:**
1. Relayer console will show: `📨 New Message Detected!`
2. After ~10 blocks, relayer submits checkpoint
3. Check Holesky explorer for checkpoint tx

### 8. Start Frontend (Optional)

```bash
cd frontend
bun run dev
```

Open http://localhost:3000 to see the dashboard.

## Verification Steps

### Verify Contracts

```bash
# Verify on Rayls (if verification API available)
forge verify-contract \
  $RAYLS_EMITTER_ADDRESS \
  contracts/RaylsCheckpointEmitter.sol:RaylsCheckpointEmitter \
  --chain-id 123123 \
  --rpc-url https://devnet-rpc.rayls.com

# Verify on Holesky
forge verify-contract \
  $HOLESKY_ROOTCHAIN_ADDRESS \
  contracts/RaylsRootChain.sol:RaylsRootChain \
  --chain-id 17000 \
  --rpc-url https://rpc.ankr.com/eth_holesky \
  --etherscan-api-key $ETHERSCAN_API_KEY \
  --constructor-args $(cast abi-encode "constructor(address)" $VALIDATOR_ADDRESS)
```

### Test Contract Interactions

```bash
# Check emitter message count
cast call $RAYLS_EMITTER_ADDRESS \
  "messageCount()(uint256)" \
  --rpc-url https://devnet-rpc.rayls.com

# Check RootChain checkpoint count
cast call $HOLESKY_ROOTCHAIN_ADDRESS \
  "getCheckpointCount()(uint256)" \
  --rpc-url https://rpc.ankr.com/eth_holesky

# Check validator address
cast call $HOLESKY_ROOTCHAIN_ADDRESS \
  "raylsValidator()(address)" \
  --rpc-url https://rpc.ankr.com/eth_holesky
```

## Troubleshooting

### Relayer Not Starting
- **Issue**: "Cannot find module 'viem'"
- **Fix**: `cd relayer && bun install`

### Deployment Fails
- **Issue**: "insufficient funds"
- **Fix**: Get more testnet tokens from faucets
- **Issue**: "nonce too low"
- **Fix**: Wait 30s and retry

### Checkpoint Not Submitting
- **Issue**: No checkpoints appearing on Holesky
- **Check**: Relayer has ETH on Holesky
- **Check**: Contract addresses are correct in `.env`
- **Check**: Validator address matches deployer

### Messages Not Detected
- **Issue**: No `RaylsMessage` events in relayer logs
- **Check**: Emitter address is correct
- **Check**: RPC connection is stable
- **Try**: Restart relayer

## Production Deployment

### For Mainnet Launch (Q1 2026)

1. **Update RPCs**:
   ```bash
   RAYLS_RPC_URL=https://rpc.rayls.com
   ETHEREUM_RPC_URL=https://eth-mainnet.g.alchemy.com/v2/YOUR_KEY
   ```

2. **Multi-Signature Validator**:
   - Deploy with validator set (not single address)
   - Require 2/3+ signatures for checkpoints
   - Add validator rotation mechanism

3. **Security Audit**:
   - Get contracts audited by reputable firm
   - Add time-locks for critical functions
   - Set up monitoring and alerts

4. **Infrastructure**:
   - Use dedicated RPC endpoints (Alchemy/Infura)
   - Run relayer on cloud with high uptime
   - Set up backup relayers

## Support

For issues:
1. Check logs in relayer console
2. Verify contract addresses on explorers
3. Join Rayls Telegram: https://t.me/+NnGH9BZlcrc1NjMx
4. Open GitHub issue with full logs

---

**Ready to ship! 🚀**
