// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

contract DAO {
    // Struct to hold proposal details
    struct Proposal {
        uint256 id; // Unique proposal ID
        string description; // Description of the proposal
        uint256 voteCount; // Total votes cast for the proposal
        uint256 trueVoteCount; // Votes in favor of the proposal
        bool executed; // Whether the proposal has been executed
        uint256 deadline; // Deadline for voting on the proposal
        mapping(address => bool) votes; // Mapping of voters who have voted on the proposal
    }

    mapping(uint256 => Proposal) public proposals; // Mapping of proposal IDs to proposals
    uint256 public nextProposalId; // Next proposal ID to be assigned
    address public chairperson; // Address of the chairperson
    mapping(address => uint256) public votingPower; // Mapping of addresses to their voting power
    uint256 public proposalFee = 0.1 ether; // Fee to create a proposal
    uint256 public voteFee = 0.01 ether; // Fee to cast a vote
    uint256 public quorum = 100; // Minimum votes required for a proposal to pass
    uint256 public votingDuration = 3 days; // Duration of the voting period
    uint256 public fineAmount = 0.02 ether; // Fine for not voting on a proposal

    // Event emitted when a proposal is created
    event ProposalCreated(uint256 id, string description);
    // Event emitted when a vote is cast
    event Voted(uint256 proposalId, address voter, bool vote);
    // Event emitted when a proposal is executed
    event Executed(uint256 proposalId);

    // Modifier to restrict access to only the chairperson
    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Not chairperson");
        _;
    }

    // Modifier to check if a proposal exists
    modifier proposalExists(uint256 proposalId) {
        require(proposals[proposalId].id == proposalId, "Proposal does not exist");
        _;
    }

    // Modifier to check if a proposal has not been executed
    modifier notExecuted(uint256 proposalId) {
        require(!proposals[proposalId].executed, "Proposal already executed");
        _;
    }

    // Constructor to set the chairperson
    constructor() {
        chairperson = msg.sender;
    }

    // Function to add voting power to a voter
    // Voting power determines the weight of each voter’s vote.
    function addVotingPower(address voter, uint256 amount) external onlyChairperson {
        votingPower[voter] += amount;
    }

    // Function to create a new proposal
    function createProposal(string memory description) external payable {
        require(msg.value == proposalFee, "Incorrect proposal fee"); // Check if the correct proposal fee is paid
        proposals[nextProposalId].id = nextProposalId;
        proposals[nextProposalId].description = description;
        proposals[nextProposalId].executed = false;
        proposals[nextProposalId].deadline = block.timestamp + votingDuration; // Set the deadline for the proposal

        emit ProposalCreated(nextProposalId, description); // Emit the ProposalCreated event
        nextProposalId++; // Increment the next proposal ID
    }

    // Function to cast a vote on a proposal
    function vote(uint256 proposalId, bool support) external payable proposalExists(proposalId) notExecuted(proposalId) {
        Proposal storage proposal = proposals[proposalId];
        require(msg.value == voteFee, "Incorrect vote fee"); // Check if the correct vote fee is paid
        require(block.timestamp <= proposal.deadline, "Voting period has ended"); // Check if the voting period has not ended
        require(!proposal.votes[msg.sender], "Already voted"); // Check if the voter has not already voted
        require(votingPower[msg.sender] > 0, "No voting power"); // Check if the voter has voting power

        proposal.votes[msg.sender] = true; // Mark the voter as having voted
        proposal.voteCount += votingPower[msg.sender]; // Increase the vote count
        if (support) {
            proposal.trueVoteCount += votingPower[msg.sender]; // Increase the true vote count if the vote is in favor
        }

        emit Voted(proposalId, msg.sender, support); // Emit the Voted event

        if (proposal.trueVoteCount >= quorum) {
            _executeProposal(proposalId); // Execute the proposal if the quorum is reached
        }
    }

    // Function to execute a proposal
    function executeProposal(uint256 proposalId) external onlyChairperson proposalExists(proposalId) notExecuted(proposalId) {
        require(block.timestamp > proposals[proposalId].deadline, "Voting period has not ended"); // Check if the voting period has ended
        _executeProposal(proposalId); // Execute the proposal
    }

    // Internal function to execute a proposal
    function _executeProposal(uint256 proposalId) internal {
        Proposal storage proposal = proposals[proposalId];
        require(!proposal.executed, "Proposal already executed"); // Check if the proposal has not been executed

        proposal.executed = true; // Mark the proposal as executed

        emit Executed(proposalId); // Emit the Executed event
        // Execute proposal actions here
    }

    // Function to enforce fines on voters who did not vote on a proposal
    function enforceFines(address voter, uint256 proposalId) external onlyChairperson proposalExists(proposalId) notExecuted(proposalId) {
        Proposal storage proposal = proposals[proposalId];
        require(block.timestamp > proposal.deadline, "Voting period has not ended"); // Check if the voting period has ended
        require(!proposal.votes[voter], "Voter has voted"); // Check if the voter has not voted

        payable(chairperson).transfer(fineAmount); // Transfer the fine amount to the chairperson
    }

    // Fallback function to allow the contract to receive Ether
    receive() external payable {}
}
