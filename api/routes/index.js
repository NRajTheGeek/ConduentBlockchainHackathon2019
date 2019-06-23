// "use strict";

var express = require("express");
var router = express.Router();
var docService = require("../utils/docService");
var contractService = require("../utils/contractService");
var fs = require('fs');
var helper = require("../utils/helper");

router.post("/addPublisher", function(req, res, callback) {
  var publisherAddress = req.body.publisherAddress;
  var senderAddress = req.body.senderAddress;

  contractService.addPublisher(
    publisherAddress,
    senderAddress,
    res
  );
});

router.post("/addVerifier", function(req, res, callback) {
  var verifierAddress = req.body.verifierAddress;
  var senderAddress = req.body.senderAddress;

  contractService.addVerifier(
    verifierAddress,
    senderAddress,
    res
  );
});

router.get("/isPublisher/publisherAddress/:publisherAddress", function(req, res, callback) {
  var publisherAddress = req.params.publisherAddress;

  contractService.isPublisher(
    publisherAddress,
    res
  );
});

router.post("/uploadDocToBePublished", function(req, res, callback) {
  var documentBinary = req.body.document;
  var publisherAddress = req.body.publisherAddress;
  var ownerAddress = req.body.ownerAddress;

  docService.uploadDocumentToIPFS(
    documentBinary,
    publisherAddress,
    ownerAddress,
    res
  );
});

router.get("/generateRSAKeyPair/EthAddress/:EthAddress", async function(req, res, callback) {
  var EthAddress = req.params.EthAddress;
  await helper.generateAndPersistUserCredData(EthAddress, res);
});

router.post("/viewDoc/docHash/:docHash/CID/:CID", function(req, res, callback) {
  var docHash = req.params.docHash;
  var CID = req.params.CID;
  var RSAPrivateKeyPEM = req.body.rsaKeyPem;

  var viewerAddress = req.body.viewerAddress;

  docService.viewDocument(docHash, CID, viewerAddress, RSAPrivateKeyPEM, res);
});

router.get(
  "/queryDocByHash/docHash/:DocumentHash/requesterAddress/:requesterAddress",
  function(req, res, callback) {
    var requesterAddress = req.params.requesterAddress;
    var docHash = req.params.DocumentHash;

    docService.queryDocByHash(docHash, requesterAddress, res);
  }
);

router.post("/shareDocument", function(req, res, callback) {
  var docHash = req.body.documentHash;
  var CID = req.body.shareDocCID;
  var ownerAddress = req.body.ownerAddress;
  var addressToBeSharedWith = req.body.addressToBeSharedWith;

  var RSAPrivateKeyPEM = req.body.rsaKeyPem;

  docService.shareDocumentAccess(
    docHash,
    CID,
    ownerAddress,
    RSAPrivateKeyPEM,
    addressToBeSharedWith,
    res
  );
});

router.post("/sendDocumentForVerification", function(req, res, callback) {
  var docHash = req.body.docHash;
  var ownerAddress = req.body.ownerAddress;
  var publisherAddress = req.body.publisherAddress;
  var DocumentStatus = req.body.DocumentStatus;

  docService.sendDocumentForVerification(
    docHash,
    ownerAddress,
    publisherAddress,
    DocumentStatus,
    res
  );
});

router.post("/verifyDocument", function(req, res, callback) {
  var docHash = req.body.docHash;
  var verifierAddress = req.body.verifierAddress;
  var DocumentStatus = req.body.DocumentStatus;

  docService.verifyDocument(docHash, verifierAddress, DocumentStatus, res);
});

router.post("/rejectDocument", function(req, res, callback) {
  var docHash = req.body.docHash;
  var verifierAddress = req.body.verifierAddress;
  var DocumentStatus = req.body.DocumentStatus;

  docService.rejectDocument(docHash, verifierAddress, DocumentStatus, res);
});

//HealthCheck

router.get("/healthcheck", function(req, res, callback) {
  console.log("Healthcheck called")
  res.end("OK!")  
});

//User Logins

router.post("/login", function(req, res, callback) {
  var userName = req.body.userName;
  var passPhrase = req.body.passPhrase;
  console.log("Login Called")
  res.end("Success");
});

//RFP Processing

router.post("/setRFPDetails", function(req, res, callback) {
  console.log("Setting RFP Details...");
  contractService.setRFPDetails(req.body, res);
  res.send("Success");
});

router.post("/publishRFP", function(req, res, callback) {
  var requesterAddress = req.body.requesterAddress;
  var tenderID = req.body.tenderID;
  console.log("Publishing RFP...");
  contractService.publishRFP(tenderID, requestorAddress, res);
  res.send("Success");
});

router.post("/getRFPDetails", function(req, res, callback) {
  var tenderID = req.body.tenderID;
  console.log("Fetching RFP Details...")
  contractService.getRFPDetails(tenderID, requestorAddress, res);
  res.send("Success");
});

router.post("/getAllTenders", function(req, res, callback) {
  var userName = req.body.username;
  console.log("Fetching All Tenders...");
  var arrayFound = [];
  fs.readFile('users.json', 'utf8', function(err, contents) {
    arrayFound = contents.users.filter(function(user) {
        return user.username == username;
    });
  });
  contractService.getAllTenders(username,arrayFound[0].role,arrayFound[0].Dept,arrayFound[0].Org, requestorAddress, res);
  res.send("Success");
});

router.post("/editRFPDetails", function(req, res, callback) {
  var tenderID = req.body.tenderID;
  console.log("Editing RFP Details...")
  contractService.editRPFDetails(tenderID, requestorAddress, res);
  res.send("Success");
});

//bidding
router.post("/createBid", function(req, res, callback) {
  var bidder_address = req.body.bidder_address;
  var tenderID = req.body.tenderID;
  console.log("Creating Bid...")
  contractService.createBid(tenderID, requestorAddress, res);
  res.send("Success");
});

router.post("/withdrawBid", function(req, res, callback) {
  var bidder_address = req.body.bidder_address;
  var tenderID = req.body.tenderID;
  console.log("Withdrawing Bid...");
  contractService.withdrawBid(tenderID, requestorAddress, res);
  res.send("success");
});

router.post("/fetchBid", function(req, res, callback) {
  var requestorAddress = req.body.requesterAddress;
  var tenderID = req.body.tenderID;
  console.log("Fetching Bid...");
  contractService.fetchBid(tenderID, requestorAddress, res);
  res.send("success");
});

router.post("/revealBid", function(req, res, callback) {
  var bidder_address = req.body.bidder_address;
  var bidID = req.body.bidID;
  console.log("Revealing Bid...");
  contractService.revealBid(bidID, requestorAddress, res);
  res.send("Success");
});

router.post("/logAuditReport", function(req, res, callback) {
  var auditor_address = req.body.auditor_address;
  var tenderID = req.body.tenderID;
  console.log("Logging Audit Report...");
  contractService.logAuditReport(tenderID, auditor_address, res);
  res.send("Success");
});

router.post("/fetchAuditReport", function(req, res, callback) {
  var tenderID = req.body.tenderID;
  console.log("Fetching Audit Report...");
  contractService.fetchAuditReport(tenderID, res);
  res.send("Success");
});

module.exports = router;
