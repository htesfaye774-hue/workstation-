# Mastering Workstation (VST3, JUCE 8 / C++17)

A mastering plugin for modern underground hip-hop, rage, trap and melodic rap.
Real-time stereo DSP engine (no GUI dependencies) + JUCE editor.

## Signal chain
Input trim -> Parametric EQ -> 4-band dynamics -> 3-band harmonic enhancer -> transient / 808 shaper
-> 4-band stereo imager -> true-peak look-ahead limiter -> output ceiling (always enforced).
Each module has On, Reset, and smooth 12 ms crossfaded bypass. Master bypass is latency-aligned.

| Module | What it does |
|---|---|
| Analysis | Peak, RMS, LUFS M/S/I, LRA, true peak (4x), correlation, width; spectrum (in/out); flags for excess bass, muddy mids, harshness, weak transients, wide/over-compressed dynamics; subtle EQ suggestions (max +-2 dB, you apply them) |
| EQ | HPF 12/24 dB, low shelf, 4 bells, high shelf; drag nodes in the display, wheel = Q, double-click = reset |
| Dynamics | 4 bands, LR4 crossovers with allpass phase compensation; threshold/ratio/attack/release/gain per band, mix |
| Harmonics | Low/mid/high drive, Warm / Drive / Hard (ADAA anti-aliased), harshness tame |
| Transients | Attack, sustain, separate 808 sustain with split frequency |
| Stereo | Width per band, bass mono below a set frequency, mono-safety guard (limits widening only) |
| Limiter | Input gain, threshold, release, ceiling; Punch / Balanced / Aggressive; true-peak detection 1x/2x/4x/8x |
| Reference | Load WAV/AIFF/FLAC (or drop on the window) or use the sidechain input; level-matched A/B; difference table and curves. Never changes your settings |

Latency: 3.46 ms @ 48 kHz (reported to the host). Presets: 7 factory starting points + user presets.
Simple / Advanced modes, Undo / Redo, Reset module / Reset all.

## Build
Requirements: CMake >= 3.22, a C++17 compiler. JUCE 8.0.15 is fetched automatically (or place it in ./JUCE).
* Windows: run `build.bat` (Visual Studio 2022). * macOS / Linux: `./build.sh`
* Linux needs: libasound2-dev libfreetype-dev libfontconfig1-dev libx11-dev libxrandr-dev libxinerama-dev libxcursor-dev libxext-dev libgl1-mesa-dev libcurl4-openssl-dev
* No local toolchain? Push to GitHub: `.github/workflows/build.yml` builds Windows, macOS and Linux VST3s.
Output: `build/MasteringWorkstation_artefacts/Release/VST3/Mastering Workstation.vst3`
Copy to `C:\Program Files\Common Files\VST3` (Windows) and rescan in REAPER.
Parameters are generated from `tools/gen_params.py` (`python3 tools/gen_params.py` after editing).

## Tests (run by the build scripts)
* `MWTests` - 59 DSP checks (measured loudness, EQ gain, crossover flatness, compressor ratio, limiter ceiling /
  true peak vs. an independent 16x measurement, latency, bypass, clicks, NaN/Inf, denormals, CPU, sample rates).
* `MWHostTest <path-to.vst3> <screens-dir>` - 42 checks: processor, presets, undo/redo, state, reference loading,
  UI snapshots, and loading the compiled VST3 as a host would. Results are in `test-results/`.

## Known limits (honest list)
* Verified on Linux x86_64 only; Windows/macOS builds and REAPER were not tested by the author.
* True-peak limiting is accurate to a few tenths of a dB: a 0.3 dB safety margin is built in at 2x+ detection.
  2x is the least accurate mode; use 4x or 8x for delivery.
* Bass mono uses an LR4 crossover: one octave below the split the out-of-phase residue is ~25 dB down, not total.
* Diagnostic thresholds, the target tonal curve, and presets are heuristics - starting points, not rules.
* Harmonic enhancer uses first-order ADAA, not oversampling; very high drive on bright material can still alias slightly.
* Reference files are capped at 12 minutes.
* JUCE is AGPLv3 / commercial: distributing this plugin requires complying with one of those licenses.
