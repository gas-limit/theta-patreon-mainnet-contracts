// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./UserPass.sol";

/**
 * @title UserFactory
 * @dev A contract for creating and managing user accounts and associated creator passes.
 */
contract UserFactory {

    address immutable admin;
    address[] public creators;
    uint40 numCreators = 1;
    mapping(uint40 => address) public IDToAddress;
    mapping(address => uint40) public AddressToID;
    mapping(address => creatorData) public AddressToCreatorData;

    uint8 IDCounter = 1;

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

    /**
     * @dev Initializes the UserFactory contract and sets the admin address.
     */
    constructor() {
        admin = msg.sender;
    }

    /**
     * @dev Creates a new creator account and associated creator passes.
     * @param _creatorName The name of the creator.
     * @param _description The description of the creator.
     * @param _bronzePrice The price of the bronze subscription pass.
     * @param _silverPrice The price of the silver subscription pass.
     * @param _goldPrice The price of the gold subscription pass.
     */
    function makeCreator(
        string memory _creatorName,
        string memory _description,
        uint _bronzePrice,
        uint _silverPrice,
        uint _goldPrice
    ) public {

        uint8 IDCounter_ = IDCounter;

        // Deploy new CreatorPass contracts
        CreatorPass bronzeNFT = new CreatorPass(_creatorName, msg.sender, _bronzePrice);
        CreatorPass silverNFT = new CreatorPass(_creatorName, msg.sender, _silverPrice);
        CreatorPass goldNFT = new CreatorPass(_creatorName, msg.sender, _goldPrice);

        // Store creator data
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

        // Map ID to address and address to ID
        IDToAddress[IDCounter_] = msg.sender;
        AddressToID[msg.sender] = IDCounter_;

        creators.push(msg.sender);

        ++numCreators;
    }

    /**
     * @dev Adds a video to the user's account.
     * @param _name The name of the video.
     * @param _videoURL The URL of the video.
     * @param _description The description of the video.
     * @param _tier The tier of the video (0 for bronze, 1 for silver, 2 for gold).
     */
    function addVideo(
        string memory _name,
        string memory _videoURL,
        string memory _description,
        uint8 _tier
    ) public {
        videoData memory videoData_ = videoData(_name, _videoURL, _description, _tier);

        userVideoData[msg.sender].push(videoData_);
    }

}
