// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LKCOIN {

    //Event is an inheritable member of the contract, which stores the arguments passed in the transaction logs when emitted. 
    //Generally, events are used to inform the calling application about the current state of the contract
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

    string public constant name = "LKCOIN";
    string public constant symbol = "LKC";
    //smallest possible ethereum token denomination which can be used for transfer is 0.00001 if decimal is 5
    uint8 public constant decimals = 5;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    //Need to define total supply at the time of deployment of contract
    constructor(uint256 total) {
      totalSupply_ = total;
      balances[msg.sender] = totalSupply_;
    }

    //check total supply of cryptocoin
    function totalSupply() public view returns (uint256) {
      return totalSupply_;
    }

    //check balance of any wallet address
    function balanceOf(address tokenOwner) public view returns (uint) {
        return balances[tokenOwner];
    }

    //transfer coin from one wallet address to another wallet address
    function transfer(address receiver, uint numTokens) public returns (bool) {
        //reject request if no of tokens transfer request is more than tokens in wallet
        require(numTokens <= balances[msg.sender]);
        //substract tokens from minter
        balances[msg.sender] -= numTokens;
        //add tokens to receiver
        balances[receiver] += numTokens;
        //Inside a contract, once the event is defined, You can trigger the events using emit keyword with the below syntax. emit transfer(_from, _to, amount);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function transferFrom(address owner, address buyer, uint numTokens) public returns (bool) {
        //reject request if no of tokens transfer request is more than no of tokens in owner's wallet
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        //substract tokens from minter
        balances[owner] -= numTokens;
        allowed[owner][msg.sender] -= numTokens;
        //add tokens to receiver
        balances[buyer] += numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}
