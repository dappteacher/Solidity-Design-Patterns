// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract Counter {

    uint256 public number;

    event Increment(
        uint256 newValue
    );

    event Decrement(
        uint256 newValue
    );

    function increment()
        external
    {
        number++;

        emit Increment(
            number
        );
    }

    function decrement()
        external
    {
        require(
            number > 0,
            "Already zero"
        );

        number--;

        emit Decrement(
            number
        );
    }

    function reset()
        external
    {
        number = 0;
    }
}