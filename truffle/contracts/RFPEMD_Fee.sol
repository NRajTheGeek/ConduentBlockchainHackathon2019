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


contract RFPEMD_Fee is Utils {
    
    string payableTo;
    string payableAt;
    uint amount;
    // bool state;

    constructor(){}
    
    function addEMDDetails(
        uint    _amount,
        string _payableTo,
        string memory  _payableAt
    )
    public 
    // modifier
    {
        amount = _amount;
        payableTo = _payableTo;
        payableAt = _payableAt;
        // true
    }

    string feePayableTo;
    string feePayableAt;
    uint payableFee;
    // bool state;

    function addFeeDetails(
        string _feePayableTo,
        string _feePayableAt,
        uint _payableFee
    )
    public 
    //modifier
    {
        feePayableTo = _feePayableTo;
        feePayableAt = _feePayableAt;
        payableFee = _payableFee;
        // true
    }

    
}
