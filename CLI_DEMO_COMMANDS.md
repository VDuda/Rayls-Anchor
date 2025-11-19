# 🎬 CLI Demo Commands - Copy/Paste Ready

## 🚀 Complete Demo Flow

### Step 0: Setup (Before Demo)

```bash
# Terminal 1: Start Frontend (optional but impressive)
cd frontend
bun run dev
# Open http://localhost:3000 in browser

# Terminal 2: Keep ready for commands
cd /Users/vlad/hackathon/Rayls-Anchor
```

---

## 📍 Step 1: Show Deployed Contracts

### Check Rayls Emitter
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "messageCount()(uint256)" \
  --rpc-url rayls
```
**Expected**: Returns current message count (e.g., `1`)

### Check Sepolia RootChain
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```
**Expected**: Returns current checkpoint count (e.g., `0` or `1`)

### Check Your Balance
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

## 📨 Step 2: Send Message on Rayls

```bash
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "Bank X tokenized $10M bond" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy
```

**What to say**: 
> "Watch this - the transaction confirms in under 1 second on Rayls"

**Copy the transaction hash** from output and open in browser:
```
https://devnet-explorer.rayls.com/tx/[TX_HASH]
```

### Verify Message Was Sent
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "messageCount()(uint256)" \
  --rpc-url rayls
```
**Expected**: Count increased by 1

---

## 🔄 Step 3: Start Relayer

### Terminal 2 (or new terminal):
```bash
cd relayer
bun run dev
```

**What to say**:
> "The relayer watches Rayls blocks and submits checkpoints to Sepolia every 10 blocks"

**Point out in logs**:
- Current Rayls block
- Current Sepolia block
- Waiting for checkpoint interval
- When it submits: "Checkpoint submitted! Tx: 0x..."

**Copy the Sepolia tx hash** from relayer logs

---

## ✅ Step 4: Verify Checkpoint on Sepolia

### Open Sepolia Transaction
```
https://sepolia.etherscan.io/tx/[SEPOLIA_TX_HASH]
```

**What to show**:
- Transaction confirmed
- Look for `NewCheckpoint` event
- Show the receipts root

### Check Checkpoint Count
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```
**Expected**: Count increased by 1

### Get Latest Checkpoint Details
```bash
# Get the checkpoint number (count - 1)
# If count is 1, use 0. If count is 2, use 1, etc.

cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpoint(uint256)(uint256,uint256,bytes32,uint256)" \
  0 \
  --rpc-url sepolia
```
**Expected**: Returns (blockNumber, timestamp, receiptsRoot, checkpointNumber)

---

## 🎯 Alternative: Send Multiple Messages

### Send 3 Messages Quickly
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

**What to say**:
> "All three messages confirmed in under 3 seconds total. The relayer will batch them into a single checkpoint."

---

## 📊 Step 5: Show the Stats

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

### Check Validator Address
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "validator()(address)" \
  --rpc-url sepolia
```
**Expected**: `0x58E9CF917c3204A0BA31702173D575D144373993`

---

## 🎬 Demo Script Summary

### Timing (Total: 2-3 minutes)

**0:00-0:30** - Show contracts deployed, check counts
**0:30-0:45** - Send message on Rayls (<1s confirmation)
**0:45-1:15** - Start relayer, explain mechanism
**1:15-2:00** - Wait for checkpoint (show logs)
**2:00-2:30** - Verify on Sepolia, show transaction
**2:30-3:00** - Recap: <45 seconds total, explain advantages

---

## 💡 Pro Tips

1. **Have both explorers open** in browser tabs before starting
2. **Keep terminal visible** - split screen with browser
3. **Copy tx hashes quickly** - use mouse selection
4. **Emphasize speed** - "Under 1 second on Rayls!"
5. **Show timestamps** - Point to block times in explorers
6. **Explain while waiting** - Talk about architecture during relayer wait

---

## 🔗 Quick Links (Open Before Demo)

- Rayls Emitter: https://devnet-explorer.rayls.com/address/0xe6AF1212d688601142f5E8b70da4e320d7838362
- Sepolia RootChain: https://sepolia.etherscan.io/address/0xe6AF1212d688601142f5E8b70da4e320d7838362
- Frontend: http://localhost:3000

---

## 🚨 Troubleshooting

### If relayer doesn't submit:
- Check it's been 10+ blocks on Rayls
- Verify Sepolia balance: `cast balance 0x58E9CF917c3204A0BA31702173D575D144373993 --rpc-url sepolia --ether`
- Check relayer logs for errors

### If transaction fails:
- Verify you have Rayls balance
- Check RPC is responding: `cast block-number --rpc-url rayls`
- Try with `--legacy` flag

### If checkpoint query fails:
- Make sure checkpoint count > 0
- Use count - 1 as the checkpoint number (0-indexed)

---

**YOU'RE READY! 🚀 Copy these commands and crush that demo!**
