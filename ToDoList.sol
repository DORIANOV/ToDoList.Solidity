// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PersonalTodoList {
    struct Task {
        uint id;
        string content;
        bool completed;
        uint createdAt;
    }

    mapping(address => Task[]) private userTasks;
    
    mapping(address => uint) private taskCount;

    event TaskCreated(address indexed user, uint taskId, string content, uint createdAt);
    event TaskCompleted(address indexed user, uint taskId);
    event TaskDeleted(address indexed user, uint taskId);

    function createTask(string memory _content) public {
        require(bytes(_content).length > 0, "La tache ne peut pas etre vide");
        
        uint taskId = taskCount[msg.sender];
        userTasks[msg.sender].push(Task({
            id: taskId,
            content: _content,
            completed: false,
            createdAt: block.timestamp
        }));

        taskCount[msg.sender]++;
        
        emit TaskCreated(msg.sender, taskId, _content, block.timestamp);
    }
    function completeTask(uint _taskId) public {
        require(_taskId < taskCount[msg.sender], "Tache invalide");
        
        Task storage task = userTasks[msg.sender][_taskId];
        require(!task.completed, "Tache deja completee");
        
        task.completed = true;
        
        emit TaskCompleted(msg.sender, _taskId);
    }

    function deleteTask(uint _taskId) public {
        require(_taskId < taskCount[msg.sender], "Tache invalide");
        
        Task[] storage tasks = userTasks[msg.sender];
        tasks[_taskId] = tasks[tasks.length - 1];
        tasks[_taskId].id = _taskId;
        tasks.pop();
        
        taskCount[msg.sender]--;
        
        emit TaskDeleted(msg.sender, _taskId);
    }

    function getTasks() public view returns (Task[] memory) {
        return userTasks[msg.sender];
    }

    function getTaskCount() public view returns (uint) {
        return taskCount[msg.sender];
    }
}