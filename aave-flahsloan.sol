// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.6;

/*
1-Have the interfaces.
2-Function that calls the method inside the lendingPool.
3-Indicating in the contract that carries out the investment logic that executes everything.
*/

import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/FlashLoanReceiverBase.sol";

import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPoolAddressesProvider.sol";

import "https://github.com/aave/flashloan-box/blob/Remix/contracts/aave/ILendingPool.sol";



contract Flashloan is FlashLoanReceiverBase {

    constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}

    function executeOperation(
        address _reserve, 
        uint256 _amount,  
        uint256 _fee,     
        bytes calldata _params  
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        uint totalDebt = _amount.add(_fee);
        
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }



    function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether; 
        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());

        lendingPool.flashLoand(address(this), _asset, amount, data);
    }


}