import {LiquidityMath} from "./LiquidityMath.sol";
import {Math} from "./Math.sol";

library Tick {
    struct Info {
        bool initialized;
        uint128 liquidityGross;
        uint128 liquidityNet;
    }

    function update(mapping(int24 => Info) storage self, int24 tick, uint128 liquidityDelta, bool upper)
        internal
        returns (bool flipped)
    {
        Tick.Info storage tickInfo = self[tick];
        uint128 liquidityBefore = tickInfo.liquidityGross;
        uint128 liquidityAfter = LiquidityMath.addLiquidity(liquidityBefore, liquidityDelta);

        flipped = (liquidityBefore == 0) != (liquidityAfter == 0);

        if (liquidityBefore == 0) {
            tickInfo.initialized = true;
        }

        tickInfo.liquidityGross = liquidityAfter;

        if (upper) {
            tickInfo.liquidityNet = int128(int256(tickInfo.liquidityNet) - liquidityDelta);
        } else {
            tickInfo.liquidityNet = int128(int256(tickInfo.liquidityNet) + liquidityDelta);
        }
    }

    function cross(mapping(int24 => Info) storage self, int24 tick, uint128 liquidityDelta, bool upper)
        internal
        returns (bool flipped)
    {
        Tick.Info storage tickInfo = self[tick];
        liquidityDelta = tickInfo.liquidityNet;
    }
}
