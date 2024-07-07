// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

import "forge-std/Test.sol";
import "../src/Tasks.sol";

/// @title Tasks Contract Test
/// @notice This contract tests the functionality of the Tasks contract
/// @dev The tests cover various aspects including adding, retrieving, updating, and deleting tasks.
contract TasksTest is Test {
    Tasks tasks;

    // Define an address to use for testing
    address owner = address(1);
    address account1 = address(2);
    address account2 = address(3);

    /// @notice Sets up the test environment
    /// @dev Deploys the Tasks contract and assigns it to the tasks variable
    function setUp() public {
        vm.prank(owner);
        tasks = new Tasks();
    }

    /// @notice Tests if the owner is set correctly upon contract deployment
    function testOwnerSetCorrectly() public {
        assertEq(tasks.owner(), owner);
    }

    /// @notice Tests adding a new task
    /// @dev Adds a task for account1 and verifies that the task was added correctly
    function testAddTask() public {
        vm.prank(owner);
        tasks.addTask(account1, "Test Task 1");
        
        string memory description = tasks.getDescription(account1, 0);
        assertEq(description, "Test Task 1");

        vm.expectEmit(true, true, true, true);
        emit TaskAdded(account1, "Test Task 1", 0);
    }

    /// @notice Tests retrieving all task descriptions for an account
    /// @dev Adds two tasks for account1 and verifies the retrieval of both task descriptions
    function testGetTaskDescriptions() public {
        vm.prank(owner);
        tasks.addTask(account1, "Test Task 1");
        tasks.addTask(account1, "Test Task 2");

        string[] memory descriptions = tasks.getTaskDescriptions(account1);
        assertEq(descriptions.length, 2);
        assertEq(descriptions[0], "Test Task 1");
        assertEq(descriptions[1], "Test Task 2");
    }

    /// @notice Tests retrieving the completion status of a task
    /// @dev Adds a task for account1 and verifies the initial completion status is false
    function testGetTaskStatus() public {
        vm.prank(owner);
        tasks.addTask(account1, "Test Task 1");

        bool status = tasks.getTaskStatus(account1, 0);
        assertFalse(status);
    }

    /// @notice Tests updating a task's completion status
    /// @dev Adds a task for account1, marks it as completed, and verifies the updated status
    function testUpdateTask() public {
        vm.prank(owner);
        tasks.addTask(account1, "Test Task 1");

        vm.prank(owner);
        tasks.update(account1, 0);

        bool status = tasks.getTaskStatus(account1, 0);
        assertTrue(status);
    }

    /// @notice Tests deleting a task
    /// @dev Adds a task for account1, deletes it, and verifies that the task's description is empty
    function testDeleteTask() public {
        vm.prank(owner);
        tasks.addTask(account1, "Test Task 1");

        vm.prank(owner);
        tasks.deleteTask(account1, 0);

        string memory description = tasks.getDescription(account1, 0);
        assertEq(description, "");
    }

    /// @notice Tests that only the owner can add a task
    /// @dev Attempts to add a task with a non-owner account and expects a revert
    function testOnlyOwnerCanAddTask() public {
        vm.expectRevert("Access is denied!");
        tasks.addTask(account1, "Unauthorized Task");
    }

    /// @notice Tests that only the owner can update a task
    /// @dev Attempts to update a task with a non-owner account and expects a revert
    function testOnlyOwnerCanUpdateTask() public {
        vm.prank(owner);
        tasks.addTask(account1, "Test Task 1");

        vm.expectRevert("Access is denied!");
        tasks.update(account1, 0);
    }

    /// @notice Tests that only the owner can delete a task
    /// @dev Attempts to delete a task with a non-owner account and expects a revert
    function testOnlyOwnerCanDeleteTask() public {
        vm.prank(owner);
        tasks.addTask(account1, "Test Task 1");

        vm.expectRevert("Access is denied!");
        tasks.deleteTask(account1, 0);
    }
}
