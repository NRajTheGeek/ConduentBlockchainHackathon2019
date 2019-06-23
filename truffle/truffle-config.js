module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 22000,
      network_id: "*", // Match any network id,
      gasPrice: 0,
      gas: 500000000
    }
  },
  compilers: {
    solc: {
      settings: {
        optimizer: {
          enabled: true, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  }
};
