// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    IERC20 public token;
    address public owner;

    struct Stake {
        uint256 amount;
        uint256 timestamp;
    }

    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    constructor(IERC20 _token) {
        token = _token;
        owner = msg.sender;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        token.transferFrom(msg.sender, address(this), amount);

        stakes[msg.sender].amount += amount;
        stakes[msg.sender].timestamp = block.timestamp;

        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No staked amount");

        uint256 amountToUnstake = userStake.amount;
        stakes[msg.sender].amount = 0;

        token.transfer(msg.sender, amountToUnstake);

        emit Unstaked(msg.sender, amountToUnstake);
    }

    function getStakedAmount(address user) external view returns (uint256) {
        return stakes[user].amount;
    }
}