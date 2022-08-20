// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Ownable.sol";

contract Reward is Ownable {
    
    struct RewardDetail{
        uint256 rewardAmount;
        uint256 lastClaim;
    }
    mapping (address => RewardDetail) private RewardDetails;
    address private operator; 

    modifier onlyOperator{
        require (msg.sender == operator, "only operator");
        _;
    }
    constructor(address _operator){
        operator = _operator;
    }
    function setOperator(address _operator) public onlyOwner{
        operator = _operator;
    }
    function getOperator() public view returns(address){
        return operator ;
    }
    function addReward(address _client) public payable onlyOperator{
        RewardDetails[_client].rewardAmount += msg.value;
    }
    function claimReward(uint256 _amount) public {
        require(RewardDetails[msg.sender].rewardAmount >= _amount, "Not enough rewards");
        RewardDetails[msg.sender].rewardAmount -= _amount;
        RewardDetails[msg.sender].lastClaim = block.timestamp;

        payable(msg.sender).transfer(_amount);
    }
    function getBalance() public view returns(uint256 balance){
        return RewardDetails[msg.sender].rewardAmount;
    }

    function switchAddressBalance(address source, address destination) public onlyOwner{
        RewardDetails[destination].rewardAmount = RewardDetails[source].rewardAmount;
        RewardDetails[destination].lastClaim = RewardDetails[source].lastClaim;
        RewardDetails[source].rewardAmount=0;
        RewardDetails[source].lastClaim=0;
    }
    function getBalanceByOperator(address _client) public view returns(uint256 balance){
        return RewardDetails[_client].rewardAmount;
    }
    receive()external payable{}
    fallback()external payable{}
}
