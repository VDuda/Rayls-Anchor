// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../contracts/RaylsCheckpointEmitter.sol";

/**
 * @title DeployEmitter
 * @notice Deployment script for RaylsCheckpointEmitter on Rayls Devnet
 * @dev Run: forge script script/DeployEmitter.s.sol:DeployEmitter --rpc-url rayls --broadcast --private-key $PRIVATE_KEY
 */
contract DeployEmitter is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        RaylsCheckpointEmitter emitter = new RaylsCheckpointEmitter();

        console.log("==============================================");
        console.log("RaylsCheckpointEmitter deployed to:", address(emitter));
        console.log("Chain ID:", block.chainid);
        console.log("Deployer:", vm.addr(deployerPrivateKey));
        console.log("==============================================");

        vm.stopBroadcast();
    }
}
