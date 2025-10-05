# FIFO Tutorial

This repository contains a SystemVerilog implementation of a FIFO (First-In-First-Out) buffer with a testbench for simulation using Xilinx Vivado.

## Video Tutorial

Watch this video for a detailed explanation of FIFO design and implementation in SystemVerilog:

<div class="video-container" style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden; max-width: 100%; margin: 20px 0;">
  [Watch the video tutorial on YouTube](https://www.youtube.com/watch?v=U54oiMhJSIo)
  [![Watch the video](https://img.youtube.com/vi/U54oiMhJSIo/0.jpg)](https://www.youtube.com/watch?v=U54oiMhJSIo)
</div>

[![Watch the video](https://img.youtube.com/vi/U54oiMhJSIo/0.jpg)](https://www.youtube.com/watch?v=U54oiMhJSIo)

## Prerequisites

- Xilinx Vivado 2024.2 or later installed and in your PATH
- Make utility

## Project Structure

- `src/fifo.sv`: FIFO RTL implementation
- `tb/test_fifo.sv`: Testbench for the FIFO
- `common/tb_utils_pkg.sv`: Utility package for testbench
- `scripts/`: Simulation scripts and configuration files
  - `Makefile`: Build and simulation targets
  - `filelist.f`: List of source files
  - `xsim_cfg.tcl`: Simulation configuration

## Running the Simulation

1. Navigate to the `scripts` directory:
   ```bash
   cd scripts
   ```

2. Run the full simulation with waveform viewer:
   ```bash
   make wave
   ```

   This will:
   - Compile the SystemVerilog files
   - Elaborate the design
   - Run the simulation
   - Open the waveform viewer

## Other Make Targets

- `make compile`: Compile only
- `make elaborate`: Compile and elaborate
- `make simulate`: Compile, elaborate, and simulate
- `make clean`: Clean build artifacts

## Viewing Results

Simulation logs are stored in `scripts/outputs/`. The waveform viewer will open automatically with `make wave`.