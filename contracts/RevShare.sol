// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IERC20.sol";
import "./libraries/Ownable.sol";

contract RevShare {
    address gasToken;

    Tier[] tiers;

    struct Tier {
        uint256 tier;
        uint256 requiredBalanceMin;
        uint256 rewardPercentage;
    }

    struct User {
        address user;
        uint256 tier;
    }
    
    mapping(address => mapping(address => uint256)) public userBalances;

    constructor(address _gasToken) {
        _owner = msg.sender;
        gasToken = _gasToken;
    }

    function checkBalance(address user, address token) external view returns (uint256) {
        return userBalances[user][token];
    }

    function claimRevenue(address token, uint256 amount) external {
        // msg.sender can claim their userBalance 
        if (userBalances[msg.sender][token] >= amount) {
            userBalances[msg.sender][token] -= amount;
            if(token == gasToken) {
                payable(msg.sender).transfer(amount);
            } else {
                IERC20(token).transfer( msg.sender, amount);
            }
        }
    } 

    function approveBalance(address user, address token, uint256 amount) external onlyOwner {
        userBalances[user][token] += amount;
    }

    function addTier(uint256 tier, uint256 requiredBalanceMin, uint256 rewardPercentage) external onlyOwner{
        Tier memory newTier = Tier(tier, requiredBalanceMin, rewardPercentage);
        tiers.push(newTier);
    }

    function removeTier(uint256 tier) external onlyOwner {
        delete tiers[tier];
    }

    function updateTier(uint256 tier, uint256 requiredBalanceMin, uint256 rewardPercentage) external onlyOwner {
        tiers[tier].requiredBalanceMin = requiredBalanceMin;
        tiers[tier].rewardPercentage = rewardPercentage;
    }

    // function getTierPercentage(address user, address token) external view returns (uint256) {
    //     uint256 userBalance = IERC20(token).balanceOf(user);
    //     uint256 index = 0;
    //     uint256 currentMinBalance = 0;
    //     for (uint256 i = 0; i < tiers.length; i++) {
    //         if (userBalance >= tiers[i].requiredBalanceMin) {
    //             if (tiers[i].requiredBalanceMin < userBalance && tiers[i].requiredBalanceMin > currentMinBalance) {
    //                 currentMinBalance = tiers[i].requiredBalanceMin;
    //                 index = i;
    //             }
    //         }
    //     }
    //     return tiers[index].rewardPercentage;
    // }
}
