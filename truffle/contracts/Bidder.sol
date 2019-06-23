pragma solidity ^0.4.22;

import "./Utils.sol";
import "./RFP.sol";


contract Bidder is Utils {
    RFP rfp;

    struct Bid {
        address bidder;
        // only should be put back here after the bid deadline crossed
        uint bidPrice;

        string bidID;
        uint64 RFPBidLastDate;

        uint64 propsedCompletionDate;
        string c1_DocHash;
        string c1_CID;
        //string c1_CID_Shared;
        string t1_DocsHash;
        string t1_CID;
        //string t1_CID_Shared;

        uint16 BidStatus;
        // uint voteCount;

    }

    Bid[] public bids;

    // function recieveAVote(address recievedFrom, address bidPlacedBy, string bidId)
    // public {
    //     bidsPlaced[bidPlacedBy].voteCount++;
    // }

    mapping(address => Bid) bidsPlaced;

    
    mapping(uint16 => string) BidStatusString;
    mapping (string => Bid) bidsByBidId;

    constructor (address _rfp) public {
        rfp = RFP(_rfp);
            
        BidStatusString[PLACED_NOT_DECLARED] = "PLACED NOT DECLARED";
        BidStatusString[PLACED_AND_DECLARED] = "PLACED AND DECLARED";
        BidStatusString[PLACED_WON_TENDER]   = "PLACED WON TENDER";
    }

    function bidForRFP(
        // string bidPriceHASH,
        address RFPAddress,

        string bidID,

        uint64 propsedCompletionDate,
        string memory c1_DocHash,
        string memory t1_DocsHash
    )
    public
    // modifier: all input data should be valid
    // modifier: only if the RFP is ACTIVE state
    // modifier: only if the bidder's KYC in accepted
    {
        Bid memory bid;

        bid.bidder = msg.sender;
        bid.bidID = bidID;
        bid.propsedCompletionDate = propsedCompletionDate;
        bid.c1_DocHash = c1_DocHash;
        bid.t1_DocsHash = t1_DocsHash;

        bid.BidStatus=PLACED_NOT_DECLARED;
        
        // bidCount++;

        bidsByBidId[bid.bidID] = bid;
        bids.push(bid);
    }

    function declareBidPriceAnd_C1T1(
        string bidID,
        uint _bidPrice,
        string _c1CID, 
      //  string _c1CID_Shared,
        string _t1CID
      //  string _t1CID_Shared
    )
    public
    // modifier: check the bidId belongs to same account
    // modifier: check the sanity of all input
    // modifier: check that the bid end date is over
    {
        bidsByBidId[bidID].bidPrice  = _bidPrice;
        bidsByBidId[bidID].c1_CID= _c1CID;
       // bidsByBidId[bidID].c1_CID_Shared = _c1CID_Shared;

       // bidsByBidId[bidID].t1_CID = _t1CID;
      //  bidsByBidId[bidID].t1_CID_Shared = _t1CID_Shared;
        bidsByBidId[bidID].BidStatus=PLACED_AND_DECLARED;
    }

    function getBidByBidID(string _bidID)
    public
    // modifier: check invalid ids
    returns (
        address,
        uint,
        string,
        uint64,
        uint64,
        string,
        string,
        string,
        string,
        uint16
    )
    {
        Bid memory _bid = bidsByBidId[_bidID];
        return (
            _bid.bidder,
            _bid.bidPrice,
            _bid.bidID,
            _bid.RFPBidLastDate,
            _bid.propsedCompletionDate,
            _bid.c1_DocHash,
            _bid.c1_CID,
          //  _bid.c1_CID_Shared,
            _bid.t1_DocsHash,
            _bid.t1_CID,
      //      _bid.t1_CID_Shared,

            _bid.BidStatus
        );
    }
}