// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import ".././ERC3475.sol";

contract Bond is ERC3475 {

    function createBond(uint256 classId, address tokenAddress, string memory _symbol) external {
        createClass(classId, tokenAddress, _symbol);
    }

    function issueBonds(address to, uint256 classId, uint256 nonceId, uint256 amount) external {
        issue(to, classId, nonceId, amount);
    }

    function redeemBonds(address from, uint256 classId, uint256 nonceId, uint256 amount) external {
        redeem(from, classId, nonceId, amount);
    }
}
