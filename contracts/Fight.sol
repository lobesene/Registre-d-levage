pragma solidity >=0.4.25;
import "./Animals.sol";


contract Fight is Animals {

    constructor()public{
        // biddingTime=
       //auctionEndTime = now + _biddingTime;
    }

    struct Bidder{
        address[] parieur;
        uint[] bet;
        uint balance;
        uint stake;
    }

    mapping(uint256=>Bidder) _registerBidder;
    mapping (uint256 => address) private _tokenOwner;

    function HasWin(uint256 tokenid1,uint256 tokenid2)public returns(uint256){
        uint256 etablir_un_gagnant;
        return etablir_un_gagnant;
    }

    function betOnPet(uint256 tokenId, uint bid)public{
        require( now <= auctionEndTime,"Auction already ended.");
        _registerBidder[tokenId].parieur.push(msg.sender);
        _registerBidder[tokenId].bet.push(bid);
        _registerBidder[tokenId].balance = _registerBidder[tokenId].balance - bid;
        _registerBidder[tokenId].stake = _registerBidder[tokenId].stake + bid;

    }


    function ToFight(uint256 tokenId, uint256 adverssaire) public{
        require(_tokenOwner[tokenId] == msg.sender,"vous ne pouvez pas faire combattre un animal qui n'est pas le votre");
        require(_registerFighting[tokenId].peutcombattre==true," votre animal n'est pas inscrit dans le registre de combat");
        if(_registerFighting[tokenId].level == _registerFighting[adverssaire].level){
            require(_registerFighting[adverssaire].peutcombattre==true,"vous ne pouvez pas faire combattre un animal qui n'est pas le votre");
            //return HasWin(tokenId,adverssaire)
        }
    }

}