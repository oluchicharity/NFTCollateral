// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LoanFacet {
    struct Loan {
        address borrower;
        uint256 amount;
        bool isRepaid;
    }

    mapping(address => Loan) public loans;

    function requestLoan(uint256 amount) external {
        loans[msg.sender] = Loan(msg.sender, amount, false);
    }

    function repayLoan() external {
        require(loans[msg.sender].amount > 0, "No active loan");
        loans[msg.sender].isRepaid = true;
    }

    function getLoanDetails(address borrower) external view returns (Loan memory) {
        return loans[borrower];
    }
}
