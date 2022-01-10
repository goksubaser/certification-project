pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Roles.sol";

contract Course is ERC721, Roles{

    //Mapping of the instructor to the tokenIDs
    mapping(address => uint256[]) _givesCourses;
    //Mapping of the tokenID to the owner is defined in ERC721.sol
    //Mapping of the student to the tokenIDs
    mapping(address => uint256[]) _takesCourses;
    //Mapping of the tokenID to the students
    mapping(uint256 => address[]) _studentsOf;
    //is Course link exist
    mapping(string => bool) _courseExist;
    //List of Course Links
    string[] _courseLinks;

    constructor() ERC721("Course", "CRS"){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);//TODO Transfer Admin to Rector later
    }

    //TODO Change It To Role Based Ownership From Public
    function mint(string memory _courseLink, address instructorAddress) public{
        require(!_courseExist[_courseLink], "This link is already minted");
        //diplomaLinks - add
        _courseLinks.push(_courseLink);
        uint _id = _courseLinks.length; //tokenID's start from 1 because default uint256 value is 0
        //Call mint of ERC721
        _mint(instructorAddress, _id);
        //Trace it
        _courseExist[_courseLink] = true;
        _givesCourses[instructorAddress].push(_id);
    }
    function getCourseLinks() public view returns(string[] memory courseLinks){
        return _courseLinks;
    }
    function getGivesCourses(address instructorAddress) public view returns (uint[] memory givesCourses){
        return _givesCourses[instructorAddress];
    }

    //TODO Contract Owner can make mistakes when minting. Token should be somewhat editable for contract owner
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
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
