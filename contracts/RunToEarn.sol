// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";

contract RunToEarn {
    RunToEarnToken public rewardToken;

    struct User {
        address wallet;
        uint256 totalDistance; // Total distance run by user
        uint256 lastRewardTime; // Last time rewards were claimed
    }

    mapping(address => User) public users;
    uint256 public rewardRate = 100; // Reward tokens per distance unit (e.g., meter)

    constructor(address _rewardToken) {
        rewardToken = RunToEarnToken(_rewardToken);
    }

    modifier onlyRegistered() {
        require(users[msg.sender].wallet != address(0), "User not registered");
        _;
    }

    function register() external {
        require(users[msg.sender].wallet == address(0), "User already registered");
        users[msg.sender] = User(msg.sender, 0, block.timestamp);
    }

    function trackActivity(uint256 distance) external onlyRegistered {
        users[msg.sender].totalDistance += distance;

        // Calculate and mint rewards
        uint256 rewards = distance * rewardRate;
        rewardToken.mint(msg.sender, rewards);
    }

    function getTotalDistance() external view onlyRegistered returns (uint256) {
        return users[msg.sender].totalDistance;
    }
}
