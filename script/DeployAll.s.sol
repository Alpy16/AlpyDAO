// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {AlpyToken} from "src/AlpyToken.sol";
import {AlpyStaking} from "src/AlpyStaking.sol";
import {AlpyDAO} from "src/AlpyDAO.sol";

contract DeployAll is Script {
    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerKey);

        AlpyToken token = new AlpyToken();
        console2.log("AlpyToken deployed at:", address(token));

        AlpyStaking staking = new AlpyStaking(
            address(token),
            address(token),
            3e18,
            address(0) // temp DAO address
        );
        console2.log("AlpyStaking deployed at:", address(staking));

        AlpyDAO dao = new AlpyDAO(address(staking), 1 days);
        console2.log("AlpyDAO deployed at:", address(dao));

        staking.setDao(address(dao));

        token.approve(address(staking), 1000e18);
        staking.stakeTokens(1000e18);
        console2.log("Staked 1000 ALPY");

        vm.stopBroadcast();
    }
}
