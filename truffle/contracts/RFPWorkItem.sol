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

contract RFPWorkItem is Utils {
    string title;
    uint tenderValue;
    string category;
    string bidValidity;
    string periodOfWork;
    //string workDescription;
    // bool state;

    constructor () public {}

    function addWorkItemDetails(
        string _title,
        uint    _tenderValue,
        string _category,
        string _bidValidity,
       string _periodOfWork
       //string _workDescription
    ) 
    public 
    //modifier
    {
        title =_title;
        tenderValue = _tenderValue;
       category = _category;
       bidValidity = _bidValidity;
       periodOfWork = _periodOfWork;
       // workDescription = _workDescription;
        //return true;
    }
      
}
