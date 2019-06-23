const Web3 = require("web3");
const contract = require("truffle-contract");
const path = require("path");
const fs = require("fs");

let KYCContractABI = require(path.join(
  __dirname,
  "../../truffle/build/contracts/KYCApplications.json"
));

let RFPContractABI = require(path.join(
  __dirname,
  "../../truffle/build/contracts/RFP.json"
));

let provider = new Web3.providers.HttpProvider("http://localhost:22000");

let KYCContract = contract(KYCContractABI);

KYCContract.setProvider(provider);

let RPFContract = contract(RFPContractABI);
RPFContract.setProvider(provider);

// let BidContract = contract(BidContractABI);
// BidContract.setProvider(provider);

// let VerifierContract = contract(VerifierContractABI);
// VerifierContract.setProvider(provider);

// let VotingContract = contract(VotingContractABI);
// VotingContract.setProvider(provider);

const addVerifier = function(verifierAddress, senderAddress, res) {
  KYCContract.deployed()
    .then(function(instance) {
      return instance.addVerifier(verifierAddress, {
        from: senderAddress
      });
    })
    .then(function(result) {
      console.log("successfully added verifier");
      res.send(result);
    })
    .catch(function(error) {
      console.log(error);
      res.send(error);
    });
};

const addPublisher = function(publisherAddress, senderAddress, res) {
  KYCContract.deployed()
    .then(function(instance) {
      return instance.addPublisher(publisherAddress, {
        from: senderAddress
      });
    })
    .then(result => {
      console.log("successfully added publisher");
      res.send(result);
    })
    .catch(function(error) {
      console.log(error);
      res.send(error);
    });
};

const isPublisher = function(publisherAddress, senderAddress, res) {
  KYCContract.deployed()
    .then(function(instance) {
      return instance.publishers.call(publisherAddress, senderAddress);
    })
    .then(result => {
      console.log(result);
      res.send(result);
    })
    .catch(function(error) {
      console.log(error);
      res.send(error);
    });
};

const sendDocumentForVerification = function(
  docHash,
  ownerAddress,
  publisherAddress,
  DocumentStatus,
  res
) {
  KYCContract.deployed()
    .then(function(instance) {
      return instance.sendDocForVerification(
        docHash,
        DocumentStatus,
        ownerAddress,
        {
          from: publisherAddress,
          gas: 3000000
        }
      );
    })
    .then(result => {
      console.log("document sent for verification");
      res.send(result);
    })
    .catch(function(error) {
      console.log(error);
      res.send(error);
    });
};

const verifyDocument = function(docHash, verifierAddress, DocumentStatus, res) {
  KYCContract.deployed()
    .then(function(instance) {
      return instance.verifyDocument(docHash, DocumentStatus, {
        from: verifierAddress
      });
    })
    .then(result => {
      console.log("document sent for verification");
      res.send(result);
    })
    .catch(function(error) {
      console.log(error);
      res.send(error);
    });
};

const rejectDocument = function(docHash, verifierAddress, DocumentStatus, res) {
  KYCContract.deployed()
    .then(function(instance) {
      return instance.rejectDocument(docHash, DocumentStatus, {
        from: verifierAddress
      });
    })
    .then(result => {
      console.log("document sent for verification");
      res.send(result);
    })
    .catch(function(error) {
      console.log(error);
      res.send(error);
    });
};

const getDocumentByDocHash = function(docHash, requesterAddress, res) {
  KYCContract.deployed()
    .then(function(instance) {
      return instance.getDocByHash(docHash, {
        from: requesterAddress
      });
    })
    .then(result => {
      console.log("document sent for verification");
      var response = {
        docHash: docHash,
        ownerAddress: result[0],
        publisherAddress: result[1],
        docStatus: result[2],
        createdOn: result[3],
        modifiedOn: result[4]
      }
      res.send(response);
    })
    .catch(function(error) {
      console.log(error);
      res.send(error);
    });
};

//----------RFP Functions--------------
//Get RFP Details
const getRFPDetails = function(tenderID, requesterAddress, res) {
  RPFContract.deployed().then(function(instance) {
    return instance.getRFPDetails(tenderID, {from: requestorAddress});
  }).then(result => {
    console.log("Fetching RFP Details...");
    var response = result;
    res.send(response); 
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//Publish RFP Details
const publishRFP = function(tenderID, requesterAddress, res) {
  RPFContract.deployed().then(function(instance) {
    return instance.publishRFP(tenderID,{from: requestorAddress});
  }).then(result => {
    console.log("Publishing RFP...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//Edit RFP Details
const editRFPDetails = function(tenderID, requesterAddress, res) {
  RPFContract.deployed().then(function(instance) {
    return instance.editRFPDetails(tenderID,{from: requestorAddress});
  }).then(result => {
    console.log("Updating RFP Details...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//------Bidding Functions---------
//Create a bid
const createBid = function(tenderID, requesterAddress, res) {
  BidContract.deployed().then(function(instance) {
    return instance.createBid(tenderID, bidID, {from: requestorAddress});
  }).then(result => {
    console.log("Creating a Bid...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//Fetching Bid Details
const fetchBid = function(bidID, requesterAddress, res) {
  BidContract.deployed().then(function(instance) {
    return instance.fetchBid(bidID,{from: requestorAddress});
  }).then(result => {
    console.log("Fetching Bid Details...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//Reveal Bid
const revealBid = function(bidID, requesterAddress, res) {
  BidContract.deployed().then(function(instance) {
    return instance.revealBid(bidID,{from: requestorAddress});
  }).then(result => {
    console.log("Revealing Bid Details...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//Withdraw Bid
const withdrawBid = function(tenderID, requesterAddress, res) {
  BidContract.deployed().then(function(instance) {
    return instance.withdrawBid(bidID,{from: requestorAddress});
  }).then(result => {
    console.log("Withdrawing the bid...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//------Verifier Functions---------
//Add verifier
const addAuditor = function(_verifierAddress, _validThroughDate, _authorityID, res) {
  VerifierContract.deployed().then(function(instance) {
    return instance.addAuditor(_verifierAddress, _validThroughDate, _authorityID ,{from: requestorAddress});
  }).then(result => {
    console.log("Adding Verifier...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//Add verifier
// const addVerifier = function(_verifierAddress, _validThroughDate, _authorityID, res) {
//   VerifierContract.deployed().then(function(instance) {
//     return instance.addVerifier(_verifierAddress, _validThroughDate, _authorityID ,{from: requestorAddress});
//   }).then(result => {
//     console.log("Adding Verifier...");
//     var response = result;
//     res.send(response);
//   })
//   .catch(function(error) {
//   console.log(error);
//   res.send(error);
// });
// };


//Verify the bid
const verifyRFP = function(tenderID, requesterAddress, res) {
  VerifierContract.deployed().then(function(instance) {
    return instance.verifyRFP(tenderID ,{from: requestorAddress});
  }).then(result => {
    console.log("Verifying RFP Details...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

const verifyTenderProgress = function(tenderID, requesterAddress, res) {
  VerifierContract.deployed().then(function(instance) {
    return instance.verifyTenderProgress(tenderID ,{from: requestorAddress});
  }).then(result => {
    console.log("Verifying Tender Progress...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};


//------Voting Functions---------
//Vote for the bid
const voteForBid = function(bidID, requesterAddress, res) {
  VotingContract.deployed().then(function(instance) {
    return instance.voteForBid(bidID ,{from: requestorAddress});
  }).then(result => {
    console.log("Voting for a bid...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};

//publish voting results
const publishVotingResults = function(tenderID, requesterAddress, res) {
  VotingContract.deployed().then(function(instance) {
    return instance.publishVotingResults(tenderID ,{from: requestorAddress});
  }).then(result => {
    console.log("Publishing Voting Results...");
    var response = result;
    res.send(response);
  })
  .catch(function(error) {
  console.log(error);
  res.send(error);
});
};


module.exports = {
  sendDocumentForVerification,
  addVerifier,
  addPublisher,
  isPublisher,
  verifyDocument,
  rejectDocument,
  getDocumentByDocHash
};
