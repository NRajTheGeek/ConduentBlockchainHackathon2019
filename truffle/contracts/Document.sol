pragma solidity ^0.4.22;

/* Author: Neeraj Kumar
 * 
 * private contract: This will host the following features:
 *  - KYC document lifecycle management  
 *  - 
*/
import "./Utils.sol";
import "./VerifyingAuthorities.sol";

contract Document is Utils {
    // only allows verifications from the VA contract by checking the msg.sender 
    // as the address of the VA
    address private VAAddress;
    
    modifier checkOnlyVAIsAllowed(address _VAAddress) {
        require(_VAAddress != address(0x0), "blank address should not be provided");
        require(_VAAddress != VAAddress, "not allowed to verify");
        _;
    }
    
    // the 32 character strings for the well defined concerns
    mapping(uint8 => string) wellDefinedConcerns;
    
    
    modifier isValidAuthority(string _authorityID, string _docHash) {
        require(keccak256(_authorityID) == keccak256(documents[_docHash].varifyingAuthorityID), "not a valid authority");
        _;
    }
    
    modifier isAuthorizedToVerify(address _vaContractAddress, string _authorityID, address _verifierAddress, string docHash) {
        VerifyingAuthorities va = VerifyingAuthorities(_vaContractAddress);
        // require(va.authorities[_authorityID].authorizedVerifiers.add == _verifierAddress, "");
        // require(_verifierAddress == _authorityID, "");
        _;
    }
    
    struct DocDetails {
        // Store the 32 character size IPFS CID: the encrypted DOC base64 data
        string docHash;
        
        // mapping exists in utils
        uint8 docType;

        uint64 validThroughDate;
        
        string varifyingAuthorityID;
        // address[] varifiableBy;
        address varifiedBy;
        uint64 varifactionDate;
        
        // user/bidder who has submitted the document
        address submittedBy;
        uint64 submitionDate;
        
        // document verification status; mapping exists in utils
        uint8 status;
        
        string comment; // can be completely empty
    }
    
    mapping(uint8 => string) docTypeString;
    
    // map document's hash witht the document state struct
    mapping(string => DocDetails) documents;
    
    mapping(uint8 => string) doctypeStrings;
    
    // events
    event DocumentCreated(
        string _docHash,
        uint8 _docType,
        uint64 _validThroughDate,
        
        string _varifyingAuthorityID,
        // address[] _varifiableBy,
        address _varifiedBy,
        uint64 _varifactionDate,
        
        address _submittedBy,
        uint64 _submitionDate,
        
        uint8 _status,
        string _comment
    );
    
    mapping(uint8 => string) docStatusString;
    
    constructor() public 
    {
        docStatusString[INITIAL_DOC_STATE]              = "INITIALIZED";
        docStatusString[SENT_FOR_VERFICATION_DOC_STATE] = "SENT FOR VERIFICATION";
        docStatusString[VERIFIED_DOC_STATE]             = "VERIFIED";
        docStatusString[REJECTED_DOC_STATE]             = "REJECTED";
        docStatusString[RETURN_WITH_CONCERN]            = "RETURN WITH A CONCERN";
        
        wellDefinedConcerns[DOC_EXPIRED]                = "Document Expired";
        wellDefinedConcerns[IMPOSTER]                   = "Imposter";
    }
    
    function addDocConcernString32ByCode(uint8 _code,string _docConcern) 
    public
    // modifier: if an entry not already made onto the doc concern code
    // modifier: check the code is in the bounds [111, 255] and does niot exists already
    {
        // also creating a new code
        wellDefinedConcerns[_code] = "Document Expired";
    }
    
    function addADocType(uint8 docTypeCode, string docTypeString) 
    public
    // modifier for allowing this operations to only owner
    // modifier doctype does not exists already
    {
        doctypeStrings[docTypeCode] = docTypeString;
    }
    
    /*
     *
     */
    function createDocumentAsset(
        string _docHash,
        uint8 _docType,
        uint64 _validThroughDate,
        
        string _varifyingAuthorityID,
        address _varifiedBy,
        uint64 _varifactionDate,
        
        address _belongsTo,
        uint64 _submitionDate,
        
        uint8 _status
    )
    public
    // modifier: check that the VerifyingAuthorityId exists
    // modifier: validate the sanity of all incoming data
    // modifier: check doctype exists and only allow on existing doctypoes
    {
        documents[_docHash] = DocDetails(
            _docHash,
            _docType,
            _validThroughDate,
            _varifyingAuthorityID,
            _varifiedBy,
            _varifactionDate,
            _belongsTo,
            _submitionDate,
            INITIAL_DOC_STATE,
            ""    
        );
        
        emit DocumentCreated(
            _docHash, 
            _docType, 
            _validThroughDate, 
            _varifyingAuthorityID, 
            _varifiedBy, 
            _varifactionDate, 
            _belongsTo, 
            _submitionDate, 
            INITIAL_DOC_STATE, 
            ""
        );
    }
    
    function sendDocumentForVerification(string _docHash)
    public 
    // modifier: that the sender owns the document
    {
        documents[_docHash].status = SENT_FOR_VERFICATION_DOC_STATE;
    }
    
    function verifiyDocument(string _docHash, string _authorityID) 
    public
    // modifier: allowance
    // modifier: check the document is strictly in the send for verification status
    checkOnlyVAIsAllowed(msg.sender)
    {
        documents[_docHash].status = SENT_FOR_VERFICATION_DOC_STATE;
    }
    
    function returnWithAConern(string _docHash, uint8 _concernCode) 
    public
    // modifier: check the document is strictly in the send for verification status
    // modifier: check that the concern is only raised by the verifier
     // make sure that a concern code exists on that concern code
    {
        documents[_docHash].status = RETURN_WITH_CONCERN;
        documents[_docHash].comment = wellDefinedConcerns[_concernCode];
    }
    
    function rejectWithAReason(string _docHash, uint8 _concernCode) 
    public
    // modifier: check the document is strictly in the send for verification status
    // modifier: check that the rejection is only trigered by the verifier
    // make sure that a concern code exists on that concern code
    {
        documents[_docHash].status = REJECTED_DOC_STATE;
        documents[_docHash].comment = wellDefinedConcerns[_concernCode];
    }
    
    function getDocumentByHash(string _docHash) 
    public
    // modifier: check if the document owner or the KYCApplication Contract
    returns (
        string,
        uint8,
        uint64,
        string,
        address,
        uint64,
        address,
        uint64,
        uint8,
        string comment    
    )
    {
        DocDetails memory doc = documents[_docHash];
        return (
            doc.docHash,
            doc.docType,
            doc.validThroughDate,
            doc.varifyingAuthorityID,
            doc.varifiedBy,
            doc.varifactionDate,
            doc.submittedBy,
            doc.submitionDate,
            doc.status,
            doc.comment
        );
    }
    
    function getDocumentStatusByHash(string _docHash)
    public
    // modifier: check if the document owner or the KYCApplication Contract
    returns (uint8)
    {
        return documents[_docHash].status;
    }
    
    
}