//SPDX-License-Identifier: MIT


import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./IcoToken.sol";


pragma solidity ^0.8.4;


contract ICOExchange is Ownable, ReentrancyGuard{

    ICOToken private icoToken;


    constructor(){

    }


    function initIcoToken(address icoTokenAddress)public onlyOwner{
        icoToken = ICOToken(icoTokenAddress);
        icoToken.increaseAllowance(address(this), icoToken.balanceOf(icoToken.owner()));
    }



    function buyIcoTokens(uint amount)external payable nonReentrant{
        require(
            msg.sender != owner() &&
            msg.sender != icoToken.owner(),
            "Admin: Can't buy tokens!"
            );
        require(amount > 0, "Can't have this amount of tokens!");
        uint unitaryTokenCost = 0.001 ether;
        require(icoToken.balanceOf(msg.sender) == 0, "Already bought your tokens!");
        require(msg.value == unitaryTokenCost * amount, "Set Right Price in Wei!");
        uint decimalsAmount = amount *10**18;
        icoToken.transferFrom(icoToken.owner(), msg.sender, decimalsAmount);
    }



    function claimEth()public onlyOwner nonReentrant{
        payable(owner()).transfer(address(this).balance);
    }



    receive()external payable {

    }


}

