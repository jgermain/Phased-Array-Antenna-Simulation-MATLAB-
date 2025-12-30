# Phased Array Antenna Simulation (MATLAB)

## Overview
This project is a MATLAB-based simulation of a **uniform linear phased array antenna**, developed to study electronic beam steering and key radiation pattern performance metrics. The simulation is built from first principles using the analytical **array factor formulation**, with a focus on understanding how array parameters affect beam shape and sidelobes.

The project serves both as a learning tool and a foundation for more advanced phased array analysis, including amplitude tapering and hardware-aware beamforming.

---

## Features
- Electronic beam steering via progressive phase shift  
- Visualization of radiation patterns for a uniform linear array  
- Analysis of grating lobes as a function of element spacing  
- Computation of key antenna performance metrics:
  - **Half-Power Beamwidth (HPBW)**
  - **First-Null Beamwidth (FNBW)**
  - **Sidelobe Level (SLL)** (linear and dB)
- Structured storage of simulation results for reuse and analysis  
- Annotated plots for clear interpretation of results  

---

## Key Concepts Explored
- Array factor and constructive/destructive interference  
- Beam steering using phase progression  
- Effects of element spacing and array size  
- Relationship between beamwidth, sidelobes, and array geometry  
- Practical limitations such as grating lobes  

---

## Adjustable Parameters
The simulation allows easy modification of:
- Number of array elements (`N`)
- Element spacing (`d`)
- Operating wavelength (`λ`)
- Beam steering angle (`θ₀`)

These parameters can be adjusted to explore trade-offs between beamwidth, sidelobe level, and grating lobe formation.

---

## Example Output
The simulation produces:
- Radiation pattern plots versus angle (degrees)
- Visual indicators for HPBW and beam characteristics
- Computed performance metrics stored in structured variables and tables

This makes the results suitable for further analysis, reports, or presentations.

---

## Future Work
Planned extensions to this project include:
- Amplitude weighting (Taylor, Chebyshev tapers)
- Sidelobe suppression vs beamwidth trade-off analysis
- Phase quantization and hardware-aware beam steering
- Parameter sweeps and automated performance plots
- Real-time parameter adjustment using MATLAB UI sliders

---

## Motivation
This project was developed to build a strong theoretical and practical foundation in phased array antennas, bridging coursework in electromagnetics and antenna engineering with simulation-based analysis used in real-world RF systems.

---

