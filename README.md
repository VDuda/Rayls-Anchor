# Rayls Anchor

![Solidity](https://img.shields.io/badge/Solidity-0.8.26-363636?style=flat&logo=solidity)
![Foundry](https://img.shields.io/badge/Built%20with-Foundry-orange?style=flat)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat)
![Rayls](https://img.shields.io/badge/Rayls-Public%20Chain-00D4FF?style=flat)
![Ethereum](https://img.shields.io/badge/Ethereum-Holesky-627EEA?style=flat&logo=ethereum)

**The Polygon-inspired, trust-minimized checkpoint bridge that brings Rayls Public Chain state to Ethereum in <60 seconds.**

## 🎯 Overview

Rayls Anchor is a Polygon PoS-style checkpoint system tailored for Rayls' sub-second finality. It enables trust-minimized verification of Rayls Public Chain events and state on Ethereum mainnet and testnets.

### Why This Matters

- **Rayls Public Chain**: Fastest, most compliant EVM chain with sub-second finality
- **The Problem**: No trust-minimized way for Ethereum contracts to verify Rayls state
- **The Solution**: Polygon-inspired checkpoints with <60 second challenge windows (only possible due to Rayls finality)

## 🏗️ Architecture

```
Rayls Public Devnet ──(events)──► Relayer ──(signed checkpoint)──► RaylsRootChain (Holesky)
                                                    ▲
                                                    └── Merkle proof verification
                                                        for any Rayls event
```

**Security Model**: Currently uses PoA validator signatures (matching Rayls Devnet). Designed to upgrade to multi-sig consensus and eventually ZK light client verification.

**Note**: This implementation focuses on the checkpoint bridge mechanism. For production deployments, consider integrating with Rayls' native interoperability features (e.g., Sideling for cross-chain messaging) or ZK proof systems (e.g., Succinct SP1) for enhanced trustlessness.

### Core Components

1. **RaylsCheckpointEmitter.sol** (Rayls Devnet)
   - Emits messages/events from Rayls
   - Generates unique message IDs
   - Deployed on Chain ID: 123123

2. **RaylsRootChain.sol** (Ethereum Holesky)
   - Verifies PoA validator signatures
   - Stores checkpoints with receipts roots
   - Enables Merkle proof verification
   - 60-second challenge window

3. **Relayer** (TypeScript/viem)
   - Watches Rayls blocks via WebSocket
   - Signs and submits checkpoints every ~10 blocks
   - Auto-relays emitted messages

## 🚀 Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)
- Node.js 18+ (for relayer)
- Private keys for Rayls Devnet and Ethereum Holesky

### Installation

```bash
# Clone repository
git clone https://github.com/yourusername/Rayls-Anchor.git
cd Rayls-Anchor

# Install dependencies
forge install
cd relayer && npm install
```

### Configuration

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your keys
RAYLS_PRIVATE_KEY=your_rayls_private_key
HOLESKY_PRIVATE_KEY=your_holesky_private_key
VALIDATOR_PRIVATE_KEY=your_validator_private_key
```

### Deploy Contracts

```bash
# Deploy emitter to Rayls Devnet
forge script script/DeployEmitter.s.sol --rpc-url rayls --broadcast

# Deploy root chain to Ethereum Holesky
forge script script/DeployRootChain.s.sol --rpc-url holesky --broadcast
```

### Run Relayer

```bash
cd relayer
npm run dev
```

## 📋 Features

- ✅ Polygon-inspired checkpoint architecture
- ✅ ECDSA signature verification (PoA validator)
- ✅ Merkle proof-based message verification
- ✅ Sub-60 second challenge window (Rayls finality advantage)
- ✅ Upgradeable to multi-sig validator set
- ✅ Full Foundry test coverage
- ✅ TypeScript relayer with viem

## 🧪 Testing

```bash
# Run all tests
forge test

# Run with verbosity
forge test -vvv

# Run specific test
forge test --match-test testSubmitCheckpoint
```

## � Complementary Technologies

### Rayls Sideling
Rayls' native cross-chain messaging protocol. While Rayls Anchor provides checkpoint-based state verification, Sideling can be used for:
- Direct message passing between chains
- Native interoperability with private Rayls nodes
- Enhanced cross-chain contract calls

**Integration Path**: Future versions could combine Anchor's trust-minimized checkpoints with Sideling's messaging layer for a complete bridging solution.

### Succinct SP1 (ZK Proofs)
Zero-knowledge proof system for trustless light client verification. Potential upgrade to replace ECDSA signature verification with ZK proofs of validator consensus.

## �📚 Documentation

- [Deployment Guide](./DEPLOY.md)
- [Quick Start Guide](./QUICKSTART.md)
- [Project Structure](./PROJECT_STRUCTURE.md)

## 🔗 Key Links

- **Rayls Devnet RPC**: https://devnet-rpc.rayls.com
- **Rayls Explorer**: https://devnet-explorer.rayls.com
- **Holesky RPC**: https://rpc.ankr.com/eth_holesky
- **Rayls Docs**: https://docs.rayls.com

## 🛣️ Roadmap

### Current (Hackathon MVP)
- [x] PoA single validator checkpoint system
- [x] Basic Merkle proof verification
- [x] TypeScript relayer
- [x] Foundry deployment scripts

### Future (Mainnet)
- [ ] Multi-signature validator set (2/3+ consensus)
- [ ] ZK light client with Succinct SP1
- [ ] Integration with Rayls Sideling for native cross-chain messaging
- [ ] Fraud proof system
- [ ] Integration with Aave/Uniswap/Curve for DeFi liquidity
- [ ] RWA tokenized asset bridging from private nodes

## 🏆 Hackathon Submission

This project directly addresses the Rayls hackathon challenge for **Ethereum trust anchors** (Idea 3.h from the wiki). It demonstrates:

- Infrastructure-level innovation (not another vault/DEX)
- Battle-tested Polygon architecture adapted for Rayls
- Leverages Rayls' unique sub-second finality
- Immediate strategic value for Rayls ecosystem

**Demo**: Watch a tokenized message move from Rayls → verified on Ethereum in <45 seconds.

## 📄 License

MIT License - see [LICENSE](./LICENSE) for details

## 🤝 Contributing

Contributions welcome! Please open an issue or PR.

## ⚡ Built For

**Rayls Public Chain** - The fastest, most compliant EVM chain with native private-chain interop.

---

*Bringing institutional DeFi to Ethereum, one checkpoint at a time.* 🚀
