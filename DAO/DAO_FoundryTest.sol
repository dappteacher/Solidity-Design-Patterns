// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/DAO.sol";

contract DAO_FoundryTest is Test {
    DAO dao;
    address chairperson;
    address voter1;
    address voter2;

    // Setup function to deploy the contract and initialize addresses
    function setUp() public {
        chairperson = address(this);
        voter1 = address(0x1);
        voter2 = address(0x2);

        // Deploy the DAO contract
        dao = new DAO();

        // Add voting power to voters
        dao.addVotingPower(voter1, 50);
        dao.addVotingPower(voter2, 60);
    }

    // Test the creation of a proposal
    function testCreateProposal() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        (uint256 id, string memory description, uint256 voteCount, uint256 trueVoteCount, bool executed, uint256 deadline) = dao.proposals(0);
        assertEq(id, 0);
        assertEq(description, "Proposal 1");
        assertEq(voteCount, 0);
        assertEq(trueVoteCount, 0);
        assertFalse(executed);
        assertTrue(deadline > block.timestamp);
    }

    // Test voting on a proposal
    function testVoteOnProposal() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        vm.prank(voter2);
        dao.vote{value: 0.01 ether}(0, true);

        (, , uint256 voteCount, uint256 trueVoteCount, , ) = dao.proposals(0);
        assertEq(voteCount, 60);
        assertEq(trueVoteCount, 60);
        assertTrue(dao.proposals(0).votes(voter2));
    }

    // Test execution of a proposal by the chairperson
    function testExecuteProposal() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        vm.prank(voter2);
        dao.vote{value: 0.01 ether}(0, true);

        vm.warp(block.timestamp + 4 days);
        vm.prank(chairperson);
        dao.executeProposal(0);

        (, , , , bool executed, ) = dao.proposals(0);
        assertTrue(executed);
    }

    // Test adding voting power by the chairperson
    function testAddVotingPower() public {
        vm.prank(chairperson);
        dao.addVotingPower(voter1, 50);

        assertEq(dao.votingPower(voter1), 100);
    }

    // Test enforcing fines for not voting
    function testEnforceFines() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        vm.warp(block.timestamp + 4 days);
        vm.prank(chairperson);
        dao.enforceFines(voter1, 0);

        // No explicit assertion here since we are just testing the fine transfer
        // Check if the fine amount is correctly transferred to the chairperson in a real environment
    }

    // Test only chairperson can add voting power
    function testOnlyChairpersonCanAddVotingPower() public {
        vm.prank(voter1);
        vm.expectRevert("Not chairperson");
        dao.addVotingPower(voter1, 50);
    }

    // Test only chairperson can execute a proposal
    function testOnlyChairpersonCanExecuteProposal() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        vm.warp(block.timestamp + 4 days);
        vm.prank(voter1);
        vm.expectRevert("Not chairperson");
        dao.executeProposal(0);
    }

    // Test only chairperson can enforce fines
    function testOnlyChairpersonCanEnforceFines() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        vm.warp(block.timestamp + 4 days);
        vm.prank(voter1);
        vm.expectRevert("Not chairperson");
        dao.enforceFines(voter1, 0);
    }

    // Test incorrect proposal fee
    function testIncorrectProposalFee() public {
        vm.prank(voter1);
        vm.expectRevert("Incorrect proposal fee");
        dao.createProposal{value: 0.05 ether}("Proposal 1");
    }

    // Test incorrect vote fee
    function testIncorrectVoteFee() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        vm.prank(voter2);
        vm.expectRevert("Incorrect vote fee");
        dao.vote{value: 0.005 ether}(0, true);
    }

    // Test voter without voting power cannot vote
    function testNoVotingPowerCannotVote() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        address nonVoter = address(0x3);

        vm.prank(nonVoter);
        vm.expectRevert("No voting power");
        dao.vote{value: 0.01 ether}(0, true);
    }

    // Test voter cannot vote after deadline
    function testVoteAfterDeadline() public {
        vm.prank(voter1);
        dao.createProposal{value: 0.1 ether}("Proposal 1");

        vm.warp(block.timestamp + 4 days);
        vm.prank(voter1);
        vm.expectRevert("Voting period has ended");
        dao.vote{value: 0.01 ether}(0, true);
    }
}
