# 🚀 Deployment Steps for End-to-End Testing

## 📋 Prerequisites Checklist

- [x] Foundry installed
- [x] `.env` file created with fresh wallet
- [x] Contracts compiled and ready
- [ ] **Testnet tokens acquired** (REQUIRED NEXT STEP)

## 🔑 Your Deployment Wallet

**Address**: `0x0135537bcfA2635ad89F1a413C4E97E8194185cC`

**Private Key**: Already set in `.env` (gitignored)

## 💰 Step 1: Fund Your Wallet

### Rayls Devnet (USDgas tokens)

1. **Option A: Web Faucet**
   - Visit: https://devnet-dapp.rayls.com/sign-in
   - Connect MetaMask with address: `0x0135537bcfA2635ad89F1a413C4E97E8194185cC`
   - Claim USDgas tokens from built-in faucet

2. **Option B: Telegram**
   - Join: https://t.me/+NnGH9BZlcrc1NjMx
   - Request faucet for: `0x0135537bcfA2635ad89F1a413C4E97E8194185cC`

### Ethereum Holesky (ETH)

1. **Holesky Faucet**
   - Visit: https://holesky-faucet.pk910.de/
   - Enter address: `0x0135537bcfA2635ad89F1a413C4E97E8194185cC`
   - Mine or request 0.1 ETH

2. **Alternative Faucets**
   - https://faucet.quicknode.com/ethereum/holesky
   - https://cloud.google.com/application/web3/faucet/ethereum/holesky

## ✅ Step 2: Verify Balances

```bash
# Check Rayls balance
cast balance 0x0135537bcfA2635ad89F1a413C4E97E8194185cC --rpc-url rayls

# Check Holesky balance
cast balance 0x0135537bcfA2635ad89F1a413C4E97E8194185cC --rpc-url holesky
```

Both should show non-zero balances before proceeding.

## 🏗️ Step 3: Deploy Contracts

### Deploy to Rayls Devnet

```bash
forge script script/DeployEmitter.s.sol:DeployEmitter \
  --rpc-url rayls \
  --broadcast \
  --legacy
```

**Expected Output:**
```
RaylsCheckpointEmitter deployed to: 0x...
Chain ID: 123123
```

### Deploy to Ethereum Holesky

```bash
forge script script/DeployRootChain.s.sol:DeployRootChain \
  --rpc-url holesky \
  --broadcast
```

**Expected Output:**
```
RaylsRootChain deployed to: 0x...
Chain ID: 17000
Validator: 0x0135537bcfA2635ad89F1a413C4E97E8194185cC
Challenge Window: 60 seconds
```

## 📝 Step 4: Update Contract Addresses

After deployment, update `.env` with the deployed addresses:

```bash
# Edit .env and add:
RAYLS_EMITTER_ADDRESS=0x... # from step 3.1
HOLESKY_ROOTCHAIN_ADDRESS=0x... # from step 3.2
```

## 🧪 Step 5: Test End-to-End

### Test 1: Send Message on Rayls

```bash
cast send $RAYLS_EMITTER_ADDRESS \
  "sendToEthereum(string)" \
  "Bank X tokenized $10M bond" \
  --rpc-url rayls \
  --private-key $PRIVATE_KEY \
  --legacy
```

### Test 2: Verify Transaction

```bash
# Get transaction receipt
cast receipt <TX_HASH> --rpc-url rayls

# View on explorer
open "https://devnet-explorer.rayls.com/tx/<TX_HASH>"
```

### Test 3: Start Relayer

```bash
cd relayer
npm run dev
```

The relayer should:
1. Watch for new blocks on Rayls
2. Sign checkpoints every ~10 blocks
3. Submit to Holesky RootChain
4. Log checkpoint submissions

### Test 4: Verify Checkpoint on Holesky

```bash
# Check checkpoint count
cast call $HOLESKY_ROOTCHAIN_ADDRESS \
  "getCheckpointCount()(uint256)" \
  --rpc-url holesky

# Get latest checkpoint
cast call $HOLESKY_ROOTCHAIN_ADDRESS \
  "getCheckpoint(uint256)((uint256,uint256,bytes32,uint256))" \
  0 \
  --rpc-url holesky
```

## 🎯 Success Criteria

- ✅ Emitter deployed on Rayls (Chain ID: 123123)
- ✅ RootChain deployed on Holesky (Chain ID: 17000)
- ✅ Message sent on Rayls confirms in <1 second
- ✅ Relayer submits checkpoint to Holesky in ~10 seconds
- ✅ Checkpoint verifiable on Holesky explorer
- ✅ Total time: <45 seconds (Rayls → Ethereum verification)

## 🐛 Troubleshooting

### "Insufficient funds" error
- Check balances with `cast balance` commands above
- Request more tokens from faucets

### "Invalid signature" error on Holesky
- Ensure `VALIDATOR_ADDRESS` in `.env` matches deployer address
- Verify relayer is using correct private key

### Relayer not submitting checkpoints
- Check Rayls RPC connectivity
- Verify `.env` has correct contract addresses
- Check relayer logs for errors

## 📊 Monitoring

- **Rayls Explorer**: https://devnet-explorer.rayls.com
- **Holesky Explorer**: https://holesky.etherscan.io
- **Relayer Logs**: Terminal output from `npm run dev`

## 🎥 Demo Recording Tips

1. Record terminal showing deployment commands
2. Show Rayls explorer with <1s confirmation
3. Show relayer logs submitting checkpoint
4. Show Holesky explorer with checkpoint tx
5. Highlight total time: <45 seconds

---

**Ready to deploy?** Start with Step 1: Fund your wallet! 🚀
