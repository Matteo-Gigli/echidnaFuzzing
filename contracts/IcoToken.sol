//SPDX-License-Identifier: MIT


import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";

pragma solidity ^0.8.4;


contract ICOToken is ERC20, Ownable{


    constructor(uint supply)ERC20("ICOToken", "ICT"){
        _mint(owner(), supply);
    }



    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        require(to != address(0), "0 address is not admitted");
        super._transfer(from, to, amount);
    }
}
