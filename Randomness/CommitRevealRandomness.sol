// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

/// @title Commit-Reveal Randomness Contract
/// @dev This contract generates randomness using a commit-reveal scheme.
contract CommitRevealRandomness {

    struct Commitment {
        bytes32 commitHash;
        uint256 blockNumber;
    }

    mapping(address => Commitment) public commitments;
    uint256 public randomNumber;
    bool public revealed;
    address public winner;

    /// @dev Event emitted when a commitment is made
    /// @param committer The address of the committer
    /// @param commitHash The hash of the committed value
    event CommitmentMade(address indexed committer, bytes32 commitHash);

    /// @dev Event emitted when a commitment is revealed
    /// @param committer The address of the committer
    /// @param value The revealed value
    /// @param randomNumber The generated random number
    event CommitmentRevealed(address indexed committer, uint256 value, uint256 randomNumber);

    /// @notice Commit a value to participate in randomness generation
    /// @param commitHash The hash of the committed value
    function commit(bytes32 commitHash) public {
        require(commitments[msg.sender].blockNumber == 0, "Commitment already made");

        commitments[msg.sender] = Commitment({
            commitHash: commitHash,
            blockNumber: block.number
        });

        emit CommitmentMade(msg.sender, commitHash);
    }

    /// @notice Reveal the committed value to generate the random number
    /// @param value The value that was committed
    function reveal(uint256 value) public {
        Commitment memory commitment = commitments[msg.sender];
        require(commitment.blockNumber != 0, "No commitment found");
        require(!revealed, "Random number already revealed");
        require(keccak256(abi.encodePacked(value)) == commitment.commitHash, "Invalid reveal value");

        // Generate the random number
        randomNumber = uint256(keccak256(abi.encodePacked(value, blockhash(commitment.blockNumber), msg.sender)));

        revealed = true;
        winner = msg.sender;

        emit CommitmentRevealed(msg.sender, value, randomNumber);
    }

    /// @notice Reset the contract for new randomness generation
    function reset() public {
        require(revealed, "Random number not yet revealed");

        delete commitments[winner];
        randomNumber = 0;
        revealed = false;
        winner = address(0);
    }
}
/*
Explanation:

    Commit-Reveal Scheme: This method involves two phases:
        Commit: Users submit a hash of their secret value. 
            This ensures they cannot change their value after seeing others’ values.
        Reveal: Users reveal their original value, and the contract verifies it against the stored hash. 
            The random number is then generated using the revealed value and other blockchain data.

    Contract Structure:
        Commitment Struct: Stores the commit hash and the block number of the commitment.
        commitments Mapping: Maps each user to their commitment.
        randomNumber: Stores the generated random number.
        revealed: Boolean indicating whether the random number has been revealed.
        winner: Address of the user who revealed the commitment.

    Functions:
        commit: Allows users to submit their commitment hash.
        reveal: Users reveal their committed value, and the random number is generated.
        reset: Resets the contract state for a new round of randomness generation.

Usage:

    Commit Phase: Users call the commit function with a hash of their secret value 
        (e.g., keccak256(abi.encodePacked(secretValue))).
    Reveal Phase: After a certain period (or immediately), users call the reveal function with their original secret value.
    Random Number Generation: The contract combines the revealed value with other blockchain data (e.g., blockhash) 
        to generate a random number.
    Reset: Once the randomness is revealed, the contract can be reset for a new round.

Considerations:

    Timing: Ensure there’s enough time between commit and reveal phases 
        to prevent users from committing and revealing in quick succession.
    Security: The scheme relies on users not being able to predict or manipulate 
        the random number until all commitments are revealed.

The commit-reveal scheme is a useful method for generating randomness in a decentralized and trustless manner, 
ensuring fairness and preventing front-running or manipulation.
*/
