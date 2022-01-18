pragma solidity ^0.8.10;

import "./Department.sol";

contract Request {

    address departmentContractAddress;

    struct DiplomaRequest{
        address studentAddress;
        string diplomaLink;
        address requestorDepartment;
        bool atRector;
    }
    //DiplomaRequest list
    DiplomaRequest[] _diplomaRequests;
    //is Diploma link in _diplomaRequests exist
    mapping(string => bool) _linkDiplomaExist;
    //is Diploma student in _diplomaRequests exist
    mapping(address => bool) _studentRequestExist;

    constructor(address _departmentContractAddress){
        departmentContractAddress = _departmentContractAddress;
    }

    function createDiplomaRequest(string memory _diplomaLink, address _graduatedAddress) public{
        //Requirements
        require(Department(departmentContractAddress).hasDepartmentRole(msg.sender), "This address is not department");
        require(Department(departmentContractAddress).hasStudentRole(_graduatedAddress), "This address is not in STUDENT_ROLE");
        require(!_linkDiplomaExist[_diplomaLink], "This link is already requested before");
        require(!_studentRequestExist[_graduatedAddress], "This student's diploma is already requested before");
        uint256 departmentID = getDepartmentID(msg.sender);
        require(departmentID > 0, "Requestor Department cannot found");
        address[] memory students = Department(departmentContractAddress).getStudents(departmentID);
        bool studentExist = false;
        for(uint i = 0; i<students.length; i++){
            if(students[i] == _graduatedAddress){
                studentExist = true;
            }
        }
        require(studentExist, "This address is not one of the students of this department");
        DiplomaRequest memory request = DiplomaRequest(_graduatedAddress,_diplomaLink, msg.sender, false);
        _diplomaRequests.push(request);
        _linkDiplomaExist[_diplomaLink] = true;
        _studentRequestExist[_graduatedAddress] = true;
    }
    function approveDiplomaRequest(DiplomaRequest memory diplomaRequest) public{
        //Requirements
        require(Department(departmentContractAddress).hasFacultyRole(msg.sender), "This address is not a Faculty");
        require(diplomaRequest.atRector == false, "This request is approved already");
        require(_linkDiplomaExist[diplomaRequest.diplomaLink], "This link is not requested");
        require(_studentRequestExist[diplomaRequest.studentAddress], "This student's diploma is not requested");

        uint256 departmentID = getDepartmentID(diplomaRequest.requestorDepartment);
        require(departmentID > 0, "Requestor Department cannot found");
        require(msg.sender == Department(departmentContractAddress).getFaculty(departmentID), "This Faculty is not the faculty of the requestor");

        //Approval
        for(uint256 i = 0; i<_diplomaRequests.length; i++){
            if(_diplomaRequests[i].studentAddress == diplomaRequest.studentAddress){
                _diplomaRequests[i].atRector = true;
            }
        }
    }
    function disapproveDiplomaRequest() public{
        require(Department(departmentContractAddress).hasFacultyRole(msg.sender), "This address is not a Faculty");
    }
    function getDiplomaRequests() public view returns (DiplomaRequest[] memory){
        return _diplomaRequests;
    }

    struct CourseRequest{
        address instructorAddress;
        string courseLink;
        address requestorDepartment;
        bool atRector;
    }
    //CourseRequest list
    CourseRequest[] _courseRequests;
    //is Diploma link in _courseRequests exist
    mapping(string => bool) _linkCourseExist;

    function createCourseRequest(string memory _courseLink, address _instructorAddress) public{
        //Requirements
        require(Department(departmentContractAddress).hasDepartmentRole(msg.sender), "This address is not department");
        require(Department(departmentContractAddress).hasInstructorRole(_instructorAddress), "This address is not in INSTRUCTOR_ROLE");
        require(!_linkCourseExist[_courseLink], "This link is already requested before");
        uint256 departmentID = getDepartmentID(msg.sender);
        require(departmentID > 0, "Requestor Department cannot found");
        address[] memory instructors = Department(departmentContractAddress).getInstructors(departmentID);
        bool instructorExist = false;
        for(uint i = 0; i<instructors.length; i++){
            if(instructors[i] == _instructorAddress){
                instructorExist = true;
            }
        }
        require(instructorExist, "This address is not one of the instructor of this department");
        CourseRequest memory request = CourseRequest(_instructorAddress,_courseLink, msg.sender, false);
        _courseRequests.push(request);
        _linkCourseExist[_courseLink] = true;
    }
    function approveCourseRequest(CourseRequest memory courseRequest) public{
        //Requirements
        require(Department(departmentContractAddress).hasFacultyRole(msg.sender), "This address is not a Faculty");
    }
    function disapproveCourseRequest() public{
        require(Department(departmentContractAddress).hasFacultyRole(msg.sender), "This address is not a Faculty");
    }
    function getCourseRequests() public view returns (CourseRequest[] memory){
        return _courseRequests;
    }

    function getDepartmentID(address departmentAddress) private returns(uint256){
        for(uint256 i = 1; i<=Department(departmentContractAddress).getTotalSupply(); i++){
            if(Department(departmentContractAddress).ownerOf(i) == msg.sender){
                return i;
            }
        }
        return 0;
    }

}
