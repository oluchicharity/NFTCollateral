// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721} from "../interfaces/IERC721.sol";

contract LiquidationFacet {
    struct Loan {
        address borrower;
        address nftContract;
        uint256 tokenId;
        uint256 loanAmount;
        bool isDefaulted;
        bool isLiquidated;
    }

    mapping(address => Loan) public loans;

    event Liquidated(address indexed borrower, address indexed nftContract, uint256 tokenId, uint256 loanAmount);

    function liquidateCollateral(address borrower) external {
        // Ensure loan is in default and not already liquidated
        Loan storage loan = loans[borrower];
        require(loan.isDefaulted, "Loan is not in default");
        require(!loan.isLiquidated, "Loan already liquidated");

        // Transfer the collateral (NFT) to the contract or the liquidator
        IERC721(loan.nftContract).transferFrom(address(this), msg.sender, loan.tokenId);

        // Mark the loan as liquidated
        loan.isLiquidated = true;

        // Emit a liquidation event
        emit Liquidated(borrower, loan.nftContract, loan.tokenId, loan.loanAmount);
    }
}