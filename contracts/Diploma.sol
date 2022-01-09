pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Diploma is ERC721, Ownable{

    //Mapping owner to the tokenID
    mapping(address => uint256) _hasCertificate;
    //Mapping tokenID to the owner is defined in ERC721.sol as ownerOf
    //is Diploma link exist
    mapping(string => bool) _diplomaExist;
    //List of Diploma Links
    string[] _diplomaLinks;

    constructor() ERC721("Diploma", "DPLM"){}

    //TODO Change It To Role Based Ownership From Public
    function mint(string memory _diplomaLink, address graduateAddress) public{
        require(!_diplomaExist[_diplomaLink], "This link is already minted");
        require(_hasCertificate[graduateAddress] == 0, "This graduate already has a Diploma");
        //diplomaLinks - add
        _diplomaLinks.push(_diplomaLink);
        uint _id = _diplomaLinks.length; //tokenID's start from 1 because default uint256 value is 0
        //Call mint of ERC721
        _mint(graduateAddress, _id);
        //Trace it
        _diplomaExist[_diplomaLink] = true;
        _hasCertificate[graduateAddress] = _id;
    }
    function getDiplomaLinks() public view returns(string[] memory diplomaLinks){
        return _diplomaLinks;
    }

}
