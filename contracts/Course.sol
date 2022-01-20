pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";
import "./Request.sol";

contract Course is ERC721{

    address rolesContractAddress;
    address requestContractAddress;

    //Mapping of the instructor to the tokenIDs
    mapping(address => uint256[]) _givesCourses;
    //Mapping of the tokenID to the owner is defined in ERC721.sol

    //TODO///////////////////////////////////////////
    //Mapping of the student to the tokenIDs
    mapping(address => uint256[]) _takesCourses;
    //Mapping of the tokenID to the request of students
    mapping(uint256 => address[]) _requestOfStudents;
    //Mapping of the tokenID to the approved students
    mapping(uint256 => address[]) _approvedStudents;
    //Mapping of the tokenID to frozen or not
    mapping(uint256 => bool) _frozen;
    //TODO///////////////////////////////////////////

    //is Course link exist
    mapping(string => bool) _courseExist;
    //List of Course Links
    string[] _courseLinks;

    constructor(address _rolesContractAddress, address _requestContractAddress) ERC721("Course", "CRS"){
        rolesContractAddress =_rolesContractAddress;
        requestContractAddress = _requestContractAddress;
    }
    function mint(string memory _courseLink, address _instructorAddress) public{
        require(Roles(rolesContractAddress).hasRectorRole(msg.sender), "This account does not have the Rector Permissions");
        require(Roles(rolesContractAddress).hasInstructorRole(_instructorAddress), "This address is not an instructor");
        require(!_courseExist[_courseLink], "This link is already minted");
        //_courseLinks - add
        _courseLinks.push(_courseLink);
        uint _id = _courseLinks.length;
        //tokenID's start from 1 because default uint256 value is 0
        //Call mint of ERC721
        _mint(_instructorAddress, _id);
        //Trace it
        _courseExist[_courseLink] = true;
        _givesCourses[_instructorAddress].push(_id);
        _frozen[_id] = false;

        //Make request minted
        Request(requestContractAddress).courseMinted(_courseLink);
    }
    function applyCourse(uint256 _id) public{
        //Requirements
        require(Roles(rolesContractAddress).hasStudentRole(msg.sender), "This account does not have the Student Permissions");
        require(_id<=_courseLinks.length && _id>0, "This course does not exist");
        require(!_frozen[_id],"This course is closed by the Instructor");
        require(!isExist(_approvedStudents[_id], msg.sender), "This student already approved for this course");
        require(!isExist(_requestOfStudents[_id], msg.sender), "This student already applied for this course");

        //Push it
        _requestOfStudents[_id].push(msg.sender);
    }
    function getCourseLinks() public view returns(string[] memory courseLinks){
        return _courseLinks;
    }
    function getGivesCourses(address instructorAddress) public view returns (uint[] memory givesCourses){
        return _givesCourses[instructorAddress];
    }
    function getTakesCourses(address studentAddress)public view returns(uint256[] memory){
        return _takesCourses[studentAddress];
    }
    function getRequestOfStudents(uint _id)public view returns(address[] memory){
        return _requestOfStudents[_id];
    }
    function getApprovedStudents(uint _id)public view returns(address[] memory){
        return _approvedStudents[_id];
    }
    function getFrozen(uint256 _id) public view returns(bool){
        return _frozen[_id];
    }

    function isExist(address[] storage list, address element) private view returns(bool){
        for(uint256 i = 0; i<list.length; i++){
            if(list[i] == element){
                return true;
            }
        }
        return false;
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
}
