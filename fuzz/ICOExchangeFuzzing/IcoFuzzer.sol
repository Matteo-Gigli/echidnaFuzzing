//SPDX-License-Identifier: MIT


pragma solidity ^0.8.4;

import "../../contracts/IcoExchange.sol";
import "../../contracts/IcoToken.sol";
import "node_modules/@crytic/properties/contracts/util/Hevm.sol";



contract IcoFuzzer{

    address icoTokenAddress;
    address payable icoExchange;


    address constant _owner = address(0x20000);

    constructor(){
        icoTokenAddress = address(new ICOToken(10000));
        icoExchange = payable(address(new ICOExchange()));
    }


    //CalculateError
    //CalculateError means, this error and the risk of use this function, should be note to the developer
    function icoToken_checkInitAccess()public{
        ICOExchange(icoExchange).initIcoToken(icoTokenAddress);
        address ownerIcoTokenContract = ICOToken(icoTokenAddress).owner();
        uint allowances = ICOToken(icoTokenAddress).allowance(ownerIcoTokenContract, address(this));
        assert(ICOToken(icoTokenAddress).balanceOf(ownerIcoTokenContract) == allowances);
    }



    //Passed
    function icoToken_checkBuyFunction_NotAccessibleFromOwner(uint amount)external payable{
        ICOExchange(icoExchange).buyIcoTokens{value: 0.1 ether}(100);
        address ownerIcoTokenContract = ICOToken(icoTokenAddress).owner();
        uint ownerIcoTokenContractBalance = ICOToken(icoTokenAddress).balanceOf(ownerIcoTokenContract);
        assert(ownerIcoTokenContractBalance == 10000);
    }



    //Passed
    function icoToken_checkBuyFunction_AccessibleFromAnybody(uint amount)external payable{
        hevm.prank(_owner);
        ICOExchange(icoExchange).buyIcoTokens{value: 0.1 ether}(100);
        address ownerIcoTokenContract = ICOToken(icoTokenAddress).owner();
        uint newSenderBalance = ICOToken(icoTokenAddress).balanceOf(_owner);
        uint ownerIcoTokenContractBalance = ICOToken(icoTokenAddress).balanceOf(ownerIcoTokenContract);
        assert(ownerIcoTokenContractBalance == 9900);
        assert(newSenderBalance == 100);
    }

}
