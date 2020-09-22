pragma solidity ^0.6.0;

contract CrptoID{
    address public owner;
    uint instituteCount = 0;
    string studentIDHash;
    constructor() public{
        owner = msg.sender;
    }
    //defining structure of institute
    struct institute{
        address instituteAddress;
        bytes32 instituteName;
        uint studentCount;
        mapping(uint => string) student;
    }
    
    modifier onlyOwner(){
        require(msg.sender == owner,"You are not the owner");
        _;
    }
    
    // helper hash function
    function hash(string memory _str) private pure returns(bytes32) {
        return  keccak256(abi.encode(_str));
    }
    
    // mapping from address to struct institute
    mapping(address => institute) private institutes;
    // register new institute
    function registerInstitute(string memory _instituteName) public {
        instituteCount++;
        institutes[msg.sender].instituteAddress = msg.sender;
        institutes[msg.sender].instituteName = hash(_instituteName);
    }
    
    modifier onlyRegisteredInstitute(string memory _instituteName){
        require(institutes[msg.sender].instituteName == hash(_instituteName),"Your Institute is not Registered.");
        _;
    }
    //upload hash of student's identity card
    function newIdentityCard(uint enrollmentNumber,string memory ipfsHash,string memory _instituteName) public onlyRegisteredInstitute(_instituteName){
        institutes[msg.sender].studentCount++;
        institutes[msg.sender].student[enrollmentNumber] = ipfsHash;
    }
    //retrieve hash of student's identity card
    function getIdentityCard(uint enrollmentNumber, address instituteAddress) public view returns(string memory){
        return(institutes[instituteAddress].student[enrollmentNumber]);
    }
}