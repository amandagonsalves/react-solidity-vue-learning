// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Escrow {
  address payable public buyer;
  address payable public seller;
  mapping(address => uint256) TotalAmount;

  enum State {
    awaiting_payment,
    awaiting_confirmation,
    complete
  }

  State public state;

  modifier instate(State expected_state) {
    require(state == expected_state);
    _;
  }

  modifier onlyBuyer() {
    require(msg.sender == buyer);
    _;
  }

  modifier onlySeller() {
    require(msg.sender == seller);
    _;
  }

  constructor(address payable _buyer, address payable _seller) public {
    buyer = _buyer;
    seller = _seller;
  }

  function deposit() public onlyBuyer instate(State.awaiting_payment) {
    seller.transfer(address(this).balance);
    state = State.awaiting_confirmation;
  }

  function confirmTransfer() public onlyBuyer instate(State.awaiting_confirmation) {
    seller.transfer(address(this).balance);
    state = State.complete;
  }

  function returnPayment() public onlySeller instate(State.awaiting_confirmation) {
    buyer.transfer(address(this).balance);
  }
}
