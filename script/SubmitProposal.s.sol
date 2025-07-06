// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {AlpyDAO} from "src/AlpyDAO.sol";
import {AlpyStaking} from "src/AlpyStaking.sol";

contract SubmitProposal is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(pk);

        AlpyDAO dao = AlpyDAO(0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0);
        AlpyStaking staking = AlpyStaking(0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512);

        dao.createProposal(
            address(staking),
            0,
            abi.encodeWithSignature("setRewardRate(uint256)", 5e18),
            "Change reward rate to 5 ALPY/sec"
        );

        vm.stopBroadcast();
    }
}
