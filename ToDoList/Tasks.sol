// SPDX-License-Identifier: MIT
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
    
    // Function to add a new task for a specific account
    // Only the owner can call this function
    function addTask(address _account, string memory _description) public onlyOwner {
        uint256 taskId = tasks[_account].length;
        tasks[_account].push(Task(_description, false));
        emit TaskAdded(_account, _description, taskId);
    }
    
    // Function to get the description of a specific task for a specific account
    function getDescription(address _account, uint256 _taskId) public view returns (string memory result) {
        result = tasks[_account][_taskId].description;
    }
    
    // Function to get all task descriptions for a specific account
    function getTaskDescriptions(address _account) public view returns (string[] memory) {
        uint256 taskCount = tasks[_account].length;
        string[] memory result = new string[](taskCount);
        for (uint256 i = 0; i < taskCount; i++) {
            result[i] = tasks[_account][i].description;
        }
        return result;
    }
    
    // Function to get the completion status of a specific task for a specific account
    function getTaskStatus(address _account, uint256 _taskId) public view returns (bool result) {
        result = tasks[_account][_taskId].completed;
    }
    
    // Function to mark a specific task as completed for a specific account
    // Only the owner can call this function
    function update(address _account, uint256 _taskId) public onlyOwner {
        require(_taskId < tasks[_account].length, "Task doesn't exist!");
        tasks[_account][_taskId].completed = true;
    }

    /*
    Note: The deleteTask function is deleting a task by setting it to its initial state.
    This might not be the desired behavior, as it leaves a gap in the array.
    It's better to shift elements to fill the gap or simply mark the task as deleted
    (by setting a flag or similar mechanism) if you want to maintain the integrity of the array.
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
