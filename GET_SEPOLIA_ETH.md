# 💰 Get Sepolia ETH for Your Wallet

**Your Address**: `0x58E9CF917c3204A0BA31702173D575D144373993`

## 🚰 Working Sepolia Faucets (November 2025)

### 1. **Alchemy Faucet** (RECOMMENDED - No Mining Required)
**URL**: https://www.alchemy.com/faucets/ethereum-sepolia

**Steps**:
1. Visit the link above (should open in your browser)
2. Sign in with your Alchemy account (or create free account)
3. Paste your address: `0x58E9CF917c3204A0BA31702173D575D144373993`
4. Complete CAPTCHA
5. Click "Send Me ETH"
6. Receive **0.5 Sepolia ETH** instantly

**Limits**: 0.5 ETH per day

---

### 2. **QuickNode Faucet**
**URL**: https://faucet.quicknode.com/ethereum/sepolia

**Steps**:
1. Connect your MetaMask wallet
2. Complete Twitter verification (follow @QuickNode)
3. Receive **0.05 Sepolia ETH**

**Limits**: Once per 12 hours

---

### 3. **Sepolia PoW Faucet** (Backup - Requires Mining)
**URL**: https://sepolia-faucet.pk910.de/

**Steps**:
1. Enter your address
2. Start mining in browser (takes 5-30 minutes)
3. Receive 0.05-0.5 ETH depending on mining time

**Note**: Slower but reliable if others are rate-limited

---

### 4. **Google Cloud Faucet**
**URL**: https://cloud.google.com/application/web3/faucet/ethereum/sepolia

**Steps**:
1. Sign in with Google account
2. Paste address
3. Receive 0.05 ETH

**Limits**: Once per day

---

### 5. **Infura Faucet**
**URL**: https://www.infura.io/faucet/sepolia

**Steps**:
1. Create free Infura account
2. Verify email
3. Request Sepolia ETH

---

## ⚡ Quick Start (Use Alchemy)

1. **Open Alchemy Faucet**: https://www.alchemy.com/faucets/ethereum-sepolia
2. **Sign in** (or create account - takes 30 seconds)
3. **Paste address**: `0x58E9CF917c3204A0BA31702173D575D144373993`
4. **Get 0.5 ETH** - enough for ~100+ contract deployments!

## 🔍 Verify You Received ETH

After requesting from faucet, check your balance:

```bash
# Check Sepolia balance
cast balance 0x58E9CF917c3204A0BA31702173D575D144373993 \
  --rpc-url sepolia \
  --ether
```

Or view in MetaMask:
1. Switch network to "Sepolia Test Network"
2. Check balance shows > 0 ETH

## 📊 How Much Do You Need?

- **Deploy RootChain**: ~0.002 ETH
- **Submit 10 Checkpoints**: ~0.005 ETH
- **Buffer for testing**: ~0.01 ETH

**Total needed**: ~0.02 ETH (Alchemy gives you 0.5 ETH - plenty!)

## 🚀 After Getting ETH

Once you have Sepolia ETH, deploy the RootChain:

```bash
forge script script/DeployRootChain.s.sol:DeployRootChain \
  --rpc-url sepolia \
  --broadcast
```

---

**Pro Tip**: If one faucet is rate-limited, try another! Alchemy is usually the fastest and most reliable.
