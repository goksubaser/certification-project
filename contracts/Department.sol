pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";

contract Department is ERC721, Roles{
    uint256 _totalSupply = 0;
    //mapping from tokenID to departmentName
    mapping(uint256 => string) _departmentNameOfID;
    //mapping from departmentName to tokenID
    mapping(string => uint256) _IDOfDepartmentName;

    //TODO test below
    //mapping from tokenID to its Faculty Address
    mapping(uint256 => address) _faculty;
    //mapping from tokenID to its Instructor Addresses
    mapping(uint256 => address[]) _instructors;
    //mapping from tokenID to its Student Addresses
    mapping(uint256 => address[]) _students;

    constructor() ERC721("Department", "DEP") public{
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(RECTOR_ROLE, msg.sender);
//        grantRectorRole(msg.sender);
    }

    function mint(string memory _departmentName, address departmentAddress, address facultyAddress) public onlyRole(RECTOR_ROLE){
        require(_IDOfDepartmentName[_departmentName] == 0, "This Department is already exist");
        grantDepartmentRole(departmentAddress);
        require(hasRole(DEPARTMENT_ROLE, departmentAddress), "This departmentAddress is not in DEPARTMENT_ROLE");
        require(keccak256(abi.encodePacked(_departmentName)) != keccak256(abi.encodePacked("")), "Department name cannot be empty");
        require(hasRole(FACULTY_ROLE, facultyAddress), "This facultyAddress is not in FACULTY_ROLE");
        // Department - add
        _totalSupply = _totalSupply + 1;
        uint _id = _totalSupply; //tokenID's start from 1 because default uint256 value is 0
        // Call the mint function of ERC721
        _mint(departmentAddress, _id);
        // Department - track it
        _IDOfDepartmentName[_departmentName] = _id;
        _departmentNameOfID[_id] = _departmentName;
        _faculty[_id] = facultyAddress;
    }
//    function burn(string memory _departmentName) public onlyRole(RECTOR_ROLE){
//        uint _id = _IDOfDepartmentName[_departmentName];
//        require(_id != 0, "This Department is not exist");
//        require(keccak256(abi.encodePacked(_departmentNameOfID[_id])) == keccak256(abi.encodePacked(_departmentName)), "Department names do not match");
//        //Revoke Role
//        address owner = ownerOf(_id);
//        revokeDepartmentRole(owner);
//        _burn(_id);
//        _departmentNameOfID[_id] = "";
//        _IDOfDepartmentName[_departmentName] = 0;
//    }
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
    //TODO handle publicity with roles
    function setInstructors(uint256 id, address[] memory instructors) public{
        _instructors[id] = instructors;
    }
    function getStudents(uint256 id) public view returns(address[] memory){
        return _students[id];
    }
    //TODO handle publicity with roles
    function setStudents(uint256 id, address[] memory students) public{
        _students[id] = students;
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
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControlEnumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
