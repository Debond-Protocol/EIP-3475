// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import ".././ERC3475.sol";

contract Bond is ERC3475 {

    function createBond(uint256 classId, uint256 nonceId, string memory _symbol, uint256 startingTimestamp, uint256 maturityTimestamp) external {
        create(classId, nonceId, _symbol, startingTimestamp, maturityTimestamp);
    }
}
