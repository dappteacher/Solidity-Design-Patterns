// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.26;

/// @title SimpleDAO
/// @dev This contract implements a simple Decentralized Autonomous Organization (DAO)
contract SimpleDAO {
    
    /// @dev Structure to hold details of each proposal
    struct Proposal {
        address proposer;        // Address of the proposer
        string description;      // Description of the proposal
        uint256 voteCount;       // Number of votes for the proposal
        bool executed;           // Whether the proposal has been executed
    }

    address public chairperson;                  // Address of the chairperson
    mapping(address => bool) public members;     // Mapping to check if an address is a member
    mapping(uint256 => Proposal) public proposals; // Mapping to store proposals by their ID
    uint256 public proposalCount;                // Total number of proposals
    uint256 public votingDuration;               // Duration for which voting is open
    mapping(uint256 => mapping(address => bool)) public votes; // Mapping to track votes per proposal by members

    /// @notice Event emitted when a new proposal is created
    /// @param proposalId ID of the proposal
    /// @param proposer Address of the proposer
    /// @param description Description of the proposal
    event ProposalCreated(uint256 proposalId, address proposer, string description);
    
    /// @notice Event emitted when a member votes on a proposal
    /// @param proposalId ID of the proposal
    /// @param voter Address of the voter
    event Voted(uint256 proposalId, address voter);
    
    /// @notice Event emitted when a proposal is executed
    /// @param proposalId ID of the proposal
    event ProposalExecuted(uint256 proposalId);

    /// @dev Modifier to restrict function access to the chairperson
    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Only chairperson can call this function");
        _;
    }

    /// @dev Modifier to restrict function access to members
    modifier onlyMembers() {
        require(members[msg.sender], "Only members can call this function");
        _;
    }

    /// @notice Constructor to initialize the DAO
    /// @param _votingDuration Duration for which voting is open
    constructor(uint256 _votingDuration) {
        chairperson = msg.sender;
        votingDuration = _votingDuration;
        members[msg.sender] = true;
    }

    /// @notice Function to add a new member to the DAO
    /// @dev Only callable by the chairperson
    /// @param _member Address of the new member
    function addMember(address _member) public onlyChairperson {
        members[_member] = true;
    }

    /// @notice Function to create a new proposal
    /// @dev Only callable by members
    /// @param _description Description of the proposal
    function createProposal(string memory _description) public onlyMembers {
        proposals[proposalCount] = Proposal({
            proposer: msg.sender,
            description: _description,
            voteCount: 0,
            executed: false
        });

        emit ProposalCreated(proposalCount, msg.sender, _description);
        proposalCount++;
    }

    /// @notice Function to vote on a proposal
    /// @dev Only callable by members
    /// @param _proposalId ID of the proposal to vote on
    function vote(uint256 _proposalId) public onlyMembers {
        require(_proposalId < proposalCount, "Proposal does not exist");
        require(!votes[_proposalId][msg.sender], "Already voted on this proposal");

        proposals[_proposalId].voteCount++;
        votes[_proposalId][msg.sender] = true;

        emit Voted(_proposalId, msg.sender);
    }

    /// @notice Function to execute a proposal
    /// @dev Only callable by members
    /// @param _proposalId ID of the proposal to execute
    function executeProposal(uint256 _proposalId) public onlyMembers {
        require(_proposalId < proposalCount, "Proposal does not exist");
        Proposal storage proposal = proposals[_proposalId];
        require(proposal.voteCount > 0, "Proposal needs at least one vote to be executed");
        require(!proposal.executed, "Proposal already executed");

        proposal.executed = true;

        emit ProposalExecuted(_proposalId);
    }
}
