// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./ERC3475.sol";

contract Bond is ERC3475 {

    constructor() {
        create(0, "SASH-USD", block.timestamp, 1707333227);
    }
}
