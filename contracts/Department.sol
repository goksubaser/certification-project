pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";
import "./Faculty.sol";

contract Department is ERC721{

    address rolesContractAddress;
    address facultyContractAddress;

    uint256 _totalSupply = 0;
    //mapping from tokenID to departmentName
    mapping(uint256 => string) _departmentNameOfID;
    //mapping from departmentName to tokenID
    mapping(string => uint256) _IDOfDepartmentName;

    //mapping from tokenID to its Faculty Address
    mapping(uint256 => address) _faculty;
    //mapping from tokenID to its Instructor Addresses
    mapping(uint256 => address[]) _instructors;
    //mapping from tokenID to its Student Addresses
    mapping(uint256 => address[]) _students;

    constructor(address _rolesContractAddress, address _facultyContractAddress) ERC721("Department", "DEP"){
        rolesContractAddress =_rolesContractAddress;
        facultyContractAddress = _facultyContractAddress;
    }

    function mint(string memory _departmentName, address departmentAddress, address facultyAddress) public{
        require(Roles(rolesContractAddress).hasRectorRole(msg.sender), "This account does not have Rector Permissions");
        require(_IDOfDepartmentName[_departmentName] == 0, "This Department is already exist");
        Roles(rolesContractAddress).grantDepartmentRole(departmentAddress);
        require(Roles(rolesContractAddress).hasDepartmentRole(departmentAddress), "This departmentAddress is not in DEPARTMENT_ROLE");
        require(keccak256(abi.encodePacked(_departmentName)) != keccak256(abi.encodePacked("")), "Department name cannot be empty");
        require(Roles(rolesContractAddress).hasFacultyRole(facultyAddress), "This facultyAddress is not in FACULTY_ROLE");
        // Department - add
        _totalSupply = _totalSupply + 1;
        uint _id = _totalSupply; //tokenID's start from 1 because default uint256 value is 0
        // Call the mint function of ERC721
        _mint(departmentAddress, _id);
        // Department - track it
        _IDOfDepartmentName[_departmentName] = _id;
        _departmentNameOfID[_id] = _departmentName;
        _faculty[_id] = facultyAddress;
        //Add to Faculty's Departments List
        uint256 totalSupply = Faculty(facultyContractAddress).getTotalSupply();
        uint256 facultyID = 0;
        for(uint i = 1; i<=totalSupply; i++){
            if(Faculty(facultyContractAddress).ownerOf(i) == facultyAddress){
                facultyID = i;
                break;
            }
        }
        require(facultyID>0, "Faculty cannot found");
        address[] memory departments = Faculty(facultyContractAddress).getDepartments(facultyID);
        address[] memory newDepartments = new address[](departments.length+1);
        for(uint i = 0; i<departments.length; i++){
            newDepartments[i] = departments[i];
        }
        newDepartments[newDepartments.length-1] = departmentAddress;
        Faculty(facultyContractAddress).setDepartments(facultyID,newDepartments);
    }
    function getDepartmentName(uint256 id) public view returns(string memory departmentName){
        return _departmentNameOfID[id];
    }
    function getDepartmentID(string memory departmentName) public view returns(uint256 departmentID){
        return _IDOfDepartmentName[departmentName];
    }
    function getTotalSupply() public view returns(uint256 totalSupply){
        return _totalSupply;
    }
    function getFaculty(uint256 id) public view returns(address){
        return _faculty[id];
    }
    function getInstructors(uint256 id) public view returns(address[] memory){
        return _instructors[id];
    }
    function setInstructors(uint256 _id, address[] memory instructors, address revoked) public{
        require(Roles(rolesContractAddress).hasRectorRole(msg.sender), "This address does not have Rector Permissions");
        require(_id>0 && _id<=_totalSupply, "This Department does not exist");
        _instructors[_id] = instructors;
        if(revoked == 0x0000000000000000000000000000000000000000){
            Roles(rolesContractAddress).grantInstructorRole(instructors[instructors.length - 1]);
        }else{
            Roles(rolesContractAddress).revokeInstructorRole(revoked);
        }
    }
    function getStudents(uint256 id) public view returns(address[] memory){
        return _students[id];
    }
    function setStudents(uint256 _id, address[] memory students, address revoked) public{
        require(Roles(rolesContractAddress).hasRectorRole(msg.sender), "This address does not have Rector Permissions");
        require(_id>0 && _id<=_totalSupply, "This Department does not exist");
        _students[_id] = students;
        if(revoked == 0x0000000000000000000000000000000000000000){
            Roles(rolesContractAddress).grantStudentRole(students[students.length - 1]);
        }else{
            Roles(rolesContractAddress).revokeStudentRole(revoked);
        }
    }
    function transferFrom(//Only callable when minted
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(msg.sender == 0x0000000000000000000000000000000000000000, "Transfer after mint is prohibited");
        super.transferFrom(from,to,tokenId);
    }
    function safeTransferFrom(//Only callable when minted
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(msg.sender == 0x0000000000000000000000000000000000000000, "Transfer after mint is prohibited");
        super.safeTransferFrom(from,to,tokenId);
    }
    function safeTransferFrom(//Only callable when minted
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public virtual override {
        require(msg.sender == 0x0000000000000000000000000000000000000000, "Transfer after mint is prohibited");
        super.safeTransferFrom(from, to, tokenId, _data);
    }
}