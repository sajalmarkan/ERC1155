// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract ERC1155Contract is ERC1155, ERC1155Pausable, ERC1155Supply {

    uint public publicPrice =0.002 ether;
    uint public allowListPrice=0.001 ether;
    uint public maxSupply=100;
    uint public maxPerWallet =20;
    address public owner;

    using Strings for uint256;


    bool public publicMintOpen=false;
    bool public allowListMintOpen=true;

    mapping(address=>bool) allowList;
    mapping(address=>uint) purchasesPetWallet;

    constructor()
        ERC1155("https://aqua-gigantic-lungfish-89.mypinata.cloud/ipfs/QmRJQCuEKQmTfRDJDfXS2ihCErQ79k69PK44CwQufnnmZQ/")
    {owner=msg.sender;}

    function editMintWindow(
        bool _publicMintOpen, bool _allowListMintOpen
        )external
    {
        require(msg.sender==owner,"you cannot change it as only owner can do this");
        publicMintOpen = _publicMintOpen;
        allowListMintOpen = _allowListMintOpen;
    }

    function setURI(string memory newuri) public {
        _setURI(newuri);
    }

    function setAllowList(
        address[] calldata addresses
        )external
    {
        require(msg.sender==owner,"only owner can set this list");
        for(uint i=0;i<addresses.length;i++){
            allowList[addresses[i]]=true;
        }
    }

    function publicMint( uint256 id, uint256 amount)
        public
        payable
    {
        require(purchasesPetWallet[msg.sender]+amount<=maxPerWallet,"wallet limit reached");
        require(publicMintOpen,"public Mint is Closed");
        require(id>0 && id<5,"incorrect token id");
        require(msg.value == publicPrice * amount,"not evough money sent");
        require(totalSupply(id) +amount <=maxSupply,"not enough tokens");
        _mint(msg.sender, id, amount,"");
        purchasesPetWallet[msg.sender]+=amount;
    }

    function allowListMint( uint256 id, uint256 amount)
        public
        payable
    {
        require(purchasesPetWallet[msg.sender]+amount<=maxPerWallet,"wallet limit reached");
        require(allowList[msg.sender],"your are not on allow list");
        require(allowListMintOpen,"allow List Mint is Closed");
        require(id>0 && id<5,"incorrect token id");
        require(msg.value == allowListPrice * amount,"not evough money sent");
        require(totalSupply(id) +amount <=maxSupply,"not enough tokens");
        _mint(msg.sender, id, amount,"");
        purchasesPetWallet[msg.sender]+=amount;
    }

    function uri(uint256 _id) public view virtual override returns (string memory) {
        require(exists(_id),"uri non existent token");
        return string(abi.encodePacked(super.uri(_id), Strings.toString(_id),".json"));
    }

    function withdraw(address _addr) external {
        require(msg.sender==owner,"only owner can withdraw");
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
  }

    function _update(address from, address to, uint256[] memory ids, uint256[] memory values)
        internal
        override(ERC1155, ERC1155Pausable, ERC1155Supply)
    {
        super._update(from, to, ids, values);
    }
}
