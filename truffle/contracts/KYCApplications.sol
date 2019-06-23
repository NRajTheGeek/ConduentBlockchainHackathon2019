pragma solidity ^0.4.22;

/* Author: Neeraj Kumar
 * 
 * private contract: This will host the following features:
 *  - KYC Applications
 *  - 
*/

import "./KYCTypes.sol";
import "./Document.sol";
import "./Utils.sol";
import "./Users.sol";

contract KYCApplications is Utils {
    
    address private owner;
    Document documentCon;
    Users biddingUsers;
    
    
    function setDocumentContract(address _docCon) 
    public
    //modifier: make sure only the owbner is able to do it
    {
        documentCon = Document(_docCon);
    }
    
    function setBiddersContract(address _biddersCon) 
    public
    //modifier: make sure only the owbner is able to do it
    {
        biddingUsers = Users(_biddersCon);
    }
    
    struct KYCApplication {
        string KYCApplicationID;
        
        string KYCTypeID;
        string[] neccessaryDocuments; 
        uint8 nDInd;
        string[] optionalDocuments; 
        uint8 oDInd;
        
        address submittedBy;
        uint64 submittedAt;
        
        uint64 modifiedAt;
        
        uint8 actionTaken;
        uint64 latestActionDate;
        
        uint64 validThroughDate;
    }
    
    // KYCTypeID => (KYCApplicationID => KYCApplication)
    mapping (string => mapping(string => KYCApplication)) KYCApplicationsByType;
    
    // KYCApplicationID => KYCApplication
    mapping (string => KYCApplication) KYCApplications;
    
    mapping(uint8 => string) KYCAppActionTakenStrings;
    
    
    constructor() public{
        // KYCAppActionTakenStrings[ACTION_TAKEN_ACCEPT] = "ACCEPTED";
        // KYCAppActionTakenStrings[ACTION_TAKEN_REJECT] = "REJECTED";
    }
    
    function ApplyForKYCNeccessaryDoc(
        string _KYCApplicationID,
        string _KYCTypeID,
        string memory _neccessaryDocument,
        uint64 _validThroughDate
    )
    public
    // modifier: check the KYC by the application name not already exists
    // modifiers: check sanioty of all input fields
    // modifier: check whether all the doc hashes in both array exists
    // modifier: check the submitter exists and not a smart contract
    {        
        KYCApplication memory ka;
        
        ka.KYCApplicationID=_KYCApplicationID;
        ka.KYCTypeID=_KYCTypeID;

        ka.neccessaryDocuments[ka.nDInd] = _neccessaryDocument;
        ka.nDInd++;
        
        ka.submittedBy = msg.sender;
        
        //  a little risky due to under run
        ka.submittedAt=uint64(now);
        ka.modifiedAt=uint64(now);
        ka.validThroughDate=_validThroughDate;

        KYCApplications[ka.KYCApplicationID] = ka;
    }
    
    function ApplyForKYCOptionalDoc(
        string _KYCApplicationID,
        string _KYCTypeID,
        string memory _optionalDocument,
        uint64 _validThroughDate
    )
    public
    // modifier: check the KYC by the application name not already exists
    // modifiers: check sanioty of all input fields
    // modifier: check whether all the doc hashes in both array exists
    // modifier: check the submitter exists and not a smart contract
    {        
        KYCApplication memory ka;
        
        ka.KYCApplicationID=_KYCApplicationID;
        ka.KYCTypeID=_KYCTypeID;
        
        ka.optionalDocuments[ka.oDInd] = _optionalDocument;
        ka.oDInd++;
        
        ka.submittedBy=msg.sender;
        
        //  a little risky due to under run
        ka.submittedAt=uint64(now);
        ka.modifiedAt=uint64(now);

        ka.validThroughDate=_validThroughDate;
        KYCApplications[_KYCApplicationID] = ka;
    }

    function getKYCStatusByApplicationID(
        string _KYCApplicationID
    )
    public 
    //modifier: check whether a data with this application ID exists
    // modifier:  check the user owns the KYC or KYC initializer
    returns(
        string,
        string,
        uint,
        uint,
        address,
        uint64,
        uint64,
        uint8,
        uint64,
        uint64
    )
    {
        KYCApplication memory kycApp = KYCApplications[_KYCApplicationID];
        
        return(
            kycApp.KYCApplicationID,
            kycApp.KYCTypeID,
            kycApp.neccessaryDocuments.length,
            kycApp.optionalDocuments.length,
            kycApp.submittedBy,
            kycApp.submittedAt,
            kycApp.modifiedAt,
            kycApp.actionTaken,
            kycApp.latestActionDate,
            kycApp.validThroughDate
        );
    }
    
    function getNeccessaryKYCDocument(
        string _KYCApplicationID,
        uint ind
    )
    public
    //modifier: check whether the KYCAppliocationID data exists
    returns(string memory _neccessaryDocuments)
    {
        return KYCApplications[_KYCApplicationID].neccessaryDocuments[ind];
    }

    function getNeccessaryKYCDocumentLength(
        string _KYCApplicationID
    )
    public
    view
    returns (uint)
    {
        return KYCApplications[_KYCApplicationID].neccessaryDocuments.length;
    }
    
    function getOptionalKYCDocument(
        string _KYCApplicationID,
        uint ind
    )
    public
    //modifier: check whether the KYCAppliocationID data exists
    returns(string memory _optionalDocument)
    {
        return KYCApplications[_KYCApplicationID].optionalDocuments[ind];
    }

    function getOptionalDocumentsLength(
        string _KYCApplicationID
    )
    public
    view
    returns (uint)
    {
        return KYCApplications[_KYCApplicationID].optionalDocuments.length;
    }
    
    function processTheKYCApplication(
        string _KYCApplicationID,
        uint64 _validThroughDate
    )
    public
    // modifier: make sure that the document contract is already initialized
    // modifier: check the KYCApplicationID
    // modifier: procesed only by the KYC initializer
    {
        string[] memory neccDocs = KYCApplications[_KYCApplicationID].neccessaryDocuments;
        string[] memory optionalDocs = KYCApplications[_KYCApplicationID].optionalDocuments;
        
        bool docFlag = false;
        
        // check all the neccessary KYC documents are in verified latestActionDate
        // check that the all the neccessary KYC documents' expiry date does not exceed the asked KYC expiry date
        uint ind = 0;
        uint8 docStatus = 0;
        for(ind=0; ind < neccDocs.length; ind++){
            docStatus = documentCon.getDocumentStatusByHash(neccDocs[ind]); 
            if(docStatus != VERIFIED_DOC_STATE){
                docFlag = true;
                break;
            }
        }
        docStatus = 0;
        
        for(ind=0; ind < optionalDocs.length; ind++){
            
            if(documentCon.getDocumentStatusByHash(optionalDocs[ind]) != VERIFIED_DOC_STATE){
                docFlag = true;
                break;
            }
        }
        
        if(docFlag) {
            // reject the KYC
            KYCApplications[_KYCApplicationID].actionTaken = ACTION_TAKEN_REJECT;
            KYCApplications[_KYCApplicationID].latestActionDate = uint64(now);
        } else {
            // accept the KYC
            KYCApplications[_KYCApplicationID].actionTaken = ACTION_TAKEN_ACCEPT;
            KYCApplications[_KYCApplicationID].latestActionDate = uint64(now);
            
            
            // also ad the KYC application to the biddingUsers KYC APplications so far
            //address _userAddress, uint8 _role, string _KYCAPplicationID
            biddingUsers.AddKYCApplication(KYCApplications[_KYCApplicationID].submittedBy, _KYCApplicationID);
        }
    }
    
    function getKYCAppnStatusStringByAppnID(
        string _KYCApplicationID
    ) 
    public
    //modifier: check the appropriate pull
    returns (string)
    {
        uint8 actionTaken = KYCApplications[_KYCApplicationID].actionTaken;
        return KYCAppActionTakenStrings[actionTaken];
    }
    
    function getKYCAppnStatusCodeByAppnID(
        string _KYCApplicationID
    ) 
    public
    //modifier: check the appropriate pull
    returns (uint8)
    {
        return KYCApplications[_KYCApplicationID].actionTaken;
    }
}
