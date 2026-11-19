# Agent ID Genesis Badge — Binance Agent ID Hackathon (solo entry)

Free commemorative ERC-721 for Binance Agent ID holders. One badge per
Agent ID, claimable gas-only (value 0). The contract verifies on-chain that
the caller owns an Agent ID via the SPACE ID Agent ID registry.

## Status: PHASE 1 DONE (research + design + contract + tests + site)
No deployment, no BscScan verification, no Binance submission yet — those
need Alex's explicit confirmation on a preview (phase 2).

## Files
- `RULES.md` — full hackathon rules (official announcement).
- `AGENTID.md` — verified Agent ID registry interface.
- `agentid-abi.json` — registry ABI from Sourcify (exact_match).
- `src/AgentIDGenesisBadge.sol` — the Badge contract (minimal ERC-721).
- `test/AgentIDGenesisBadge.t.sol` — 7 mock tests (all pass).
- `test/AgentIDGenesisBadgeFork.t.sol` — 3 fork tests vs the REAL registry
  on BSC mainnet (all pass, incl. a claim as Alex's wallet rameni77.ai).
- `script/Deploy.s.sol` — deploy script (simulation only in phase 1).
- `site/` — static claim dApp (`index.html`, no build step) + metadata sample.
- `foundry.toml` — optimizer on, runs=200.

## Key numbers (measured)
- Deployment gas: **1,265,589** (runs=200; runtime 4,856 bytes).
- Deployment cost: **0.00006328 BNB @ 0.05 gwei** (Alex's BNB: 0.00008765 —
  FITS, ~0.0000244 headroom). @ 0.1 gwei = 0.00012656 BNB — OVER budget.
  Deployment is affordable only if BSC gas stays near ~0.05 gwei.
- Claim gas: **~129,024** (~0.0000065 BNB @ 0.05 gwei) — cheap for users.
- Contract: no owner, no admin functions, no pause, no withdraw. The only
  mint path is `claim()` by an Agent ID holder, and it is non-payable
  (value 0 enforced by the EVM).

## Hackathon fit
- Solo entry allowed ("Individuals and teams may both participate").
- Pioneer Award: ranked by interacting Agent ID addresses / volume / tx count.
- Innovation Award: needs product live + **≥30 Agent ID addresses**
  interacting with the contract during the Submission Period — this is the
  hard part (distribution), not the build.
- Submission Period ends **2026-12-09 08:00 UTC**.
- Red lines respected (see `site/README.md`): no QR login, no "look up
  someone else's wallet by name" (site checks only the connected address),
  no promised returns, no "Binance"/"BNB" in the name.

## Open items for phase 2
1. **Submission channel**: the announcement publishes NO direct
   project-submission form URL. Confirm it (announcement / Square post /
   dev docs) before 2026-12-09.
2. **Hosting**: host `site/` (Cloudflare Pages / GitHub Pages / IPFS) and
   set `baseURI` to `https://<host>/metadata/`; generate one metadata JSON
   per tokenId.
3. **Deployment**: deploy when BSC gas is ~0.05 gwei; verify source on
   BscScan; set `BADGE_ADDRESS` in `site/index.html`.
4. **Distribution**: get ≥30 Agent ID holders to claim (the real challenge
   for both awards). No mass-account / fake-volume tricks — disqualification
   risk.
