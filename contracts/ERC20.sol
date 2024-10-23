// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RunToEarnToken is ERC20, Ownable {
    constructor(address initialOwner) ERC20("RunToEarn", "RTE") Ownable(initialOwner){
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }

    struct User {
        address wallet;
        uint256 totalDistance; 
        uint256 lastRewardTime; 
    }

    mapping(address => User) public users;

    modifier onlyRegistered() {
        require(users[msg.sender].wallet != address(0), "User not registered");
        _;
    }

    function register() external {
        require(users[msg.sender].wallet == address(0), "User already registered");
        users[msg.sender] = User(msg.sender, 0, block.timestamp);
    }

    function mint(address to, uint256 distance) public onlyOwner {
        require(distance > 0, "Distance must be greater than zero");
        users[msg.sender].totalDistance += distance;
        _mint(to, distance);
    }

    function getTotalDistance() external view onlyRegistered returns (uint256) {
        return users[msg.sender].totalDistance;
    }
}
