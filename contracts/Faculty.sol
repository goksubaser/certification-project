pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";

contract Faculty is ERC721, Roles{
    uint256 _totalSupply = 0;
    //mapping from tokenID to facultyName
    mapping(uint256 => string) _facultyNameOfID;
    //mapping from facultyName to tokenID
    mapping(string => uint256) _IDOfFacultyName;

    constructor() ERC721("Faculty", "FAC") public{
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(RECTOR_ROLE, msg.sender);
    }

    function mint(string memory _facultyName, address facultyAddress) public onlyRole(RECTOR_ROLE){
        require(_IDOfFacultyName[_facultyName] == 0, "This Faculty is already exist");
        require(hasRole(FACULTY_ROLE, facultyAddress), "This address is not in FACULTY_ROLE");
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
    function burn(string memory _facultyName) public onlyRole(RECTOR_ROLE){
        uint _id = _IDOfFacultyName[_facultyName];
        require(_id != 0, "This Faculty is not exist");
        require(keccak256(abi.encodePacked(_facultyNameOfID[_id])) == keccak256(abi.encodePacked(_facultyName)), "Faculty names do not match");
        _burn(_id);
        _facultyNameOfID[_id] = "";
        _IDOfFacultyName[_facultyName] = 0;
    }
    function getFacultyName(uint256 id) public view returns(string memory facultyName){
        return _facultyNameOfID[id];
    }
    function getFacultyID(string memory facultyName) public{
        emit showUint(_IDOfFacultyName[facultyName]);
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
    event showUint(uint256);
}
