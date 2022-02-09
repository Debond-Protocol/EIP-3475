// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./ERC3475.sol";

contract Bond is ERC3475 {

    constructor() {
        createBond(0, "SASH-USD", 0, block.timestamp, 1707333227);
    }
}
