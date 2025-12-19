# UUPS-Upgradeable-Treasury-Practice-Project-
This repository contains a practical implementation of an upgradeable Treasury system built using the UUPS (Universal Upgradeable Proxy Standard) pattern and OpenZeppelin Contracts (v5).
The purpose of this project is to learn and demonstrate how UUPS proxies work in practice, including:

*proxy deployment

*storage layout discipline

*safe upgrades

*initializers and reinitializers

*storage gap consumption



📚 What This Project Demonstrates

This project is intentionally designed to showcase:

The difference between proxy contracts and implementation contracts

How UUPSUpgradeable moves upgrade logic into the implementation

How ERC1967Proxy stores all contract state

How to safely evolve logic across versions without corrupting storage

Common upgradeable-contract pitfalls and how to avoid them

** Architecture
Users
  ↓
ERC1967Proxy (DeployTreasury)
  ↓ delegatecall
TreasuryV1 → TreasuryV2 → TreasuryV3


The proxy address never changes

All storage lives in the proxy

Logic is swapped via UUPS upgrades

Users always interact with the proxy using the Treasury ABI

📁 Contracts Overview
DeployTreasury.sol

Proxy deployment contract

This contract deploys an OpenZeppelin ERC1967Proxy, which acts as the permanent entry point to the system.

Responsibilities:

*Deploy a UUPS-compatible proxy

*Point the proxy to the initial implementation (TreasuryV1)

*Call initialize() on deployment via delegatecall

*Ensure initialization happens exactly once

Key notes:

*The proxy holds all storage

*The proxy contains no business logic

*Users interact with the proxy address using the TreasuryV1 ABI

1 . TreasuryV1.sol

Initial implementation (base version)

Responsibilities:

*Accepts ETH deposits

*Tracks total ETH held by the treasury

*Allows the owner (DAO) to withdraw ETH

*Defines the base storage layout

*Enables UUPS upgrades via _authorizeUpgrade

!! Key concepts:

*Uses initializer instead of a constructor

*Explicit ownership initialization (OpenZeppelin v5 style)

*Storage layout must never be reordered

*Optional storage gap reserved for future upgrades

2. TreasuryV2.sol

First upgrade — adds emergency pause functionality

Responsibilities:

*Introduce a paused state

*Allow the owner to pause and unpause withdrawals

*Prevent withdrawals while paused

*Preserve all security and accounting rules from V1

!! Key concepts:

*Safe storage gap consumption

*reinitializer(2) for new state

*Guard-style modifiers (no state mutation)

*Functions marked virtual for future upgrades

3. TreasuryV3.sol

Second upgrade — adds withdrawal fees

Responsibilities:

*Introduces a configurable withdrawal fee

*Retains fees inside the treasury

*Allows the owner to update the fee

*Preserves accounting correctness across upgrades

!! Key concepts:

*Fees stored as basis points (bps) instead of percentages

*Separation of configuration state from runtime calculations

*Layered upgrade logic (V1 → V2 → V3)

*Continued safe storage gap consumption

🔐 Upgrade Pattern Used

UUPS (EIP-1822)

Proxy: ERC1967Proxy

Upgrade logic lives in the implementation

_authorizeUpgrade restricts who can upgrade

upgradeToAndCall used when new state is introduced

🚀 Deployment Flow (Conceptual)

Deploy TreasuryV1 (implementation)

Deploy DeployTreasury, passing the implementation address

ERC1967Proxy is deployed internally

initialize() is executed via delegatecall

Proxy storage is initialized

Users interact with the proxy address

🧪 Tests

🚧 Tests are not included yet

Planned additions:

Upgrade flow tests (V1 → V2 → V3)

Storage layout validation

Pause behavior tests

Fee accounting tests

Failure and edge-case scenarios

 * * Intended Audience

This repository is intended for:

*Developers learning UUPS upgradeable contracts
*Lawyers learning solidity...lol

⚠️ Disclaimer

This code is:

Educational

Unaudited

Not production-ready

Use it to learn, not to secure real funds.

📜 License

MIT

