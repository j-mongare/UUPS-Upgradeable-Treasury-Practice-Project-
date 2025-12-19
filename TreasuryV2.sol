//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./TreasuryV1.sol";

//@title TreasuryV2

contract TreasuryV2 is TreasuryV1{
    bool public paused; // new variable (appended)

    uint256[47]private __gap;

    //===========Reinitializer(v2)=================

    function initializeV2() public onlyOwner reinitializer(2){

        paused = false;

    }
    //==================modifiers/logic=======================

    //@notice modofier that blockc withdrawals when paused

    modifier whenNotPaused(){
        require (!paused, " Treasury Paused");_;
        }

        //==============Pause Management===============
      function Pause() external onlyOwner {
        

        paused = true;  
    }
     function unpause() external onlyOwner{
        paused = false;
    }
    
    
    //@DEV Updated withdrawal logic

    function withdraw (uint256 amount ) external virtual override whenNotPaused onlyOwner{
        
        require (amount <= totalAssets, " Insufficient Funds");
        require (amount > 0, " zero amount");

        totalAssets -= amount;

       (bool ok, ) = withdrawalAddr.call { value: amount}("");
       require (ok, " Tranfer Fialed");

       emit Withdrawn(msg.sender, amount);
    
    }
   


    }
