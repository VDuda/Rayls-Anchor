// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../contracts/RaylsRootChain.sol";

contract RaylsRootChainTest is Test {
    RaylsRootChain public rootChain;
    address public validator = address(0x1);
    uint256 public validatorKey = 0x1;
    address public user = address(0x2);

    event NewCheckpoint(
        uint256 indexed checkpointNumber,
        uint256 startBlock,
        uint256 endBlock,
        bytes32 receiptsRoot,
        uint256 timestamp
    );

    event MessageVerifiedFromRayls(
        bytes32 indexed messageId,
        string message,
        address sender,
        uint256 checkpointNumber
    );

    function setUp() public {
        rootChain = new RaylsRootChain(validator);
    }

    function testSubmitCheckpoint() public {
        uint256 startBlock = 100;
        uint256 endBlock = 110;
        bytes32 receiptsRoot = keccak256("test_root");

        // Create signature
        bytes32 messageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encode(startBlock, endBlock, receiptsRoot, block.chainid))
            )
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(validatorKey, messageHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.expectEmit(true, false, false, true);
        emit NewCheckpoint(0, startBlock, endBlock, receiptsRoot, block.timestamp);

        rootChain.submitCheckpoint(startBlock, endBlock, receiptsRoot, signature);

        assertEq(rootChain.getCheckpointCount(), 1);
    }

    function testSubmitCheckpointInvalidRange() public {
        uint256 startBlock = 110;
        uint256 endBlock = 100;
        bytes32 receiptsRoot = keccak256("test_root");

        bytes32 messageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encode(startBlock, endBlock, receiptsRoot, block.chainid))
            )
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(validatorKey, messageHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.expectRevert(RaylsRootChain.InvalidCheckpointRange.selector);
        rootChain.submitCheckpoint(startBlock, endBlock, receiptsRoot, signature);
    }

    function testSubmitCheckpointInvalidSignature() public {
        uint256 startBlock = 100;
        uint256 endBlock = 110;
        bytes32 receiptsRoot = keccak256("test_root");

        // Sign with wrong key
        uint256 wrongKey = 0x999;
        bytes32 messageHash = keccak256(
            abi.encodePacked(
                "\x19Ethereum Signed Message:\n32",
                keccak256(abi.encode(startBlock, endBlock, receiptsRoot, block.chainid))
            )
        );

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(wrongKey, messageHash);
        bytes memory signature = abi.encodePacked(r, s, v);

        vm.expectRevert(RaylsRootChain.InvalidSignature.selector);
        rootChain.submitCheckpoint(startBlock, endBlock, receiptsRoot, signature);
    }

    function testUpdateValidator() public {
        address newValidator = address(0x3);

        vm.prank(validator);
        rootChain.updateValidator(newValidator);

        assertEq(rootChain.raylsValidator(), newValidator);
    }

    function testUpdateValidatorUnauthorized() public {
        address newValidator = address(0x3);

        vm.prank(user);
        vm.expectRevert(RaylsRootChain.UnauthorizedValidator.selector);
        rootChain.updateValidator(newValidator);
    }

    function testVersion() public {
        assertEq(rootChain.version(), "1.0.0");
    }

    function testChallengeWindow() public {
        assertEq(rootChain.CHALLENGE_WINDOW(), 60);
    }
}
