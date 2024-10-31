// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC721} from "../interfaces/IERC721.sol";

contract NFTCollateralFacet {
    mapping(address => mapping(uint256 => bool)) public collateralizedNFTs;

    function depositNFT(address nftContract, uint256 tokenId) external {
        IERC721(nftContract).transferFrom(msg.sender, address(this), tokenId);
        collateralizedNFTs[nftContract][tokenId] = true;
    }

    function retrieveNFT(address nftContract, uint256 tokenId) external {
        require(collateralizedNFTs[nftContract][tokenId], "NFT not collateralized");
        collateralizedNFTs[nftContract][tokenId] = false;
        IERC721(nftContract).transferFrom(address(this), msg.sender, tokenId);
    }
}
