pragma solidity ^0.8.14;

import "forge-std/Script.sol";
import "../src/lib/ERC20Mintable.sol";
import "../src/UniswapV3Pool.sol";
import "../src/UniswapV3Manager.sol";

contract DeployDevelopment is Script {
    function run() public {
        uint256 wethBalance = 1 ether;
        uint256 usdcBalance = 5042 ether;
        int24 currentTick = 85176;
        uint160 currentSqrtPriceX96 = 5602277097478614198912276234240;

        vm.startBroadcast();
        ERC20Mintable token0 = new ERC20Mintable("Wrapped Ether", "WETH", 18);
        ERC20Mintable token1 = new ERC20Mintable("USD Coin", "USDC", 6);

        UniswapV3Pool pool = new UniswapV3Pool(address(token0), address(token1), currentSqrtPriceX96, currentTick);
        UniswapV3Manager manager = new UniswapV3Manager();

        console.log("Pool address:", address(pool));
        console.log("Manager address:", address(manager));
        console.log("Token0 address:", address(token0));
        console.log("Token1 address:", address(token1));

        vm.stopBroadcast();
    }
}
