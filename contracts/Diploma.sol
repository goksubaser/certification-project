pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./Roles.sol";
import "./Department.sol";

contract Diploma is ERC721, Roles {

//    struct DiplomaRequest{
//        address studentAddress;
//        string diplomaLink;
//        address requestorDepartment;
//        bool atRector;
//    }

    //Mapping owner to the tokenID
    mapping(address => uint256) _hasCertificate;
    //Mapping tokenID to the owner is defined in ERC721.sol as ownerOf
    //is Diploma link exist
    mapping(string => bool) _diplomaExist;
    //List of Diploma Links
    string[] _diplomaLinks;

//    //DiplomaRequest list
//    DiplomaRequest[] _requests;
//    //is Diploma link in _requests exist
//    mapping(string => bool) _linkRequestExist;
//    //is Diploma student in _requests exist
//    mapping(address => bool) _studentRequestExist;

    constructor() ERC721("Diploma", "DPLM"){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(RECTOR_ROLE, msg.sender);
//        grantRectorRole(msg.sender);
    }
    function mint(string memory _diplomaLink, address _graduatedAddress) public onlyRole(RECTOR_ROLE){
        require(hasRole(STUDENT_ROLE, _graduatedAddress), "This address is not in STUDENT_ROLE");
        require(!_diplomaExist[_diplomaLink], "This link is already minted");
        require(_hasCertificate[_graduatedAddress] == 0, "This graduate already has a Diploma");
        grantGraduatedRole(_graduatedAddress);
        //diplomaLinks - add
        _diplomaLinks.push(_diplomaLink);
        //tokenID's start from 1 because default uint256 value is 0
        //Call mint of ERC721
        _mint(_graduatedAddress, _diplomaLinks.length);
        //Trace it
        _diplomaExist[_diplomaLink] = true;
        _hasCertificate[_graduatedAddress] = _diplomaLinks.length;
    }
//    function createRequest(string memory _diplomaLink, address _graduatedAddress) public onlyRole(DEPARTMENT_ROLE){
//        //Requirements
//        require(hasRole(STUDENT_ROLE, _graduatedAddress), "This address is not in STUDENT_ROLE");
//        require(!_linkRequestExist[_diplomaLink], "This link is already requested before");
//        require(!_studentRequestExist[_graduatedAddress], "This student's diploma is already requested before");
//
//        //TODO check department --> student at frontend
//
//        DiplomaRequest memory request = DiplomaRequest(_graduatedAddress,_diplomaLink, msg.sender, false);
//        _requests.push(request);
//        _linkRequestExist[_diplomaLink] = true;
//        _studentRequestExist[_graduatedAddress] = true;
//    }
//    function approveRequest(DiplomaRequest memory diplomaRequest, address departmentContractAddress) public onlyRole(FACULTY_ROLE){
////        Requirements
//        require(diplomaRequest.atRector == false, "This request is approved already");
//        require(_linkRequestExist[diplomaRequest.diplomaLink], "This link is not requested");
//        require(_studentRequestExist[diplomaRequest.studentAddress], "This student's diploma is not requested");
//
//        //TODO faculty --> department at frontend
//
////        Approval
//        for(uint256 i = 0; i<_requests.length; i++){
//            if(_requests[i].studentAddress == diplomaRequest.studentAddress){
//                _requests[i].atRector = true;
//            }
//        }
//    }
//    function disapproveRequest() public onlyRole(FACULTY_ROLE){
//
//    }
    function getDiplomaLinks() public view returns(string[] memory diplomaLinks){
        return _diplomaLinks;
    }
//    function getDiplomaRequests() public view returns (DiplomaRequest[] memory){
//        return _requests;
//    }

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
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControlEnumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

}
