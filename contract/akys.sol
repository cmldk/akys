pragma solidity >=0.4.22 <0.6.0;
pragma experimental ABIEncoderV2;

contract akys{
    struct NeedOffer{
        string needID;
        string personalDataHash;
        string needType;
        uint256 amount;
    }
    
    struct SupportOffer{
        string supportID;
        string personalDataHash;
        string supportType;
        uint256 supportAmount;
        string sendType;
    }
    
    // Total Count of Offers
    uint256 TotalCountSupportOffers;
    uint256 TotalCountNeedOffers;
    
    // Added Support Offers
    SupportOffer[] SupportOfferList;

    // Added All Need Offers  
    NeedOffer[] NeedOfferList;
    
    // Approved Support Offers
    SupportOffer[] ApprovedSupportOfferList;

    // Approved Need Offers Count
    NeedOffer[] ApprovedNeedOfferList;
    
    // Canceled Support Offers
    SupportOffer[] CanceledSupportOfferList;
    
    // Canceled Need Offers Count
    NeedOffer[] CanceledNeedOfferList;
    
    // User Auth
    mapping(address => string) UserAuth;
    
    // Need & Support Maps
    // supportID -> SupportOffer
    mapping(string => SupportOffer) SupportOfferMap;
    // needID -> NeedOffer
    mapping(string => NeedOffer) NeedOfferMap;

    // Status of Offers
    // supportID -> Status
    mapping(string=>string) SupportOfferStatus;
    // needID -> Status
    mapping(string=>string) NeedOfferStatus;


    modifier checkAuth(string memory _role){
        require(keccak256(abi.encode(UserAuth[msg.sender])) == keccak256(abi.encode(_role)));
        _;
    }
    
    constructor() public{
        UserAuth[msg.sender] = "ADMIN";
    }

    //Remove function from array for SupportOffer
    function removeSupport(SupportOffer[] memory _array,SupportOffer memory _support) public view checkAuth("CHECKER") {
        for (uint128 i = 0; i<_array.length; i++){
            if(keccak256(abi.encode(_array[i])) == keccak256(abi.encode(_support))){
                delete _array[i];
                break;
            }
            i+=1;
        }
    }

    //Remove function from array for NeedOffer
    function removeNeed(NeedOffer[] memory _array,NeedOffer memory _need) public view checkAuth("CHECKER") {
        for (uint128 i = 0; i<_array.length; i++){
            if(keccak256(abi.encode(_array[i])) == keccak256(abi.encode(_need))){
                delete _array[i];
                break;
            }
            i+=1;
        }
    }
    
    // Set User Role to a User Address
    function setUser(address _userAddress, string memory _role) public checkAuth("ADMIN"){
        UserAuth[_userAddress] = _role;
    }
     
    // Get User's Role 
    function getUserAuth(address _userAddress) public view checkAuth("ADMIN") returns ( string memory){
        return UserAuth[_userAddress];
    }
    
    // Create a new Support
    function createSupport(
        string memory _supportID,
        string memory _personalDataHash, 
        string memory _supportType, 
        uint256 _supportAmount, 
        string memory _sendType)public checkAuth("CREATER") returns(SupportOffer memory){
        SupportOffer memory newSupportOffer = SupportOffer({
            supportID : _supportID,
            supportType : _supportType,
            personalDataHash : _personalDataHash,
            supportAmount : _supportAmount,
            sendType : _sendType
        });
        
        SupportOfferList.push(newSupportOffer);
        SupportOfferMap[_supportID] = newSupportOffer;
        SupportOfferStatus[_supportID] = "WAITING";

        return newSupportOffer;
    }
    
    // Create a new Need
    function createNeed(
        string memory _needID,
        string memory _personalDataHash, 
        string memory _needtype, 
        uint256 _amount
         )public checkAuth("CREATER") returns(NeedOffer memory){
        NeedOffer memory newNeedOffer =  NeedOffer({
            personalDataHash : _personalDataHash,
            needID : _needID,
            needType : _needtype,
            amount : _amount
        });

        NeedOfferList.push(newNeedOffer);
        NeedOfferMap[_needID] = newNeedOffer;
        NeedOfferStatus[_needID] = "WAITING";

        return newNeedOffer;
    }

    function showSupport(string memory _supportID)public view returns(SupportOffer memory){
        return SupportOfferMap[_supportID];
    }

    function showNeed(string memory _needID)public view returns(NeedOffer memory){
        return NeedOfferMap[_needID];
    }

    function approveSupport(string memory _supportID) public  checkAuth("CHECKER"){
        SupportOfferStatus[_supportID] = "APPROVED";
        removeSupport(SupportOfferList,SupportOfferMap[_supportID]);
        ApprovedSupportOfferList.push(SupportOfferMap[_supportID]);
    }

    function approveNeed(string memory _needID) public checkAuth("CHECKER") {
        NeedOfferStatus[_needID] = "APPROVED";
        removeNeed(NeedOfferList,NeedOfferMap[_needID]);
        ApprovedNeedOfferList.push(NeedOfferMap[_needID]);
    }

    function cancelSupport(string memory _supportID) public  checkAuth("CHECKER"){
        CanceledSupportOfferList.push(SupportOfferMap[_supportID]);
        delete SupportOfferMap[_supportID];
        removeSupport(SupportOfferList,SupportOfferMap[_supportID]);
        removeSupport(ApprovedSupportOfferList,SupportOfferMap[_supportID]);
    }

    function cancelNeed(string memory _needID) public checkAuth("CHECKER") {
        CanceledNeedOfferList.push(NeedOfferMap[_needID]);
        delete NeedOfferMap[_needID];
        removeNeed(NeedOfferList,NeedOfferMap[_needID]);
        removeNeed(ApprovedNeedOfferList,NeedOfferMap[_needID]);
    }

    function showSupports()public view returns(SupportOffer[] memory){
        return SupportOfferList;
    }

    function showNeeds()public view returns(NeedOffer[] memory){
        return NeedOfferList;
    }

   
    function showApprovedSupport(string memory _supportID)private view returns(SupportOffer memory){
        if(keccak256(abi.encode(SupportOfferMap[_supportID])) == keccak256(abi.encode("APPROVED"))){
            return SupportOfferMap[_supportID];
        }
    }

    function showApprovedNeed(string memory _needID)private view returns(NeedOffer memory){
        if(keccak256(abi.encode(NeedOfferStatus[_needID])) == keccak256(abi.encode("APPROVED"))){
            return NeedOfferMap[_needID];
        }
    }
    
    function showAllApprovedSupports()public view returns(SupportOffer[] memory){
        return ApprovedSupportOfferList;
    }

    function showAllApprovedNeeds()public view returns(NeedOffer[] memory){
        return ApprovedNeedOfferList;
    }
    
    function showSupportStatus(string memory _supportID) public view checkAuth("CHECKER") returns (string memory) {
        return SupportOfferStatus[_supportID];
    }
    
    function showNeedStatus(string memory _needID) public view checkAuth("CHECKER") returns (string memory) {
        return NeedOfferStatus[_needID];
    }

    function showCanceledSupports() public view returns(SupportOffer[] memory) {
        return CanceledSupportOfferList;
    }
/*
    function showCanceledNeeds() public view returns(NeedOffer[] memory) {
        return CanceledNeedOfferList;
    }

    function showTotalSupportCount() public view returns(uint256) {
        return SupportOfferList.length;
    }

    function showTotalNeedCount() public view returns(uint256) {
        return NeedOfferList.length;
    }
  */  
}