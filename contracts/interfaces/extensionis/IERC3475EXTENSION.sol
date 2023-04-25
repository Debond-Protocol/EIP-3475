// SPDX-License-Identifier: CC0-1.0

pragma solidity ^0.8.0;

interface IERC3475EXTENSION {
    // STRUCTURE
    /**
     * @dev Values structure of the Metadata
     */
    struct ValuesExtension {
        string stringValue;
        uint uintValue;
        address addressValue;
        bool boolValue;
        string[] stringArrayValue;
        uint[] uintArrayValue;
        address[] addressArrayValue;
        bool[] boolAraryValue;
    }
    
       /**
     * @dev Returns the values of the given _metadataTitle.
     * the metadata SHOULD follow a set of structures explained in eip-3475.md
     */
    function classValuesFromTitle(uint256 _classId, string memory _metadataTitle) external view returns (ValuesExtension memory);

    /**
     * @dev Returns the values of given _metadataTitle.
     * @param _classId is the class of bonds for which you determine the nonce .
     * @param _nonceId is the nonce for which you return the value struct info
     */
    function nonceValuesFromTitle(uint256 _classId, uint256 _nonceId, string memory _metadataTitle) external view returns (ValuesExtension memory);    
    
      /**
     * @notice MUST trigger when token class is created
     */     
    event classCreated(address indexed _operator, uint256 _classId);  
    event updateClassMetadata(address indexed _operator, uint256 _classId, ValuesExtension[] oldMetedata, ValuesExtension[] newMetedata);  
    event updateNonceMetadata(address indexed _operator, uint256 _classId, uint256 _nonceId, ValuesExtension[] oldMetedata, ValuesExtension[] newMetedata);  
  
}
