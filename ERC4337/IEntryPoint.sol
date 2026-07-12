// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "./UserOperation.sol";

interface IEntryPoint {
    function handleOp(
        UserOperation calldata userOp
    ) external;

    function handleOps(
        UserOperation[] calldata userOps
    ) external;
}