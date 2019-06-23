pragma solidity >=0.4.22;

import "./RFP.sol";
import "./Users.sol";

contract Audit is Utils {
    address owner;

    address[] auditors;
    mapping (uint => string) reports;
    mapping (uint => bool) audit_status;

    address auditor_address;

    function addAuditor(address _auditor) public returns (bool) 
    // modifier: only allowed to owner
    { 
        auditors.push(_auditor);
        return true; 
    }

    function logAuditReport(uint bidID, bool status, string reportSHA256hash) public returns (uint _bidID, bool _status ,address _auditor, string _reportSHA256hash)
    {
        reports[bidID] = reportSHA256hash;
        audit_status[bidID] = status;
        auditor_address = msg.sender;
        //return (bidID, audit_status[bId], auditor_address, reportSHA256hash);
    }
    
    function getAuditReport(uint bidID) public returns (string _reportSHA256hash, bool _status){
        _reportSHA256hash = reports[bidID];
        return (_reportSHA256hash, _status);
    }
}
