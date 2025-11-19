# ⚡ Quick Start - 5 Minutes to Demo

This guide gets you from zero to a working demo in **5 minutes**.

## Prerequisites (1 minute)

1. **Install Foundry**:
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. **Install Bun**:
   ```bash
   curl -fsSL https://bun.sh/install | bash
   ```

3. **Get testnet tokens**:
   - Rayls: https://devnet-dapp.rayls.com/sign-in (claim USDgas)
   - Holesky: https://faucet.quicknode.com/ethereum/holesky (get ETH)

## Setup (2 minutes)

```bash
# Clone and enter directory
cd /Users/vlad/hackathon/Rayls-Anchor

# Install dependencies
forge install
cd relayer && bun install
cd ../frontend && bun install
cd ..

# Configure environment
cp .env.example .env
# Edit .env with your PRIVATE_KEY and VALIDATOR_ADDRESS
```

## Deploy (1 minute)

```bash
# Deploy on Rayls
forge script script/DeployEmitter.s.sol:DeployEmitter \
  --rpc-url https://devnet-rpc.rayls.com \
  --broadcast \
  --private-key $PRIVATE_KEY

# Copy address, add to .env as RAYLS_EMITTER_ADDRESS

# Deploy on Holesky
forge script script/DeployRootChain.s.sol:DeployRootChain \
  --rpc-url https://rpc.ankr.com/eth_holesky \
  --broadcast \
  --private-key $PRIVATE_KEY

# Copy address, add to .env as HOLESKY_ROOTCHAIN_ADDRESS
```

## Run (1 minute)

```bash
# Terminal 1: Start relayer
cd relayer && bun run dev

# Terminal 2 (optional): Start frontend
cd frontend && bun run dev
```

## Test (30 seconds)

```bash
# Send a test message
cast send $RAYLS_EMITTER_ADDRESS \
  "sendToEthereum(string)" \
  "Hello from Rayls Hackathon!" \
  --rpc-url https://devnet-rpc.rayls.com \
  --private-key $PRIVATE_KEY
```

**Watch**: Relayer logs show message detected → checkpoint submitted in ~10s!

---

## Demo Script (2 minutes for judges)

### Opening (15s)
"Hi, I built **Rayls Anchor** - the first Polygon-style checkpoint bridge for Rayls that leverages sub-second finality to verify cross-chain messages in under 60 seconds."

### Problem (20s)
"Rayls has incredible speed and compliance, but DeFi liquidity lives on Ethereum. Without a trust-minimized bridge, institutional RWAs can't flow between chains. This is the #1 blocker to Rayls hitting $10B TVL."

### Solution (30s)
"Rayls Anchor uses Polygon's battle-tested checkpoint system:
1. Messages emit on Rayls with sub-second finality
2. Relayer signs checkpoints every 10 seconds
3. Ethereum verifies using Merkle proofs
4. 60-second challenge window - impossible on slower chains"

### Live Demo (45s)
```bash
# Show contracts on explorers
open https://devnet-explorer.rayls.com/address/$RAYLS_EMITTER_ADDRESS
open https://holesky.etherscan.io/address/$HOLESKY_ROOTCHAIN_ADDRESS

# Send message
cast send $RAYLS_EMITTER_ADDRESS "sendToEthereum(string)" "Bank X tokenized $10M bond" \
  --rpc-url https://devnet-rpc.rayls.com --private-key $PRIVATE_KEY

# Show relayer logs
# Point to checkpoint submission on Holesky
# Total time: <45 seconds ⚡
```

### Closing (10s)
"This is production-ready for Q1 2026 mainnet. It qualifies for the $500k TVL bonus and solves the exact problem the judges highlighted in idea 3.h. Thank you!"

---

## Troubleshooting

### "Insufficient funds"
- Get more testnet tokens from faucets above

### "Cannot find module 'viem'"
```bash
cd relayer && bun install
cd ../frontend && bun install
```

### "Relayer not detecting messages"
- Check `RAYLS_EMITTER_ADDRESS` in relayer/.env
- Verify RPC connection: `curl https://devnet-rpc.rayls.com`

### "Checkpoint not submitting"
- Ensure you have ETH on Holesky
- Check `HOLESKY_ROOTCHAIN_ADDRESS` in relayer/.env
- Verify validator address matches: `cast call $HOLESKY_ROOTCHAIN_ADDRESS "raylsValidator()(address)" --rpc-url https://rpc.ankr.com/eth_holesky`

---

## Next Steps

1. **Record demo video**: Use OBS/QuickTime to record the 2-min demo
2. **Polish README**: Add deployed addresses, screenshots
3. **Prepare slides**: 3-5 slides covering problem/solution/demo
4. **Practice pitch**: Nail the 2-minute presentation

## Key Talking Points

- ✅ "Only possible with Rayls' sub-second finality"
- ✅ "Polygon-proven architecture, battle-tested"
- ✅ "Production-ready for Q1 2026 mainnet"
- ✅ "Solves judges' idea 3.h directly"
- ✅ "$10B+ TVL unlock for institutional RWAs"

---

**You're ready to win! 🏆**
