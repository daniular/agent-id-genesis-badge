#!/usr/bin/env python3
"""Synthesize a gentle ambient background track (~57.5s) for the AIDGB demo video.
Chord pads (C - Am - F - G) + soft pentatonic arpeggio + bass. No external files."""
import numpy as np
from scipy.io import wavfile

SR = 44100
DUR = 57.5
N = int(SR * DUR)
t = np.arange(N) / SR
audio = np.zeros(N)

def note(freq, start, dur, amp, attack=0.4, release=0.8, harmonic=0.25):
    """Add a sine note with attack/release envelope into the mix."""
    s0 = int(start * SR)
    s1 = min(N, int((start + dur) * SR))
    if s1 <= s0:
        return
    tt = np.arange(s1 - s0) / SR
    env = np.ones(s1 - s0)
    a = int(attack * SR)
    r = int(release * SR)
    if a > 0:
        env[:a] = np.linspace(0, 1, a)
    if r > 0:
        env[-r:] = np.linspace(1, 0, r)
    # fundamental + soft 2nd harmonic for warmth
    sig = np.sin(2 * np.pi * freq * tt) + harmonic * np.sin(2 * np.pi * freq * 2 * tt)
    audio[s0:s1] += amp * env * sig

# --- Pad chords: C - Am - F - G, each ~14.375s with crossfade overlap ---
chords = [
    [130.81, 164.81, 196.00, 261.63, 329.63],   # C major
    [110.00, 164.81, 220.00, 261.63, 329.63],   # A minor
    [87.31, 130.81, 174.61, 220.00, 261.63],    # F major
    [98.00, 146.83, 196.00, 246.94, 293.66],    # G major
]
chord_len = DUR / 4
for i, chord in enumerate(chords):
    start = i * chord_len - 1.0 if i > 0 else 0.0   # 1s overlap for crossfade
    dur = chord_len + 1.0
    for f in chord:
        # lower notes a bit quieter, higher notes softer
        amp = 0.055 if f < 200 else 0.04
        note(f, start, dur, amp, attack=2.0, release=2.0, harmonic=0.2)

# --- Soft bass (root, one octave down, whole-note) ---
roots = [65.41, 55.00, 43.65, 49.00]  # C2, A1, F1, G1
for i, r in enumerate(roots):
    start = i * chord_len
    note(r, start, chord_len + 0.5, 0.09, attack=0.8, release=1.5, harmonic=0.1)

# --- Gentle pentatonic arpeggio (C major pentatonic, soft, sparse) ---
penta = [523.25, 587.33, 659.25, 783.99, 880.00, 1046.50]  # C5 D5 E5 G5 A5 C6
rng = np.random.default_rng(7)
step = 0.5  # one note every 0.5s
idx = 0
pos = 2.0
# simple ascending/descending walk, mostly stepwise
cur = 2
while pos < DUR - 3:
    f = penta[cur]
    note(f, pos, 1.6, 0.05, attack=0.05, release=1.4, harmonic=0.15)
    # random walk
    cur += rng.choice([-2, -1, -1, 1, 1, 2])
    cur = max(0, min(len(penta) - 1, cur))
    pos += step
    idx += 1

# --- Master: normalize, fade in/out ---
peak = np.max(np.abs(audio))
audio = audio / peak * 0.5
fade_in = int(2.0 * SR)
fade_out = int(3.0 * SR)
audio[:fade_in] *= np.linspace(0, 1, fade_in)
audio[-fade_out:] *= np.linspace(1, 0, fade_out)
# gentle stereo widening: duplicate with slight delay on right
stereo = np.stack([audio, np.roll(audio, int(0.012 * SR))], axis=1)
# keep overall level modest for background use
stereo = np.clip(stereo * 0.9, -1.0, 1.0)
wavfile.write("/home/hatch/workspace/binance-hackathon/demo/music.wav", SR, (stereo * 32767).astype(np.int16))
print("wrote music.wav, duration", DUR, "s")
