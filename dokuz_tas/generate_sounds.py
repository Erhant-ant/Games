import wave
import struct
import math
import os

os.makedirs('assets/audio', exist_ok=True)

def generate_wav(filename, duration, freq_func, vol_func, sample_rate=44100):
    num_samples = int(duration * sample_rate)
    with wave.open(filename, 'w') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)
        
        for i in range(num_samples):
            t = float(i) / sample_rate
            freq = freq_func(t)
            vol = vol_func(t)
            
            value = int(vol * 32767.0 * math.sin(2.0 * math.pi * freq * t))
            data = struct.pack('<h', value)
            wav_file.writeframesraw(data)

# 1. Place Sound (Wooden Tok)
# Short, low frequency, quick decay
def place_freq(t): return 150.0 + (100.0 * math.exp(-t * 20))
def place_vol(t): return math.exp(-t * 30)
generate_wav('assets/audio/place.wav', 0.15, place_freq, place_vol)

# 2. Capture Sound (Sharp Break/Crunch)
# Slightly noisy, fast attack, medium decay
import random
def capture_freq(t): return 400.0 + random.uniform(-100, 100)
def capture_vol(t): return math.exp(-t * 15) * 0.8
generate_wav('assets/audio/capture.wav', 0.25, capture_freq, capture_vol)

# 3. Mill Sound (Success Ding/Shimmer)
def mill_freq(t): return 800.0 + (200.0 * math.sin(t * 20))
def mill_vol(t): return math.exp(-t * 5) * 0.5
generate_wav('assets/audio/mill.wav', 0.5, mill_freq, mill_vol)

print("Sounds generated in assets/audio/")
