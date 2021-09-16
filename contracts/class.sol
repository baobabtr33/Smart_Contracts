pragma solidity ^0.5.6;
//pragma experimental ABIEncoderV2;


contract Class {
    struct Attendance {
        string className;
        string classDate;
        uint32 presentPrice;
        uint32 latePrice;
        bool Active; 
    }

    struct Request {
        address student; 
        uint32 reward;
        bool Active;
    }
    
    struct Student{
        string name;
        string ID;
        uint32 point;
    }

    // event - 컨트랙트에서 함수가 실행되는 중간에 이벤트를 발생시켜서, 어떤 변수가 현재 어떤 값인지 로그를 남겨, DApp에서 로그 추적 가능.
    // emit으로 event를 기록 할 수 있음  

    // Global
    address payable owner; // 변수 선언, contstructor에서 initialize 됨 + payable
    string className;

    uint32 numAttendances;
    mapping (uint32 => Attendance) Attendances; // mapping 

    uint32 numRequests;
    mapping (uint32 => Request) requests; // mapping
    
    uint32 numStudent;
    mapping (address => Student[]) students; 
    address [] public studentAccounts;


    // When a contract is created, its constructor 
    // (a function declared with the constructor keyword) is executed once.
    // A constructor is optional. Only one constructor is allowed, which means overloading is not supported.
    constructor(string memory name, address payable addr) public { // memory keyword -> 동적 할당으로 name을 받는다 
        owner = addr; // payable owner 
        className = name;

        //Attendances[numAttendances] = Attendance("all", 0, 0, MenuStatus.deactivated);
        numAttendances = 0;
        numRequests = 0;
    }
    
    // Student
    function setStudent(address _address, string memory _name, string memory _ID, uint32 _point) public{
        students[_address].push(Student(_name, _ID, _point));
        numStudent = numStudent + 1;
    }
    
    function setStudentPoint(address _address) public{
        students[_address][0].point = students[_address][0].point + 821;
    }
        
    function getStudentPoint(address _address) public view returns(uint32) {
        return students[_address][0].point;
    }
    
    function getNumStudent() public view returns (uint32) {
        return numStudent;
    }
    
    function setStudentPointForce(address _address, uint32 weekId) public{
        students[_address][0].point = students[_address][0].point + Attendances[weekId].presentPrice;
    }
    
    // public - Public functions are part of the contract interface 
    // and can be either called internally or via messages. For public state variables, an automatic getter function (see below) is generated.
    // view - Functions can be declared view in which case they promise not to modify the state.
    // return 값 -> uint32 dtype
    function getNumAttendances() public view returns (uint32) {
        return numAttendances;
    }

    function getAttendanceActive(uint32 weekId) public view returns (bool) {
        if (weekId < numAttendances){
            return Attendances[weekId].Active;
        }else{
            return false;
        }
    }

    function addAttendance(string memory classDate, uint32 presentPrice, uint32 latePrice) public returns (uint32){
        require(bytes(classDate).length > 0);
        //require(msg.sender == owner);
        
        Attendances[numAttendances] = Attendance(className, classDate, presentPrice, latePrice, true);
        numAttendances = numAttendances + 1;
        return numAttendances - 1;
    }

    function deactivateAttendance(uint32 weekId) public {
        Attendances[weekId].Active = false;
    }


    // Emit
    // Events are emitted using `emit`, followed by
    // the name of the event and the arguments
    // (if any) in parentheses. Any such invocation
    // (even deeply nested) can be detected from
    // the JavaScript API by filtering for `Deposit`.
    
    
    
    function addRequestPresent(address _address, uint32 weekId) public returns (uint32){
        if (Attendances[weekId].Active){
            numRequests = numRequests + 1;
            requests[numRequests] = Request(_address, Attendances[weekId].presentPrice, true); 
            return numRequests;
        }else{
            return 100003;
        }
    }
    
    function addRequestLate(address _address,uint32 weekId) public returns (uint32){
        if (Attendances[weekId].Active){
            requests[numRequests] = Request(_address, Attendances[weekId].latePrice, true); 
            numRequests = numRequests + 1;
            return numRequests - 1;
        }else{
            return 100004;
        }
    }
    
    function getNumRequests() public view returns (uint32) {
        return numRequests;
    }
    

    function approveRequest(uint32 requestId) public {
        //require(msg.sender == owner);
        if (requests[requestId].Active) {
            requests[requestId].Active = false; 
            students[requests[requestId].student][0].point = students[requests[requestId].student][0].point + requests[requestId].reward;
        }
    }
    
}
