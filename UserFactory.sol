// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./UserPass.sol";

contract UserFactory {

    address immutable admin;
    address[] public creators;
    uint40 numCreators = 1;
    mapping(uint40 => address) public IDToAddress;
    mapping(address => uint40) public AddressToID;
    mapping(address => creatorData) public AddressToCreatorData;

    uint40 IDCounter = 1;

    struct creatorData {
        address creatorAddress;
        uint40 ID;
        string name;
        string description;
        address bronzeAddress;
        address silveraddress;
        address goldAddress;

    }

    struct videoData {
        string name;
        string videoURL;
        string description;
        uint8 tier;  //0 bronze, 1 silver, 2 gold
        // string previewVideoImage; //??maybe
    }

    mapping(address => videoData[]) userVideoData;



    constructor(){
        admin = msg.sender;
    }

    function makeCreator(string memory _creatorName, string memory _description, uint _bronzePrice, uint _silverPrice, uint _goldPrice ) public  {

        uint40 IDCounter_ = IDCounter;

        
        CreatorPass bronzeNFT = new CreatorPass(_creatorName, msg.sender, _bronzePrice);
        CreatorPass silverNFT = new CreatorPass(_creatorName, msg.sender, _silverPrice);
        CreatorPass goldNFT = new CreatorPass(_creatorName, msg.sender, _goldPrice);

        creatorData memory creatorData_ = creatorData(
            msg.sender,
            IDCounter,
            _creatorName,
            _description,
            address(bronzeNFT),
            address(silverNFT),
            address(goldNFT)
        );

        AddressToCreatorData[msg.sender] = creatorData_;

        IDToAddress[IDCounter_] = msg.sender;
        AddressToID[msg.sender] = IDCounter_;

        creators.push(msg.sender);

        ++numCreators;

    }

    function addVideo(string memory _name, string memory _videoURL, string memory _description, uint8 _tier) public {
        videoData memory videoData_ = videoData(_name, _videoURL, _description, _tier);

        userVideoData[msg.sender].push(videoData_);
    }

}
