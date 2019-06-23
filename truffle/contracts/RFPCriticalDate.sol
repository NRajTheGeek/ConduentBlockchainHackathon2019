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


contract RFPCriticalDate is Utils {
    
    uint64 publishedDate;
    uint64 bidOpeningdate;

    uint64 bidRevealStartDate;
    uint64 bidRevealEndDate;
    uint64 votingStartDate;
    uint64 votingEndDate;
    // uint64 bidSubmissionStartDate;
    uint64 bidSubmissionEndDate;
    uint64 bidOpeningDate;
    // uint64 uintclarificationDate;
    // bool state;

    constructor () public {}
    
    function addCriticaldate(
        uint64 _bidOpeningdate,

        uint64 _bidRevealStartDate,
        uint64 _bidRevealEndDate,
        uint64 _votingStartDate,
        uint64 _votingEndDate,
        // uint64 _bidSubmissionStartDate,
        uint64 _bidSubmissionEndDate,
        uint64 _bidOpeningDate
        // uint64 _uintclarificationDate
        // bool status
    )
    public
    // modfier: check the owner
    {
        publishedDate = uint64(now);
        bidOpeningdate = _bidOpeningdate;
        
        bidRevealStartDate = _bidRevealStartDate;
        bidRevealEndDate = _bidRevealEndDate;
        votingStartDate = _votingStartDate;
        votingEndDate = _votingEndDate;
        //_bidSubmissionStartDate,
        bidSubmissionEndDate = _bidSubmissionEndDate;
        bidOpeningDate = _bidOpeningDate;
        // _uintclarificationDate,
        // true
    }
}
