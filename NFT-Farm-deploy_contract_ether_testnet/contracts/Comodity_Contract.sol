// contracts/Comodity_contract.sol
// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;

/** 
 * @title Crop_contract
 * @dev Implements crop contract between seller and buyer 
 */

contract ComodityContract {
    enum contractStatus {activated, deactivated, hold} 
    
    struct Crop {
        string name; 
        string expirationDate;  // YYYYMMDD 
        uint128 price;          // price per unit
        uint128 unit_kg;        // unit in kg | 1 ton = 1000 kg
        uint128 unit_total;   
        uint128 unit_sold;
    }
    
    struct Farm {
        string name;   // ENG name of Farm
        contractStatus status;
    }
    
    struct Buyer{
        address addr;               // comodity_NFT owner addr
        uint128 unit_bought;
        uint128 unit_request; // weight is accumulated by delegation
        uint256 ComodityNFTAddress; // comodity_NFT - tokenID
    }
    
    address public owner;
    Crop Crop_Meta;
    Farm Farm_Meta;
    
    uint32 buyID; 
    mapping (uint32 => Buyer) buyers;
    
    constructor(string memory name, string memory expirationDate, string memory farm_name,
        uint128 price, uint128 unit_kg, uint128 unit_total) {
        owner = msg.sender;
        Crop_Meta.name = name;
        Crop_Meta.expirationDate = expirationDate;
        Crop_Meta.price = price; 
        Crop_Meta.unit_kg = unit_kg;
        Crop_Meta.unit_total = unit_total;
        Crop_Meta.unit_sold = 0;

        Farm_Meta.name = farm_name;
        Farm_Meta.status = contractStatus.activated;
        
        buyID = 0; 
    }
    
    function addBuyer(uint128 buyAmount, uint256 ComodityNFTAddress)
        public
        returns (uint32)
    {
        require(buyAmount > 0);
        require(buyAmount < Crop_Meta.unit_total - Crop_Meta.unit_sold);
        
        uint32 currentID = buyID;
        buyers[currentID] = Buyer(msg.sender, 0, buyAmount, ComodityNFTAddress);
        
        buyID = buyID + 1;
        return currentID; // return buyer NUM
    }
    
    
    function approveBuyer(uint128 approveAmount, uint32 requestID)
        public
        returns (bool)
    {
        require(approveAmount > 0);
        require(approveAmount < Crop_Meta.unit_total - Crop_Meta.unit_sold);
        require(requestID <= buyID);

        Crop_Meta.unit_sold = Crop_Meta.unit_sold + approveAmount;
        
        buyers[requestID].unit_bought = approveAmount;
        
        return true; // return buyer NUM
    }
    
    
    function checkAmount(uint128 buyAmount)
        public view
        returns (bool)
    {
        return buyAmount < (Crop_Meta.unit_total - Crop_Meta.unit_sold);
    }
}