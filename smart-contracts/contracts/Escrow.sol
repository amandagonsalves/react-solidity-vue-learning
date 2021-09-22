// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Escrow {
  address payable public buyer;
  address payable public seller;
  address public arbiter;
  mapping(address => uint256) TotalAmount;

  enum State {
    awate_payment,
    awate_delivery,
    complete
  }

  State public state;

  modifier instate(State expected_state) {
    require(state == expected_state);
    _;
  }

  modifier onlyBuyer() {
    require(msg.sender == buyer || msg.sender == arbiter);
    _;
  }

  modifier onlySeller() {
    require(msg.sender == seller);
    _;
  }

  constructor(address payable _buyer, address payable _seller) public {
    buyer = _buyer;
    seller = _seller;
    arbiter = msg.sender;
  }

  function confirmPayment() public onlyBuyer instate(State.awate_delivery) {
    seller.transfer(address(this).balance);
    state = State.awate_delivery;
  }

  function confirm_Delivery() public onlyBuyer instate(State.awate_delivery) {
    seller.transfer(address(this).balance);
    state = State.complete;
  }

  function ReturnPayment() public onlySeller instate(State.awate_delivery) {
    buyer.transfer(address(this).balance);
  }
}
