// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../contracts/RaylsCheckpointEmitter.sol";

contract RaylsCheckpointEmitterTest is Test {
    RaylsCheckpointEmitter public emitter;
    address public user = address(0x1);

    event RaylsMessage(
        address indexed sender,
        string message,
        uint256 raylsBlock,
        bytes32 indexed messageId
    );

    function setUp() public {
        emitter = new RaylsCheckpointEmitter();
    }

    function testSendToEthereum() public {
        string memory message = "Test message from Rayls";

        vm.prank(user);
        vm.expectEmit(true, true, false, true);
        
        bytes32 expectedId = keccak256(abi.encode(user, message, block.number, 0));
        emit RaylsMessage(user, message, block.number, expectedId);

        emitter.sendToEthereum(message);

        assertEq(emitter.messageCount(), 1);
    }

    function testMultipleMessages() public {
        vm.startPrank(user);
        
        emitter.sendToEthereum("Message 1");
        emitter.sendToEthereum("Message 2");
        emitter.sendToEthereum("Message 3");

        vm.stopPrank();

        assertEq(emitter.messageCount(), 3);
    }

    function testVersion() public {
        assertEq(emitter.version(), "1.0.0");
    }
}
