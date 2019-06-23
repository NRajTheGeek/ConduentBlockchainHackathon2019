const KYCContract = artifacts.require("KYC");
const RFPContract = artifacts.require("RFP");
const KYCTypesContract = artifacts.require("KYCTypes");
const ReviewContract = artifacts.require("Review");
const UsersContract = artifacts.require("Users");
const AuditContract = artifacts.require("Audit");


module.exports = function(deployer) {
  deployer.deploy(KYCContract);
  deployer.deploy(RFPContract);
  deployer.deploy(KYCTypesContract);
  deployer.deploy(ReviewContract);
  deployer.deploy(UsersContract);
  deployer.deploy(AuditContract);
}
