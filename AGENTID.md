# Agent ID Registry — Verified Interface

## Contract
- Address (BSC 56): **0x60b9262456de011f7d15a54cdd8c48baaa8b022f**
- Name: **SPACE ID Agent ID**
- Symbol: **AI**
- Standard: **ERC-721, non-transferable (soulbound)**
- Sourcify: **exact_match** (verified 2026-11-19; full ABI saved in
  `agentid-abi.json` in this folder)
- Announcement confirms the same address, name, symbol, standard.

## Ownership model (verified on-chain 2026-11-19, BSC mainnet)
- Each user can claim only ONE Agent ID; it is non-transferable.
- Token ID = **keccak256(handle)** where handle is the name WITHOUT ".ai".
  Verified: keccak256("rameni77") =
  15128495923547782284498233209200551330616824100094439571620909054239259342211,
  and `ownerOf` of that tokenId = Alex's wallet.
- `approve` / `setApprovalForAll` are `pure` no-ops; transfers revert with
  custom error `Soulbound()` (0xa4420a95).

## Functions relevant to the Badge contract
| Function | Signature | Notes |
|---|---|---|
| `balanceOf` | `balanceOf(address) → uint256` (view) | **Official check** per the announcement: return > 0 means the address holds an Agent ID. Use this as the eligibility gate. |
| `handleOf` | `handleOf(address) → string` (view) | Returns the handle (e.g. `"rameni77"`) for a holder; empty for non-holders. Use to derive the Agent ID tokenId: `keccak256(bytes(handle))`. |
| `ownerOf` | `ownerOf(uint256) → address` (view) | Owner of an Agent ID tokenId. |
| `ownerOfHandle` | `ownerOfHandle(string) → address` (view) | Owner of a handle. |
| `name` / `symbol` | `name() → string`, `symbol() → string` (view) | "SPACE ID Agent ID" / "AI". |
| `tokenURI` | `tokenURI(uint256) → string` (view) | Off-chain metadata, e.g. `https://agentid.prd.space.id/metadata/rameni77.json`. |
| `register` | `register(string,uint256,bytes)` | Claim path (Binance-signed, in-app only). Not used by the Badge. |

## Live verification (2026-11-19, BSC mainnet, read-only)
Alex's wallet 0xa38f4115280C385e6e0eB99a7E407dc87e020284:
- `balanceOf` = **1**
- `handleOf` = **"rameni77"**
- `ownerOf(keccak256("rameni77"))` = 0xa38f4115280C385e6e0eB99a7E407dc87e020284
- `ownerOfHandle("rameni77")` = 0xa38f4115280C385e6e0eB99a7E407dc87e020284
- `tokenURI` = https://agentid.prd.space.id/metadata/rameni77.json
- No `totalSupply()` function on the registry.

## How the Badge contract uses it
`claim()` calls `registry.balanceOf(msg.sender)` and requires > 0. It then
calls `registry.handleOf(msg.sender)`, derives
`agentId = keccak256(bytes(handle))`, and requires `!claimed[agentId]` before
minting — enforcing exactly 1 badge per Agent ID (not per wallet address).
The registry is soulbound and 1-per-user, so per-address and per-Agent-ID
tracking coincide, but per-Agent-ID is the rule as written and is what the
contract enforces.

## Minimal interface used by the Badge contract
```solidity
interface IAgentID {
    function balanceOf(address owner) external view returns (uint256);
    function handleOf(address owner) external view returns (string memory);
}
```
