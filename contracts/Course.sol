pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Course is ERC721, Ownable{

    //Mapping of the instructor to the tokenIDs
    mapping(address => uint256[]) givesCourses;
    //Mapping of the tokenID to the instructor
    mapping(uint256 => address) instructorOf;
    //Mapping of the student to the tokenIDs
    mapping(address => uint256[]) takesCourses;
    //Mapping of the tokenID to the students
    mapping(uint256 => address[]) studentsOf;
    //is Course link exist
    mapping(string => bool) _courseExist;
    //List of Course Links
    string[] courseLinks;


    constructor() ERC721("Course", "CRS"){}
}
