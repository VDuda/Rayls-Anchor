# 🎥 Rayls Anchor Demo Script

## 📋 Deployed Contracts

✅ **Rayls Emitter**: `0xe6AF1212d688601142f5E8b70da4e320d7838362`
- Explorer: https://devnet-explorer.rayls.com/address/0xe6AF1212d688601142f5E8b70da4e320d7838362

✅ **Sepolia RootChain**: `0xe6AF1212d688601142f5E8b70da4e320d7838362`
- Explorer: https://sepolia.etherscan.io/address/0xe6AF1212d688601142f5E8b70da4e320d7838362

---

## 🎬 Demo Flow (2-3 Minutes)

### Scene 1: Introduction (15 seconds)
**Say**:
> "Rayls Anchor is a Polygon-inspired checkpoint bridge that brings Rayls Public Chain state to Ethereum in under 60 seconds. This solves the Tradfi to Defi divide as part of this hackathon."

**Show**: README.md with architecture diagram

---

### Scene 2: Show Deployed Contracts (20 seconds)
**Say**:
> "I've deployed two contracts: the Emitter on Rayls Devnet and the RootChain on Ethereum Sepolia."

**Show**:
1. Open Rayls Explorer: https://devnet-explorer.rayls.com/address/0xe6AF1212d688601142f5E8b70da4e320d7838362
2. Open Sepolia Explorer: https://sepolia.etherscan.io/address/0xe6AF1212d688601142f5E8b70da4e320d7838362

---

### Scene 3: Send Message on Rayls (30 seconds)
**Say**:
> "Let me send a message from Rayls that will be verified on Ethereum. This simulates a tokenized asset transfer."

**Run in Terminal**:
```bash
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "Bank X tokenized $10M bond" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy
```

**Point Out**:
- Transaction confirms in <1 second (show terminal output)
- Copy the transaction hash
- Open in Rayls Explorer to show the RaylsMessage event

---

### Scene 4: Start Relayer (30 seconds)
**Say**:
> "Now I'll start the relayer, which watches Rayls blocks and submits signed checkpoints to Ethereum every 10 blocks."

**Run in Terminal**:
```bash
cd relayer
bun install  # if not already done
bun run dev
```

**Point Out**:
- Relayer connects to both chains
- Shows current block numbers
- Waits for checkpoint interval

---

### Scene 5: Checkpoint Submitted (30 seconds)
**Say**:
> "Watch as the relayer automatically submits a checkpoint to Sepolia containing the receipts root."

**Show**:
- Relayer logs showing checkpoint submission
- Copy the Sepolia transaction hash from logs
- Open in Sepolia Explorer: https://sepolia.etherscan.io/tx/[TX_HASH]
- Show the NewCheckpoint event

**Point Out**:
- Total time from Rayls message to Ethereum verification: <45 seconds
- Only possible due to Rayls' sub-second finality

---

### Scene 6: Verify Checkpoint (20 seconds)
**Say**:
> "Let's verify the checkpoint was stored correctly."

**Run in Terminal**:
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```

**Show**: Returns 1 (or more if multiple checkpoints)

---

### Scene 7: Why This Wins (30 seconds)
**Say**:
> "This project directly solves the judge's highlighted idea for Ethereum trust anchors. It uses battle-tested Polygon architecture, leverages Rayls' unique sub-second finality for a 60-second challenge window—impossible on other chains—and provides immediate strategic value for the Rayls ecosystem."

**Show**: README.md roadmap section

---

## 🚀 Quick Test Commands (Run These Before Recording)

### 1. Send Test Message
```bash
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "Test message from Rayls" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy
```

### 2. Check Message Count
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "messageCount()(uint256)" \
  --rpc-url rayls
```

### 3. Check Checkpoint Count
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```

### 4. Start Relayer
```bash
cd relayer && bun run dev
```

---

## 📊 Key Talking Points

1. **Infrastructure Play**: Not another vault/DEX—this is foundational bridging infrastructure
2. **Polygon-Inspired**: Battle-tested architecture adapted for Rayls
3. **Rayls Advantage**: <60s challenge window only possible due to sub-second finality
4. **Judge's Request**: Directly addresses Idea 3.h from hackathon wiki
5. **Production Ready**: Clear path to mainnet with multi-sig and ZK upgrades

---

## 🎯 Demo Tips

- **Keep terminal visible** throughout demo
- **Have both explorers open** in browser tabs
- **Show timestamps** to prove <60s verification
- **Emphasize the speed** (Rayls <1s, total <45s)
- **End with roadmap** showing mainnet vision

---

## 🔗 Quick Links for Demo

- **Rayls Emitter**: https://devnet-explorer.rayls.com/address/0xe6AF1212d688601142f5E8b70da4e320d7838362
- **Sepolia RootChain**: https://sepolia.etherscan.io/address/0xe6AF1212d688601142f5E8b70da4e320d7838362
- **GitHub Repo**: https://github.com/VDuda/Rayls-Anchor

---

**Total Demo Time**: 2-3 minutes
**Wow Factor**: Live cross-chain verification in <45 seconds 🚀
