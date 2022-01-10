pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";

contract Department is ERC721, Roles{
    string[] _departmentNames;
    mapping(string => bool) _departmentExist;

    constructor() ERC721("Department", "DEP") public{
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(RECTOR_ROLE, msg.sender);
    }

    function mint(string memory _departmentName, address departmentAddress) public onlyRole(RECTOR_ROLE){
        require(!_departmentExist[_departmentName], "This Department is already exist");
        require(hasRole(DEPARTMENT_ROLE, departmentAddress), "This address is not in DEPARTMENT_ROLE");
        // Department - add
        _departmentNames.push(_departmentName);
        uint _id = _departmentNames.length; //tokenID's start from 1 because default uint256 value is 0
        // Call the mint function of ERC721
        _mint(departmentAddress, _id);
        // Department - track it
        _departmentExist[_departmentName] = true;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControlEnumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
