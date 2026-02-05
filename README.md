# ETCswap V2 Periphery

Peripheral smart contracts for interacting with ETCswap V2 on Ethereum Classic.

> **Branch:** `etc` - ETCswap branded contracts for Ethereum Classic

## Overview

This repository contains the router and helper contracts for ETCswap V2:

- **ETCswapV2Router01** - Original router (has minor bug, use Router02)
- **ETCswapV2Router02** - Main router for swaps and liquidity
- **ETCswapV2Migrator** - Migrate liquidity from V1 to V2
- **ETCswapV2Library** - Helper functions for price calculations

## Differences from Uniswap V2

| Feature | Uniswap V2 | ETCswap V2 |
|---------|------------|------------|
| Package Name | `@uniswap/v2-periphery` | `@etcswap/v2-periphery` |
| Contract Prefix | `UniswapV2*` | `ETCswapV2*` |
| Native Asset | WETH | WETC |
| Router Functions | `*ETH*` | `*ETC*` |
| Error Prefix | `UniswapV2Library:` | `ETCswapV2Library:` |

## Router Functions

All ETH-related functions are renamed for ETC:

| Uniswap | ETCswap |
|---------|---------|
| `addLiquidityETH` | `addLiquidityETC` |
| `removeLiquidityETH` | `removeLiquidityETC` |
| `swapExactETHForTokens` | `swapExactETCForTokens` |
| `swapTokensForExactETH` | `swapTokensForExactETC` |
| `swapExactTokensForETH` | `swapExactTokensForETC` |
| `swapETHForExactTokens` | `swapETCForExactTokens` |

## Contracts

```
contracts/
├── ETCswapV2Router01.sol
├── ETCswapV2Router02.sol
├── ETCswapV2Migrator.sol
├── interfaces/
│   ├── IETCswapV2Router01.sol
│   ├── IETCswapV2Router02.sol
│   ├── IETCswapV2Migrator.sol
│   ├── IWETC.sol
│   └── V1/
│       ├── IETCswapV1Factory.sol
│       └── IETCswapV1Exchange.sol
├── libraries/
│   ├── ETCswapV2Library.sol
│   ├── ETCswapV2OracleLibrary.sol
│   ├── ETCswapV2LiquidityMathLibrary.sol
│   └── SafeMath.sol
├── examples/
│   ├── ExampleFlashSwap.sol
│   ├── ExampleOracleSimple.sol
│   ├── ExampleSlidingWindowOracle.sol
│   ├── ExampleSwapToPrice.sol
│   └── ExampleComputeLiquidityValue.sol
└── test/
    └── WETC9.sol               # Wrapped ETC for testing
```

## INIT_CODE_HASH

The library uses CREATE2 to compute pair addresses. Update the hash in `ETCswapV2Library.sol`:

```solidity
hex'fa6865812aae02db67c54fe0f27c82c60f55aac028fd78b9839579911832679e'
```

## Local Development

### Prerequisites
- Node.js >= 10
- Yarn

### Install Dependencies
```bash
yarn
```

### Compile Contracts
```bash
yarn compile
```

### Run Tests
```bash
yarn test
```

111 tests should pass. 5 gas tests may fail due to branding changes (expected).

## Dependencies

This package depends on `@etcswap/v2-core`:

```json
{
  "dependencies": {
    "@etcswap/v2-core": "file:../v2-core"
  }
}
```

## ETC Compatibility

ETCswap V2 Periphery is fully compatible with Ethereum Classic's Istanbul EVM.

## License

GPL-3.0-or-later
