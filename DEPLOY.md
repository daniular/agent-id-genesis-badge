# Deploy — Agent ID Genesis Badge site (Cloudflare Pages)

Site is ready. Deploy is ONE login + ONE command. Nothing is deployed yet
(no Cloudflare credentials exist on this machine).

## What you need
- A Cloudflare account (free). No API token needed if you use `wrangler login`
  (browser OAuth). A token also works: `CLOUDFLARE_API_TOKEN` with
  Pages:Edit + Account:Read, plus `CLOUDFLARE_ACCOUNT_ID`.

## Steps (run in a terminal on this machine)
```bash
cd ~/workspace/binance-hackathon
wrangler login            # opens a browser, authorize Cloudflare (one time)
wrangler pages deploy site --project-name agentid-genesis-badge
```
Wrangler will ask to create the project `agentid-genesis-badge` if it does
not exist yet — answer yes. The project name MUST stay
`agentid-genesis-badge` because the contract baseURI is
`https://agentid-genesis-badge.pages.dev/metadata/`.

## After deploy, verify
```bash
curl -s https://agentid-genesis-badge.pages.dev/ | head -c 100
curl -s https://agentid-genesis-badge.pages.dev/metadata/1
curl -s -I https://agentid-genesis-badge.pages.dev/metadata/1 | grep -i content-type
# expect: HTTP 200, Content-Type: application/json
```

## Files
- `site/index.html` — claim page, BADGE_ADDRESS =
  `0x988bffCb78a21b10228aE45ba3DCF20D7d260F76`
- `site/metadata/1..10` + `site/metadata/1.json..10.json` — token metadata
  (both forms; tokenURI returns baseURI + tokenId with NO .json suffix)
- `site/badge.png` — 512x512 image referenced by the metadata
- `site/_headers` — serves /metadata/* as application/json
- `wrangler.toml` — project name + pages_build_output_dir = site

## Local check (already done 2026-11-19)
`wrangler pages dev site` serves: / = 200 text/html (contains the deployed
address), /metadata/1 = 200 application/json, /metadata/1.json = 200
application/json, /badge.png = 200 image/png. Wrangler 4.165.0 installed
globally at /usr/bin/wrangler.
