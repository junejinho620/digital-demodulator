# Subsystem B - Digital Demodulator

An FPGA-based demodulator for the FLRTRX SDR that samples I/Q, down-converts a 10 kHz IF to baseband, and outputs line-level audio. Supports AM and single-sideband (SSB) detection, with a clean I/O: RX I/Q in, audio out via DAC.

## Overview  

### 1. Milestone 1 — Clock Divider + I²S Receiver
Derived 24.576 MHz MCLK from 50 MHz via PLL; generated synchronized LRCLK (= MCLK/512) and SCLK (= MCLK/8) in a clock divider; implemented I²S Rx/Tx with frame-valid handoff and verified passthrough on the PMOD-I2S2.

### 2. Milestone 2 — Fixed-Point DSP Blocks + FIR Filter
Built signed adder/subtractor/multiplier units and a tapped-delay-line FIR; passed module testbenches; designed a DE10-Lite <-> PMOD interface PCB (test points, silkscreen, mounting holes); resolved the M1 “white-noise” issue.

### 3. Milestone 3 — Demodulation & System Integration
Implemented AM and SSB demodulation; validated with frequency sweeps and sideband-rejection plots; integrated the full chain to demodulate desired signals and attenuate undesired content.

### Testing & Results

- Signal sweeps from 440 Hz ~ 20 kHz confirm low pass filter behavior and demodulation bandwidth.

- AM Demodulation: ~500 Hz audio recovered from a 10 kHz carrier on bench.

- SSB Demodulation: measured sideband rejection after Hilbert path integration.

### Next Steps

Finalize reset debouncing, expose Local Oscillator tuning via rotary encoder, and reduce memory by replacing long FIR delays with register lines where feasible.


### Repository layout
- `rtl/` — synthesizable IP (I²S Rx/Tx, clock divider, FIR, arithmetic units)
- `top/` — bring-up / integration top-levels (e.g., `Audio_Passthrough.sv`)
- `sim/` — testbenches and ModelSim scripts (`.do`)
- `quartus/` — project files (`.qsf`, constraints)
- `docs/` — design requirements

### Quickstart

#### Sim (ModelSim/Questa)
```tcl
# From sim/modelsim/
do Audio_Passthrough.do
```

### 👥 Contributors

- **Jinho Choi**
- **Jason Zhang**
- **Sebastian Sergnese**

---
