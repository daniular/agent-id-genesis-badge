// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/AgentIDGenesisBadge.sol";

/// @notice Mock of the SPACE ID Agent ID registry (subset used by the Badge).
contract MockAgentID {
    mapping(address => string) public handles;
    mapping(address => uint256) public balances;

    function setAgent(address owner, string memory handle) external {
        handles[owner] = handle;
        balances[owner] = 1;
    }

    function balanceOf(address owner) external view returns (uint256) {
        return balances[owner];
    }

    function handleOf(address owner) external view returns (string memory) {
        return handles[owner];
    }
}

contract AgentIDGenesisBadgeTest is Test {
    AgentIDGenesisBadge public badge;
    MockAgentID public registry;

    address public alice = address(0xA11CE);
    address public bob = address(0xB0B);

    function setUp() public {
        registry = new MockAgentID();
        registry.setAgent(alice, "alice");
        // bob has NO Agent ID
        badge = new AgentIDGenesisBadge(address(registry), "https://example.com/metadata/");
    }

    // (a) an address WITH an Agent ID can claim once
    function testClaimWithAgentID() public {
        vm.prank(alice);
        badge.claim();
        assertEq(badge.ownerOf(1), alice);
        assertEq(badge.balanceOf(alice), 1);
        assertEq(badge.totalSupply(), 1);
        assertEq(badge.nextTokenId(), 2);
        bytes32 agentId = keccak256(bytes("alice"));
        assertTrue(badge.claimed(agentId));
        assertEq(badge.tokenURI(1), "https://example.com/metadata/1");
    }

    // (b) an address WITHOUT an Agent ID reverts
    function testClaimWithoutAgentIDReverts() public {
        vm.prank(bob);
        vm.expectRevert("No Agent ID");
        badge.claim();
    }

    // (c) a second claim with the same Agent ID reverts
    function testSecondClaimReverts() public {
        vm.prank(alice);
        badge.claim();
        vm.prank(alice);
        vm.expectRevert("Already claimed");
        badge.claim();
    }

    // (d) claim is value 0 — sending value reverts (non-payable)
    function testClaimWithValueReverts() public {
        vm.deal(alice, 1 ether);
        vm.prank(alice);
        (bool ok, ) = address(badge).call{value: 0.001 ether}(
            abi.encodeWithSelector(AgentIDGenesisBadge.claim.selector)
        );
        assertFalse(ok, "claim with value should revert");
        // and value 0 works
        vm.prank(alice);
        badge.claim();
        assertEq(badge.ownerOf(1), alice);
    }

    // extra: badge is transferable (standard ERC-721)
    function testTransferable() public {
        vm.prank(alice);
        badge.claim();
        vm.prank(alice);
        badge.transferFrom(alice, bob, 1);
        assertEq(badge.ownerOf(1), bob);
        assertEq(badge.balanceOf(alice), 0);
        assertEq(badge.balanceOf(bob), 1);
    }

    // extra: two different Agent IDs each get one badge
    function testTwoAgentIDs() public {
        address carol = address(0xCA901);
        registry.setAgent(carol, "carol");
        vm.prank(alice);
        badge.claim();
        vm.prank(carol);
        badge.claim();
        assertEq(badge.totalSupply(), 2);
        assertEq(badge.ownerOf(2), carol);
    }

    // extra: ERC165 interface ids
    function testSupportsInterface() public {
        assertTrue(badge.supportsInterface(0x01ffc9a7)); // ERC165
        assertTrue(badge.supportsInterface(0x80ac58cd)); // ERC721
        assertTrue(badge.supportsInterface(0x5b5e139f)); // ERC721Metadata
        assertFalse(badge.supportsInterface(0xffffffff));
    }
}
