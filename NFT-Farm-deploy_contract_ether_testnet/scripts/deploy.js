// scripts/deploy.js
async function main () {
  // Deploy Comodity_Contract
  const Comodity_Contract = await ethers.getContractFactory('ComodityContract');
  console.log('Deploying Comodity_Contract...');
  const comodity_contract = await Comodity_Contract.deploy("Peach", "2021/10/05", "M-ROBO-FARM",
                                                          2000000, 1000, 10000); // Deploy with contract
  await comodity_contract.deployed();
  console.log('Comodity_Contract deployed to:', comodity_contract.address);
  
  // Deploy Comodity_NFT
  const Comodity_NFT = await ethers.getContractFactory('ComodityNFT');
  console.log('Deploying Comodity_Contract...');
  const comodity_NFT = await Comodity_NFT.deploy(); // Deploy with contract
  await comodity_NFT.deployed();
  console.log('Comodity_Contract deployed to:', comodity_NFT.address);
  
  const fs = require('fs');

  let contract_address = { 
      Comodity_NFT: comodity_contract.address,
      Comodity_Contract: comodity_NFT.address
  };
  let data = JSON.stringify(contract_address, null, 2);
  console.log(data);

  'use strict';
  fs.writeFileSync('public/assets/contract/contract-address.json', data);
  }

main()
  .then(() => process.exit(0))
  .catch(error => {
    console.error(error);
    process.exit(1);
  });