// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract AlpyToken is ERC20 {
    constructor() ERC20("AlpyToken", "AT") {
        _mint(msg.sender, 1_000_000 ether);
    }
}
