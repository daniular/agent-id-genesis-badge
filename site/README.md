# Agent ID Genesis Badge — site

Static site (no build step). Host the `site/` folder on any static host
(Cloudflare Pages, GitHub Pages, IPFS, …).

## Files
- `index.html` — the claim dApp. Connects via the injected wallet
  (`window.ethereum`, e.g. Binance Wallet / MetaMask). No QR-code login,
  no WalletConnect, no server.
- `metadata/1.json` — sample token metadata. The Badge contract's `tokenURI`
  returns `baseURI + tokenId`, so the host must serve
  `/metadata/<tokenId>.json` for every minted token. Generate one JSON per
  tokenId (same shape as `1.json`, with the token number in `name`).

## Before launch (phase 2)
1. Deploy `AgentIDGenesisBadge` with constructor args:
   - registry: `0x60B9262456de011F7d15a54cdd8c48baaa8b022F`
   - baseURI: `https://<your-host>/metadata/` (must end with `/`)
2. In `index.html`, set `BADGE_ADDRESS` to the deployed contract address.
3. Verify the contract source on BscScan (hackathon requirement).
4. The baseURI host must serve `/metadata/<tokenId>.json` files.

## Red lines respected
- No QR-code / pairing-code login; no stored login sessions.
- Only checks the CONNECTED address's own Agent ID (never a "look up
  someone else's wallet by name" tool).
- No promised returns, no trading, no asset transfers beyond the user's
  own claim (value 0) and their own ERC-721 transfers.
- No seed phrase / private key / API secret collection.
- Project/token name does not use "Binance" or "BNB".
