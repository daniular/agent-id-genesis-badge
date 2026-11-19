# Binance Agent ID Hackathon — Rules Summary

Source: official Binance announcement
https://www.binance.com/en/support/announcement/detail/95f5dbe0ea674a48a739b59e046648bf
(read in full 2026-11-19). Also mirrored on Binance Square:
https://www.binance.com/en/square/post/389517345917641

## Timeline (all UTC)
- Submission Period: **2026-11-18 08:00 → 2026-12-09 08:00**
- Internal Review: 2026-12-09 08:00 → 2026-12-17 08:00
- Public Review: 2026-12-17 08:00 → 2026-12-20 08:00
- Rewards: within 14 business days after the public announcement period ends,
  sent to the reward receiving address provided during project submission.

## Who can enter
- Open to all Binance Wallet users, developers, and project teams.
  **Individuals and teams may both participate (solo is allowed).**
- New and existing projects are eligible. For existing projects, only data
  generated during the Submission Period counts.
- Each team may submit **one project only**.
- Each project may only receive **one award**.

## What a project must do
1. Deploy contract(s) on BNB Chain.
2. Complete source-code verification on BscScan + make the code publicly open-source.
3. Integrate Agent ID into the product for real-world use cases
   (access control, payments, identity).
4. Submit during the Submission Period: **project name, website, contract
   address(es), Agent ID usage description, and other required materials.**
   No registration needed.
5. During the Submission Period, actively guide Agent ID holders to interact
   with the project contract(s).

## Prizes — 60,000 USDC total
### Agent ID Ecosystem Pioneer Award — 29,000 USDC (top 10, on-chain ranking)
Ranked by real on-chain data: number of interacting Agent ID addresses,
transaction volume, transaction count (weighted score by Binance Wallet team).
Only submitted contract addresses count; interacting addresses must hold an
Agent ID.
- 1st 10,000 · 2nd 6,000 · 3rd 4,000 · 4th 3,000 · 5th 2,000 · 6th–10th 800 each.

### Agent Application Innovation Award — 29,000 USDC (top 10, judging panel)
Judging panel (Binance Wallet, BNB Chain, technical/ecosystem reps), 100-point
system:
- Agent ID Application Depth 30% — Agent ID genuinely in the product's core
  functionality and business flow, real application value.
- Practicality & Feasibility 25% — addresses a real need, reasonable use case.
- Product Completion 25% — product live, core features usable.
- Innovation 20% — new Agent ID use cases, differentiation.
- 1st 10,000 · 2nd 6,000 · 3rd 4,000 · 4th 3,000 · 5th 2,000 · 6th–10th 800 each.
- **Eligibility: product must already be live, with at least 30 Agent ID
  addresses having interacted with the participating contract(s) during the
  Submission Period.**

### Bonus
- Winners of the two project categories (20 projects) each additionally get
  one eligibility spot to claim a **two-digit Agent ID** (higher rank = priority).
- Outstanding winners may be featured on the Binance Wallet Agentic Wallet
  ecosystem page and in future Agent ID campaigns.

### Community Promotion — 2,000 USDC (separate, X posts; NOT the build track)
- Post original content on X about participating projects, hashtags
  #BinanceWalletHackathon + #AgenticWallet, submit the X link via the official
  campaign survey (app.binance.com). 20 winners share 2,000 USDC (100 each).

## Safety red lines (violation = immediate disqualification)
- No web-based QR code login for Agentic Wallet: no QR codes / pairing codes
  on third-party websites to sign in; no storing login sessions on servers to
  place orders on users' behalf.
- Skills must NOT contain prompts that bypass user transaction confirmation.
  Users must see and confirm asset operations themselves.
- No unauthorized asset transfers: no scheduled collection, automatic transfers
  to fixed addresses, bundled extra transfers, or soliciting unlimited
  approvals without the user's knowledge.
- Contracts must be open-source with disclosed owner permissions (minting,
  changing tax rates, pausing trading, freezing assets, withdrawing user funds
  must be clearly documented).
- No impersonation of the Binance brand: project/token/domain names must not
  use "Binance" / "BNB" to impersonate the official brand.
- No collection of sensitive credentials: seed phrases, private keys, API
  secrets, pairing codes.
- No promised returns externally: "passive income" / "automatic money-making"
  prohibited.
- Products involving trading must display risk warnings on the page.
- **Agent ID must not be packaged as a tool for "looking up other people's
  wallets by name."**
- No abnormal behavior: malicious volume manipulation, illegitimate mass
  account registration for interactions, market manipulation.
- Binance reserves the right to verify eligibility/materials/results and to
  disqualify for cheating (reports: audit@binance.com).

## Agent ID (from the announcement)
- Agent ID Contract (BNB Chain): 0x60b9262456de011f7d15a54cdd8c48baaa8b022f
- Contract name: SPACE ID Agent ID, Symbol: AI, Standard: ERC-721,
  Non-transferable (soulbound).
- Check if an address holds an Agent ID: call balanceOf(address); > 0 = holds one.
- Claim an Agent ID: only inside the Binance App (Wallet > homepage banner >
  Agent ID).
- Product docs: https://web3.binance.com/en/dev-docs/products/agentic-wallet/introduction

## OPEN ITEM — project submission channel
The announcement does NOT publish a direct project-submission form URL. It
only says to submit "project name, website, contract address(es), Agent ID
usage description, and other required materials during the Submission Period"
(no registration needed). The only survey link in the announcement is the
Community Promotion X-link survey (app.binance.com). Before 2026-12-09, the
submission channel must be confirmed — re-check the announcement page, the
Binance Square post, and the Agentic Wallet dev docs for a submission form.
Do NOT guess a form URL.
