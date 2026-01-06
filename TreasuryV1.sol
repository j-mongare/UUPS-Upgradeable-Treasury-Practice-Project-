//SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

//@title TresuryVI

contract TreasuryV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable{

    //========Storage=============
    //@notice storage vars are merely described here to help with compiliation
    // the proxy holds the storage
 
    uint256 public totalAssets; // total ETH collected
    address public withdrawalAddr; // address where withdrawals are sent
  
    //@notice storage gap for appending new variables in the future
    uint256[48]private __gap;

    event Deposited(address indexed user, uint256 amount);
    event Withdrawn( address indexed user, uint256 amount);

    //@notice this permanently bricks the logic SC
    // IT sets _initialized = max(uint64)
    // this ensures the logic contract becomes unusable forever

   constructor (){ _disableInitializers();}

    //@dev initializers replace constructors in upgradeable contract patterns

    function initialize(address _owner, address _withdrawalAddr ) public initializer{

        __Ownable_init(_owner);
        __UUPSUpgradeable_init();
          
       
        withdrawalAddr= _withdrawalAddr;
        totalAssets = 1_000 ether;

       
    } 

    //==============Business Logic=====================
    function deposit() external payable {
        require (msg.value > 0, " Deposit Must be greater than 0");
        totalAssets += msg.value;

        emit Deposited(msg.sender, msg.value);

    }
    function withdraw (uint256 amount) external onlyOwner virtual {
        // @notice use of CEI pattern to avoid reentrancy/recursive calls

             // checks
        require (msg.sender == owner(), " Not Owner");
        require (amount <= totalAssets, " Insufficient Funds");

           // effects
        totalAssets -= amount;

          // Interactions
       (bool ok, ) = withdrawalAddr.call {value:amount}("");
       require (ok, " Transaction failed");

       emit Withdrawn(msg.sender, amount);
    }
   //=========UUPS Authorization================

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner{}

    



}



