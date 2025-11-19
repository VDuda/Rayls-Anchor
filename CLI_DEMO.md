# 🎬 Rayls Anchor - Complete CLI Demo

> **Total Time**: 2-3 minutes | **Verification Speed**: <45 seconds from Rayls to Ethereum

---

## 📋 Quick Reference

### Deployed Contracts
- **Rayls Emitter**: `0xe6AF1212d688601142f5E8b70da4e320d7838362`
- **Sepolia RootChain**: `0xe6AF1212d688601142f5E8b70da4e320d7838362`
- **Validator**: `0x58E9CF917c3204A0BA31702173D575D144373993`

### Explorer Links (Open Before Demo)
- [Rayls Emitter](https://devnet-explorer.rayls.com/address/0xe6AF1212d688601142f5E8b70da4e320d7838362)
- [Sepolia RootChain](https://sepolia.etherscan.io/address/0xe6AF1212d688601142f5E8b70da4e320d7838362)
- [Frontend](http://localhost:3000) (optional)

---

## 🚀 Complete Demo Flow

### Step 0: Pre-Demo Setup

**Terminal 1** (Optional - Frontend):
```bash
cd frontend
bun run dev
# Open http://localhost:3000 in browser
```

**Terminal 2** (Main Demo Terminal):
```bash
cd /Users/vlad/hackathon/Rayls-Anchor
```

**What to Say**:
> "Rayls Anchor is a Polygon-inspired checkpoint bridge that brings Rayls state to Ethereum in under 60 seconds. This directly solves the judge's highlighted Idea 3.h for Ethereum trust anchors."

---

## 📍 Step 1: Show Current State (20 seconds)

### Check Rayls Message Count
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "messageCount()(uint256)" \
  --rpc-url rayls
```
**Expected**: Returns current message count (e.g., `1` or `2`)

### Check Sepolia Checkpoint Count
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```
**Expected**: Returns current checkpoint count (e.g., `0` or `1`)

### Verify Validator Address
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "validator()(address)" \
  --rpc-url sepolia
```
**Expected**: `0x58E9CF917c3204A0BA31702173D575D144373993`

**What to Say**:
> "I've deployed the Emitter on Rayls Devnet and RootChain on Ethereum Sepolia. Let me show you how fast we can bridge state between them."

---

## 📨 Step 2: Send Message on Rayls (30 seconds)

```bash
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "Bank X tokenized $10M bond" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy
```

**What to Say**: 
> "Watch this - the transaction confirms in under 1 second on Rayls. This simulates a tokenized asset transfer that needs Ethereum verification."

**Action Items**:
1. **Copy the transaction hash** from output
2. **Open in browser**: `https://devnet-explorer.rayls.com/tx/[TX_HASH]`
3. **Show the RaylsMessage event** in the transaction

### Verify Message Was Sent
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "messageCount()(uint256)" \
  --rpc-url rayls
```
**Expected**: Count increased by 1

---

## 🔄 Step 3: Start Relayer (30 seconds)

**Open Terminal 3** (or split Terminal 2):
```bash
cd relayer
bun run dev
```

**What to Say**:
> "The relayer watches Rayls blocks and submits signed checkpoints to Sepolia every 10 blocks. It batches all messages into a single checkpoint with the receipts root."

**Point Out in Logs**:
- ✅ Current Rayls block number
- ✅ Current Sepolia block number
- ⏳ Waiting for checkpoint interval (10 blocks)
- 🚀 When it submits: "Checkpoint submitted! Tx: 0x..."

**Action Items**:
1. **Copy the Sepolia transaction hash** from relayer logs
2. Keep terminal visible to show real-time progress

---

## ✅ Step 4: Verify Checkpoint on Sepolia (30 seconds)

### Open Sepolia Transaction
```
https://sepolia.etherscan.io/tx/[SEPOLIA_TX_HASH]
```

**What to Show**:
- ✅ Transaction confirmed
- ✅ Look for `NewCheckpoint` event
- ✅ Show the receipts root and block number

### Check Updated Checkpoint Count
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```
**Expected**: Count increased by 1

### Get Latest Checkpoint Details
```bash
# Use checkpoint number = count - 1 (0-indexed)
# If count is 1, use 0. If count is 2, use 1, etc.

cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpoint(uint256)(uint256,uint256,bytes32,uint256)" \
  0 \
  --rpc-url sepolia
```
**Expected**: Returns `(blockNumber, timestamp, receiptsRoot, checkpointNumber)`

**What to Say**:
> "Total time from Rayls message to Ethereum verification: less than 45 seconds. This is only possible with Rayls' sub-second finality - no other chain can achieve this speed."

---

## 🎯 Alternative: Send Multiple Messages

### Send 3 Messages in Quick Succession
```bash
# Message 1
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "RWA Asset #1: Treasury Bond $5M" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy

# Message 2
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "RWA Asset #2: Real Estate Token $10M" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy

# Message 3
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "RWA Asset #3: Corporate Bond $8M" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy
```

**What to Say**:
> "All three messages confirmed in under 3 seconds total. The relayer will batch them into a single checkpoint, saving gas on Ethereum."

---

## 📊 Step 5: Show Final Stats (20 seconds)

### Total Messages Sent
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "messageCount()(uint256)" \
  --rpc-url rayls
```

### Total Checkpoints on Ethereum
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```

### Check Your Balances
```bash
# Rayls balance
cast balance 0x58E9CF917c3204A0BA31702173D575D144373993 \
  --rpc-url rayls

# Sepolia balance
cast balance 0x58E9CF917c3204A0BA31702173D575D144373993 \
  --rpc-url sepolia \
  --ether
```

---

## 🎤 Key Talking Points

### Why This Wins
1. **Judge's Request**: Directly addresses Idea 3.h from hackathon wiki - Ethereum trust anchors
2. **Battle-Tested**: Polygon-inspired architecture with proven security model
3. **Rayls Advantage**: <60 second challenge window only possible due to sub-second finality
4. **Infrastructure Play**: Not another vault/DEX - foundational bridging infrastructure
5. **Production Ready**: Clear path to mainnet with multi-sig and ZK upgrades

### The Speed Advantage
- **Rayls Transaction**: <1 second confirmation
- **Checkpoint Submission**: ~30 seconds (every 10 blocks)
- **Total Verification**: <45 seconds from Rayls to Ethereum
- **Challenge Window**: 60 seconds (vs 7 days on other chains)

### Roadmap Highlights
- ✅ **Phase 1**: Single validator (current)
- 🔄 **Phase 2**: Multi-sig validation (Q1 2026)
- 🚀 **Phase 3**: ZK light client (Q2 2026)
- 🌐 **Mainnet**: Launch with Rayls mainnet (Q1 2026)

---

## ⏱️ Demo Timeline

| Time | Step | Action |
|------|------|--------|
| 0:00-0:20 | Introduction | Show contracts, explain architecture |
| 0:20-0:50 | Send Message | Execute on Rayls, show <1s confirmation |
| 0:50-1:20 | Start Relayer | Explain checkpoint mechanism |
| 1:20-2:00 | Wait & Explain | Talk about architecture while relayer works |
| 2:00-2:30 | Verify | Show Sepolia transaction and checkpoint |
| 2:30-3:00 | Closing | Recap speed, explain strategic value |

---

## 💡 Pro Demo Tips

### Before You Start
- [ ] Have both explorers open in browser tabs
- [ ] Test that RPCs are responding
- [ ] Verify you have balance on both chains
- [ ] Have README.md open to show architecture diagram
- [ ] Terminal visible with good font size

### During Demo
1. **Keep terminal visible** - split screen with browser
2. **Copy tx hashes quickly** - use mouse selection
3. **Emphasize speed** - "Under 1 second on Rayls!"
4. **Show timestamps** - Point to block times in explorers
5. **Explain while waiting** - Talk about architecture during relayer wait
6. **End with roadmap** - Show mainnet vision

### Energy & Delivery
- This is **infrastructure** that enables $10B+ TVL
- Emphasize the **strategic value** for Rayls ecosystem
- Show **confidence** in the production roadmap
- Highlight **uniqueness** of sub-second finality advantage

---

## 🚨 Troubleshooting

### If Relayer Doesn't Submit
```bash
# Check it's been 10+ blocks on Rayls
cast block-number --rpc-url rayls

# Verify Sepolia balance
cast balance 0x58E9CF917c3204A0BA31702173D575D144373993 \
  --rpc-url sepolia --ether

# Check relayer logs for errors
# Should see "Waiting for checkpoint interval..."
```

### If Transaction Fails
```bash
# Verify Rayls balance
cast balance 0x58E9CF917c3204A0BA31702173D575D144373993 \
  --rpc-url rayls

# Check RPC is responding
cast block-number --rpc-url rayls

# Try with --legacy flag (already included)
```

### If Checkpoint Query Fails
- Make sure checkpoint count > 0
- Use `count - 1` as the checkpoint number (0-indexed)
- Example: If count is 1, query checkpoint 0

### If RPC Connection Issues
```bash
# Test Rayls RPC
curl -X POST https://rpc.devnet.rayls.com \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# Test Sepolia RPC
cast block-number --rpc-url sepolia
```

---

## 🔥 Closing Statement

> "Rayls Anchor is production-ready infrastructure that brings Rayls' institutional-grade blockchain to Ethereum's DeFi ecosystem. With battle-tested Polygon architecture, unique sub-second finality advantage, and clear paths to multi-sig validation and ZK light clients, this is the canonical bridge Rayls needs for mainnet launch in Q1 2026. This directly solves the TradFi to DeFi divide by providing trust-minimized verification for institutional RWAs."

---

## 📋 Quick Command Reference

### Essential Commands
```bash
# Send message
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" "Your message" \
  --rpc-url rayls --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 --legacy

# Start relayer
cd relayer && bun run dev

# Check message count
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "messageCount()(uint256)" --rpc-url rayls

# Check checkpoint count
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" --rpc-url sepolia

# Get checkpoint details (use count - 1)
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpoint(uint256)(uint256,uint256,bytes32,uint256)" \
  0 --rpc-url sepolia
```

---

**YOU'RE READY TO DEMO! 🚀**

**Remember**: This isn't just a bridge - it's the foundational infrastructure that enables Rayls to become the canonical chain for institutional RWAs on Ethereum.
