pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

contract Roles is AccessControlEnumerable {
    bytes32 public constant RECTOR_ROLE = keccak256("RECTOR_ROLE");
    bytes32 public constant FACULTY_ROLE = keccak256("FACULTY_ROLE");
    bytes32 public constant DEPARTMENT_ROLE = keccak256("DEPARTMENT_ROLE");
    bytes32 public constant INSTRUCTOR_ROLE = keccak256("INSTRUCTOR_ROLE");
    bytes32 public constant STUDENT_ROLE = keccak256("STUDENT_ROLE");
    bytes32 public constant GRADUATED_ROLE = keccak256("GRADUATED_ROLE");

    //////////////////////////// CREATE ROLE ///////////////////////////////////////////////////////////////////////////
    function grantRectorRole(address account) public onlyRole(RECTOR_ROLE) {
        grantRole(RECTOR_ROLE, account);
        grantRole(DEFAULT_ADMIN_ROLE, account);
        renounceRole(DEFAULT_ADMIN_ROLE, msg.sender);
        renounceRole(RECTOR_ROLE, msg.sender);
    }
//    function grantFacultyRole(address account) public onlyRole(RECTOR_ROLE) {grantRole(FACULTY_ROLE, account);}
//    function grantDepartmentRole(address account) public onlyRole(RECTOR_ROLE) {grantRole(DEPARTMENT_ROLE, account);}
    function grantInstructorRole(address account) public onlyRole(RECTOR_ROLE) {grantRole(INSTRUCTOR_ROLE, account);}
    function grantStudentRole(address account) public onlyRole(RECTOR_ROLE) {grantRole(STUDENT_ROLE, account);}
//    function grantGraduatedRole(address account) public onlyRole(RECTOR_ROLE) {
//        require(hasRole(STUDENT_ROLE, account));
//        revokeRole(STUDENT_ROLE, account);
//        grantRole(GRADUATED_ROLE, account);
//    }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// READ ROLE /////////////////////////////////////////////////////////////////////////////
    function hasRectorRole(address account) public view returns (bool){return hasRole(RECTOR_ROLE, account);}
    function hasFacultyRole(address account) public view returns (bool){return hasRole(FACULTY_ROLE, account);}
    function hasDepartmentRole(address account) public view returns (bool){return hasRole(DEPARTMENT_ROLE, account);}
    function hasInstructorRole(address account) public view returns (bool){return hasRole(INSTRUCTOR_ROLE, account);}
    function hasStudentRole(address account) public view returns (bool){return hasRole(STUDENT_ROLE, account);}
    function hasGraduatedRole(address account) public view returns (bool){return hasRole(GRADUATED_ROLE, account);}

    //TODO It is left for the front-end

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////// DELETE ROLE ///////////////////////////////////////////////////////////////////////////
//    function revokeFacultyRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(FACULTY_ROLE, account);}
//    function revokeDepartmentRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(DEPARTMENT_ROLE, account);}
    function revokeInstructorRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(INSTRUCTOR_ROLE, account);}
    function revokeStudentRole(address account) public onlyRole(RECTOR_ROLE) {revokeRole(STUDENT_ROLE, account);}
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //Create Read Delete
    //1 EF
    //2 Fen Edb
    //3 Ibf
    //4 Mühendislik
    //5 Uygulamalı Bilimler Yüksekokulu
}
