// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "./UserPass.sol";
import "./UserFactory.sol";

contract Periphery {

    address factoryAddress;

    constructor(address _factoryAddress) {
        factoryAddress = _factoryAddress;
    }

    

}

