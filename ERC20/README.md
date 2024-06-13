```markdown
# ERC20 Token Implementation

This repository contains a basic implementation of the ERC20 token standard using Solidity.
It includes the necessary contracts and interfaces to create an ERC20 token on the Ethereum blockchain.

## Contracts

### 1. Context.sol
The `Context` contract provides information about the current execution context,
including the sender of the transaction and its data.
While these are generally available via `msg.sender` and `msg.data`,
they should not be accessed in such a direct manner since when dealing with meta-transactions the account sending
and paying for execution may not be the actual sender (as far as an application is concerned).

### 2. IERC20.sol
The `IERC20` interface outlines the standard functions and events that an ERC20 token must implement.
These include functions for transferring tokens, approving tokens to be spent by another account,
and querying balances and allowances.

### 3. IERC20Metadata.sol
The `IERC20Metadata` interface extends `IERC20` to include additional metadata functions, namely `name`,
`symbol`, and `decimals`, which provide more information about the token.

### 4. ERC20.sol
The `ERC20` contract is an implementation of the `IERC20` and `IERC20Metadata` interfaces.
It includes all the standard functionalities of an ERC20 token, such as transferring tokens, approving allowances,
and minting and burning tokens.

## Usage

To use these contracts, you need to install the Solidity compiler.
You can then compile and deploy these contracts using any Ethereum development framework such as Truffle, Hardhat, or Remix.

### Example Deployment

Here is an example of how to deploy the `ERC20` contract:

```solidity
pragma solidity ^0.8.25;

import "./ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 1000000 * (10 ** uint256(decimals())));
    }
}
```

This example creates a new token called "MyToken" with the symbol "MTK" and an initial supply of 1,000,000 tokens.

## Installation

Clone the repository:
```sh
git clone https://github.com/dappteacher/ERC20.git
```

Install dependencies (if any):
```sh
npm install
```

Compile the contracts:
```sh
npx hardhat compile
```

Deploy the contracts:
```sh
npx hardhat run scripts/deploy.js --network <network-name>
```

## Testing

To run tests, use the following command:
```sh
npx hardhat test
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Yaghoub Adelzadeh
- GitHub: [dappteacher](https://www.github.com/dappteacher)

## Acknowledgments

- [OpenZeppelin](https://openzeppelin.com/) for their excellent library of secure smart contract templates.
```

Feel free to adjust any sections or add more details as necessary for your specific use case or development setup.