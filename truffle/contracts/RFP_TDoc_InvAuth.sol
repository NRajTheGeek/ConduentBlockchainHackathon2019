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


contract RFP_TDoc_InvAuth is Utils {
    string docCID;
    string DocHash;
    // bool state;
  
    function addTenderDoc(
        string _docCID,
        string _DocHash
    ) {
        docCID = _docCID;
        DocHash = _DocHash;
        // true
    }

    address authAddress;
    string name;
    string Address;
    // bool state;

    function addTenderInvitingAuth(
        address _authAddress,
        string _name,
        string _Address
    ) {
        authAddress = _authAddress;
        name = _name;
        Address = _Address;
        // true
    }
    
}
