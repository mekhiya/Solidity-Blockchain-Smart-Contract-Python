// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    mapping(address => uint256) public addressToAmountFunded;
    address public owner;
    address[] public funders;

    constructor() public {
        owner = msg.sender;
    }

    function fund() public payable {
        addressToAmountFunded[msg.sender] = msg.value;
        uint256 minimumUSD = 50 * 10**18;
        require(
            getConversionRate(msg.value) > minimumUSD,
            "Insufficient amount"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * (10**10));
    }

    function getDecimal() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        return uint256(priceFeed.decimals());
    }

    //1000000000 1 gwei
    //returns 2616550929290, has 18 decimals inside hence 0.000002616550929290
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        //261655092929 * 10**10
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "you do not have permission to withdraw");
        _;
    }

    function withdraw() public payable onlyOwner {
        msg.sender.transfer(address(this).balance);
        for (uint256 fIndex = 0; fIndex < funders.length; fIndex++) {
            addressToAmountFunded[funders[fIndex]] = 0;
        }
        funders = new address[](0);
    }
}
