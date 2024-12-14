# FoundryDAO

FoundryDAO is a decentralized autonomous organization (DAO) built on Ethereum, where members can vote on proposals to improve the protocol. This project aims to demonstrate how to create a DAO from scratch using Foundry, smart contracts, and various components like ERC20 tokens, governance contracts, and time-lock mechanisms.

## Table of Contents

1. [Introduction](#introduction)
2. [Project Setup](#project-setup)
3. [Smart Contracts Overview](#smart-contracts-overview)
4. [Granularity Theory](#granularity-theory)
5. [Governance System](#governance-system)
6. [TimeLockController Contract](#timelockcontroller-contract)
7. [Deployment Guide](#deployment-guide)
8. [Future Improvements](#future-improvements)
9. [Contributing](#contributing)
10. [License](#license)

## Introduction

In this project, we will build a DAO that mirrors the token-based voting model, where voting power is proportional to the number of tokens held by a participant. While this method isn't the most decentralized, it is widely used in protocols such as Compound and other DeFi platforms.

### Key Features:

- **Token-based voting**: Participants vote based on the number of tokens they own.
- **Granularity Theory**: Smart contracts are designed with modularity and specific purposes in mind to allow for further extensions.
- **TimeLock Controller**: Introduces a delay between the proposal's approval and execution, giving members time to exit if they disagree with the decision.

## Project Setup

To begin, create a new directory called `FoundryDAO` and initialize the Foundry project:

```bash
mkdir FoundryDAO
cd FoundryDAO
forge init
```

## Installing Dependencies

For this project, we will use the following dependencies:

OpenZeppelin Contracts
Foundry (for testing and contract deployment)
Install the necessary OpenZeppelin contracts using:

```bash
forge install OpenZeppelin
```

#### Smart Contracts Overview

## Box.sol

The Box.sol contract is a simple contract that inherits from OpenZeppelin’s Ownable contract. It serves as the basic foundation for interactions with the DAO.

## GovToken.sol

The GovToken.sol contract is an ERC20 token that has additional governance functionality. It inherits from:

## ERC20Votes

Enables token-based voting.

## ERC20Permit

Allows token transfers with signatures, improving usability.
This contract uses the granularity theory to handle the voting power for each account, where each transfer updates the voting checkpoints accordingly.

## MyGovernor.sol

The MyGovernor.sol contract allows token holders to propose, vote on, and execute proposals. It inherits from OpenZeppelin's Governor contract and utilizes ERC20Votes for voting.

## TimeLockController.sol

The TimeLockController.sol contract adds a delay between when a proposal is passed and when it is executed. This ensures that DAO members have time to react if they disagree with the proposal.

## Granularity Theory

Granularity theory emphasizes that smart contracts should serve specific purposes, and protocols should be modular. Each contract has a well-defined role, and others can build upon it. In the context of the FoundryDAO, this approach ensures that our voting mechanisms are extendable and flexible.

By inheriting contracts like ERC20Votes and Governor, we can combine functionalities and customize them to meet the DAO's needs. Granularity theory encourages exploring the contract code in depth to find reusable components that serve the project's objectives.

## Governance System

Our DAO uses a token-based voting model, which means the more tokens you hold, the more influence you have in the decision-making process. This model is common in DeFi platforms but comes with challenges regarding centralization.

The MyGovernor.sol contract allows users to propose new initiatives, vote on them, and execute them once the proposal is approved. The smart contract handles the governance logic, ensuring that only valid proposals are executed.

TimeLockController Contract
The TimeLockController.sol contract enforces a delay between when a proposal passes and when it is executed. This gives members enough time to react if they disagree with the proposal.

The TimeLockController functions are integrated into the governance contract, ensuring that proposals are executed only after a specified time period.

## Deployment Guide

### Deploy GovToken Contract

Deploy the ERC20 token contract, which will be used for voting.

```bash
forge deploy GovToken.sol
```

Deploy MyGovernor Contract: Deploy the governor contract that will handle proposals and voting.

```bash
forge deploy MyGovernor.sol
```

Deploy TimeLockController Contract: Deploy the TimeLockController contract, which ensures a delay between proposal approval and execution.

```bash
forge deploy TimeLockController.sol
```

Set Up Interactions: Once all contracts are deployed, link them together so that the DAO members can begin interacting with the system.

## Future Improvements

- **Decentralized Voting:** Implement off-chain voting to reduce gas costs.
- **Granularity Enhancements:** Further modularize smart contracts to allow for easier extensions.
- **Security Audits:** Perform in-depth security audits to ensure the DAO's safety.

## License

- **This project is licensed under the MIT License.**
