#!/usr/bin/env python3
"""Generate title/info cards for the AIDGB demo video (1280x720)."""
from PIL import Image, ImageDraw, ImageFont
import os

OUT = "/home/hatch/workspace/binance-hackathon/demo"
W, H = 1280, 720
BG = (14, 14, 20)        # near-black
GOLD = (240, 185, 11)    # binance yellow
WHITE = (245, 245, 245)
GREY = (170, 170, 180)

def font(size, bold=False):
    # DejaVu Sans is reliably present
    path = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf" if bold else "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
    return ImageFont.truetype(path, size)

def card(filename, title, lines, title_size=64, line_size=34, accent=True):
    img = Image.new("RGB", (W, H), BG)
    d = ImageDraw.Draw(img)
    # gold top bar
    if accent:
        d.rectangle([0, 0, W, 8], fill=GOLD)
    y = 150 if title else 200
    if title:
        f = font(title_size, bold=True)
        # wrap title manually by width
        tw = d.textlength(title, font=f)
        d.text(((W - tw) / 2, y), title, font=f, fill=GOLD)
        y += title_size + 50
    f = font(line_size)
    for line in lines:
        tw = d.textlength(line, font=f)
        d.text(((W - tw) / 2, y), line, font=f, fill=WHITE)
        y += line_size + 22
    img.save(os.path.join(OUT, filename))
    print("wrote", filename)

# Scene 1: title
card("card1_title.png", "Agent ID Genesis Badge",
     ["Free commemorative NFT for Binance Agent ID holders",
      "Binance Agent ID Hackathon — solo entry"])

# Scene 3: badge showcase (badge image centered on dark bg + caption)
badge = Image.open("/home/hatch/workspace/binance-hackathon/site/badge.png").convert("RGBA")
img = Image.new("RGB", (W, H), BG)
d = ImageDraw.Draw(img)
d.rectangle([0, 0, W, 8], fill=GOLD)
b = badge.resize((360, 360))
img.paste(b, ((W - 360)//2, 70), b)
f = font(36, bold=True)
t = "One badge per Agent ID — free, gas only"
tw = d.textlength(t, font=f)
d.text(((W - tw)/2, 470), t, font=f, fill=GOLD)
f2 = font(28)
t2 = "Claimable only by wallets holding an Agent ID"
tw2 = d.textlength(t2, font=f2)
d.text(((W - tw2)/2, 530), t2, font=f2, fill=WHITE)
img.save(os.path.join(OUT, "card3_badge.png"))
print("wrote card3_badge.png")

# Scene 4: how it works
card("card4_how.png", "How it works",
     ["1. Connect your Agentic Wallet",
      "2. The contract verifies your Agent ID on-chain",
      "3. Claim your badge — gas only (value 0)"])

# Scene 5: live proof
card("card5_proof.png", "Live on BNB Chain",
     ["36 badges claimed by Agent ID holders",
      "Source verified on BscScan + Sourcify (exact_match)",
      "Contract: 0x988bffCb78a21b10228aE45ba3DCF20D7d260F76"])

# Scene 6: closing
card("card6_close.png", "Claim yours free",
     ["agentid-genesis-badge.pages.dev",
      "One badge per Agent ID"])
print("done")
