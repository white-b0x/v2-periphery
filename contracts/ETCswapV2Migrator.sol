pragma solidity =0.6.6;

import '@uniswap/lib/contracts/libraries/TransferHelper.sol';

import './interfaces/IETCswapV2Migrator.sol';
import './interfaces/V1/IETCswapV1Factory.sol';
import './interfaces/V1/IETCswapV1Exchange.sol';
import './interfaces/IETCswapV2Router01.sol';
import './interfaces/IERC20.sol';

contract ETCswapV2Migrator is IETCswapV2Migrator {
    IETCswapV1Factory immutable factoryV1;
    IETCswapV2Router01 immutable router;

    constructor(address _factoryV1, address _router) public {
        factoryV1 = IETCswapV1Factory(_factoryV1);
        router = IETCswapV2Router01(_router);
    }

    // needs to accept ETC from any v1 exchange and the router. ideally this could be enforced, as in the router,
    // but it's not possible because it requires a call to the v1 factory, which takes too much gas
    receive() external payable {}

    function migrate(address token, uint amountTokenMin, uint amountETCMin, address to, uint deadline)
        external
        override
    {
        IETCswapV1Exchange exchangeV1 = IETCswapV1Exchange(factoryV1.getExchange(token));
        uint liquidityV1 = exchangeV1.balanceOf(msg.sender);
        require(exchangeV1.transferFrom(msg.sender, address(this), liquidityV1), 'TRANSFER_FROM_FAILED');
        (uint amountETCV1, uint amountTokenV1) = exchangeV1.removeLiquidity(liquidityV1, 1, 1, uint(-1));
        TransferHelper.safeApprove(token, address(router), amountTokenV1);
        (uint amountTokenV2, uint amountETCV2,) = router.addLiquidityETC{value: amountETCV1}(
            token,
            amountTokenV1,
            amountTokenMin,
            amountETCMin,
            to,
            deadline
        );
        if (amountTokenV1 > amountTokenV2) {
            TransferHelper.safeApprove(token, address(router), 0); // be a good blockchain citizen, reset allowance to 0
            TransferHelper.safeTransfer(token, msg.sender, amountTokenV1 - amountTokenV2);
        } else if (amountETCV1 > amountETCV2) {
            // addLiquidityETC guarantees that all of amountETCV1 or amountTokenV1 will be used, hence this else is safe
            TransferHelper.safeTransferETC(msg.sender, amountETCV1 - amountETCV2);
        }
    }
}
