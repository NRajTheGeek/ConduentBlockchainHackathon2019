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

contract RFPBasic is Utils {
    
    // important to keep the owner private
    address private owner;

    string orgChain;
    string tenderRefNumber;
    string tenderID;
    //string RefId;
    string catagory;
    string paymentMode;
    string tenderType;

    constructor () public {}

    function setRFPBasicDetails(
        string _orgChain,
        string _tenderRefNumber,
        string _tenderID,
      //  string _RefId,
        string _catagory,
        string _paymentMode,
        string _tenderType
    ) 
    public
    // modifier: should be allowed to only owner
    {
        orgChain = _orgChain;
        tenderRefNumber = _tenderRefNumber;
        tenderID = _tenderID;
        //RefId = _RefId;
        catagory = _catagory;
        paymentMode = _paymentMode;
        tenderType = _tenderType;
    }
}
