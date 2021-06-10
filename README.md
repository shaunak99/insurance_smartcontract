# Smart Contract for Car Insurance

## Dependencies

1. Node
2. NPM
3. Truffle
4. Ganache

## Description

This contract is a simple implementiation for CarInsurances. It holds data about the cars such as name, owner, distance/miles travelled, duration of insurance, number of times insurance has been claimed. This data is assumed to be automatically retreived with the help of the IoT devices installed in the cars. The miles for example can be emitted by the car every month and captured by the contract. This data is then saved onto the blockchain making it immutable. The insurance company can access it at any time and quote a fair price. Transactions too happen instantlty, without any intermediaries if all the conditions are met.
This is a most likely future for insurance.

## Deploy

You may use Remix-ide to test this.

You can also run the code using truffle and ganache-cli.

To start ganache, use the following command

```bash
ganache-cli
```

In a separate terminal, deploy and test

```bash
truffle compile
truffle migrate
truffle test
```
