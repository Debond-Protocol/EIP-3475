// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./IERC3475.sol";

contract ERC3475 is IERC3475 {

    /**
    * @notice this Struct is representing the Nonce properties as an object
    *         and can be retrieve by the nonceId (within a class)
    */
    struct Nonce {
        uint256 nonceId;
        bool exists;
        uint256 _activeSupply;
        uint256 _burnedSupply;
        uint256 _redeemedSupply;
        uint256[] values; // here in this implementation we have for each nonce an array of 2 values: Issuance Date, Maturity Date
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
    }

    /**
    * @notice this Struct is representing the Class properties as an object
    *         and can be retrieve by the classId
    */
    struct Class {
        uint256 classId;
        bool exists;
        string symbol;
        uint256[] values; // here for each class we have an array of 2 values: debt token address and period of the bond (6 months or 12 months for example)
        string[] nonceDescriptions;
        mapping(address => mapping(address => bool)) operatorApprovals;
        mapping(uint256 => Nonce) nonces; // from nonceId given
    }

    mapping(uint256 => Class) internal classes; // from classId given
    string[] _classDescriptions;


    /**
    * @notice Here the constructor is just to initialize a class and nonce,
    *         in practice you will have a function to create new class and nonce
    */
    constructor() {
        _classDescriptions.push("Id of token Address");
        _classDescriptions.push("period of the class");
        // creating class
        Class storage class = classes[0];
        class.classId = 0;
        class.exists = true;
        class.symbol = "DBIT";
        class.values.push(1);
        class.values.push(180 * 24 * 3600);

        // creating nonce
        Nonce storage nonce = class.nonces[0];
        nonce.nonceId = 0;
        nonce.exists = true;
        nonce.values.push(block.timestamp); class.nonceDescriptions.push("Issuance Date");
        nonce.values.push(block.timestamp); class.nonceDescriptions.push("Maturity Date");
    }


    // WRITE


    function transferFrom(address from, address to, uint256 classId, uint256 nonceId, uint256 amount) public virtual override {
        require(msg.sender == from || isApprovedFor(from, msg.sender, classId), "ERC3475: caller is not owner nor approved");
        _transferFrom(from, to, classId, nonceId, amount);
        emit Transfer(msg.sender, from, to, classId, nonceId, amount);
    }


    function issue(address to, uint256 classId, uint256 nonceId, uint256 amount) external virtual override {
        require(classes[classId].exists, "ERC3475: only issue bond that has been created");
        Class storage class = classes[classId];

        Nonce storage nonce = class.nonces[nonceId];
        require(nonceId == nonce.nonceId, "Error ERC-3475: nonceId given not found!");

        require(to != address(0), "ERC3475: can't transfer to the zero address");
        _issue(to, classId, nonceId, amount);
        emit Issue(msg.sender, to, classId, nonceId, amount);
    }


    function redeem(address from, uint256 classId, uint256 nonceId, uint256 amount) external virtual override {
        require(from != address(0), "ERC3475: can't transfer to the zero address");
        (, uint256 progressRemaining) = getProgress(classId, nonceId);
        require(progressRemaining == 0, "ERC3475 Error: Not redeemable");
        _redeem(from, classId, nonceId, amount);
        emit Redeem(msg.sender, from, classId, nonceId, amount);
    }


    function burn(address from, uint256 classId, uint256 nonceId, uint256 amount) external virtual override {
        require(from != address(0), "ERC3475: can't transfer to the zero address");
        _burn(from, classId, nonceId, amount);
        emit Burn(msg.sender, from, classId, nonceId, amount);
    }


    function approve(address spender, uint256 classId, uint256 nonceId, uint256 amount) external virtual override {
        classes[classId].nonces[nonceId].allowances[msg.sender][spender] = amount;
    }


    function setApprovalFor(address operator, uint256 classId, bool approved) public virtual override {
        classes[classId].operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalFor(msg.sender, operator, classId, approved);
    }


    function batchApprove(address spender, uint256[] calldata classIds, uint256[] calldata nonceIds, uint256[] calldata amounts) external {
        require(classIds.length == nonceIds.length && classIds.length == amounts.length, "ERC3475 Input Error");
        for(uint256 i = 0; i < classIds.length; i++) {
            classes[classIds[i]].nonces[nonceIds[i]].allowances[msg.sender][spender] = amounts[i];
        }
    }
    // READS


    function totalSupply(uint256 classId, uint256 nonceId) public override view returns (uint256) {
        return classes[classId].nonces[nonceId]._activeSupply + classes[classId].nonces[nonceId]._redeemedSupply + classes[classId].nonces[nonceId]._burnedSupply;
    }


    function activeSupply(uint256 classId, uint256 nonceId) public override view returns (uint256) {
        return classes[classId].nonces[nonceId]._activeSupply;
    }


    function burnedSupply(uint256 classId, uint256 nonceId) public override view returns (uint256) {
        return classes[classId].nonces[nonceId]._burnedSupply;
    }


    function redeemedSupply(uint256 classId, uint256 nonceId) public override view returns (uint256) {
        return classes[classId].nonces[nonceId]._burnedSupply;
    }


    function balanceOf(address account, uint256 classId, uint256 nonceId) public override view returns (uint256) {
        require(account != address(0), "ERC3475: balance query for the zero address");

        return classes[classId].nonces[nonceId].balances[account];
    }


    function symbol(uint256 classId) public view override returns (string memory) {
        Class storage class = classes[classId];
        return class.symbol;
    }

    
    function classValues(uint256 classId) public view override returns (uint256[] memory) {
        return classes[classId].values;
    }

    function classDescriptions() external view returns (string[] memory) {
        return _classDescriptions;
    }
    
    function nonceValues(uint256 classId, uint256 nonceId) public view override returns (uint256[] memory) {
        return classes[classId].nonces[nonceId].values;
    }

    function nonceDescriptions(uint256 classId) external view returns (string[] memory) {
        return classes[classId].nonceDescriptions;
    }

    /**
     * @notice ProgressAchieved and progressRemaining is abstract, here for the example we are giving time passed and time remaining.
     */
    function getProgress(uint256 classId, uint256 nonceId) public override view returns (uint256 progressAchieved, uint256 progressRemaining) {
        uint256 issuanceDate = classes[classId].nonces[nonceId].values[0];
        uint256 maturityDate = classes[classId].nonces[nonceId].values[1];
        progressAchieved = block.timestamp > issuanceDate ? block.timestamp - issuanceDate : 0;
        progressRemaining = block.timestamp < maturityDate ? maturityDate - block.timestamp : 0;
    }


    function allowance(address owner, address spender, uint256 classId, uint256 nonceId) external view returns (uint256) {
        return classes[classId].nonces[nonceId].allowances[owner][spender];
    }


    function isApprovedFor(address owner, address operator, uint256 classId) public view virtual override returns (bool) {
        return classes[classId].operatorApprovals[owner][operator];
    }

    function _transferFrom(address from, address to, uint256 classId, uint256 nonceId, uint256 amount) private {
        require(from != address(0), "ERC3475: can't transfer from the zero address");
        require(to != address(0), "ERC3475: can't transfer to the zero address");
        require(classes[classId].nonces[nonceId].balances[from] >= amount, "ERC3475: not enough bond to transfer");
        _transfer(from, to, classId, nonceId, amount);
    }

    function _transfer(address from, address to, uint256 classId, uint256 nonceId, uint256 amount) private {
        require(from != to, "ERC3475: can't transfer to the same address");
        classes[classId].nonces[nonceId].balances[from]-= amount;
        classes[classId].nonces[nonceId].balances[to] += amount;
    }

    function _issue(address to, uint256 classId, uint256 nonceId, uint256 amount) private {
        classes[classId].nonces[nonceId].balances[to] += amount;
        classes[classId].nonces[nonceId]._activeSupply += amount;
    }

    function _redeem(address from, uint256 classId, uint256 nonceId, uint256 amount) private {
        require(classes[classId].nonces[nonceId].balances[from] >= amount);
        classes[classId].nonces[nonceId].balances[from] -= amount;
        classes[classId].nonces[nonceId]._activeSupply -= amount;
        classes[classId].nonces[nonceId]._redeemedSupply += amount;
    }

    function _burn(address from, uint256 classId, uint256 nonceId, uint256 amount) private {
        require(classes[classId].nonces[nonceId].balances[from] >= amount);
        classes[classId].nonces[nonceId].balances[from] -= amount;
        classes[classId].nonces[nonceId]._activeSupply -= amount;
        classes[classId].nonces[nonceId]._burnedSupply += amount;
    }

}
