ERC-3475 Multiple Callable Bonds Standard implementation
=============================================

This repository maintains an example implementation of the [ERC-3475 Abstract Bonds Standard](eips.ethereum.org/eip-3475) for EVM compatible network. 

This token standard can replace current ERC20 LP token. ERC-3475 has more complex data structure, which will allow the LP token to store more information, and allow the developer to build more sophisticated logic for the redemption and reward system of the DeFI project in question.

## Getting started

### Install

`git clone https://github.com/DeBond-Protocol/EIP-3475`

### Usage

```solidity
pragma solidity ^0.8;

import '@DeBond-Protocol/EIP-3475/tree/main/contracts/util/IERC3475.sol';

contract Testbond is IERC3475{
  ...
}
```
## Description:

contracts/ folder has other derivative implementation of the ERC3475 interface funcitons in order for developers to understand how to integrate the different functionalities in the contract as supported by openzeppelin contract. ERC3475.sol still remains the default  minimal implementation.
## Specification

A detailed specification document can be found at [EIP-document](eips.ethereum.org/eip-3475), which is also maintained in the [EIP/](EIPS/eip-3475.md).

