// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;


interface IERC3475 {

    // WRITE

    function transferFrom(address _from, address _to, uint256 classId, uint256 nonceId, uint256 _amount) external;

    function issue(address to, uint256 classId, uint256 nonceId, uint256 amount) external;

    function redeem(address _from, uint256 classId, uint256 nonceId, uint256 _amount) external;

    function burn(address _from, uint256 classId, uint256 nonceId, uint256 _amount) external;

    function approve(address spender, uint256 classId, uint256 nonceId, uint256 amount) external;

    function setApprovalFor(address operator, uint256[] calldata classIds, bool _approved) external;

    function batchApprove(address spender, uint256[] calldata classIds, uint256[] calldata nonceIds, uint256[] calldata amounts) external;

    function batchTransferFrom(address _from, address _to, uint256[] calldata classIds, uint256[] calldata nonceIds, uint256[] calldata _amount) external;


    // READ

    /**
     * @dev Returns the total supply of the bond in question
     */
    function totalSupply(uint256 classId, uint256 nonceId) external view returns (uint256);

    /**
     * @dev Returns the redeemed supply of the bond in question
     */
    function redeemedSupply(uint256 classId, uint256 nonceId) external view returns (uint256);

    /**
     * @dev Returns the active supply of the bond in question
     */
    function activeSupply(uint256 classId, uint256 nonceId) external view returns (uint256);

    /**
     * @dev Returns the burned supply of the bond in question
     */
    function burnedSupply(uint256 classId, uint256 nonceId) external view returns (uint256);

    /**
     * @dev Returns the balance of the giving bond classId and bond nonce
     */
    function balanceOf(address account, uint256 classId, uint256 nonceId) external view returns (uint256);


    function symbol(uint256 classId) external view returns (string memory);

    function infos(uint256 classId, uint256 nonceId) external view returns (uint256[]);

    function isRedeemable(uint256 classId, uint256 nonceId) external view returns (bool);

    function allowance(address owner, address spender, uint256 classId, uint256 nonceId) external view returns (uint256);

    function isApprovedFor(address account, address operator, uint256 classId) external view returns (bool);

    function batchIsApprovedFor(address account, address operator, uint256[] calldata classIds, uint256[] calldata nonceIds) external view returns (bool);

    event Transfer(address indexed _operator, address indexed _from, address indexed _to, uint256 classId, uint256 nonceId, uint256 _amount);

    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] classIds, uint256[] nonceIds, uint256[] _amounts);

    event ApprovalFor(address indexed _owner, address indexed _operator, uint256[] classIds, bool _approved);

}
