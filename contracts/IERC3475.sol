// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;


interface IERC3475 {

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

    /**
     * @dev Returns the bond symbol and a list of uint256 parameters of a bond nonce.
      * — e.g. ["DEBIT-BUSD","1615584000",(3rd uint256)...].** Every bond contract can have their own list.
      * But the first uint256 in the list MUST be the UTC time code of the issuing time.
     */
    function infos(uint256 classId, uint256 nonceId) external view returns (uint256 startingDate, uint256 maturityDate, uint256 info3, uint256 info4, uint256 info5, uint256 info6);

    function transferFrom(address _from, address _to, uint256 classId, uint256 nonceId, uint256 _amount) external;

    function isRedeemable(uint256 classId, uint256 nonceId) external view returns (bool);

    function isApprovedFor(address account, address operator, uint256 classId, uint256 nonceId) external view returns (bool);

    /**
        @notice Enable or disable approval for a third party ("operator") to manage a given bond.
        @dev MUST emit the ApprovalFor event on success.
    */
    function setApprovalFor(address _operator, uint256[] calldata classIds, uint256[] calldata nonceIds, bool _approved) external;


    function batchIsApprovedFor(address account, address operator, uint256[] calldata classIds, uint256[] calldata nonceIds) external view returns (bool);

    /**
     * @dev Transfer of any number of bond types from an address to another.
     */
    function batchTransferFrom(address _from, address _to, uint256[] calldata classIds, uint256[] calldata nonceIds, uint256[] calldata _amount) external;

    /**
        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
        The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
        The `_from` argument MUST be the address of the holder whose balance is decreased.
        The `_to` argument MUST be the address of the recipient whose balance is increased.
        The `_classId` argument MUST be the classId of the token being transferred.
        The `_nonceId` argument MUST be the nonce of the token being transferred.
        The `_amount` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
    */
    event Transferred(address indexed _operator, address indexed _from, address indexed _to, uint256 classId, uint256 nonceId, uint256 _amount);

    event Redeemed(address indexed _operator, address indexed _from, uint256 classId, uint256 nonceId, uint256 _amount);

    event Burned(address indexed _operator, address indexed _from, uint256 classId, uint256 nonceId, uint256 _amount);

    event Issued(address indexed _operator, address indexed _to, uint256 classId, uint256 nonceId, uint256 _amount);


    /**
        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
    */
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] classIds, uint256[] nonceIds, uint256[] _amounts);

    /**
        @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absence of an event assumes disabled).
    */
    event ApprovalFor(address indexed _owner, address indexed _operator, uint256[] classIds, uint256[] nonceIds, bool _approved);

}
