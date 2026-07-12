// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import "./UserOperation.sol";

contract SmartAccount {

    using ECDSA for bytes32;

    ////////////////////////////////////////////////////////////
    // State Variables
    ////////////////////////////////////////////////////////////

    address public immutable entryPoint;

    address public owner;

    uint256 public nonce;

    ////////////////////////////////////////////////////////////
    // Events
    ////////////////////////////////////////////////////////////

    event Executed(
        address indexed target,
        uint256 value
    );

    event OwnerChanged(
        address indexed newOwner
    );

    ////////////////////////////////////////////////////////////
    // Constructor
    ////////////////////////////////////////////////////////////

    constructor(
        address _owner,
        address _entryPoint
    ) {
        owner = _owner;
        entryPoint = _entryPoint;
    }

    ////////////////////////////////////////////////////////////
    // Modifiers
    ////////////////////////////////////////////////////////////

    modifier onlyEntryPoint() {
        require(
            msg.sender == entryPoint,
            "Only EntryPoint"
        );
        _;
    }

    ////////////////////////////////////////////////////////////
    // Validation
    ////////////////////////////////////////////////////////////

    /// Called by EntryPoint before execution.
    ///
    /// Real ERC-4337 validates:
    /// - Signature
    /// - Nonce
    /// - Gas
    /// - Paymaster
    /// - Aggregator
    ///
    /// This educational version validates only
    /// signature and nonce.
    function validateUserOp(
        UserOperation calldata op
    )
        external
        onlyEntryPoint
        returns (bool)
    {
        require(
            op.sender == address(this),
            "Wrong sender"
        );

        require(
            op.nonce == nonce,
            "Invalid nonce"
        );

        bytes32 hash = keccak256(
            abi.encode(
                op.sender,
                op.nonce,
                op.target,
                op.value,
                keccak256(op.data)
            )
        );

        address signer = hash
            .toEthSignedMessageHash()
            .recover(op.signature);

        require(
            signer == owner,
            "Invalid signature"
        );

        nonce++;

        return true;
    }

    ////////////////////////////////////////////////////////////
    // Execution
    ////////////////////////////////////////////////////////////

    function execute(
        address target,
        uint256 value,
        bytes calldata data
    )
        external
        onlyEntryPoint
    {
        (bool success,) =
            target.call{value: value}(data);

        require(
            success,
            "Execution failed"
        );

        emit Executed(
            target,
            value
        );
    }

    ////////////////////////////////////////////////////////////
    // Owner Management
    ////////////////////////////////////////////////////////////

    function changeOwner(
        address newOwner
    )
        external
    {
        require(
            msg.sender == owner,
            "Only owner"
        );

        owner = newOwner;

        emit OwnerChanged(
            newOwner
        );
    }

    receive() external payable {}
}