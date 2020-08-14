pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliverCrowdsale {

    constructor(
        // @TODO: Fill in the constructor parameters!
        uint rate, //1 token per ether
        address payable wallet, //address that will receive the funds
        PupperCoin token, //token that is used for the crowdsale
        uint cap, //max amount of coins to be sold
        uint closingTime, //end time for the crowdsale
        uint openintTime, //start time for the crowdsale
        uint goal //target number of coins to sell
    )
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        Crowdsale(rate, wallet, token)
        Capped Crowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
        RefundableCrowdsale (goal)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet //address that will receive the funds
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
            PupperCoin token = new PupperCoin(name, symbol, 0);
            token_address = address(token);

        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
            PupperCoinSale puppercoin_sale = new PupperCoinSale(1, wallet, token, now, now + 24 weeks, cap, goal);
            token_sale_address = address (puppercoin_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}