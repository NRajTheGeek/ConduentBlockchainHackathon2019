pragma solidity ^0.4.22;

/* Author: Neeraj Kumar
 * 
 * private contract: This will host the following features:
 *  - To represent a registered Verifying Authorities
 *  - 
*/

contract VerifyingAuthorities {
    
    address private owner;
    
    bool private constant ACTIVE = true; 
    
    struct Verifier {
        address add;
        bool isActive;
        uint64 validThroughDate;
        string authorityID;
    }
    
    struct Authority {
        // MD5 of all lower name
        string name;
        // MD5 of the ethereum address of the generator of authority
        string authorityID;
        uint authorityIndex;
        
        address authAddress;
        mapping(address => bool) isAuthorizedVerifiers;
        mapping(address => Verifier) authorizedVerifiers;
    }
    
    Authority[] authBundle;
    // mapping authorityID with the authority
    mapping(string => Authority) authorities;
    
    function addAVerifyingAuthority(
        string _name,
        string _authorityID,
        address _authAddress,
        address _verifierAddress,
        uint64 _validThroughDate
    ) 
    public {
        Authority memory auth;
        authorities[_authorityID] = auth;
        
        Verifier memory verif = Verifier(_verifierAddress, ACTIVE, _validThroughDate, _authorityID);
        
        authorities[_authorityID].name = _name;
        authorities[_authorityID].authorityID = _authorityID;
        authorities[_authorityID].authAddress = _authAddress;
        authorities[_authorityID].isAuthorizedVerifiers[_verifierAddress]= ACTIVE;
        authorities[_authorityID].authorizedVerifiers[_verifierAddress]= verif;
    }
    
    /*
    *
    */
    function _addAVerifierToAuthority(
        Authority memory auth,
        Verifier memory verif
    )
    private {
        authorities[auth.authorityID].isAuthorizedVerifiers[verif.add] = ACTIVE;
        authorities[auth.authorityID].authorizedVerifiers[verif.add] = verif;
    }
    
    /*
    *
    */
    function addAVerifierToAuthority(
        address _verifierAddress,
        uint64 _validThroughDate,
        // must check through the modifier that the autorityID already exists
        string _authorityID
    ) 
    public {
        Authority memory auth = authorities[_authorityID];
        // creating an active verifier
        Verifier memory verif = Verifier(_verifierAddress, ACTIVE, _validThroughDate, _authorityID); 
        _addAVerifierToAuthority(auth, verif);
    }
}