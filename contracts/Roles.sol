pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract Roles is AccessControlEnumerable {

    bytes32 public constant RECTOR_ROLE = keccak256("RECTOR_ROLE");
    bytes32 public constant FACULTY_ROLE = keccak256("FACULTY_ROLE");
    bytes32 public constant DEPARTMENT_ROLE = keccak256("DEPARTMENT_ROLE");
    bytes32 public constant INSTRUCTOR_ROLE = keccak256("INSTRUCTOR_ROLE");
    bytes32 public constant STUDENT_ROLE = keccak256("STUDENT_ROLE");
    bytes32 public constant GRADUATED_ROLE = keccak256("GRADUATED_ROLE");

    //Unordered lists of roles
    address Rector;
    address[] Faculties;
    address[] Departments;
    address[] Instructors;
    address[] Students;
    address[] Graduateds;

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(RECTOR_ROLE, msg.sender);
        Rector = msg.sender;
    }

    function init(
        address _courseContractAddress,
        address _departmentContractAddress,
        address _diplomaContractAddress,
        address _facultyContractAddress
    ) public onlyRole(RECTOR_ROLE){
        _setupRole(DEFAULT_ADMIN_ROLE, _courseContractAddress);
        _setupRole(RECTOR_ROLE, _courseContractAddress);

        _setupRole(DEFAULT_ADMIN_ROLE, _departmentContractAddress);
        _setupRole(RECTOR_ROLE, _departmentContractAddress);

        _setupRole(DEFAULT_ADMIN_ROLE, _diplomaContractAddress);
        _setupRole(RECTOR_ROLE, _diplomaContractAddress);

        _setupRole(DEFAULT_ADMIN_ROLE, _facultyContractAddress);
        _setupRole(RECTOR_ROLE, _facultyContractAddress);
    }
    //////////////////////////// CREATE ROLE ///////////////////////////////////////////////////////////////////////////
    function grantRectorRole(address account) public onlyRole(RECTOR_ROLE) {
        roleCheck(account, false);
        grantRole(RECTOR_ROLE, account);
        grantRole(DEFAULT_ADMIN_ROLE, account);
        renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
        renounceRole(RECTOR_ROLE, msg.sender);
        Rector = account;
    }
    function grantFacultyRole(address account) public onlyRole(RECTOR_ROLE) {
        roleCheck(account, false);
        grantRole(FACULTY_ROLE, account);
        Faculties.push(account);
    }
    function grantDepartmentRole(address account) public onlyRole(RECTOR_ROLE) {
        roleCheck(account, false);
        grantRole(DEPARTMENT_ROLE, account);
        Departments.push(account);
    }
    function grantInstructorRole(address account) public onlyRole(RECTOR_ROLE) {
        roleCheck(account, false);
        grantRole(INSTRUCTOR_ROLE, account);
        Instructors.push(account);
    }
    function grantStudentRole(address account) public onlyRole(RECTOR_ROLE) {
        roleCheck(account, false);
        grantRole(STUDENT_ROLE, account);
        Students.push(account);
    }
    function grantGraduatedRole(address account) public onlyRole(RECTOR_ROLE) {
        roleCheck(account, true);
        require(hasRole(STUDENT_ROLE, account), "The address is not a student");
        revokeStudentRole(account);
        grantRole(GRADUATED_ROLE, account);
        Graduateds.push(account);
    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// READ ROLE /////////////////////////////////////////////////////////////////////////////
    function hasRectorRole(address account) public view returns (bool){return hasRole(RECTOR_ROLE, account);}
    function hasFacultyRole(address account) public view returns (bool){return hasRole(FACULTY_ROLE, account);}
    function hasDepartmentRole(address account) public view returns (bool){return hasRole(DEPARTMENT_ROLE, account);}
    function hasInstructorRole(address account) public view returns (bool){return hasRole(INSTRUCTOR_ROLE, account);}
    function hasStudentRole(address account) public view returns (bool){return hasRole(STUDENT_ROLE, account);}
    function hasGraduatedRole(address account) public view returns (bool){return hasRole(GRADUATED_ROLE, account);}

    function getRectorRole() public view returns(address){return Rector;}
    function getFacultyRoles() public view returns(address[] memory){return Faculties;}
    function getDepartmentRoles() public view returns(address[] memory){return Departments;}
    function getInstructorRoles() public view returns(address[] memory){return Instructors;}
    function getStudentRoles() public view returns(address[] memory){return Students;}
    function getGraduatedRoles() public view returns(address[] memory){return Graduateds;}
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// DELETE ROLE ///////////////////////////////////////////////////////////////////////////
    function revokeFacultyRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(FACULTY_ROLE, account); removeElement(account,Faculties);}
    function revokeDepartmentRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(DEPARTMENT_ROLE, account); removeElement(account,Departments);}
    function revokeInstructorRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(INSTRUCTOR_ROLE, account); removeElement(account,Instructors);}
    function revokeStudentRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(STUDENT_ROLE, account); removeElement(account,Students);}
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    function removeElement(address element, address[] storage arr) private{
        for(uint i = 0; i<arr.length; i++){
            if(arr[i] == element){
                arr[i] = arr[arr.length-1];
                arr.pop();
            }
        }
    }
    function roleCheck(address account, bool shouldStudent) private{
        require(!hasRole(RECTOR_ROLE, account), "The address is already has RECTOR_ROLE");
        require(!hasRole(FACULTY_ROLE, account), "The address is already has FACULTY_ROLE");
        require(!hasRole(DEPARTMENT_ROLE, account), "The address is already has DEPARTMENT_ROLE");
        require(!hasRole(INSTRUCTOR_ROLE, account), "The address is already has INSTRUCTOR_ROLE");
        if(!shouldStudent){
            require(!hasRole(STUDENT_ROLE, account), "The address is already has STUDENT_ROLE");
        }
        require(!hasRole(GRADUATED_ROLE, account), "The address is already has GRADUATED_ROLE");
    }
}