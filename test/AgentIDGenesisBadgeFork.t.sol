// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AgentIDGenesisBadge.sol";

/// @notice Fork test against the REAL SPACE ID Agent ID registry on BSC mainnet.
/// Run: forge test --match-contract AgentIDGenesisBadgeForkTest --fork-url https://bsc-dataseed1.bnbchain.org -vv
contract AgentIDGenesisBadgeForkTest is Test {
    AgentIDGenesisBadge public badge;

    address public constant REGISTRY = 0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F;
    address public constant ALEX = 0xa38f4115280C385e6e0eB99a7E407dc87e020284;
    address public constant NOBODY = address(0xDEAD);

    function setUp() public {
        badge = new AgentIDGenesisBadge(REGISTRY, "https://example.com/metadata/");
    }

    // Alex (rameni77.ai, Agent ID holder) can claim once on the real registry
    function testForkClaimAsAlex() public {
        vm.prank(ALEX);
        badge.claim();
        assertEq(badge.ownerOf(1), ALEX);
        assertEq(badge.balanceOf(ALEX), 1);
        bytes32 agentId = keccak256(bytes("rameni77"));
        assertTrue(badge.claimed(agentId));
    }

    // An address without an Agent ID reverts on the real registry
    function testForkClaimWithoutAgentIDReverts() public {
        vm.prank(NOBODY);
        vm.expectRevert("No Agent ID");
        badge.claim();
    }

    // Second claim by the same Agent ID reverts on the real registry
    function testForkSecondClaimReverts() public {
        vm.prank(ALEX);
        badge.claim();
        vm.prank(ALEX);
        vm.expectRevert("Already claimed");
        badge.claim();
    }
}
