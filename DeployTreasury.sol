//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "./TreasuryV1.sol";

//@title DeployTreasury.......sets TreasuryV1.sol as implementation 
//@ notice this is the proxy contract, where storage lives and the interface users use to access its logic contracts
// under the hood, th proxy utilizes delegatecall to access implementation logic

contract DeployTreasury {

ERC1967Proxy public proxy;

    constructor (address implementation){
       
        bytes memory data = abi.encodeWithSignature("initialize()");
       proxy = new ERC1967Proxy (address(implementation), data);

        // proxy is deployed
        // initialize() runs once
        // proxy now points to TreasuryV1.sol
        // users interact with proxy address + TreasuryV1 abi
    }
}




