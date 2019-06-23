pragma solidity ^0.4.22;

/* Author: Neeraj Kumar
 * 
 * This will host the following features:
 *  - KYC  
 *  - 
*/

contract UserRoles {
    // 11 to 20 allowed tro put here
    uint8 constant GUEST                                = 11;
    uint8 constant USER_OR_BIDDER                       = 12;
    uint8 constant AUDITOR                              = 13;
    uint8 constant COMMITEE_MEMBER                      = 14;
    
}

contract DocStatusCodes {
    
    // 0-9 allowed to put here
    uint8 constant INITIAL_DOC_STATE                    = 1;
    uint8 constant SENT_FOR_VERFICATION_DOC_STATE       = 2;
    uint8 constant VERIFIED_DOC_STATE                   = 3;
    uint8 constant REJECTED_DOC_STATE                   = 4;
    uint8 constant RETURN_WITH_CONCERN                  = 5;
    
}

contract DocConcernCodes {
    
    // 0-9 allowed to put here
    uint8 constant DOC_EXPIRED                          = 111;
    uint8 constant IMPOSTER                             = 112;
    
}

contract KYCTypeCodes {
    uint8 constant KYC_TYPE_ACTIVE                      = 21;
    uint8 constant KYC_TYPE_INACTIVE                    = 22;
    uint8 constant KYC_TYPE_STALLED                     = 23;
    
    uint8  constant KYC_TYPE_AUDITOR                    = 221;
    uint8  constant KYC_TYPE_COM_MEMBER                 = 222;
    uint8  constant KYC_TYPE_USR_BIDDER                 = 223;
    
}

contract KYCAppActionCodes {
    uint8 constant ACTION_TAKEN_ACCEPT                  = 31;
    uint8 constant ACTION_TAKEN_REJECT                  = 32;
    
}

contract RFPStatus {
    uint16 constant RFP_ACTIVE                           = 1000;
    uint16 constant RFP_INACTIVE                         = 1100;
    uint16 constant RFP_STALLED                          = 1200;
    uint16 constant RFP_NOT_READY                        = 1300;
    uint16 constant RFP_TENDER_AWARDED                   = 1400;
}

contract BidStatus {
    uint16 constant PLACED_NOT_DECLARED                  = 2000;
    uint16 constant PLACED_AND_DECLARED                  = 2100;
    uint16 constant PLACED_WON_TENDER                    = 2200;
}

contract Utils is UserRoles, DocStatusCodes, DocConcernCodes, KYCTypeCodes, KYCAppActionCodes, RFPStatus, BidStatus {
    
    
    // modifiers for every action
    
    
    // generic function or routines
    uint _INACTIVE = 0;
    uint _PENDING = 1;
    uint _VERIFIED = 2;
    uint _REJECTED = 3;
    address owner;

    struct Document2 {
        address docOwner;
        address publisher;
        uint verificationStatus;
        uint createdOn;
        uint modifiedOn;
        bool upload;
    }

    mapping (address => bool) verifiers;
    mapping (address => bool) publishers;
    //    sha256_hashDigest => document
    mapping (string => Document2) KYCDoc;


    modifier onlyOwner(address _owner) 
    {
        require(_owner == owner, "cannot perform action.");
        _;
    }

    modifier onlyActiveVerifier(address _verifier) 
    {
        require(verifiers[_verifier] == true, "not an active verifer.");
        _;
    }

    modifier onlyActivePublisher(address _publisher) 
    {
        require(publishers[_publisher] == true, "not an active publisher.");
        _;
    }

    modifier addressNotBlank(address add)
    {
        require(add != address(0), "null address");
        _;
    }

    modifier nullStringCheck(string memory val)
    {
        require(bytes(val).length > 0, "empty string");
        _;
    }

    modifier uintNonZero (uint val) 
    {
        require(val > 0, "cannot be zero");
        _;
    }
    
    
    modifier alreadyVerifier (address _toBeSet) 
    {
        bool toCheck = verifiers[_toBeSet];
        require(!toCheck, "already added");
        _;
    }
    
    modifier alreadyPublisher (address _toBeSet) 
    {
        bool toCheck = publishers[_toBeSet];
        require(!toCheck, "already added");
        _;
    }
    
    modifier alreadySentForVeirifcation (string memory _docHash)
    {
        Document2 memory document = KYCDoc[_docHash];
        require(document.verificationStatus == _INACTIVE, "Error! already sent for verification.");
        _;
    }
    
    modifier alreadyVerified (string memory _docHash)
    {
        Document2 memory document = KYCDoc[_docHash];
        require(document.verificationStatus != _VERIFIED, "Error! already verified.");
        _;
    } 
    
    modifier alreadyRejected (string memory _docHash)
    {
        Document2 memory document = KYCDoc[_docHash];
        require(document.verificationStatus != _REJECTED, "Error! already rejected.");
        _;
    }
    
    modifier maybeRejected (string memory _docHash)
    {
        Document2 memory document = KYCDoc[_docHash];
        require(document.verificationStatus != _REJECTED, "Error! already rejected.");
        _;
    }
    
    modifier mustBePending (uint status) {
        require(status == _PENDING, "Error! only pending status allowed.");
        _;
    }
    
    modifier mustBeVerified (uint status) 
    {
        require(status == _VERIFIED, "Error! only verified status allowed.");
        _;
    }
    
    modifier mustBeRejected (uint status) 
    {
        require(status == _REJECTED, "Error! only rejected status allowed.");
        _;
    }
    
}