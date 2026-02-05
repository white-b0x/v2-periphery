pragma solidity >=0.5.0;

interface IETCswapV2Migrator {
    function migrate(address token, uint amountTokenMin, uint amountETCMin, address to, uint deadline) external;
}
