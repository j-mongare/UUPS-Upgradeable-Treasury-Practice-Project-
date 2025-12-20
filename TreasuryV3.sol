//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "./TreasuryV2.sol";

//@title TreasuryV3

contract TreasuryV3 is TreasuryV2{
    //@notice production level upgradeable contracts utilize basis points to avoind rounding ambiguity
    //  10 = 0.1%,
    // 10_000 = 100%,
     // 100 = 1%

    uint256 public feeBps; // FEES IN BASIS POINTS 

    uint256[46] private __gap;

    //================ReinitializerV3=================

    function initializeV3()public onlyOwner reinitializer(3){
        feeBps = 1_000; // 10%
    }
    //===========Updated Logic===============
    //@notice withdrawal logic now includes fees, which remains in the treasury, a % of amount withdrawn

    function withdraw(uint256 amount) external onlyOwner  override whenNotPaused{
        require (amount > 0, " Zero Amount");
        require (amount <= totalAssets, "Insufficient Funds");

        uint256 fee= (feeBps * amount)/1_000; // a 10% fee is levied on withdrawals
        uint256 payout = amount - fee; // amount transferred to the caller

        totalAssets -= amount;
        (bool ok,) = withdrawalAddr.call{value: payout}("");
        require (ok, " Transfer Failed");

        emit Withdrawn(msg.sender, payout);

    }
    function updateFees(uint256 _newFeeBps)external onlyOwner{
        require (_newFeeBps <= 2_000, " Fee Too High"); // 20% max
        feeBps= _newFeeBps;
    }

}
