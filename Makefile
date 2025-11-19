.PHONY: install test deploy-rayls deploy-holesky start-relayer start-frontend clean

# Install all dependencies
install:
	@echo "📦 Installing Foundry dependencies..."
	forge install
	@echo "📦 Installing relayer dependencies..."
	cd relayer && bun install
	@echo "📦 Installing frontend dependencies..."
	cd frontend && bun install
	@echo "✅ All dependencies installed!"

# Run tests
test:
	@echo "🧪 Running contract tests..."
	forge test -vv

# Deploy emitter on Rayls
deploy-rayls:
	@echo "🚀 Deploying RaylsCheckpointEmitter on Rayls Devnet..."
	forge script script/DeployEmitter.s.sol:DeployEmitter \
		--rpc-url https://devnet-rpc.rayls.com \
		--broadcast \
		--private-key $(PRIVATE_KEY) \
		-vvvv

# Deploy root chain on Holesky
deploy-holesky:
	@echo "🚀 Deploying RaylsRootChain on Ethereum Holesky..."
	forge script script/DeployRootChain.s.sol:DeployRootChain \
		--rpc-url https://rpc.ankr.com/eth_holesky \
		--broadcast \
		--private-key $(PRIVATE_KEY) \
		-vvvv

# Deploy both contracts
deploy-all: deploy-rayls deploy-holesky

# Start relayer
start-relayer:
	@echo "🔄 Starting Rayls Anchor Relayer..."
	cd relayer && bun run dev

# Start frontend
start-frontend:
	@echo "🌐 Starting Next.js frontend..."
	cd frontend && bun run dev

# Clean build artifacts
clean:
	@echo "🧹 Cleaning build artifacts..."
	forge clean
	rm -rf frontend/.next
	rm -rf frontend/dist
	rm -rf relayer/dist
	@echo "✅ Clean complete!"

# Run local demo (requires deployed contracts)
demo:
	@echo "🎬 Starting demo environment..."
	@echo "1. Relayer starting in background..."
	cd relayer && bun run dev &
	@echo "2. Frontend starting..."
	cd frontend && bun run dev

# Build for production
build:
	@echo "🏗️  Building for production..."
	forge build
	cd frontend && bun run build
	cd relayer && bun run build
	@echo "✅ Build complete!"

# Help
help:
	@echo "Rayls Anchor - Available Commands:"
	@echo ""
	@echo "  make install         - Install all dependencies"
	@echo "  make test            - Run contract tests"
	@echo "  make deploy-rayls    - Deploy emitter on Rayls"
	@echo "  make deploy-holesky  - Deploy root chain on Holesky"
	@echo "  make deploy-all      - Deploy both contracts"
	@echo "  make start-relayer   - Start the relayer service"
	@echo "  make start-frontend  - Start the Next.js frontend"
	@echo "  make demo            - Start full demo environment"
	@echo "  make build           - Build for production"
	@echo "  make clean           - Clean build artifacts"
	@echo "  make help            - Show this help message"
	@echo ""
	@echo "Environment variables needed:"
	@echo "  PRIVATE_KEY          - Your wallet private key"
	@echo "  VALIDATOR_ADDRESS    - Validator address for PoA"
