// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title RaylsCheckpointEmitter
 * @notice Emits messages from Rayls Public Chain to be verified on Ethereum
 * @dev Deployed on Rayls Devnet (Chain ID: 123123)
 * Part of the Rayls Anchor checkpoint bridge system
 */
contract RaylsCheckpointEmitter {
    /// @notice Emitted when a message is sent to Ethereum
    event RaylsMessage(
        address indexed sender,
        string message,
        uint256 raylsBlock,
        bytes32 indexed messageId
    );

    /// @notice Total messages sent
    uint256 public messageCount;

    /**
     * @notice Send a message from Rayls to Ethereum
     * @param message The message content to send
     * @dev Emits RaylsMessage event that will be checkpointed and verified on Ethereum
     */
    function sendToEthereum(string calldata message) external {
        bytes32 id = keccak256(abi.encode(msg.sender, message, block.number, messageCount));
        messageCount++;
        emit RaylsMessage(msg.sender, message, block.number, id);
    }

    /**
     * @notice Get contract version
     * @return Version string
     */
    function version() external pure returns (string memory) {
        return "1.0.0";
    }
}
