// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./IEntryPoint.sol";
import "./SmartAccount.sol";

contract EntryPoint is IEntryPoint {

    ////////////////////////////////////////////////////////////
    // Events
    ////////////////////////////////////////////////////////////

    event UserOperationHandled(
        address indexed account,
        address indexed target
    );

    ////////////////////////////////////////////////////////////
    // Handle a single operation
    ////////////////////////////////////////////////////////////

    function handleOp(
        UserOperation calldata userOp
    )
        public
        override
    {
        SmartAccount wallet =
            SmartAccount(
                payable(userOp.sender)
            );

        bool valid =
            wallet.validateUserOp(
                userOp
            );

        require(
            valid,
            "Validation failed"
        );

        wallet.execute(
            userOp.target,
            userOp.value,
            userOp.data
        );

        emit UserOperationHandled(
            userOp.sender,
            userOp.target
        );
    }

    ////////////////////////////////////////////////////////////
    // Handle multiple operations
    ////////////////////////////////////////////////////////////

    function handleOps(
        UserOperation[] calldata userOps
    )
        external
        override
    {
        uint256 length = userOps.length;

        for (
            uint256 i;
            i < length;
            i++
        ) {
            handleOp(userOps[i]);
        }
    }
}