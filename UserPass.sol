// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CreatorPass is ERC721, Ownable {
    

    address immutable creatorAddr;
    uint256 price;
    string level;
    uint256 tokenId = 1;



    struct subscriptionData {
        uint subscriptionLength;
        uint startDate;
        uint endDate;
    }

    mapping(uint => subscriptionData) tokenIDData;


    constructor(string memory _name,address _creatorAddr,uint _price )
    ERC721(_name){
        creatorAddr = _creatorAddr;
        price = _price;
    }

    function subscribe(uint8 _subscriptionLength) public payable {

        uint month = 30 days;

        subscriptionData memory subscriptionData_;

        //1 month
        if(_subscriptionLength == 0) {
            require(msg.value == price);
            subscriptionData_ = subscriptionData(
            month,
            block.timestamp,
            block.timestamp + month);
        }

        //3 months
        if(_subscriptionLength == 1) {
            require(msg.value == price * 3);
            subscriptionData_ = subscriptionData(
            month * 3,
            block.timestamp,
            block.timestamp + month * 3);
        }

        //6 months
        if(_subscriptionLength == 2) {
            require(msg.value == price * 6);
            subscriptionData_ = subscriptionData(
            month * 6,
            block.timestamp,
            block.timestamp + month * 6);
        }

        //1 year
        if(_subscriptionLength == 3) {
            require(msg.value == price * 12);
            subscriptionData_ = subscriptionData(
            month * 12,
            block.timestamp,
            block.timestamp + month * 12);
        }

        tokenIDData[tokenId] = subscriptionData_;

        _safeMint(msg.sender, tokenId);

        ++tokenId;
    }

    function burnPasses() public {
        uint tokenId_ = tokenId;
        for(uint i; i < tokenId_; i++) {
            if(tokenIDData[i].endDate <= block.timestamp) {
                _burn(i);
            }
        }
    }



    function tokenURI(uint256 id) public view override returns (string memory link){
    }

}