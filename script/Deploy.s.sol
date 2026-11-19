// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/AgentIDGenesisBadge.sol";

/// @notice Deploy script (dry-run only in phase 1 — no real deployment).
contract Deploy is Script {
    address public constant REGISTRY = 0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F;

    function run() external {
        vm.startBroadcast();
        AgentIDGenesisBadge badge = new AgentIDGenesisBadge(
            REGISTRY,
            "https://agentid-genesis-badge.pages.dev/metadata/"
        );
        vm.stopBroadcast();
        console.log("Badge deployed at:", address(badge));
    }
}
