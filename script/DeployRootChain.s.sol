// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../contracts/RaylsRootChain.sol";

/**
 * @title DeployRootChain
 * @notice Deployment script for RaylsRootChain on Ethereum Sepolia
 * @dev Run: forge script script/DeployRootChain.s.sol:DeployRootChain --rpc-url sepolia --broadcast --private-key $PRIVATE_KEY
 */
contract DeployRootChain is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address validator = vm.envAddress("VALIDATOR_ADDRESS");

        vm.startBroadcast(deployerPrivateKey);

        RaylsRootChain rootChain = new RaylsRootChain(validator);

        console.log("==============================================");
        console.log("RaylsRootChain deployed to:", address(rootChain));
        console.log("Chain ID:", block.chainid);
        console.log("Validator:", validator);
        console.log("Deployer:", vm.addr(deployerPrivateKey));
        console.log("Challenge Window:", rootChain.CHALLENGE_WINDOW(), "seconds");
        console.log("==============================================");

        vm.stopBroadcast();
    }
}
