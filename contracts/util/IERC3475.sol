// SPDX-License-Identifier: MIT


pragma solidity ^0.6.8;


interface IERC3475 {

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
    function getBondSymbol(uint256 class) external view returns (string memory);

    /**
     * @dev Returns the bond symbol and a list of uint256 parameters of a bond nonce.
      * — e.g. ["DEBIT-BUSD","1615584000",(3rd uint256)...].** Every bond contract can have their own list.
      * But the first uint256 in the list MUST be the UTC time code of the issuing time.
     */
    function getBondInfo(uint256 class, uint256 nonce) external view returns (string memory bondSymbol, uint256 timestamp, uint256 info2, uint256 info3, uint256 info4, uint256 info5, uint256 info6);

    /**
     * @dev Returns "true" if the cited bond is redeemable. and "false"if is not.
     */
    function bondIsRedeemable(uint256 class, uint256 nonce) external view returns (bool);





    /**
     * @dev Issuing any number of bond types to an address.
     * !! The calling of this function needs to be restricted to bond issuer contract !!
     */
    function issueBond(address _to, uint256 class, uint256 _amount) external;

    /**
     * @dev Redemption of any number of bond types from an address.
     */
    function redeemBond(address _from, uint256 class, uint256[] calldata nonce, uint256[] calldata _amount) external;

    /**
     * @dev Transfer of any number of bond types from an address to another.
     */
    function transferBond(address _from, address _to, uint256[] calldata class, uint256[] calldata nonce, uint256[] calldata _amount) external;

    function burnBond(address _from, uint256[] calldata class, uint256[] calldata nonce, uint256[] calldata _amount) external;

    event eventIssueBond(address _operator, address _to, uint256 class, uint256 nonce, uint256 _amount);
    event eventRedeemBond(address _operator, address _from, uint256 class, uint256 nonce, uint256 _amount);
    event eventBurnBond(address _operator, address _from, uint256 class, uint256 nonce, uint256 _amount);
    event eventTransferBond(address _operator, address _from, address _to, uint256 class, uint256 nonce, uint256 _amount);

}
