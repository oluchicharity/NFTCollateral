// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "../contracts/facets/NFTCollateralFacet.sol";
import "../contracts/facets/LoanFacet.sol";

contract NFTCollateralizedLendingPlatformTest is Test {
    OwnershipFacet public ownerFacet;
    NFTCollateralFacet public collateralFacet;
    LoanFacet public loanFacet;

    address public owner = address(1);
    address public newOwner = address(2);
    address public borrower = address(3);
    address public nftContract = address(4);

    function setUp() public {
        vm.prank(owner);
        ownerFacet = new OwnershipFacet();
        collateralFacet = new NFTCollateralFacet();
        loanFacet = new LoanFacet();
    }

    function testOwnershipTransfer() public {
        vm.startPrank(owner);
        ownerFacet.transferOwnership(newOwner);
        assertEq(ownerFacet.owner(), newOwner);
        vm.stopPrank();
    }

    function testDepositNFTCollateral() public {
        // Assume borrower owns an NFT with tokenId 1
        vm.startPrank(borrower);
        collateralFacet.depositNFT(nftContract, 1);
        assertTrue(collateralFacet.collateralizedNFTs(nftContract, 1));
        vm.stopPrank();
    }

    function testRequestLoan() public {
        vm.startPrank(borrower);
        loanFacet.requestLoan(100);
        uint256 amount = loanFacet.getLoanDetails(borrower).amount;
        assertEq(amount, 100);
        vm.stopPrank();
    }
}
