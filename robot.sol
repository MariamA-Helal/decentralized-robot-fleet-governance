pragma solidity ^0.8.0;

contract RobotAutomation {
    
    
    address public owner;

    //types of tasks Bitmask
    uint128 public constant FILLING_CAPABILITY    =1; // Bit 001
    uint128 public constant SORTING_CAPABILITY    =2; // Bit 010
    uint128 public constant PACKAGING_CAPABILITY  =4; // Bit 100

    struct Robot {
        uint robotID;
        uint128 capabilities; // store capabilities as a Bitmask
        bool isWorking;

    }

    struct Task {
        uint taskId;
        uint128 neededCapabilities;
        bool isCompleted;
    }

    mapping (Robot => uint) public robots;
    mapping (address => uint) public taskToRobot; 
    mapping (Task => uint) public tasks;
    mapping (bool => uint) public taskCompleted;

    // to make sure how calls a funtion is the real owner only
    modifier onlyOwner {
        require (msg.sender == owner, "only the engineer can do this!");
        _;
    }

    // used for first execution only to set who is the owner 
    constructor() {
        owner = msg.sender;
    }

    function AddRobot (uint _robotID , uint128 _capabilities) public onlyOwner {
        // add robot id 
        // add robot type to know what's kind of fuction it can do

        robots[_robotID] = Robot ({
            robotID: _robotID,
            capabilities: _capabilities,
            isWorking: false // new robot is always available 
        });
        
    }

    function CreatAndAssignTask (uint _taskId, uint _robotID, uint128 _neededCapabilities) public onlyOwner {
        
        //if the robot is not working assgin the task & complete the code else print Robot Busy!
        require(robots[_robotID].isWorking == false, "Robot Busy!");

        // comfirm AND operation between robot capabilities and task needed capabilities to ensure that the robot matches the task
        require((robots[_robotID].capabilities & _neededCapabilities) != 0, "Robot Doesn't have the required acpcbility!");
        
        // list the task
        tasks[_taskId] = Task({
            taskId: _taskId,
            neededCapabilities: _neededCapabilities,
            isCompleted: false
        });

        // assign the task to a robot
        taskToRobot[_taskId] = msg.sender;

        // update its state isWorking = true
        robots[_robotID].isWorking = true;
    
    }

    function Check (uint _robotID, uint _taskId) public {

        // check if the task assigned is for that robot 
        require(taskToRobot[_taskId] == _robotID, "Unauthrized Robot!");

        // check if the task has been completed or not 
        taskCompleted[_taskId] = true;
        tasks[_taskId].isCompleted = true;

        // upddate robot state
        robots[_robotID].isWorking = false;

        // send tokens 
        

    }

}