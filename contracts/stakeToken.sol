// SPDX-License-Identifier: UNLICENSED

// declare solidity version 
pragma solidity ^0.5.0;

// import SafeMath, ERC20, & Ownable
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";

/**
*@title Staking Token (STK)
* @author Michelle David
* @notice implimenting a staking vesting contract 
 */

contract MichToken is ERC20, Ownable {
    using SafeMath for uint256;
  
constructor(address _owner, uint256 _amount) public {
    _mint(_owner, _amount);
}

address[] internal stakers; 
 
 // @notice method to check if an address is a staker 
 function isStaker(address _address) public view returns(bool, uint256) {
for(uint256 x = 0; x < stakers.length; x += 1) {
  if(_address == stakers[x]) return(true, x); 
}
return (false, 0);

 }

// @notice method to add a staker 
 function addStakers(address _isStaker) public {
     (bool _isStaker,) = isStaker(_isStaker);
     if (!_isStaker) stakers.push(_isStaker);
 }

 // @notice method to remove a staker
 function removeStaker(address _isStaker) public {
     (bool _isStaker, uint256 x) = isStaker(_isStaker);
     if (_isStaker) {
         stakers[x] = stakers[stakers.length -1];
         stakers.pop();
     }
 }

 // stakes for each staker
 mapping(address => uint256) internal stakes; 

//@notice method to retieve stake for a staker
//@param _isStaker the staker to retrieve the stake for
//@return uint256 the amount of wei staked
function retrieveStake(address _isStaker) public view returns(uint256) {
    return stakes[_isStaker];
}

// @notice a method to the total stakes of stakers 
function totalStakes() public view returns(uint256) {
    uint256 _totalStakers = 0;
    for(uint256 x = o; x < stakers.length; x += 1) {
        _totalStakers = _totalStakers.add(stakes[stakers[x]])
    }
    return _totalStakers;
}
// @notice for a staker to create a stake
// @param _stake size of the stake to be created 
function createStaking(uint256 _stake) public {
    _burn(msg.sender, _stake);
    if(stakes[msg.sender == 0]) addStaker(msg.sender);
    stakes[msg.sender] = stakes[msg.sender].add(_stake);
}
// @notice method for a staker to remove a stake
//@param _stake size of the stake to be remove
function removeStake(uint256 _stake) public {
    stakes[msg.sender] = stakes[msg.sender].sub(_stake);
    if (stakes[msg.sender == 0]) removeStaker(msg.sender);
    _mint(msg.sender, _stake);
} 
// @notice the accumulated reward for each staker
mapping(address => uint256) benefits; 

//@notice method to allow the stakers check their benefits
//@param _staker the staker to check benefit for 
function checkBenefit(address _isStaker) public view returns(uint256) {
    return benefits[_isStaker];
}

//@notice a method to the total benefit from all stakers
//@return uint256 the total benefit of all stakers
function totalBenefit() public view returns(uint256) {
    uint256 _totalBenefit = 0;

    for (uint256 x = 0; x < stakers.length; x += 1) {
        _totalBenefit = _totalBenefit.add(benefit[stakers[x]]);
    }
    return _totalBenefit; 
}

//@notice method that calculate the benefit for each staker 
//@param _isStaker the staker to calculate the benefit for 
function calculateBenefit(address _isStaker) public view returns(uint256){
    return stakes[_isStaker] / 100;
    
}
// @notice a method to distribute rewards to all stakers 
function distributeBenefit() public OnlyOwner {
  for (uint256 x = 0; stakers.length; x += 1) {
      address staker = stakers[x];
      uint256 benefit = calculateBenefit(staker);
      benefits[staker] = benefits[staker].add(benefit);
  }
}
// @notice a method to allow stakers withdraw reward
function withdrawBenefit() public {
    uint256 benefit = benefits[msg.sender];
    benefits[msg.sender] = 0; 
    _mint(msg.sender, benefit); 
}
