// 'use strict'

const Web3 = require("web3");
const contract = require("truffle-contract");
const path = require("path");
const fs = require("fs");

// let KYCContractABI = require(path.join(
//   __dirname,
//   "../../truffle/build/contracts/KYC.json"
// ));

let RFPContractABI = require(path.join(
  __dirname,
  "../../truffle/build/contracts/RFP.json"
));

// let web3Url = "http://localhost:22000";

var intiateRFP = async (req, res, next) => {

    var requesterAddress = req.body.requesterAddress;
    var tenderID = req.body.tenderID;
    console.log("Publishing RFP...");

    let provider = new Web3.providers.HttpProvider("http://localhost:22000");      
    const web3 = new Web3(provider);       
    const RFPContract = web3.eth.contract(RFPContractABI.abi);
    console.log(requesterAddress);
    var conAddress;
    await RFPContract.new(
        {
          data: RFPContract.bytecode,
          from: requesterAddress,
          gas: 3500000
        },
        async (err, contract) => {
          if (err) {
            console.log(`Error creating contract ${err}`);
          } else {
            if (!contract.address) {
                console.log(
                "Contract transaction send: TransactionHash: " +
                  contract.transactionHash +
                  " waiting to be mined..."
              );
            } else {
                conAddress = contract.address;
                console.log(
                `Contract mined! Address: ${
                  contract.address
                }, tx count is ${web3.eth.getTransactionCount(account)}`
              );
              
            }
        }
    }) 
    res.send(conAddress);
  
}
module.exports = {
    intiateRFP
};