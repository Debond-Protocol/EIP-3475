// SPDX-License-Identifier: CC0-1.0


pragma solidity ^0.8.0;


interface IERC3475 {

    // STRUCTURE
    /**
     * @dev Values structure of the Metadata
     */
    struct Values {
        string stringValue;
        uint uintValue;
        address addressValue;
        bool boolValue;
        string[] stringArrayValue;
        uint[] uintArrayValue;
        address[] addressArrayValue;
        bool[] boolArrayValue;
    }
    /**
     * @dev structure allows the transfer of any given number of bonds from one address to another.
     * @title": "defining the title information",
     * @type": "explaining the type of the title information added",
     * @description": "little description about the information stored in the bond",
     */
    struct Metadata {
        string title;
        string _type;
        string description;
    }
    /**
     * @dev structure allows the transfer of any given number of bonds from one address to another.
     * @classId is the class id of the bond.
     * @nonceId is the nonce id of the given bond class. This param is for distinctions of the issuing conditions of the bond.
     * @amount is the amount of the bond that will be transferred.
     */
    struct Transaction {
        uint256 classId;
        uint256 nonceId;
        uint256 amount;
    }

    // WRITABLES
    /**
     * @dev allows the transfer of a bond from one address to another (either single or in batches).
     * @param _from  is the address of the holder whose balance is about to decrease.
     * @param _to is the address of the recipient whose balance is about to increase.
     */
    function transferFrom(address _from, address _to, Transaction[] calldata _transactions) external;

    /**
     * @dev allows the transfer of allowance from one address to another (either single or in batches).
     * @param _from is the address of the holder whose balance about to decrease.
     * @param _to is the address of the recipient whose balance is about to increased.
     */
    function transferAllowanceFrom(address _from, address _to, Transaction[] calldata _transactions) external;

    /**
     * @dev allows issuing of any number of bond types to an address.
     * The calling of this function needs to be restricted to bond issuer contract.
     * @param _to is the address to which the bond will be issued.
     */
    function issue(address _to, Transaction[] calldata _transactions) external;

    /**
     * @dev allows redemption of any number of bond types from an address.
     * The calling of this function needs to be restricted to bond issuer contract.
     * @param _from is the address _from which the bond will be redeemed.
     */
    function redeem(address _from, Transaction[] calldata _transactions) external;

    /**
     * @dev allows the transfer of any number of bond types from an address to another.
     * The calling of this function needs to be restricted to bond issuer contract.
     * @param _from  is the address of the holder whose balance about to decrees.
     */
    function burn(address _from, Transaction[] calldata _transactions) external;

    /**
     * @dev Allows _spender to withdraw from your account multiple times, up to the amount.
     * @notice If this function is called again, it overwrites the current allowance with amount.
     * @param _spender is the address the caller approve for his bonds
     */
    function approve(address _spender, Transaction[] calldata _transactions) external;

    /**
     * @notice Enable or disable approval for a third party ("operator") to manage all of the caller's tokens.
     * @dev MUST emit the ApprovalForAll event on success.
     * @param _operator Address to add to the set of authorized operators
     * @param _approved "True" if the operator is approved, "False" to revoke approval
     */
    function setApprovalFor(address _operator, bool _approved) external;

    // READABLES
    /**
     * @dev Returns the total supply of the bond in question.
     */
    function totalSupply(uint256 _classId, uint256 _nonceId) external view returns (uint256);

    /**
     * @dev Returns the redeemed supply of the bond in question.
     */
    function redeemedSupply(uint256 _classId, uint256 _nonceId) external view returns (uint256);

    /**
     * @dev Returns the active supply of the bond in question.
     */
    function activeSupply(uint256 _classId, uint256 _nonceId) external view returns (uint256);

    /**
     * @dev Returns the burned supply of the bond in question.
     */
    function burnedSupply(uint256 _classId, uint256 _nonceId) external view returns (uint256);

    /**
     * @dev Returns the balance of the giving bond _classId and bond nonce.
     */
    function balanceOf(address _account, uint256 _classId, uint256 _nonceId) external view returns (uint256);

    /**
     * @dev Returns the JSON metadata of the classes.
     * The metadata SHOULD follow a set of structure explained later in eip-3475.md
     */
    function classMetadata(uint256 _metadataId) external view returns (Metadata memory);

    /**
     * @dev Returns the JSON metadata of the nonces.
     * The metadata SHOULD follow a set of structure explained later in eip-3475.md
     */
    function nonceMetadata(uint256 _classId, uint256 _metadataId) external view returns (Metadata memory);

    /**
     * @dev Returns the values of the given _classTitle.
     * the metadata SHOULD follow a set of structures explained in eip-3475.md
     */
    function classValuesFromTitle(uint256 _classId, string memory _metadataTitle) external view returns (Values memory);


    /**
     * @dev Returns the values of given _nonceId.
     * @param _classId is the class of bonds for which you determine the nonce .
     * @param _nonceId is the nonce for which you return the value struct info
     * @param _metadataTitle The metadata SHOULD follow a set of structures explained in eip-3475.md
     */
    function nonceValuesFromTitle(uint256 _classId, uint256 _nonceId, string memory _metadataTitle) external view returns (Values memory);

    /**
     * @dev Returns the information about the progress needed to redeem the bond
     * @notice Every bond contract can have its own logic concerning the progress definition.
     * @param _classId The class of  bonds.
     * @param _nonceId is the nonce of bonds for finding the progress.
     */
    function getProgress(uint256 _classId, uint256 _nonceId) external view returns (uint256 progressAchieved, uint256 progressRemaining);

    /**
     * @notice Returns the amount which spender is still allowed to withdraw from _owner.
     * @param _owner is the address whose owner allocates some amount to the _spender address.
     * @param _classId is the _classId of bond .
     * @param _nonceId is the nonce corresponding to the class for which you are approving the spending of total amount of bonds.
     */
    function allowance(address _owner, address _spender, uint256 _classId, uint256 _nonceId) external view returns (uint256);

    /**
     * @notice Queries the approval status of an operator for a given owner.
     * @param _owner is the current holder of the bonds for  all classes / nonces.
     * @param _operator is the address which is  having access to the bonds of _owner for transferring
     * Returns "true" if the operator is approved, "false" if not
     */
    function isApprovedFor(address _owner, address _operator) external view returns (bool);

    // EVENTS
    /**
     * @notice MUST trigger when tokens are transferred, including zero value transfers.
     */
    event Transfer(address indexed _operator, address indexed _from, address indexed _to, Transaction[] _transactions);

    /**
     * @notice MUST trigger when tokens are issued
     */
    event Issue(address indexed _operator, address indexed _to, Transaction[] _transactions);

    /**
     * @notice MUST trigger when tokens are redeemed
     */
    event Redeem(address indexed _operator, address indexed _from, Transaction[] _transactions);

    /**
     * @notice MUST trigger when tokens are burned
     */
    event Burn(address indexed _operator, address indexed _from, Transaction[] _transactions);

    /**
     * @dev MUST emit when approval for a second party/operator address to manage all bonds from a classId given for an owner address is enabled or disabled (absence of an event assumes disabled).
     */
    event ApprovalFor(address indexed _owner, address indexed _operator, bool _approved);
}


contract ERC3475 is IERC3475 {
    /**
     * @notice this Struct is representing the Nonce properties as an object
     */
    struct Nonce {
        mapping(string => IERC3475.Values) _values;

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
        _classes[1]._values["symbol"].stringValue = "ACR586";
        _classes[1]._values["projectID"].stringValue = "ACR586"; 
        _classes[1]._values["category"].stringValue = "Certificate";
        _classes[1]._values["subcategory"].stringValue = "Credit";
        _classes[1]._values["childCategory"].stringValue = "ESG action carbon credits";
        _classes[1]._values["description"].stringValue = "Capture mine methane to reduce GHG emission";  
        _classes[1]._values["projectName"].stringValue = "18 Reserves Forest Carbon Project";  
        _classes[1]._values["projectType"].stringValue = "Forest Carbon";
        _classes[1]._values["projectProtocol"].stringValue = "Improved Forest Management (IFM) on Non-Federal U.S. Forestlands";
        _classes[1]._values["projectWebSite"].stringValue = "https://climatetrust.org/";
        _classes[1]._values["ProjectSiteLocation"].stringValue = "Near Cleveland";
        _classes[1]._values["projectDeveloperJurisdiction"].stringValue = "US";
        _classes[1]._values["projectDeveloperLogo"].stringValue = "https://climatetrust.org/wp-content/uploads/2015/07/logo-tct-2015.png";
        _classes[1]._values["projectDeveloperRegistrationNumber"].stringValue = "US-000000000000";
        _classes[1]._values["projectDeveloperDocURL"].stringArrayValue = [
            "https://acr2.apx.com/mymodule/reg/TabDocuments.asp?r=112&ad=Prpt&act=update&type=PRO&aProj=ipub&tablename=doc&id1=586"
        ];  
        _classes[1]._values["sustainableDevelopmentGoals"].stringArrayValue = [
            "Clean Water and Sanitation",
            "Climate Action",
            "Life on Land"
        ];
        _classes[1]._values["verifiedRemoval"].boolValue = true; 
        _classes[1]._values["arbEligible"].boolValue = false;
        _classes[1]._values["isCORSIA"].boolValue = false;

        // define metadata of the class 1";
        _classes[1]._values["symbol"].stringValue = "ACR586";
        _classes[1]._values["projectID"].stringValue = "ACR586"; 
        _classes[1]._values["category"].stringValue = "Certificate";
        _classes[1]._values["subcategory"].stringValue = "Credit";
        _classes[1]._values["childCategory"].stringValue = "ESG action carbon credits";
        _classes[1]._values["description"].stringValue = "Capture mine methane to reduce GHG emission";  
        _classes[1]._values["projectName"].stringValue = "18 Reserves Forest Carbon Project";  
        _classes[1]._values["projectType"].stringValue = "Forest Carbon";
        _classes[1]._values["projectProtocol"].stringValue = "Improved Forest Management (IFM) on Non-Federal U.S. Forestlands";
        _classes[1]._values["projectWebSite"].stringValue = "https://climatetrust.org/";
        _classes[1]._values["ProjectSiteLocation"].stringValue = "Near Cleveland";
        _classes[1]._values["projectDeveloperJurisdiction"].stringValue = "US";
        _classes[1]._values["projectDeveloperLogo"].stringValue = "https://climatetrust.org/wp-content/uploads/2015/07/logo-tct-2015.png";
        _classes[1]._values["projectDeveloperRegistrationNumber"].stringValue = "US-000000000000";
        _classes[1]._values["projectDeveloperDocURL"].stringArrayValue = [
            "https://acr2.apx.com/mymodule/reg/TabDocuments.asp?r=112&ad=Prpt&act=update&type=PRO&aProj=ipub&tablename=doc&id1=586"
        ];  
        _classes[1]._values["sustainableDevelopmentGoals"].stringArrayValue = [
            "Clean Water and Sanitation",
            "Climate Action",
            "Life on Land"
        ];
        _classes[1]._values["verifiedRemoval"].boolValue = true; 
        _classes[1]._values["arbEligible"].boolValue = false;
        _classes[1]._values["isCORSIA"].boolValue = false;
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

    function nonceValuesFromTitle(uint256 classId, uint256 nonceId, string memory metadataTitle)
    external
    view
    override
    returns (Values memory) {
        return (_classes[classId]._nonces[nonceId]._values[metadataTitle]);
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
        uint256 issuanceDate = _classes[classId]._nonces[nonceId]._values["issuranceTime"].uintValue;
        uint256 maturityDate = issuanceDate + _classes[classId]._values["maturityPeriod"].uintValue;

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
