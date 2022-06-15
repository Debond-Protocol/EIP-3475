ERC-3475 Multiple Callable Bonds Standard implementation
=============================================

This repository maintains an example implementation of the ERC-3475 Multiple Callable Bonds Standard for Solidity compatible network. The implementation was created to illustrate the functionalities of the ERC569.  

This token standard can replace current ERC20 LP token. ERC-3475 has more complex data structure, which will allow the LP token to store more information, and allow the developer to build more sophisticated logic for the redemption and reward system of the DEFI project in question.

## Getting started

### Install

`git clone https://github.com/DeBond-Protocol/EIP-3475`

### Usage

```solidity
pragma solidity ^0.8;

import '@DeBond-Protocol/EIP-3475/tree/main/contracts/util/IERC3475.sol';
import '@DeBond-Protocol/EIP-3475/tree/main/contracts/util/ERC3475data.sol';

contract MyTestToken is ERC3475 {
  ...
}
```



## Description

This API standard allows for the creation of any number of bonds type in a single contract. Existing LP token standards like ERC-20 require deployment of separate factory and token contracts per token type. The need of issuing bonds with multiple redemption data can’t be achieved with existing token standards. ERC-3475 Multiple Callable Bonds Standard allows for each bond class ID to represent a new configurable token type, and for each bond nonce to represent an issuing date or any other forms of data in uint256. Every single nonce of a bond class may have its own metadata, supply and other redemption conditions.

Current LP token is a simple ERC-20 token, which has not much complicity in data structure. To allow more complex reward and redemption logic to be built, we need a new LP token standard that can manage multiple bonds, stores much more data and gas efficient.  ERC-3475 standard interface allows any tokens on solidity compatible block chains to create its own bond. These bonds with the same interface standard can be exchanged in secondary market. And it allows any 3nd party wallet applications or exchanges to read the balance and the redemption conditions of these tokens. ERC-3475 bonds can also be packed into separate packages. Those packages can in their turn be divided and exchanged in a secondary market.

New functions built in ERC-3475 Multiple Callable Bonds Standard, will allow the users to economize their gas fee spend. Trading and burning of ERC-3475 Bonds will also multiply tokens market cap, helping it to recover from recession period[(1)](https://medium.com/coinmonks/the-future-of-algorithmic-stable-coin-13ddbc27485). Existing structures, such as AMM exchanges or lending platform can be updated to recognize ERC-3475 Bonds.

## Specification

A detailed specification document can be found at [SPECIFICATIONS.md](<https://github.com/sgmfinance/erc-3475/blob/main/SPECIFICATIONS.md>).

## Security Review

There are no known security considerations for this EIP. More security considerations will be added after the authoring/feedback process of this EIP.

## LICENSE

Copyright (c) 2021-present Yu LIU, [DeBond](https://DeBond.org).

Licensed under [Apache-2.0](./LICENSE)
