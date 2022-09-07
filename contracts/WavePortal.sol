// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    // will be used to generate random number
    uint256 private seed;

    
    // do more research on events and structs later
    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver; 
        string message;
        uint256 timestamp;
    }

    // declaring variable waves that lets me store an array of structs
    Wave[] waves;

    // address -> unsigned int mapping, associates address with a number. Stores address with the last time the user waved.
    mapping(address => uint256) public lastWavedAt;

    // payable allows contract to pay people / send eth
    constructor() payable {
        console.log("making a wave smart contract");
        // set initial seed
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        // 1 minute in between limit per wave
        require(
            lastWavedAt[msg.sender] + 1 minutes < block.timestamp,
            "Wait 1m"
        );
        // update current timestamp for waving user
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender, _message);
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate a new seed for user who waves
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        if (seed < 50) {
            console.log("%s won!", msg.sender);
        // declare eth amount and check if amount is available in contract balance
        uint256 prizeAmount = 0.001 ether;
        require(
            prizeAmount <= address(this).balance,
            "Trying to withdraw more money than the contract has."
        );
        // send the money
        (bool success, ) = (msg.sender).call{value: prizeAmount}("");
        // checks success
        require(success, "Failed to withdraw money from contract.");
        }

        //do more reseach on emit
        emit NewWave(msg.sender, block.timestamp, _message);
    }


    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }


}
