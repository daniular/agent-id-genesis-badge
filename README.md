# Agent ID Genesis Badge — Binance Agent ID Hackathon (solo entry)

Free commemorative ERC-721 for Binance Agent ID holders. One badge per
Agent ID, claimable gas-only (value 0). The contract verifies on-chain that
the caller owns an Agent ID via the SPACE ID Agent ID registry.

## Status: DEPLOYED + PHASE 2 DONE (2026-11-19 ~15:16–15:30 WIB)
- **Contract deployed:** `0x988bffCb78a21b10228aE45ba3DCF20D7d260F76` (BSC 56),
  tx `0xcd4d67e94b5da22d453e617c7de5a0d7a179d6dba0d1a36ade23183270ad2fa7`,
  block 134469617, gas 1,207,127 (~0.00006036 BNB @ 0.05 gwei), via the
  CREATE2 factory `0x4e59b44847b379578588920cA78FbF26c0B4956C` (baw cannot
  deploy directly — contract-call requires a `to` address).
- **Source verified on Sourcify: exact_match** (creation + runtime),
  https://sourcify.dev/server/v2/contract/56/0x988bffCb78a21b10228aE45ba3DCF20D7d260F76
  — job caed1e02-539e-4e21-9096-cd028bf38643. BscScan-native verification
  NOT done: no Etherscan/BscScan API key exists on this machine (the
  foundry.toml entries only reference an unset `${ETHERSCAN_API_KEY}` env
  var); BscScan page fetch returns 403 and the v2 API requires a key.
  Blocker: a free Etherscan API key (etherscan.io account) OR manual
  web-form verification. Sourcify exact_match is the public source proof
  in the meantime (BscScan surfaces Sourcify-verified contracts).
- **Site wired:** `BADGE_ADDRESS` in `site/index.html` set to the deployed
  address (JS syntax checked OK). Metadata JSONs for token IDs 1–10
  generated (both `N.json` and extensionless `N`, because `tokenURI()`
  returns `baseURI + tokenId` with no `.json` suffix) + `site/badge.png`
  (512×512) + `site/_headers` (JSON content-type for `/metadata/*`).
- **Live usage:** totalSupply was 8 within ~15 min of deployment (6 → 7 → 8),
  all from distinct Agent ID-holder addresses — organic claims, contract
  enforces Agent ID ownership. Alex (rameni77) is ELIGIBLE and UNCLAIMED:
  registry balanceOf = 1, `claimed[agentId]` = false, `claim()` eth_call
  sim SUCCEEDS, est. gas 113,134 (~0.0000057 BNB @ 0.05 gwei). No claim
  tx was sent (phase 2 is read-only on-chain).
- **Hosting: BLOCKED.** `agentid-genesis-badge.pages.dev` does not resolve
  (HTTP 000). No Cloudflare credentials on this machine (no
  CLOUDFLARE_API_TOKEN, no `~/.config/cloudflare`, no `~/.wrangler`;
  `wrangler` not installed; `gh` not logged in). Site files are ready
  under `site/`; deploying to Cloudflare Pages needs a Cloudflare account
  + API token (or `wrangler login` in a browser), or a GitHub login for
  GitHub Pages. Until hosted, `tokenURI()` metadata URLs 404.
- **Submission: NOT submitted.** No direct project-submission form URL is
  published in the official announcement or the Square post (both read in
  full 2026-11-19). The only survey link in the announcement is the
  Community Promotion X-link survey:
  https://app.binance.com/uni-qr/user-survey/ff6832f8d2984af289068c9450a3c98c
  (X posts only, NOT project submission). Next step: watch the Binance
  Wallet / BNB Chain channels for the project form, or check the Agentic
  Wallet ecosystem page — do NOT guess a form URL.

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

## Open items (after phase 2)
1. **Hosting (BLOCKER):** deploy `site/` to Cloudflare Pages (project
   `agentid-genesis-badge`) so `https://agentid-genesis-badge.pages.dev/`
   resolves and `tokenURI()` metadata returns JSON. Needs a Cloudflare
   account + API token (or `wrangler login` / GitHub login). Files are
   ready: `index.html`, `badge.png`, `metadata/1..10` + `1.json..10.json`,
   `_headers`.
2. **BscScan-native verification (BLOCKER):** needs a free Etherscan API
   key (etherscan.io account) for `forge verify-contract --verifier
   etherscan --chain 56`, or manual web-form verification. Sourcify
   exact_match is already done.
3. **Submission channel:** locate the project-submission form before
   2026-12-09 08:00 UTC (announcement + Square post publish none; only
   the Community Promotion survey exists). Do NOT guess a URL.
4. **Distribution:** 8/30 Agent ID holders have claimed so far — need
   ≥30 distinct Agent ID addresses interacting during the Submission
   Period for Innovation eligibility and any Pioneer ranking. Alex himself
   has NOT claimed yet (eligible, unclaimed; claim ~113k gas). Promote
   the claim page once hosted. No mass-account / fake-volume tricks.
