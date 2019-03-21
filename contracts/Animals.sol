pragma solidity >=0.4.25;
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";
import "./WhitelistAdminRole.sol";
import "./WhitelistedRole.sol";
contract Animals is ERC721,WhitelistAdminRole,WhitelistedRole{

    event BreederRemoved(address indexed account);
    event BreederAdded(address indexed account);
    event PetDied(address indexed account);
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    address public owner;
    uint256 public nextTokenId;
    string unknown;
    string baby;


    address public beneficiary;
    uint public auctionEndTime;
    address public highestBidder;
    uint public highestBid;
    uint public biddingTime;


    bool ended;

    mapping(address => uint) pendingReturns;

    Roles.Role private _registerBreeders;
    struct Pet
    {
        string name;
        string race;
        string espece;
        uint256 age;
        bool horny;
        address proprietaire;
    }

    struct Foofighter
    {
        bool peutcombattre;
        uint level; 
        uint256 nbVictoire;
        uint256 nbDefaite;
    }

    struct Genes
    {
        string color;
        string fur;
        string eyes;
    }

    struct Sex
    {
        bool sex;
    }

    struct Proprietaire
    {
        address account;
        uint256 nbPets;
        bool feuVert;
        mapping(uint256=>Pet) _myPets;
    }
    mapping (uint256 => address) private _tokenOwner;
    mapping(uint=>Pet) public _registerPet;
    mapping(uint=>Foofighter) public _registerFighting;
    mapping(uint=>Genes) public _registerGenes;
    mapping(uint=>Sex) public _registerSex;
    mapping(uint=>Proprietaire) public _registerProp;
    

    constructor() public{
        owner = 0x81D73743E4d31EBa453343264d6cEd820bB436f1;
        nextTokenId = 0;
        baby = baby;
       // biddingTime=
       //auctionEndTime = now + _biddingTime;
        ended = false;
        addWhitelisted(0x81D73743E4d31EBa453343264d6cEd820bB436f1);
        addWhitelisted(0x335aD6C6977115cDE1033E86950656A9871C0a25);
        _transferFrom(owner,0xbdB575cc6762080A4C262718Cf3645e9b5E7278B,3);
    }

    //---------------------------------Functions-------------------------------//
    modifier onlyOwner(address account) {
        require(account==msg.sender);
        _;
    }
   
    function addBreeder(address account) public onlyOwner(owner){
        require(isWhitelisted(account)==true);
        _registerBreeders.add(account);
        emit BreederAdded(account);

    }

    function removeBreeder(address account) public onlyOwner(owner) {
        require(isWhitelisted(account)==true);
        _registerBreeders.remove(account);
        emit BreederRemoved(account);
    }

    function addPet(string memory _name,string memory _race,string memory _espece)public returns(bool){
        require(isWhitelisted(msg.sender) == true);
        _tokenOwner[nextTokenId] = msg.sender;
        _registerPet[nextTokenId].proprietaire = msg.sender;
        _registerPet[nextTokenId].name = _name;
        _registerPet[nextTokenId].race = _race;
        _registerPet[nextTokenId].espece = _espece;
        _registerPet[nextTokenId].age = 0;
        _tokenOwner[nextTokenId] = msg.sender;
        nextTokenId = nextTokenId+1;
        //Pour le sex associer un sex avec une chance sur 2
        return true;
    }

    function deadPet(address proprio, uint256 tokenId)public {
        _burn(owner,tokenId);
        emit PetDied(owner);

    }


    function setHorny(uint _tokenId) public  returns (bool) {
        require(msg.sender!= address(0));
        require(isWhitelisted(msg.sender) == true,"vous n'êtes pas whitelisté");
        require(_tokenOwner[_tokenId] == msg.sender,"vous devez être le propriétaire de l'animal");
        _registerPet[_tokenId].horny = true;
        return _registerPet[_tokenId].horny;
    }

    function setFeuvert(uint256 _tokenId)public returns (bool){
        require(msg.sender!= address(0));
       
        if (_tokenOwner[_tokenId]==msg.sender){
            _registerProp[_tokenId].feuVert=true;
            return _registerProp[_tokenId].feuVert;
        }
       
    }

    function breedAnimal(address prop1, address prop2,uint _tokenId1,uint _tokenId2,string memory _name,string memory _race,string memory _sex, string memory _espece)public returns(bool){
        require(_tokenOwner[_tokenId1] == prop1,"vous devez être proprietaire de cet animal");
        require(_tokenOwner[_tokenId2] == prop2,"vous devez être proprietaire de cet animal");
        if (_registerPet[_tokenId1].horny == true && _registerPet[_tokenId2].horny == true && _registerProp[_tokenId1].feuVert == true && _registerProp[_tokenId2].feuVert == true){
            if(msg.sender==prop1||msg.sender==prop2){
                _registerGenes[nextTokenId] = _registerGenes[_tokenId1];
                addPet(baby,_registerPet[_tokenId1].race,_registerPet[_tokenId2].espece);
                return addPet(baby,_registerPet[_tokenId1].race,_registerPet[_tokenId2].espece);

            }

        }
        
    }
    /*
    function withdraw() public returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }
    */

    function auctionEnd() public {

        // 1. Conditions
        require(now >= auctionEndTime, "Auction not yet ended.");
        require(!ended, "auctionEnd has already been called.");

        // 2. Éffets
        ended = true;
        emit AuctionEnded(highestBidder, highestBid);

        // 3. Interaction
        beneficiary = highestBidder;

    }


    function betOnAuction(uint256 tokenId, uint256 bid)public{
        require(_tokenOwner[tokenId]!=msg.sender);
        require( now <= auctionEndTime,"Auction already ended.");
        require(bid > highestBid,"There already is a higher bid.");
        if (highestBid != 0) {
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = bid;
        emit HighestBidIncreased(msg.sender,bid);

    }

    




}


