pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";

contract Faculty is ERC721{

    address rolesContractAddress;

    uint256 _totalSupply = 0;
    //mapping from tokenID to facultyName
    mapping(uint256 => string) _facultyNameOfID;
    //mapping from facultyName to tokenID
    mapping(string => uint256) _IDOfFacultyName;
    //mapping from tokenID to its departments
    mapping(uint256 => address[]) _departments;

    constructor(address _rolesContractAddress) ERC721("Faculty", "FAC"){
        rolesContractAddress =_rolesContractAddress;
    }

    function mint(string memory _facultyName, address facultyAddress) public{
        require(Roles(rolesContractAddress).hasRectorRole(msg.sender), "This account does not have Rector Permmisions");
        require(_IDOfFacultyName[_facultyName] == 0, "This Faculty is already exist");
        Roles(rolesContractAddress).grantFacultyRole(facultyAddress);
        require(Roles(rolesContractAddress).hasFacultyRole(facultyAddress), "This address is not in FACULTY_ROLE");
        require(keccak256(abi.encodePacked(_facultyName)) != keccak256(abi.encodePacked("")), "Faculty name cannot be empty");
        // Faculty - add
        _totalSupply = _totalSupply + 1;
        uint _id = _totalSupply; //tokenID's start from 1 because default uint256 value is 0
        // Call the mint function of ERC721
        _mint(facultyAddress, _id);
        // Faculty - track it
        _IDOfFacultyName[_facultyName] = _id;
        _facultyNameOfID[_id] = _facultyName;
    }
    function getFacultyName(uint256 id) public view returns(string memory){
        return _facultyNameOfID[id];
    }
    function getFacultyID(string memory facultyName) public view returns(uint256){
        return _IDOfFacultyName[facultyName];
    }
    function getTotalSupply() public view returns(uint256){
        return _totalSupply;
    }
    function getDepartments(uint256 id) public view returns(address[] memory){
        return _departments[id];
    }
    //TODO handle public visiblity to onlyRole
    function setDepartments(uint256 id, address[] memory departments) public{
        require(Roles(rolesContractAddress).hasRectorRole(msg.sender), "This address does not have Rector Permissions");
        _departments[id] = departments;
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
