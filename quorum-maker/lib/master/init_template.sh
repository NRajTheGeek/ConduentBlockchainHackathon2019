#!/bin/bash

# echo "[*] Cleaning up temporary data directories for master node"
cp -r node/qdata/keystore .
cp node/qdata/geth/nodekey .
cp node/qdata/*.properties .
cp node/qdata/*.mv.db .

cp node/qdata/static-nodes.json .
rm -rf node/qdata
mkdir -p node/qdata/gethLogs
mkdir -p node/qdata/constellationLogs

# echo "[*] Configuring master node"
mkdir -p node/qdata/{keystore,geth}
mv keystore node/qdata/
mv nodekey node/qdata/geth/
mv static-nodes.json node/qdata/
mv *.properties node/qdata/
mv *.mv.db node/qdata

cd node/
geth --datadir qdata init genesis.json 2>> /dev/null

