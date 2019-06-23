pragma solidity ^0.4.22;

/* Author: Neeraj Kumar
 * 
 * private contract: This will host the following features:
 *  - KYC  
 *  - 
*/

import "./Utils.sol";

contract KYCTypes is Utils {
    
    address private owner;
    
    struct KYCTypeDetails {
        string KYCTypeID;
        address initializingParty;
        // auditor, member, bidder/user
        uint8 KYCType; // mapit with a string NAME/explanation
        uint8 status;   
        uint8 KYCTypeState; // map it with a btes32 for the active, deactive, stalled states
        
        uint8[] neccessaryDocumentTypes;
        uint8[] optionalDocumentTypes;
    }
    
    mapping (uint8=>string) KYCTypesExplanation;
    
    //KYCTypeID to KYCDEtails
    mapping (string => KYCTypeDetails) KYCTypesAvailable;
    
    mapping(uint8 => string) KYCTypeStatusStrings;
    
    constructor () public {
        KYCTypesExplanation[KYC_TYPE_AUDITOR]   = "Auditor KYC";
        KYCTypesExplanation[KYC_TYPE_COM_MEMBER]= "Com Member KYC";
        KYCTypesExplanation[KYC_TYPE_USR_BIDDER]= "User/Bidder KYC";
    }
    
    function getKYCTypeDetailsByTypeID(
        string _KYCTypeID
    ) 
    public 
    view 
    // modifier: check the KYC type exists by the TypeID
    returns (
        string,
        address,
        uint8,
        uint8,
        uint8,
        uint8[] memory neccessaryDocumentTypes,
        uint8[] memory optionalDocumentTypes
    )
    {
        KYCTypeDetails memory kyd = KYCTypesAvailable[_KYCTypeID];
        return (
            kyd.KYCTypeID,
            kyd.initializingParty,
            kyd.KYCType,
            kyd.status,
            kyd.KYCTypeState,
            kyd.neccessaryDocumentTypes,
            kyd.optionalDocumentTypes
        );
    }
   
}
