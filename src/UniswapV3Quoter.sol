pragma solidity ^0.8.14;

import {Tick} from "./lib/Tick.sol";
import {Position} from "./lib/Position.sol";
import {IERC20} from "./interfaces/IERC20.sol";
import {IUniswapV3MintCallback} from "./interfaces/IUniswapV3MintCallback.sol";
import {IUniswapV3SwapCallback} from "./interfaces/IUniswapV3SwapCallback.sol";
import {TickBitmap} from "./lib/TickBitmap.sol";
import {TickMath} from "./lib/TickMath.sol";
import {SwapMath} from "./lib/SwapMath.sol";
import {Math} from "./lib/Math.sol";

contract UniswapV3Quoter is IUniswapV3Quoter {
    struct QuoteParams {
        address pool;
        uint256 amountIn;
        bool zeroForOne;
    }

    function quote(QuoteParams memory params)
        public
        returns (uint256 amountOut, uint160 sqrtPriceX96After, int24 tickAfter)
    {
        try IUniswapV3Pool(params.pool).swap(address(this), params.zeroForOne, params.amountIn, abi.encode(params)) {}
        catch (bytes memory reason) {
            return abi.decode(reason, (uint256, uint160, int24));
        }
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes memory data) external view {
        address pool = abi.decode(data, (address));

        uint256 amountOut = amount0Delta > 0 ? uint256(-amount1Delta) : uint256(-amount0Delta);

        (uint160 sqrtPriceX96After, int24 tickAfter) = IUniswapV3Pool(pool).slot0();

        assembly {
            let ptr := mload(0x40)
            mstore(ptr, amountOut)
            mstore(add(ptr, 0x20), sqrtPriceX96After)
            mstore(add(ptr, 0x40), tickAfter)
            revert(ptr, 0x60)
        }
    }
}
