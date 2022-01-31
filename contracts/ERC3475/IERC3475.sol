// SPDX-License-Identifier: MIT


pragma solidity ^0.6.8;


interface IERC3475 {

    /**
        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
        The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
        The `_from` argument MUST be the address of the holder whose balance is decreased.
        The `_to` argument MUST be the address of the recipient whose balance is increased.
        The `_id` argument MUST be the token type being transferred.
        The `_value` argument MUST be the number of tokens the holder balance is decreased by and match what the recipient balance is increased by.
        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
    */
    event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 class, uint256 nonce, uint256 _amount);


    /**
        @dev Either `TransferSingle` or `TransferBatch` MUST emit when tokens are transferred, including zero value transfers as well as minting or burning (see "Safe Transfer Rules" section of the standard).
        The `_operator` argument MUST be the address of an account/contract that is approved to make the transfer (SHOULD be msg.sender).
        The `_from` argument MUST be the address of the holder whose balance is decreased.
        The `_to` argument MUST be the address of the recipient whose balance is increased.
        The `_ids` argument MUST be the list of tokens being transferred.
        The `_values` argument MUST be the list of number of tokens (matching the list and order of tokens specified in _ids) the holder balance is decreased by and match what the recipient balance is increased by.
        When minting/creating tokens, the `_from` argument MUST be set to `0x0` (i.e. zero address).
        When burning/destroying tokens, the `_to` argument MUST be set to `0x0` (i.e. zero address).
    */
    event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] class, uint256[] nonce, uint256[] _amount);

    /**
        @dev MUST emit when approval for a second party/operator address to manage all tokens for an owner address is enabled or disabled (absence of an event assumes disabled).
    */
    event ApprovalFor(address indexed _owner, address indexed _operator, uint256[] class, uint256[] nonce, bool _approved);

    /**
     * @dev Returns the total supply of the bond in question
     */
    function totalSupply(uint256 class, uint256 nonce) external view returns (uint256);

    /**
     * @dev Returns the active supply of the bond in question
     */
    function activeSupply(uint256 class, uint256 nonce) external view returns (uint256);

    /**
     * @dev Returns the burned supply of the bond in question
     */
    function burnedSupply(uint256 class, uint256 nonce) external view returns (uint256);

    /**
     * @dev Returns the redeemed supply of the bond in question
     */
    function redeemedSupply(uint256 class, uint256 nonce) external view returns (uint256);

    /**
     * @dev Returns the balance of the giving bond class and bond nonce
     */
    function balanceOf(address account, uint256 class, uint256 nonce) external view returns (uint256);

    /**
     * @dev Returns the symbol string of the bond class.
     * — e.g. bond symbol="DEBIT-BUSD bond".**DEBIT as the first half of the bond symbol represents the settlement token of the bond.
     * BUSD as the second half of the bond symbol represents the token used for the perches of this bond.
     * If the bond have more than one settlement token or buying token, the symbol should be "Token1,Token2-Token3,Token4 bond"
     */
    function symbol(uint256 class) external view returns (string memory);

    /**
     * @dev Returns the bond symbol and a list of uint256 parameters of a bond nonce.
      * — e.g. ["DEBIT-BUSD","1615584000",(3rd uint256)...].** Every bond contract can have their own list.
      * But the first uint256 in the list MUST be the UTC time code of the issuing time.
     */
    function infos(uint256 class, uint256 nonce) external view returns (string memory symbol, uint256 timestamp, uint256 info2, uint256 info3, uint256 info4, uint256 info5, uint256 info6);

    /**
     * @dev Returns "true" if the cited bond is redeemable. and "false"if is not.
     */
    function isRedeemable(uint256 class, uint256 nonce) external view returns (bool);

    function transferFrom(address _from, address _to, uint256 _class, uint256 _nonce, uint256 _amount) external;

    function isApprovedFor(address account, address operator, uint256 _class, uint256 _nonce) public view virtual override returns (bool);

    function batchIsApprovedFor(address account, address operator, uint256[] calldata _classes, uint256[] calldata _nonces) public view returns (bool);

    /**
     * @dev Transfer of any number of bond types from an address to another.
     */
    function batchTransferFrom(address _from, address _to, uint256[] calldata classes, uint256[] calldata nonces, uint256[] calldata _amount) external;

    /**
        @notice Enable or disable approval for a third party ("operator") to manage a given bond.
        @dev MUST emit the ApprovalFor event on success.
        @param _operator  Address to add to the set of authorized operators
        @param _class  class of bond
        @param _nonce  nonce of class bond
        @param _approved  True if the operator is approved, false to revoke approval
    */
    function setApprovalFor(address _operator, uint256[] calldata classes, uint256[] calldata nonces, bool _approved) external;

}
