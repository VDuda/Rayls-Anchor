# ⚡ QUICK DEMO - 3 Minutes

## 🎯 The Flow
1. Send message on Rayls (<1s)
2. Start relayer (watches blocks)
3. Checkpoint submitted to Sepolia (~30s)
4. Verify on Ethereum
5. **Total: <45 seconds!**

---

## 📋 Commands (Copy/Paste)

### 1️⃣ Send Message
```bash
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "Bank X tokenized $10M bond" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy
```
**Copy TX hash** → Open: https://devnet-explorer.rayls.com/tx/[HASH]

---

### 2️⃣ Start Relayer
```bash
cd relayer
# Make sure .env exists (should be already created)
bun run dev
```
**Copy Sepolia TX hash** from logs when it submits

---

### 3️⃣ Verify Checkpoint
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```
Open: https://sepolia.etherscan.io/tx/[SEPOLIA_TX_HASH]

---

## 🎤 What to Say

**Opening**: "Rayls Anchor bridges Rayls to Ethereum in under 60 seconds using Polygon-inspired checkpoints"

**While sending**: "Watch - transaction confirms in under 1 second on Rayls"

**While relayer runs**: "The relayer batches messages every 10 blocks and submits signed checkpoints to Sepolia"

**At verification**: "Total time from Rayls to Ethereum: less than 45 seconds - only possible with Rayls' sub-second finality"

**Closing**: "This solves the TradFi to DeFi divide by providing trust-minimized verification for institutional RWAs"

---

## 🔗 Have These Open
- Frontend: http://localhost:3000
- Rayls: https://devnet-explorer.rayls.com/address/0xe6AF1212d688601142f5E8b70da4e320d7838362
- Sepolia: https://sepolia.etherscan.io/address/0xe6AF1212d688601142f5E8b70da4e320d7838362

---

**GO WIN! 🏆**
