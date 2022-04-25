// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenBlack is ERC20{
    address _owner;
    constructor(uint256 initialSupply) ERC20("TokenBlack", "TB"){
        _owner = msg.sender;
        _mint(msg.sender, initialSupply*10**18);
    }

    function mintTokens(uint256 amount, address to) public {
        require(msg.sender == _owner);
        _mint(to, amount * 10**18);
    }
}