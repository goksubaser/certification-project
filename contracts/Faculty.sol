pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";

contract Faculty is ERC721, Roles{
    string[] _facultyNames;
    mapping(string => bool) _facultyExist;

    constructor() ERC721("Faculty", "FAC") public{
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(RECTOR_ROLE, msg.sender);
    }

    function mint(string memory _facultyName, address facultyAddress) public onlyRole(RECTOR_ROLE){
        require(!_facultyExist[_facultyName], "This Faculty is already exist");
        require(hasRole(FACULTY_ROLE, facultyAddress), "This address is not in FACULTY_ROLE");
        // Faculty - add
        _facultyNames.push(_facultyName);
        uint _id = _facultyNames.length; //tokenID's start from 1 because default uint256 value is 0
        // Call the mint function of ERC721
        _mint(facultyAddress, _id);
        // Faculty - track it
        _facultyExist[_facultyName] = true;
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControlEnumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
