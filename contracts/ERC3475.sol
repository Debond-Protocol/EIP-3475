// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

import "./IERC3475.sol";

contract ERC3475 is IERC3475 {
    /**
     * @notice this Struct is representing the Nonce properties as an object
     */
    struct Nonce {
        mapping(uint256 => IERC3475.Values) _values;

        // stores the values corresponding to the dates (issuance and maturity date).
        mapping(address => uint256) _balances;
        mapping(address => mapping(address => uint256)) _allowances;

        // supplies of this nonce
        uint256 _activeSupply;
        uint256 _burnedSupply;
        uint256 _redeemedSupply;
    }

    /**
     * @notice this Struct is representing the Class properties as an object
     *         and can be retrieved by the classId
     */
    struct Class {
        mapping(string => IERC3475.Values) _values;
        mapping(uint256 => IERC3475.Metadata) _nonceMetadatas;
        mapping(uint256 => Nonce) _nonces;
    }

    mapping(address => mapping(address => bool)) _operatorApprovals;

    // from classId given
    mapping(uint256 => Class) internal _classes;
    mapping(uint256 => IERC3475.Metadata) _classMetadata;

    /**
     * @notice Here the constructor is just to initialize a class and nonce,
     * in practice, you will have a function to create a new class and nonce
     * to be deployed during the initial deployment cycle
     */
    constructor() {
        // define metadata of the class 1";
        _classes[1]._values["symbol"].stringValue = "A55 1Y BRL Liquidity Flow Bond";
        _classes[1]._values["category"].stringValue = "security";
        _classes[1]._values["subcategory"].stringValue = "bond";
        _classes[1]._values["childCategory"].stringValue = "coupon callable bond";
        
        _classes[1]._values["description"].stringValue = "Pledge of future economic rights resulting from a commercial contract between the borrower and its drawee with or without escrow; ";
        _classes[1]._values["issuerName"].stringValue = "A55";
        _classes[1]._values["issuerType"].stringValue = "LTD";
        _classes[1]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[1]._values["issuerRegistrationAddress"].stringValue = "Rodovia Admar Gonzaga, 4405 andar - Itacorubi";
        _classes[1]._values["issuerURL"].stringValue = "https://www.a55.tech/";
        _classes[1]._values["issuerLogo"].stringValue = "https://github.com/Debond-Protocol/EIP-3475/blob/main/test/media/8e36abff206b20109afb8e9f1c2e7572.png";
        _classes[1]._values["issuerRegistrationNumber"].stringValue = "BR-000000000000";
        _classes[1]._values["issuerDocURL"].stringArryValue = [
            "https://github.com/Debond-Protocol/EIP-3475/blob/main/test/media/a55.pptx.pdf"
        ];  
        _classes[1]._values["ISIN"].stringValue = "BR-000402625-0";  
        _classes[1]._values["fundType"].stringValue = "corporate";  
        _classes[1]._values["riskLevel"].stringValue = "AAA";  
        _classes[1]._values["intendedDate"].stringValue = "1676038570";  
        _classes[1]._values["shareValue"].uintValue = 100000000;  
        _classes[1]._values["currency"].stringValue = "BRL";  
        _classes[1]._values["collateralAllowed"].stringArryValue = [
            "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
            "0x55d398326f99059ff775485246999027b3197955"
        ];  
        _classes[1]._values["callable"].boolValue = true;  
        _classes[1]._values["maturityPeriod"].uintValue = 31104000;  
        _classes[1]._values["coupon"].boolValue = true;  
        _classes[1]._values["couponRate"].uintValue = 5000;  
        _classes[1]._values["couponPeriod"].uintValue = 2592000;  
        _classes[1]._values["fixed-rate"].boolValue = true;  
        _classes[1]._values["APY"].uintValue = 60000;  

      // define metadata of the class 2";
        _classes[2]._values["symbol"].stringValue = "A55 1Y BRL Credit Card Bond";
        _classes[2]._values["category"].stringValue = "security";
        _classes[2]._values["subcategory"].stringValue = "bond";
        _classes[2]._values["childCategory"].stringValue = "coupon callable bond";
        
        _classes[2]._values["description"].stringValue = "Pledge of future economic rights resulting from a commercial contract between the borrower and its drawee with or without escrow; ";
        _classes[2]._values["issuerName"].stringValue = "A55";
        _classes[2]._values["issuerType"].stringValue = "LTD";
        _classes[2]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[2]._values["issuerRegistrationAddress"].stringValue = "Rodovia Admar Gonzaga, 4405 andar - Itacorubi";
        _classes[2]._values["issuerURL"].stringValue = "https://www.a55.tech/";
        _classes[2]._values["issuerLogo"].stringValue = "https://github.com/Debond-Protocol/EIP-3475/blob/main/test/media/8e36abff206b20109afb8e9f1c2e7572.png";
        _classes[2]._values["issuerRegistrationNumber"].stringValue = "BR-000000000000";
        _classes[2]._values["issuerDocURL"].stringArryValue = [
            "https://github.com/Debond-Protocol/EIP-3475/blob/main/test/media/a55.pptx.pdf"
        ];  
        _classes[2]._values["ISIN"].stringValue = "BR-000402625-0";  
        _classes[2]._values["fundType"].stringValue = "corporate";  
        _classes[2]._values["riskLevel"].stringValue = "B";  
        _classes[2]._values["intendedDate"].stringValue = "1676038570";  
        _classes[2]._values["shareValue"].uintValue = 100000000;  
        _classes[2]._values["currency"].stringValue = "BRL";  
        _classes[2]._values["collateralAllowed"].stringArryValue = [
            "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
            "0x55d398326f99059ff775485246999027b3197955"
        ];  
        _classes[2]._values["callable"].boolValue = true;  
        _classes[2]._values["maturityPeriod"].uintValue = 31104000;  
        _classes[2]._values["coupon"].boolValue = true;  
        _classes[2]._values["couponRate"].uintValue = 20000;  
        _classes[2]._values["couponPeriod"].uintValue = 2592000;  
        _classes[2]._values["fixed-rate"].boolValue = true;  
        _classes[2]._values["APY"].uintValue = 240000;  

        // define metadata of the class 3";
        _classes[3]._values["symbol"].stringValue = "A55 1Y Crypto Bond";
        _classes[3]._values["category"].stringValue = "security";
        _classes[3]._values["subcategory"].stringValue = "bond";
        _classes[3]._values["childCategory"].stringValue = "coupon callable bond";
        
        _classes[3]._values["description"].stringValue = "Pledge of future economic rights resulting from a commercial contract between the borrower and its drawee with or without escrow; ";
        _classes[3]._values["issuerName"].stringValue = "A55";
        _classes[3]._values["issuerType"].stringValue = "LTD";
        _classes[3]._values["issuerJurisdiction"].stringValue = "BR";
        _classes[3]._values["issuerRegistrationAddress"].stringValue = "Rodovia Admar Gonzaga, 4405 andar - Itacorubi";
        _classes[3]._values["issuerURL"].stringValue = "https://www.a55.tech/";
        _classes[3]._values["issuerLogo"].stringValue = "https://github.com/Debond-Protocol/EIP-3475/blob/main/test/media/8e36abff206b20109afb8e9f1c2e7572.png";
        _classes[3]._values["issuerRegistrationNumber"].stringValue = "BR-000000000000";
        _classes[3]._values["issuerDocURL"].stringArryValue = [
            "https://github.com/Debond-Protocol/EIP-3475/blob/main/test/media/a55.pptx.pdf"
        ];  
        _classes[3]._values["ISIN"].stringValue = "BR-000402625-0";  
        _classes[3]._values["fundType"].stringValue = "corporate";  
        _classes[3]._values["riskLevel"].stringValue = "CC";  
        _classes[3]._values["intendedDate"].stringValue = "1676038570";  
        _classes[3]._values["shareValue"].uintValue = 100000000;  
        _classes[3]._values["currency"].stringValue = "BRL";  
        _classes[3]._values["collateralAllowed"].stringArryValue = [
            "0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d",
            "0x55d398326f99059ff775485246999027b3197955"
        ];  
        _classes[3]._values["callable"].boolValue = true;  
        _classes[3]._values["maturityPeriod"].uintValue = 31104000;  
        _classes[3]._values["coupon"].boolValue = true;  
        _classes[3]._values["couponRate"].uintValue = 50000;  
        _classes[3]._values["couponPeriod"].uintValue = 2592000;  
        _classes[3]._values["fixed-rate"].boolValue = true;  
        _classes[3]._values["APY"].uintValue = 600000;  
      
        }

    // WRITABLES
    function transferFrom(
        address _from,
        address _to,
        Transaction[] calldata _transactions
    ) public virtual override {
        require(
            _from != address(0),
            "ERC3475: can't transfer from the zero address"
        );
        require(
            _to != address(0),
            "ERC3475:use burn() instead"
        );
        require(
            msg.sender == _from ||
            isApprovedFor(_from, msg.sender),
            "ERC3475:caller-not-owner-or-approved"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            _transferFrom(_from, _to, _transactions[i]);
        }
        emit Transfer(msg.sender, _from, _to, _transactions);
    }

    function transferAllowanceFrom(
        address _from,
        address _to,
        Transaction[] calldata _transactions
    ) public virtual override {
        require(
            _from != address(0),
            "ERC3475: can't transfer allowed amt from zero address"
        );
        require(
            _to != address(0),
            "ERC3475: use burn() instead"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            require(
                _transactions[i].amount <= allowance(_from, msg.sender, _transactions[i].classId, _transactions[i].nonceId),
                "ERC3475:caller-not-owner-or-approved"
            );
            _transferAllowanceFrom(msg.sender, _from, _to, _transactions[i]);
        }
        emit Transfer(msg.sender, _from, _to, _transactions);
    }

    function issue(address _to, Transaction[] calldata _transactions)
    external
    virtual
    override
    {
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            require(
                _to != address(0),
                "ERC3475: can't issue to the zero address"
            );
            _issue(_to, _transactions[i]);
        }
        emit Issue(msg.sender, _to, _transactions);
    }

    function redeem(address _from, Transaction[] calldata _transactions)
    external
    virtual
    override
    {
        require(
            _from != address(0),
            "ERC3475: can't redeem from the zero address"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            (, uint256 progressRemaining) = getProgress(
                _transactions[i].classId,
                _transactions[i].nonceId
            );
            require(
                progressRemaining == 0,
                "ERC3475 Error: Not redeemable"
            );
            _redeem(_from, _transactions[i]);
        }
        emit Redeem(msg.sender, _from, _transactions);
    }

    function burn(address _from, Transaction[] calldata _transactions)
    external
    virtual
    override
    {
        require(
            _from != address(0),
            "ERC3475: can't burn from the zero address"
        );
        require(
            msg.sender == _from ||
            isApprovedFor(_from, msg.sender),
            "ERC3475: caller-not-owner-or-approved"
        );
        uint256 len = _transactions.length;
        for (uint256 i = 0; i < len; i++) {
            _burn(_from, _transactions[i]);
        }
        emit Burn(msg.sender, _from, _transactions);
    }

    function approve(address _spender, Transaction[] calldata _transactions)
    external
    virtual
    override
    {
        for (uint256 i = 0; i < _transactions.length; i++) {
            _classes[_transactions[i].classId]
            ._nonces[_transactions[i].nonceId]
            ._allowances[msg.sender][_spender] = _transactions[i].amount;
        }
    }

    function setApprovalFor(
        address operator,
        bool approved
    ) public virtual override {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalFor(msg.sender, operator, approved);
    }

    // READABLES
    function totalSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return (activeSupply(classId, nonceId) +
        burnedSupply(classId, nonceId) +
        redeemedSupply(classId, nonceId)
        );
    }

    function activeSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return _classes[classId]._nonces[nonceId]._activeSupply;
    }

    function burnedSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return _classes[classId]._nonces[nonceId]._burnedSupply;
    }

    function redeemedSupply(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256)
    {
        return _classes[classId]._nonces[nonceId]._redeemedSupply;
    }

    function balanceOf(
        address account,
        uint256 classId,
        uint256 nonceId
    ) public view override returns (uint256) {
        require(
            account != address(0),
            "ERC3475: balance query for the zero address"
        );
        return _classes[classId]._nonces[nonceId]._balances[account];
    }

    function classMetadata(uint256 metadataId)
    external
    view
    override
    returns (Metadata memory) {
        return (_classMetadata[metadataId]);
    }

    function nonceMetadata(uint256 classId, uint256 metadataId)
    external
    view
    override
    returns (Metadata memory) {
        return (_classes[classId]._nonceMetadatas[metadataId]);
    }

    function classValuesFromTitle(uint256 classId, string memory metadataTitle)
    external
    view
    override
    returns (Values memory) {
        return (_classes[classId]._values[metadataTitle]);
    }  

    function nonceValues(uint256 classId, uint256 nonceId, uint256 metadataId)
    external
    view
    override
    returns (Values memory) {
        return (_classes[classId]._nonces[nonceId]._values[metadataId]);
    }

    /** determines the progress till the  redemption of the bonds is valid  (based on the type of bonds class).
     * @notice ProgressAchieved and `progressRemaining` is abstract.
      For e.g. we are giving time passed and time remaining.
     */
    function getProgress(uint256 classId, uint256 nonceId)
    public
    view
    override
    returns (uint256 progressAchieved, uint256 progressRemaining){
        uint256 issuanceDate = _classes[classId]._nonces[nonceId]._values[0].uintValue;
        uint256 maturityDate = issuanceDate + _classes[classId]._nonces[nonceId]._values[5].uintValue;

        // check whether the bond is being already initialized:
        progressAchieved = block.timestamp - issuanceDate;
        progressRemaining = block.timestamp < maturityDate
        ? maturityDate - block.timestamp
        : 0;
    }
    /**
    gets the allowance of the bonds identified by (classId,nonceId) held by _owner to be spend by spender.
     */
    function allowance(
        address _owner,
        address spender,
        uint256 classId,
        uint256 nonceId
    ) public view virtual override returns (uint256) {
        return _classes[classId]._nonces[nonceId]._allowances[_owner][spender];
    }

    /**
    checks the status of approval to transfer the ownership of bonds by _owner  to operator.
     */
    function isApprovedFor(
        address _owner,
        address operator
    ) public view virtual override returns (bool) {
        return _operatorApprovals[_owner][operator];
    }

    // INTERNALS
    function _transferFrom(
        address _from,
        address _to,
        IERC3475.Transaction calldata _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        require(
            nonce._balances[_from] >= _transaction.amount,
            "ERC3475: not enough bond to transfer"
        );

        //transfer balance
        nonce._balances[_from] -= _transaction.amount;
        nonce._balances[_to] += _transaction.amount;
    }

    function _transferAllowanceFrom(
        address _operator,
        address _from,
        address _to,
        IERC3475.Transaction calldata _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        require(
            nonce._balances[_from] >= _transaction.amount,
            "ERC3475: not allowed amount"
        );
        // reducing the allowance and decreasing accordingly.
        nonce._allowances[_from][_operator] -= _transaction.amount;

        //transfer balance
        nonce._balances[_from] -= _transaction.amount;
        nonce._balances[_to] += _transaction.amount;
    }

    function _issue(
        address _to,
        IERC3475.Transaction calldata _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];

        //transfer balance
        nonce._balances[_to] += _transaction.amount;
        nonce._activeSupply += _transaction.amount;
    }


    function _redeem(
        address _from,
        IERC3475.Transaction calldata _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        // verify whether _amount of bonds to be redeemed  are sufficient available  for the given nonce of the bonds

        require(
            nonce._balances[_from] >= _transaction.amount,
            "ERC3475: not enough bond to transfer"
        );

        //transfer balance
        nonce._balances[_from] -= _transaction.amount;
        nonce._activeSupply -= _transaction.amount;
        nonce._redeemedSupply += _transaction.amount;
    }


    function _burn(
        address _from,
        IERC3475.Transaction calldata _transaction
    ) private {
        Nonce storage nonce = _classes[_transaction.classId]._nonces[_transaction.nonceId];
        // verify whether _amount of bonds to be burned are sfficient available for the given nonce of the bonds
        require(
            nonce._balances[_from] >= _transaction.amount,
            "ERC3475: not enough bond to transfer"
        );

        //transfer balance
        nonce._balances[_from] -= _transaction.amount;
        nonce._activeSupply -= _transaction.amount;
        nonce._burnedSupply += _transaction.amount;
    }

}
