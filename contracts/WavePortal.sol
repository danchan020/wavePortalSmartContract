// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    
    mapping(address => uint) public userToWave;

    constructor(){
        console.log("making a wave smart contract");
    }

    function updateWalletWaves(uint newWaves) public {
        userToWave[msg.sender] = newWaves;
    }

    function wave() public {
        totalWaves += 1;
        console.log("%s has waved!", msg.sender);
        updateWalletWaves();
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }


}
