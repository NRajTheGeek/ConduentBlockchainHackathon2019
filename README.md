# Note: This Code is dedicated to blockchain hackathon hosted by Conduent Hyderabad India in 2019.

# e-Procurement On Blockchain

## Instarctions to run the App

## Project Root
contains the ```api``` folder which is the NodeJS server.
the ```quorum-maker``` contains the quorum blockchain creator utility.
The IPFS contains the docker-compose file for the IPFS docker cluster utility.

## Hoe to run:
Step1: start all three the quorum nodes
    I) OrganizationChainNode
    II)UserRegisterationNode
    III) VANode
    
### to start quorum-maker folder contains a directory by each name.
from within the directory run the 
```
./start.sh
```
script and the cluster will work.

### from IPFS run
```
docker-compose up -d
````

### for NodeJS app
frpom project root run
```
npm start
```

### for React App
from project root goto the www and run
```
npm start
```
