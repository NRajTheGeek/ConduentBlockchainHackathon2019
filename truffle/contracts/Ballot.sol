pragma solidity ^0.4.22;

import "./Bidder.sol";

contract ballot {

    function viteABid( address _bidderAddress, string bidId) 
    public 
    {
        Bidder bidder = Bidder(_bidderAddress);

        bidder.recieveAVote(msg.sender, _bidderAddress, bidId);
    }
    
    struct Voter {
        uint weight;
        bool voted;
        uint8 vote;
        address delegate;

    }

    struct Proposal {
        uint voteCount;
    }

    address bidder;
    mapping(address => Voter) voters;

    function giveRightToVote(address _bidder, address toVoter) public {
        Bidder bidder = Bidder(_bidder);

        if (msg.sender != bidder || voters[toVoter].voted) return;
        voters[toVoter].weight = 1;
    }

    function winningBid(address _bidderAddress) public view returns (uint8 _winningBid) {
        Bidder bidder = Bidder(_bidderAddress);

        uint256 winningVoteCount = 0;
        for (uint8 prop = 0; prop < bidder.bids.length; prop++)
            if (bidder.bids[prop].voteCount > winningVoteCount) {
                winningVoteCount = bidder.bids[prop].voteCount;
                _winningBid = prop;
            }
    }
}
