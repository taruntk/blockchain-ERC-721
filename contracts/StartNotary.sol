// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract StarNotary is ERC721 {

    struct Star {
        string name;
        string symbol;
    }

    mapping(uint256 => Star) public tokenIdToStarInfo;
    mapping(uint256 => uint256) public starsForSale;

    constructor () ERC721("StarToken", "STK") { }

    
    // Create Star using the Struct
    function createStar(string memory _name, string memory _symbol, uint256 _tokenId) public {
        Star memory newStar = Star(_name, _symbol);
        tokenIdToStarInfo[_tokenId] = newStar;
        _mint(msg.sender, _tokenId);
    }

    // Putting an Star for sale (Adding the star tokenid into the mapping starsForSale, first verify that the sender is the owner)
    function putStarUpForSale(uint256 _tokenId, uint256 _price) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't sale the Star you don't owned");
        starsForSale[_tokenId] = _price;
    }

    function buyStar(uint256 _tokenId) public  payable {
        require(starsForSale[_tokenId] > 0, "The Star should be up for sale");
        uint256 starCost = starsForSale[_tokenId];
        address ownerAddress = ownerOf(_tokenId);
        require(msg.value >= starCost, "You need to have enough Ether");
        _transfer(ownerAddress, msg.sender, _tokenId);
        payable(ownerAddress).transfer(starCost);
        if(msg.value > starCost) {
            payable(msg.sender).transfer(msg.value - starCost);
        }
    }

    // Implement Task 1 lookUptokenIdToStarInfo
    function lookUptokenIdToStarInfo (uint _tokenId) public view returns (string memory) {
        return tokenIdToStarInfo[_tokenId].name;
    }

    function lookUptokenIdToStarSymbol (uint _tokenId) public view returns (string memory) {
        return tokenIdToStarInfo[_tokenId].symbol;
    }

    // Implement Task 1 Exchange Stars function
    function exchangeStars(uint256 _tokenId1, uint256 _tokenId2) public {
        address ownerAddress1 = ownerOf(_tokenId1);
        address ownerAddress2 = ownerOf(_tokenId2);
        require((ownerAddress1 == msg.sender || ownerAddress2 == msg.sender), "Exchange not allowed if you don't own one of the exchanged stars");
        //1. Passing to star tokenId you will need to check if the owner of _tokenId1 or _tokenId2 is the sender
        //2. You don't have to check for the price of the token (star)
        //3. Get the owner of the two tokens (ownerOf(_tokenId1), ownerOf(_tokenId1)
        //4. Use _transferFrom function to exchange the tokens.
        _transfer(ownerAddress1, ownerAddress2, _tokenId1);
        _transfer(ownerAddress2, ownerAddress1, _tokenId2);
    }

    // Implement Task 1 Transfer Stars
    function transferStar(address _to1, uint256 _tokenId) public {
        require(ownerOf(_tokenId) == msg.sender, "You can't transfer the Star you don't own");
        //1. Check if the sender is the ownerOf(_tokenId)
        _transfer(msg.sender, _to1, _tokenId);
        //2. Use the transferFrom(from, to, tokenId); function to transfer the Star
    }

}