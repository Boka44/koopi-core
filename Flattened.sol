

// Sources flattened with hardhat v2.19.2 https://hardhat.org

// SPDX-License-Identifier: MIT

// File contracts/libraries/Context.sol

// Original license: SPDX_License_Identifier: MIT

// File @openzeppelin/contracts/utils/Context.sol@v4.0.0

pragma solidity 0.8.20;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


// File contracts/libraries/Ownable.sol

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity 0.8.20;
/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File contracts/interfaces/IERC20.sol

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (interfaces/IERC20.sol)

pragma solidity 0.8.20;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// File contracts/RevShare.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity 0.8.20;
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
