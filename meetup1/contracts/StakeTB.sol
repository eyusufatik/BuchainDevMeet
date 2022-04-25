// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract StakeTB{
    IERC20 _token;
    mapping(address => stakeInfo) _addressToStakeInfo;
    uint256 _rewardRatePerSecond = 1 * 10**16;


    struct stakeInfo{
        uint256 amount;
        uint256 startTime;
    }

    constructor(address token) {
        _token = IERC20(token);
    }

    function stake(uint256 amount) public {
        stakeInfo memory oldInfo = _addressToStakeInfo[msg.sender];
        if (oldInfo.amount > 0){
            uint256 rewardAmount = calcReward(oldInfo);
            _token.transfer(msg.sender, rewardAmount);
        }
        // emit event
        _token.transferFrom(msg.sender, address(this), amount);
        stakeInfo memory newInfo = stakeInfo(amount + oldInfo.amount, block.timestamp);
        _addressToStakeInfo[msg.sender] = newInfo;
    }

    function harvest() public {
        stakeInfo memory info = _addressToStakeInfo[msg.sender];
        uint256 rewardAmount = calcReward(info);
        _token.transfer(msg.sender, rewardAmount);
    }

    function calcReward(stakeInfo memory info) internal view returns(uint256){
        return info.amount * _rewardRatePerSecond * (block.timestamp - info.startTime) / 60;
    }

    function unstake() public {
        stakeInfo memory info = _addressToStakeInfo[msg.sender];
        require(info.amount > 0, "You haven't staked any coins yet.");

        _token.transfer(msg.sender, info.amount + calcReward(info));
    }

    function stakedAmount() public view returns(uint256){
        return _addressToStakeInfo[msg.sender].amount;
    }
}