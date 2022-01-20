pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";
import "./Request.sol";

contract Diploma is ERC721 {

    address rolesContractAddress;
    address requestContractAddress;

    //Mapping owner to the tokenID
    mapping(address => uint256) _hasCertificate;
    //Mapping tokenID to the owner is defined in ERC721.sol as ownerOf
    //is Diploma link exist
    mapping(string => bool) _diplomaExist;
    //List of Diploma Links
    string[] _diplomaLinks;

    constructor(address _rolesContractAddress, address _requestContractAddress) ERC721("Diploma", "DPLM"){
        rolesContractAddress = _rolesContractAddress;
        requestContractAddress = _requestContractAddress;
    }
    function mint(string memory _diplomaLink, address _graduatedAddress) public {
        require(Roles(rolesContractAddress).hasRectorRole(msg.sender), "This account has not Rector Permissions");
        require(Roles(rolesContractAddress).hasStudentRole(_graduatedAddress), "This address is not in STUDENT_ROLE");
        require(!_diplomaExist[_diplomaLink], "This link is already minted");
        require(_hasCertificate[_graduatedAddress] == 0, "This graduate already has a Diploma");
        //Role function calls
        Roles(rolesContractAddress).grantGraduatedRole(_graduatedAddress);
        //diplomaLinks - add
        _diplomaLinks.push(_diplomaLink);
        uint _id = _diplomaLinks.length;
        //tokenID's start from 1 because default uint256 value is 0
        //Call mint of ERC721
        _mint(_graduatedAddress, _id);
        //Trace it
        _diplomaExist[_diplomaLink] = true;
        _hasCertificate[_graduatedAddress] = _id;

        //Make request minted
        Request(requestContractAddress).diplomaMinted(_diplomaLink, _graduatedAddress);
    }

    function getDiplomaLinks() public view returns (string[] memory diplomaLinks){
        return _diplomaLinks;
    }


    //TODO Contract Owner can make mistakes when minting. Token should be somewhat editable for contract owner
    function transferFrom(//Only callable when minted
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(msg.sender == 0x0000000000000000000000000000000000000000, "Transfer after mint is prohibited");
        super.transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(//Only callable when minted
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        require(msg.sender == 0x0000000000000000000000000000000000000000, "Transfer after mint is prohibited");
        super.safeTransferFrom(from, to, tokenId);
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
