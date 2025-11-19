// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title RaylsRootChain
 * @notice Polygon-inspired checkpoint verification system for Rayls Public Chain
 * @dev Deployed on Ethereum Sepolia (testnet) / Mainnet
 * Verifies signed checkpoints from Rayls validators and enables Merkle proof verification
 */
contract RaylsRootChain {
    /// @notice PoA validator address (centralized on devnet, will evolve to multi-sig)
    address public raylsValidator;

    /// @notice Challenge window duration (60 seconds - only possible due to Rayls sub-second finality)
    uint256 public constant CHALLENGE_WINDOW = 60;

    /// @notice Checkpoint data structure
    struct Checkpoint {
        uint256 startBlock;
        uint256 endBlock;
        bytes32 receiptsRoot;
        uint256 timestamp;
    }

    /// @notice Array of all submitted checkpoints
    Checkpoint[] public checkpoints;

    /// @notice Mapping of verified message IDs
    mapping(bytes32 => bool) public verifiedMessages;

    /// @notice Emitted when a new checkpoint is submitted
    event NewCheckpoint(
        uint256 indexed checkpointNumber,
        uint256 startBlock,
        uint256 endBlock,
        bytes32 receiptsRoot,
        uint256 timestamp
    );

    /// @notice Emitted when a message is verified from Rayls
    event MessageVerifiedFromRayls(
        bytes32 indexed messageId,
        string message,
        address sender,
        uint256 checkpointNumber
    );

    /// @notice Emitted when validator is updated
    event ValidatorUpdated(address indexed oldValidator, address indexed newValidator);

    error InvalidSignature();
    error InvalidCheckpointRange();
    error ChallengeWindowClosed();
    error MessageAlreadyVerified();
    error InvalidMerkleProof();
    error CheckpointNotFound();
    error UnauthorizedValidator();

    /**
     * @notice Initialize with validator address
     * @param _validator Address of the initial PoA validator
     */
    constructor(address _validator) {
        require(_validator != address(0), "Invalid validator");
        raylsValidator = _validator;
    }

    /**
     * @notice Submit a checkpoint from Rayls (Polygon-style)
     * @param startBlock Starting block number of the checkpoint
     * @param endBlock Ending block number of the checkpoint
     * @param receiptsRoot Merkle root of receipts for the block range
     * @param signature ECDSA signature from the validator
     */
    function submitCheckpoint(
        uint256 startBlock,
        uint256 endBlock,
        bytes32 receiptsRoot,
        bytes calldata signature
    ) external {
        if (endBlock <= startBlock) revert InvalidCheckpointRange();

        // Reconstruct the message hash that was signed
        bytes32 messageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encode(startBlock, endBlock, receiptsRoot, block.chainid))
            )
        );

        // Verify signature
        address signer = recoverSigner(messageHash, signature);
        if (signer != raylsValidator) revert InvalidSignature();

        // Store checkpoint
        checkpoints.push(
            Checkpoint({
                startBlock: startBlock,
                endBlock: endBlock,
                receiptsRoot: receiptsRoot,
                timestamp: block.timestamp
            })
        );

        emit NewCheckpoint(
            checkpoints.length - 1,
            startBlock,
            endBlock,
            receiptsRoot,
            block.timestamp
        );
    }

    /**
     * @notice Verify and execute a message from Rayls (Polygon exit-style)
     * @param checkpointNumber Checkpoint number to verify against
     * @param messageId Message ID from the RaylsMessage event
     * @param message Original message content
     * @param sender Original sender address
     * @param raylsBlock Block number where message was emitted
     * @param merkleProof Merkle proof for the receipt
     */
    function verifyAndExecuteMessage(
        uint256 checkpointNumber,
        bytes32 messageId,
        string calldata message,
        address sender,
        uint256 raylsBlock,
        bytes32[] calldata merkleProof
    ) external {
        if (checkpointNumber >= checkpoints.length) revert CheckpointNotFound();
        if (verifiedMessages[messageId]) revert MessageAlreadyVerified();

        Checkpoint memory cp = checkpoints[checkpointNumber];

        // Check challenge window (Rayls magic - <60s possible due to sub-second finality)
        if (block.timestamp >= cp.timestamp + CHALLENGE_WINDOW) revert ChallengeWindowClosed();

        // Verify the message is within checkpoint range
        require(
            raylsBlock >= cp.startBlock && raylsBlock <= cp.endBlock,
            "Block not in checkpoint range"
        );

        // Compute leaf hash (simplified - production would use RLP-encoded receipt)
        bytes32 leaf = keccak256(abi.encode(sender, message, raylsBlock, messageId));

        // Verify Merkle proof
        if (!verifyMerkleProof(merkleProof, cp.receiptsRoot, leaf)) revert InvalidMerkleProof();

        // Mark as verified
        verifiedMessages[messageId] = true;

        emit MessageVerifiedFromRayls(messageId, message, sender, checkpointNumber);
    }

    /**
     * @notice Update validator address (only current validator can update)
     * @param newValidator New validator address
     */
    function updateValidator(address newValidator) external {
        if (msg.sender != raylsValidator) revert UnauthorizedValidator();
        require(newValidator != address(0), "Invalid validator");

        address oldValidator = raylsValidator;
        raylsValidator = newValidator;

        emit ValidatorUpdated(oldValidator, newValidator);
    }

    /**
     * @notice Get total number of checkpoints
     * @return Total checkpoint count
     */
    function getCheckpointCount() external view returns (uint256) {
        return checkpoints.length;
    }

    /**
     * @notice Get checkpoint by number
     * @param checkpointNumber Checkpoint index
     * @return Checkpoint data
     */
    function getCheckpoint(uint256 checkpointNumber) external view returns (Checkpoint memory) {
        if (checkpointNumber >= checkpoints.length) revert CheckpointNotFound();
        return checkpoints[checkpointNumber];
    }

    /**
     * @notice Get contract version
     * @return Version string
     */
    function version() external pure returns (string memory) {
        return "1.0.0";
    }

    /**
     * @dev Recover signer from signature
     */
    function recoverSigner(bytes32 messageHash, bytes memory signature)
        internal
        pure
        returns (address)
    {
        require(signature.length == 65, "Invalid signature length");

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            r := mload(add(signature, 32))
            s := mload(add(signature, 64))
            v := byte(0, mload(add(signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        require(v == 27 || v == 28, "Invalid signature v value");

        return ecrecover(messageHash, v, r, s);
    }

    /**
     * @dev Verify Merkle proof
     */
    function verifyMerkleProof(
        bytes32[] memory proof,
        bytes32 root,
        bytes32 leaf
    ) internal pure returns (bool) {
        bytes32 computedHash = leaf;

        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }

        return computedHash == root;
    }
}
