// SPDX-License-Identifier: MIT
// Author: Yaghoub Adelzadeh
// GitHub: https://www.github.com/dappteacher
pragma solidity ^0.8.25;

contract Tasks {
    // State variable to store the owner of the contract
    address owner;

    // Constructor to set the contract deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // Struct to represent a Task with a description and completion status
    struct Task {
        string description;
        bool completed;
    }
    
    // Mapping to store tasks for each account
    mapping(address => Task[]) tasks;

    // Event to emit when a new task is added
    event TaskAdded(address indexed account, string description, uint256 taskId);
    
    /**
     * @dev Adds a new task for a specific account.
     * @param _account The address of the account to add the task for.
     * @param _description The description of the task to be added.
     * Requirements:
     * - Only the owner can call this function.
     * Emits a {TaskAdded} event.
     */
    function addTask(address _account, string memory _description) public onlyOwner {
        uint256 taskId = tasks[_account].length;
        tasks[_account].push(Task(_description, false));
        emit TaskAdded(_account, _description, taskId);
    }
    
    /**
     * @dev Gets the description of a specific task for a specific account.
     * @param _account The address of the account to get the task from.
     * @param _taskId The ID of the task to get the description of.
     * @return result The description of the task.
     */
    function getDescription(address _account, uint256 _taskId) public view returns (string memory result) {
        result = tasks[_account][_taskId].description;
    }
    
    /**
     * @dev Gets all task descriptions for a specific account.
     * @param _account The address of the account to get the tasks from.
     * @return result An array of task descriptions.
     */
    function getTaskDescriptions(address _account) public view returns (string[] memory) {
        uint256 taskCount = tasks[_account].length;
        string[] memory result = new string[](taskCount);
        for (uint256 i = 0; i < taskCount; i++) {
            result[i] = tasks[_account][i].description;
        }
        return result;
    }
    
    /**
     * @dev Gets the completion status of a specific task for a specific account.
     * @param _account The address of the account to get the task from.
     * @param _taskId The ID of the task to get the status of.
     * @return result The completion status of the task.
     */
    function getTaskStatus(address _account, uint256 _taskId) public view returns (bool result) {
        result = tasks[_account][_taskId].completed;
    }
    
    /**
     * @dev Marks a specific task as completed for a specific account.
     * @param _account The address of the account to update the task for.
     * @param _taskId The ID of the task to mark as completed.
     * Requirements:
     * - Only the owner can call this function.
     * - The task must exist.
     */
    function update(address _account, uint256 _taskId) public onlyOwner {
        require(_taskId < tasks[_account].length, "Task doesn't exist!");
        tasks[_account][_taskId].completed = true;
    }

    /**
     * @dev Deletes a specific task for a specific account.
     * @param _account The address of the account to delete the task from.
     * @param _taskId The ID of the task to delete.
     * Requirements:
     * - Only the owner can call this function.
     * - The task must exist.
     * Note: The deleteTask function deletes a task by setting it to its initial state.
     * This might not be the desired behavior, as it leaves a gap in the array.
     * It's better to shift elements to fill the gap or simply mark the task as deleted
     * (by setting a flag or similar mechanism) if you want to maintain the integrity of the array.
     */
    function deleteTask(address _account, uint256 _taskId) public onlyOwner {
        require(_taskId < tasks[_account].length, "Task doesn't exist!");
        delete tasks[_account][_taskId];
    }

    // Modifier to restrict access to the owner
    modifier onlyOwner {
        require(owner == msg.sender, "Access is denied!");
        _;
    }
}
