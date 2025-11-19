# 🎬 DEMO CHEATSHEET - Copy/Paste Ready

## 📍 Your Deployed Contracts

**Rayls Emitter**: `0xe6AF1212d688601142f5E8b70da4e320d7838362`
**Sepolia RootChain**: `0xe6AF1212d688601142f5E8b70da4e320d7838362`

---

## 🚀 Commands to Run During Demo

### 0️⃣ Start Frontend (Optional - Opens in Browser)
```bash
cd frontend && bun install && bun run dev
```
Then open: http://localhost:3000

### 1️⃣ Send Message on Rayls
```bash
cast send 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "sendToEthereum(string)" \
  "Bank X tokenized $10M bond" \
  --rpc-url rayls \
  --private-key 0xc0c67d26120d792b270f7656309089f2e809e88f11532f1fc52b0aa7d1ab7132 \
  --legacy
```

### 2️⃣ Start Relayer
```bash
cd relayer && bun run dev
```

### 3️⃣ Check Checkpoint Count (After Relayer Runs)
```bash
cast call 0xe6AF1212d688601142f5E8b70da4e320d7838362 \
  "getCheckpointCount()(uint256)" \
  --rpc-url sepolia
```

---

## 🌐 Explorer Links (Open in Browser Tabs)

**Rayls Emitter**:
https://devnet-explorer.rayls.com/address/0xe6AF1212d688601142f5E8b70da4e320d7838362

**Sepolia RootChain**:
https://sepolia.etherscan.io/address/0xe6AF1212d688601142f5E8b70da4e320d7838362

**GitHub Repo**:
https://github.com/VDuda/Rayls-Anchor

---

## 🎯 Key Demo Points (Say These)

1. **"Solves judge's highlighted Idea 3.h - Ethereum trust anchors"**
2. **"Polygon-inspired architecture - battle-tested and proven"**
3. **"<60 second challenge window - only possible with Rayls sub-second finality"**
4. **"Infrastructure play, not another vault/DEX"**
5. **"Total verification time: <45 seconds from Rayls to Ethereum"**

---

## ⏱️ Demo Timeline

- **0:00-0:15** - Introduction & problem statement
- **0:15-0:35** - Show deployed contracts on both explorers
- **0:35-1:05** - Send message on Rayls (show <1s confirmation)
- **1:05-1:35** - Start relayer, explain checkpoint mechanism
- **1:35-2:05** - Show checkpoint submitted to Sepolia
- **2:05-2:20** - Verify checkpoint count
- **2:20-2:45** - Explain why this wins (roadmap, mainnet vision)

**Total**: ~3 minutes

---

## ✅ Pre-Demo Checklist

- [ ] Both explorer tabs open
- [ ] Terminal ready in project root
- [ ] README.md open to show architecture
- [ ] Test message sent successfully (already done ✅)
- [ ] Relayer dependencies installed (`cd relayer && bun install`)

---

## 🎥 Recording Tips

- **Screen**: Split between terminal and browser
- **Audio**: Emphasize speed and finality advantage
- **Visuals**: Show timestamps on transactions
- **Energy**: This is infrastructure that enables $10B+ TVL!

---

## 🔥 Closing Statement

> "Rayls Anchor is production-ready infrastructure that brings Rayls' institutional-grade blockchain to Ethereum's DeFi ecosystem. With clear paths to multi-sig validation and ZK light clients, this is the canonical bridge Rayls needs for mainnet launch in Q1 2026."

---

**You're ready to record! 🚀**
