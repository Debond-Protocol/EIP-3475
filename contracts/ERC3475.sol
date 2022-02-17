// SPDX-License-Identifier: MIT


pragma solidity ^0.8.0;

import "./IERC3475.sol";

contract ERC3475 is IERC3475 {

    struct InfoDescription {
        uint256 info2;
        uint256 info3;
        uint256 info4;
        uint256 info5;
    }

    struct Nonce {
        uint256 nonceId;
        bool exists;
        uint256 _activeSupply;
        uint256 _burnedSupply;
        uint256 _redeemedSupply;
        uint256 startingTimestamp;
        uint256 maturityTimestamp;
        InfoDescription infoDescription;
        mapping(address => uint256) balances;
        mapping(address => mapping(address => bool)) operatorApprovals;
    }

    struct Class{
        uint256 classId;
        bool exists;
        string symbol;
        uint256[] nonceIds;
        mapping(uint256 => Nonce) nonces; // from nonceId given
    }

    mapping(uint256 => Class) internal classes; // from classId given
    uint256[] public classIdsArray;

    function getClasses() public view returns (uint256[] memory) {
        return classIdsArray;
    }

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

    function balanceOf(address account, uint256 classId, uint256 nonceId) public override view returns (uint256){
        require(account != address(0), "ERC3475: balance query for the zero address");

        return classes[classId].nonces[nonceId].balances[account];
    }

    function symbol(uint256 classId) view public override returns (string memory){
        return classes[classId].symbol;
    }

    function infos(uint256 classId, uint256 nonceId) public view override returns (string memory _symbol, uint256 _startingTimestamp, uint256 _maturityTimestamp, uint256 _info2, uint256 _info3, uint256 _info4, uint256 _info5) {
        Class storage class = classes[classId];
        InfoDescription storage desc = class.nonces[nonceId].infoDescription;
        _symbol = class.symbol;
        _startingTimestamp = class.nonces[nonceId].startingTimestamp;
        _maturityTimestamp = class.nonces[nonceId].maturityTimestamp;
        _info2 = desc.info2;
        _info3 = desc.info3;
        _info4 = desc.info4;
        _info5 = desc.info5;
    }

    function isApprovedFor(address account, address operator, uint256 classId, uint256 nonceId) public view virtual override returns (bool) {
        return classes[classId].nonces[nonceId].operatorApprovals[account][operator];
    }

    function setApprovalFor(address operator, uint256[] memory classIds, uint256[] memory nonceIds, bool approved) public virtual override {
        require(classIds.length == nonceIds.length, "ERC3475: _classes and _nonces length mismatch");
        for (uint i = 0; i < classIds.length; i++) {
            classes[classIds[i]].nonces[nonceIds[i]].operatorApprovals[msg.sender][operator] = approved;
        }
    }

    function transferFrom(address from, address to, uint256 classId, uint256 nonceId, uint256 amount) public virtual override {
        require(msg.sender == from || isApprovedFor(from, msg.sender, classId, nonceId), "ERC3475: caller is not owner nor approved");
        _transferFrom(from, to, classId, nonceId, amount);
    }

    function batchTransferFrom(address from, address to, uint256[] memory classIds, uint256[] memory nonceIds, uint256[] memory amounts) public virtual override {
        require(msg.sender == from || batchIsApprovedFor(from, msg.sender, classIds, nonceIds), "ERC3475: caller is not owner nor approved");
        _batchTransferFrom(from, to, classIds, nonceIds, amounts);
        emit TransferBatch(msg.sender, from, to, classIds, nonceIds, amounts);
    }

    function batchIsApprovedFor(address account, address operator, uint256[] memory classIds, uint256[] memory nonceIds) public view virtual override returns (bool) {
        require(classIds.length == nonceIds.length, "ERC3475: _classes and _nonces length mismatch");
        for (uint i = 0; i < classIds.length; i++) {
            if (!classes[classIds[i]].nonces[nonceIds[i]].operatorApprovals[account][operator]) {
                return false;
            }
        }
        return true;
    }

    function getNonces(uint256 classId) public view returns (uint256[] memory) {
        return classes[classId].nonceIds;
    }

    function issue(address to, uint256 classId, uint256 nonceId, uint256 amount) public virtual override {
        require(classes[classId].exists && classes[classId].nonces[nonceId].exists, "ERC3475: only issue bond that has been created");
        require(to != address(0), "ERC3475: can't transfer to the zero address");
        _issue(to, classId, nonceId, amount);
        emit Issue(msg.sender, to, classId, nonceId, amount);
    }

    function isRedeemable(uint256 _classId, uint256 _nonceId) public override view returns (bool) {
        return classes[_classId].nonces[_nonceId].maturityTimestamp <= block.timestamp;
    }

    function redeem(address from, uint256 classId, uint256 nonceId, uint256 amount) public virtual override {
        require(from != address(0), "ERC3475: can't transfer to the zero address");
        require(isRedeemable(classId, nonceId));
        _redeem(from, classId, nonceId, amount);
        emit Redeem(msg.sender, from, classId, nonceId, amount);
    }

    function burn(address from, uint256 classId, uint256 nonceId, uint256 amount) public virtual override {
        require(from != address(0), "ERC3475: can't transfer to the zero address");
        _burn(from, classId, nonceId, amount);
        emit Burn(msg.sender, from, classId, nonceId, amount);
    }

    function create(uint256 classId, string memory _symbol, uint256 startingTimestamp, uint256 maturityTimestamp) internal virtual {
        require(!classes[classId].exists, "cannot create new bond given class already exists");
        Class storage class = classes[classId];
        class.classId = classId;
        class.exists = true;
        class.symbol = _symbol;
        classIdsArray.push(classId);
        uint256 nonceId = class.nonceIds.length;

        Nonce storage nonce = class.nonces[nonceId];
        nonce.nonceId = nonceId;
        nonce.exists = true;
        nonce.startingTimestamp = startingTimestamp;
        nonce.maturityTimestamp = maturityTimestamp;
        uint256[] storage nonceIds = class.nonceIds;
        nonceIds.push(nonceId);
    }

    function _transferFrom(address from, address to, uint256 classId, uint256 nonceId, uint256 amount) private {
        require(from != address(0), "ERC3475: can't transfer from the zero address");
        require(to != address(0), "ERC3475: can't transfer to the zero address");
        require(classes[classId].nonces[nonceId].balances[from] >= amount, "ERC3475: not enough bond to transfer");
        _transfer(from, to, classId, nonceId, amount);
        emit Transfer(msg.sender, from, to, classId, nonceId, amount);
    }

    function _batchTransferFrom(address from, address to, uint256[] memory classIds, uint256[] memory nonceIds, uint256[] memory amounts) private {
        require(classIds.length == nonceIds.length && classIds.length == amounts.length , "ERC3475: classes, nonces and amounts length mismatch");
        require(from != address(0), "ERC3475: can't transfer from the zero address");
        require(to != address(0), "ERC3475: can't transfer to the zero address");
        for (uint i = 0; i < nonceIds.length; i++) {
            require(classes[classIds[i]].nonces[nonceIds[i]].balances[from] >= amounts[i], "ERC3475: not enough bond to transfer");
            _transfer(from, to, classIds[i], nonceIds[i], amounts[i]);
        }
        emit TransferBatch(msg.sender, from, to, classIds, nonceIds, amounts);
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
