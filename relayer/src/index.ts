import { createPublicClient, createWalletClient, http, defineChain, parseAbi } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';

// Environment variables
const PRIVATE_KEY = process.env.PRIVATE_KEY as `0x${string}`;
const VALIDATOR_ADDRESS = process.env.VALIDATOR_ADDRESS as `0x${string}`;
const RAYLS_EMITTER_ADDRESS = process.env.RAYLS_EMITTER_ADDRESS as `0x${string}`;
const HOLESKY_ROOTCHAIN_ADDRESS = process.env.HOLESKY_ROOTCHAIN_ADDRESS as `0x${string}`;
const CHECKPOINT_INTERVAL_BLOCKS = parseInt(process.env.CHECKPOINT_INTERVAL_BLOCKS || '10');
const CHECKPOINT_INTERVAL_MS = parseInt(process.env.CHECKPOINT_INTERVAL_MS || '10000');

// Define Rayls chain
const raylsDevnet = defineChain({
  id: 123123,
  name: 'Rayls Devnet',
  nativeCurrency: { name: 'USDgas', symbol: 'USDgas', decimals: 18 },
  rpcUrls: {
    default: { http: ['https://devnet-rpc.rayls.com'] },
  },
  blockExplorers: {
    default: { name: 'Rayls Explorer', url: 'https://devnet-explorer.rayls.com' },
  },
  testnet: true,
});

// Create clients
const raylsClient = createPublicClient({
  chain: raylsDevnet,
  transport: http('https://devnet-rpc.rayls.com'),
});

const holeskyClient = createPublicClient({
  chain: {
    id: 17000,
    name: 'Holesky',
    nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
    rpcUrls: {
      default: { http: ['https://rpc.ankr.com/eth_holesky'] },
    },
    blockExplorers: {
      default: { name: 'Etherscan', url: 'https://holesky.etherscan.io' },
    },
    testnet: true,
  },
  transport: http('https://rpc.ankr.com/eth_holesky'),
});

// Create wallet client for signing and submitting
const account = privateKeyToAccount(PRIVATE_KEY);
const holeskyWalletClient = createWalletClient({
  account,
  chain: {
    id: 17000,
    name: 'Holesky',
    nativeCurrency: { name: 'Ether', symbol: 'ETH', decimals: 18 },
    rpcUrls: {
      default: { http: ['https://rpc.ankr.com/eth_holesky'] },
    },
    testnet: true,
  },
  transport: http('https://rpc.ankr.com/eth_holesky'),
});

// Contract ABIs (minimal)
const rootChainAbi = parseAbi([
  'function submitCheckpoint(uint256 startBlock, uint256 endBlock, bytes32 receiptsRoot, bytes signature) external',
  'function getCheckpointCount() external view returns (uint256)',
  'event NewCheckpoint(uint256 indexed checkpointNumber, uint256 startBlock, uint256 endBlock, bytes32 receiptsRoot, uint256 timestamp)',
]);

const emitterAbi = parseAbi([
  'event RaylsMessage(address indexed sender, string message, uint256 raylsBlock, bytes32 indexed messageId)',
]);

interface RelayerState {
  lastProcessedBlock: bigint;
  checkpointsSubmitted: number;
  isRunning: boolean;
}

const state: RelayerState = {
  lastProcessedBlock: 0n,
  checkpointsSubmitted: 0,
  isRunning: true,
};

/**
 * Sign checkpoint data with validator private key
 */
async function signCheckpoint(
  startBlock: bigint,
  endBlock: bigint,
  receiptsRoot: `0x${string}`,
  chainId: number
): Promise<`0x${string}`> {
  // Create message hash matching Solidity implementation
  const messageHash = await account.signMessage({
    message: {
      raw: await holeskyWalletClient.request({
        method: 'eth_call',
        params: [
          {
            data: `0x${Buffer.from(
              JSON.stringify([startBlock, endBlock, receiptsRoot, chainId])
            ).toString('hex')}`,
          },
          'latest',
        ],
      }),
    } as any,
  });

  return messageHash;
}

/**
 * Submit checkpoint to Holesky RootChain
 */
async function submitCheckpoint(
  startBlock: bigint,
  endBlock: bigint,
  receiptsRoot: `0x${string}`
) {
  try {
    console.log(`\n🔄 Submitting checkpoint [${startBlock} -> ${endBlock}]...`);
    console.log(`   Receipts Root: ${receiptsRoot}`);

    // Sign the checkpoint
    const signature = await account.signMessage({
      message: { raw: receiptsRoot },
    });

    // Submit to contract
    const hash = await holeskyWalletClient.writeContract({
      address: HOLESKY_ROOTCHAIN_ADDRESS,
      abi: rootChainAbi,
      functionName: 'submitCheckpoint',
      args: [startBlock, endBlock, receiptsRoot, signature],
    });

    console.log(`✅ Checkpoint submitted! Tx: ${hash}`);
    console.log(`   Explorer: https://holesky.etherscan.io/tx/${hash}`);

    state.checkpointsSubmitted++;
    state.lastProcessedBlock = endBlock;

    return hash;
  } catch (error: any) {
    console.error(`❌ Failed to submit checkpoint:`, error.message);
    throw error;
  }
}

/**
 * Watch for messages emitted on Rayls
 */
async function watchMessages() {
  console.log(`\n👀 Watching for RaylsMessage events...`);
  console.log(`   Emitter: ${RAYLS_EMITTER_ADDRESS}`);

  const unwatch = raylsClient.watchContractEvent({
    address: RAYLS_EMITTER_ADDRESS,
    abi: emitterAbi,
    eventName: 'RaylsMessage',
    onLogs: (logs) => {
      logs.forEach((log) => {
        const { sender, message, raylsBlock, messageId } = log.args;
        console.log(`\n📨 New Message Detected!`);
        console.log(`   From: ${sender}`);
        console.log(`   Message: "${message}"`);
        console.log(`   Block: ${raylsBlock}`);
        console.log(`   Message ID: ${messageId}`);
      });
    },
  });

  return unwatch;
}

/**
 * Main relayer loop
 */
async function runRelayer() {
  console.log('🚀 Rayls Anchor Relayer Starting...\n');
  console.log('='.repeat(50));
  console.log(`Rayls RPC: https://devnet-rpc.rayls.com`);
  console.log(`Holesky RPC: https://rpc.ankr.com/eth_holesky`);
  console.log(`Validator: ${VALIDATOR_ADDRESS}`);
  console.log(`Relayer: ${account.address}`);
  console.log(`Emitter: ${RAYLS_EMITTER_ADDRESS}`);
  console.log(`RootChain: ${HOLESKY_ROOTCHAIN_ADDRESS}`);
  console.log(`Checkpoint Interval: ${CHECKPOINT_INTERVAL_BLOCKS} blocks (~${CHECKPOINT_INTERVAL_MS}ms)`);
  console.log('='.repeat(50));

  // Start watching for messages
  await watchMessages();

  // Get initial state
  const currentBlock = await raylsClient.getBlockNumber();
  state.lastProcessedBlock = currentBlock;

  console.log(`\n✅ Relayer initialized at block ${currentBlock}`);
  console.log(`⏰ Checkpoint interval: ${CHECKPOINT_INTERVAL_MS}ms\n`);

  // Main loop
  while (state.isRunning) {
    try {
      const latestBlock = await raylsClient.getBlockNumber();

      // Check if we should submit a checkpoint
      if (latestBlock >= state.lastProcessedBlock + BigInt(CHECKPOINT_INTERVAL_BLOCKS)) {
        const startBlock = state.lastProcessedBlock + 1n;
        const endBlock = latestBlock;

        // Get block to extract receipts root
        const block = await raylsClient.getBlock({
          blockNumber: endBlock,
          includeTransactions: false,
        });

        // Submit checkpoint
        await submitCheckpoint(startBlock, endBlock, block.receiptsRoot);

        console.log(`\n📊 Stats:`);
        console.log(`   Current Block: ${latestBlock}`);
        console.log(`   Last Processed: ${state.lastProcessedBlock}`);
        console.log(`   Checkpoints Submitted: ${state.checkpointsSubmitted}`);
      } else {
        // Log heartbeat
        process.stdout.write(
          `\r⏳ Waiting... Current: ${latestBlock} | Last Checkpoint: ${state.lastProcessedBlock} | Submitted: ${state.checkpointsSubmitted}`
        );
      }

      // Wait before next check
      await new Promise((resolve) => setTimeout(resolve, CHECKPOINT_INTERVAL_MS));
    } catch (error: any) {
      console.error(`\n❌ Error in relayer loop:`, error.message);
      await new Promise((resolve) => setTimeout(resolve, CHECKPOINT_INTERVAL_MS * 2));
    }
  }
}

// Handle shutdown gracefully
process.on('SIGINT', () => {
  console.log('\n\n👋 Shutting down relayer...');
  state.isRunning = false;
  process.exit(0);
});

process.on('SIGTERM', () => {
  console.log('\n\n👋 Shutting down relayer...');
  state.isRunning = false;
  process.exit(0);
});

// Start the relayer
runRelayer().catch((error) => {
  console.error('Fatal error:', error);
  process.exit(1);
});
