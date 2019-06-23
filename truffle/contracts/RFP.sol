pragma solidity ^0.4.22;

/* Author: Neeraj Kumar
 * 
 * Being a public contract: This will host the following features:
 *  - launching the RFP
 *  - start and end date of accepting application (bids) 
 *  - disclosure of bids only after the dead line of bidding is over  
 *  - 
*/

import "./Utils.sol";
import "./Bidder.sol";
import "./RFPBasic.sol";
import "./RFPEMD_Fee.sol";
import "./RFP_TDoc_InvAuth.sol";
import "./RFPCriticalDate.sol";
import "./RFPWorkItem.sol";

contract RFP is Utils {
    address private owner;

    uint64 public tenderOpeningDate;
    string public tenderID;
    address public tenderWinnerAddress;

    // bool RFPStatus;
    uint bidCount;
    
    mapping(uint16 => string) RFPStatusStrings;

    mapping(address => string) bidByAddressOfBidder;

    RFPEMD_Fee rFPEMD_Fee;
    RFP_TDoc_InvAuth rFP_TDoc_InvAuth;
    RFPWorkItem rFPWorkItem;

    // RFP document needs to be uploaded ad openly public and CID should be put there
    constructor () public {
        owner = msg.sender;

        rFPBasic = new RFPBasic();
        rFPCriticalDate = new  RFPCriticalDate();
        rFPEMD_Fee = new RFPEMD_Fee();
        rFP_TDoc_InvAuth = new RFP_TDoc_InvAuth();
        rFPWorkItem = new RFPWorkItem();

        Bidder bidder = Bidder(this);
        RFPStatusStrings[RFP_ACTIVE]         = "ACTIVE";
        RFPStatusStrings[RFP_INACTIVE]       = "INACTIVE";
        RFPStatusStrings[RFP_STALLED]        = "STALLED";
        RFPStatusStrings[RFP_NOT_READY]      = "NOT READY";
        RFPStatusStrings[RFP_TENDER_AWARDED] = "TENDER AWARDED";
    }

    function getRFPStatusByStatusCode(uint16 _statusCode)
    public
    view
    returns (string)
    {
        return RFPStatusStrings[RFP_ACTIVE];
    }
}