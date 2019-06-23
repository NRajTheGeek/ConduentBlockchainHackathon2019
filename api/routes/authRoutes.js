//const mongoose = require('mongoose');
const jwt = require("jsonwebtoken");
const keys = require("../config/keys");
//require('../models/User');
//const UserModel = mongoose.model('user');
const crypto = require("crypto-js");
const fs = require("fs");
const path = require("path");
const logger = require("tracer").colorConsole();
// const utils =require('../utils');
module.exports = app => {
  //---------------------------------------------------------------------------Authenticate User------------------->
  app.post("/authenticateUser", (req, res, next) => {
    //console.log('/authenticateUser.. hit');
    const { username, password } = req.body;
    console.log(`${username},${password}`);
    console.log(path.join(__dirname, "users.txt"));

    fs.readFileSync(path.join(__dirname, "users.txt"), "utf-8", function(
      err,
      contents
    ) {
      console.log(contents);
      var arrayFound = contents.users.filter(function(user) {
        return user.username == username;
      });
      if (arrayFound == []) {
        res
          .status(400)
          .send({ success: false, message: "User doesn't exists!" });
      } else {
        if (arrayFound[0].password == crypto.SHA256(password)) {
          const payload = { userId: username, role: "Government" };
          const token = jwt.sign(payload, keys.jwtSecret, { expiresIn: "1d" });
          //console.log(res);
          res
            .status(200)
            .send({
              success: true,
              message: "Success",
              token: token,
              username: user.username,
              role: "Government"
            });
        } else {
          res.status(400).send({ success: false, message: "Failed" });
        }
      }
    });
  });
  //----------------------------------------------------------------------------------------------------------------
  //--------------------------------------------------------------------------Create New User---------------------->
  // app.post('/createUser',(req,res)=>{
  //     const {username, password, legalname , address, publicKey, publicAddress, phone, role, web3Url} = req.body;
  //     //const emailVerificationHash = crypto.SHA256(email+utils.generateRandomness(1,1000));

  // });
  //----------------------------------------------------------------------------------------------------------------
  //------------------------------------------------------------------------------Get User List-------------------->
  // app.post('/getUser',(req,res,next)=>{
  //     utils.authenticate(req,res,next);
  // },(req,res)=>{
  //     //console.log(`${JSON.stringify(req.decoded)}`);
  //     const {userId} = req.decoded;

  //     UserModel.findOne({_id:userId},(err,user)=>{
  //         if(err){
  //             logger.warn(err);
  //             res.status(400).send({success:false,message:"Connection error!"});
  //         }
  //         if(user){
  //             res.status(200).send({success:true,message:"Success!",data:user});
  //         }else{
  //             res.status(400).send({success:false,message:"User does'nt exist"});
  //         }
  //     })
  // });

  //----------------------------------------------------------------------------------------------------------------
};
