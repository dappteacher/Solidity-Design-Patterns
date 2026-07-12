// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

import "forge-std/Test.sol";
import "../src/SimpleDAO.sol";

/// @title SimpleDAO_FoundryTest
/// @dev This contract tests the SimpleDAO contract using Foundry framework
contract SimpleDAO_FoundryTest is Test {
    SimpleDAO dao;
    address chairperson;
    address member1;
    address member2;

    /// @notice Setup function to initialize the DAO contract and add members
    function setUp() public {
        chairperson = address(0x1);
        member1 = address(0x2);
        member2 = address(0x3);

        // Simulate actions from the chairperson's address
        vm.startPrank(chairperson);
        dao = new SimpleDAO(3 days);
        dao.addMember(member1);
        dao.addMember(member2);
        vm.stopPrank();
    }

    /// @notice Test the creation of a proposal
    function testCreateProposal() public {
        // Simulate action from member1's address
        vm.prank(member1);
        dao.createProposal("Proposal 1");

        // Retrieve the proposal and verify its properties
        (address proposer, string memory description, uint256 voteCount, bool executed) = dao.proposals(0);
        assertEq(proposer, member1);
        assertEq(description, "Proposal 1");
        assertEq(voteCount, 0);
        assertFalse(executed);
    }

    /// @notice Test voting on a proposal
    function testVoteOnProposal() public {
        // Create a proposal by member1
        vm.prank(member1);
        dao.createProposal("Proposal 1");

        // Vote on the proposal by member2
        vm.prank(member2);
        dao.vote(0);

        // Verify the vote count and that member2 has voted
        (, , uint256 voteCount, ) = dao.proposals(0);
        assertEq(voteCount, 1);

        bool hasVoted = dao.votes(0, member2);
        assertTrue(hasVoted);
    }

    /// @notice Test execution of a proposal
    function testExecuteProposal() public {
        // Create and vote on a proposal
        vm.prank(member1);
        dao.createProposal("Proposal 1");
        vm.prank(member2);
        dao.vote(0);

        // Execute the proposal
        vm.prank(member1);
        dao.executeProposal(0);

        // Verify the proposal is marked as executed
        (, , , bool executed) = dao.proposals(0);
        assertTrue(executed);
    }

    /// @notice Test that only the chairperson can add a new member
    function testOnlyChairpersonCanAddMember() public {
        // Attempt to add a member from a non-chairperson address and expect a revert
        vm.expectRevert("Only chairperson can call this function");
        dao.addMember(address(0x4));
    }

    /// @notice Test that only members can create a proposal
    function testOnlyMembersCanCreateProposal() public {
        // Attempt to create a proposal from a non-member address and expect a revert
        vm.prank(address(0x5));
        vm.expectRevert("Only members can call this function");
        dao.createProposal("Proposal by non-member");
    }

    /// @notice Test that only members can vote on a proposal
    function testOnlyMembersCanVote() public {
        // Create a proposal
        vm.prank(member1);
        dao.createProposal("Proposal 1");

        // Attempt to vote from a non-member address and expect a revert
        vm.prank(address(0x5));
        vm.expectRevert("Only members can call this function");
        dao.vote(0);
    }

    /// @notice Test that only members can execute a proposal
    function testOnlyMembersCanExecuteProposal() public {
        // Create and vote on a proposal
        vm.prank(member1);
        dao.createProposal("Proposal 1");
        vm.prank(member2);
        dao.vote(0);

        // Attempt to execute the proposal from a non-member address and expect a revert
        vm.prank(address(0x5));
        vm.expectRevert("Only members can call this function");
        dao.executeProposal(0);
    }
}
