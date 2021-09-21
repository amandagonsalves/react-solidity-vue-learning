// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Escrow {
  address payable public buyer;
  address payable public seller;
  address payable public arbiter;

  enum State {
    awate_payment,
    awate_delivery,
    complete
  }

  State public state;

  modifier instante(State expected_state) {
    require(state == expected_state);
    _;
  }

  modifier onlyBuyer() {
    require(msg.sender == buyer || msg.sender == arbiter);
    _;
  }
}
