// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./interfaces/IERC20.sol";
import "./libraries/Ownable.sol";

contract RevShare is Ownable {
    address gasToken;

    Tier[] tiers;

    struct Tier {
        uint256 tier;
        uint256 requiredBalanceMin;
        uint256 rewardPercentage;
    }

    uint256 public snapshot = 0;
    
    mapping(address => mapping(address => uint256)) public userBalances;

    constructor(address _gasToken) Ownable(msg.sender) {
        gasToken = _gasToken;
    }

    event ClaimRevenue(address indexed user, address indexed token, uint256 amount);
    event ApproveBalance(address indexed user, address indexed token, uint256 amount);
    event AddTier(uint256 tier, uint256 requiredBalanceMin, uint256 rewardPercentage);
    event RemoveTier(uint256 index);
    event UpdateTier(uint256 index, uint256 tier, uint256 requiredBalanceMin, uint256 rewardPercentage);
    event IncrementSnapshot(uint256 snapshot);

    function checkBalance(address user, address token) external view returns (uint256) {
        return userBalances[user][token];
    }

    function claimRevenue(address token, uint256 amount) external {
        // msg.sender can claim their userBalance 
        require(userBalances[msg.sender][token] >= amount, "Insufficient balance");

        userBalances[msg.sender][token] -= amount;
        if(token == gasToken) {
            payable(msg.sender).transfer(amount);
        } else {
            IERC20(token).transfer( msg.sender, amount);
        }
        emit ClaimRevenue(msg.sender, token, amount);
    } 

    function approveBalance(address user, address token, uint256 amount) external onlyOwner {
        userBalances[user][token] += amount;
        emit ApproveBalance(user, token, amount);
    }

    function addTier(uint256 tier, uint256 requiredBalanceMin, uint256 rewardPercentage) external onlyOwner{
        Tier memory newTier = Tier(tier, requiredBalanceMin, rewardPercentage);
        tiers.push(newTier);
        emit AddTier(tier, requiredBalanceMin, rewardPercentage);
    }

    function removeTier(uint256 index) external onlyOwner {
        delete tiers[index];
        emit RemoveTier(index);
    }

    function updateTier(uint256 index, uint256 tier, uint256 requiredBalanceMin, uint256 rewardPercentage) external onlyOwner {
        tiers[index].tier = tier;
        tiers[index].requiredBalanceMin = requiredBalanceMin;
        tiers[index].rewardPercentage = rewardPercentage;
        emit UpdateTier(index, tier, requiredBalanceMin, rewardPercentage);  
    }

    function getTier(uint256 index) external view returns (Tier memory) {
        return tiers[index];
    }

    function getTierCount() external view returns (uint256) {
        return tiers.length;
    }

    function incrementSnapshot() external onlyOwner {
        snapshot++;
        emit IncrementSnapshot(snapshot);
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
