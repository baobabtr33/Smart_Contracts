// contracts/Comodity_NFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ComodityNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("ComodityNFT", "COM") {}

    function makeContract(address buyer, string memory infos)
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 contractId = _tokenIds.current();
        _mint(buyer, contractId);
        _setTokenURI(contractId, infos);

        return contractId;
    }
}
