pragma solidity ^0.4.22;

/* Author: Neeraj Kumar
 * 
 * This will host the following features:
 *  - KYC  
 *  - 
*/
import "./Utils.sol";


contract Users is Utils {
    
    // We can also add later the the data field and algorith to maintain the auditor' reputation 
    address private owner;
    
    struct UserState {
        address userAddress;
        uint8   role; // can be bidder, auditor, reviewer, merchants (org asking a KYC)
        string[] KYCapplications;
    }
    
    mapping(address => UserState) userStates;
    
    mapping(uint8 => string) roleStrings;
    
    
    // once a bid is placed we register the bidder with the RFP 
    // we also will check if that user is an auditor/committeeMember than not allow bidding 
    mapping (string => mapping(address => UserState)) bidders;
    mapping (address => uint8) bidderExists;
    
    mapping (string => mapping(address => UserState)) acceptedAuditors;
    
    constructor () public {
        // roleStrings[GUEST]          = "GUEST";
        // roleStrings[USER_OR_BIDDER] = "USER OR BIDDER";
        // roleStrings[AUDITOR]        = "AUDITOR";
        // roleStrings[COMMITEE_MEMBER]= "COMMITEE MEMBER";
    }

    function registerAsBidder() 
    public 
    // nietherAuditorNorComMember(msg.sender)
    // modifier: not already registered
    {
        UserState memory uState;
        uState.userAddress = msg.sender;
        uState.role = USER_OR_BIDDER;
        
        userStates[msg.sender] = uState;
        bidderExists[msg.sender] = USER_OR_BIDDER;
    }
    
    
    function getUserStateByAddress(address _userAddress, uint8 _role) 
    public 
    view 
    returns (address, uint8, uint)
    {
        UserState memory us = userStates[_userAddress];
        return (us.userAddress, us.role, us.KYCapplications.length);
    }
    
    function AddKYCApplication(address _userAddress, string _KYCAPplicationID) 
    public
    //modifier: make sure that only KYCApplicationsContract is able to call this
    // modifier: make sure that user is registered and the KYCApplicationID is valid
    {
        UserState storage us = userStates[_userAddress];
        us.KYCapplications.push(_KYCAPplicationID);
    }
    
}