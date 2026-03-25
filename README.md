# MASA_Matlab_FinCalc

**Analytical Aerodynamic Load Calculator for Rocket Fins**

A MATLAB GUI applet that computes the aerodynamic forces acting on a single rocket fin across its entire flight profile — from subsonic through transonic to supersonic regimes. Upload a trajectory CSV, define your fin geometry, and get lift, drag, and moment estimates at every point along the flight envelope.

> **Disclaimer:** This project was developed as an engineering demonstrator and is not fully validated. Output accuracy has not been verified against simulation or wind tunnel data. Treat results as indicative, not authoritative.

---

## Features

- **Flight regime detection** — automatically classifies trajectory segments into subsonic (Ma < 0.8), transonic (0.8 < Ma < 1.2), and supersonic (Ma > 1) and applies the appropriate aerodynamic theory to each
- **Multiple fin planforms** — supports trapezoidal, clipped-delta, symmetric forward-swept, and parallelogram (aft-swept) geometries with automatic trailing-edge classification
- **Regime-specific load models** — uses linearized theory for subsonic and supersonic flow, with separate handling for transonic conditions
- **Mach cone visualization** — overlays Mach cones on the fin planform at peak Mach number, identifying whether leading and trailing edges are subsonic or supersonic
- **Swept-wing corrections** — accounts for sweep effects on both lift and drag in supersonic flow
- **Atmosphere model** — ISA standard atmosphere with altitude-dependent density, temperature, speed of sound, and dynamic viscosity (Sutherland's law) for Reynolds number computation
- **Assumption & warning tracking** — prints all simplifying assumptions to the command window and displays pop-up warnings when input parameters violate model validity (e.g., angle of attack beyond 7deg)

---

## Quick Start

**Requirements:** MATLAB 2023b (no backwards compatibility guaranteed)

1. Run `parameterInputs` in MATLAB to launch the GUI
2. Click **Upload CSV** and select a flight profile (see `hypothetical_student_rocket_profile.csv` for the expected format: columns `Altitude (m)` and `Speed (m/s)`)
3. Select a fin shape, enter dimensions (root chord, tip chord, span, sweep angle) and flight conditions (angle of attack, roll rate)
4. Click **Calculate**
5. Check the MATLAB command window for printed assumptions
6. Inspect the generated figures (some may open behind the GUI)

---

## What to Expect

### GUI with exemplary input

<img width="596" height="327" alt="Input GUI showing fin parameter fields and upload button" src="https://github.com/user-attachments/assets/55993355-e6db-4b0c-aecf-fe4380dba7e2" />

### Flight profile with regime classification

Uploading a trajectory CSV produces plots of altitude vs. speed with color-coded subsonic, transonic, and supersonic regions.

<img width="1119" height="450" alt="Flight profile plot with shaded Mach regime regions" src="https://github.com/user-attachments/assets/ed80c6ec-0301-4c5c-ba48-0fccf8778498" />

### Fin shape selection and geometry

Four planform types to choose from, each with automatic geometric constraint enforcement.

<img width="447" height="217" alt="Dropdown showing fin shape options" src="https://github.com/user-attachments/assets/173e44eb-873a-4f2c-abff-8df248898d45" />

### Assumption and warning reporting

After calculation, any broken assumptions or out-of-range conditions are flagged.

<img width="867" height="111" alt="Warning dialog about broken assumptions" src="https://github.com/user-attachments/assets/cdc95a7a-27f7-4a51-9063-0b7d69e03071" />

### Planar fin analysis with Mach cones

The fin planform is plotted with its center of pressure, surface area, and — for supersonic cases — Mach cone overlays indicating sub/supersonic edge conditions and the region where 2D linearized theory applies.

<img width="1109" height="500" alt="Fin shape plot with Mach cone overlay and edge classification" src="https://github.com/user-attachments/assets/2c718fa8-47ef-4377-a414-9bd9fc432fee" />
<img width="600" height="231" alt="Fin geometry detail with computed properties" src="https://github.com/user-attachments/assets/523361c9-bc14-4c68-84eb-c5d586b56b33" />

### Computed aerodynamic loads

Final output of lift, drag, and moment estimates across the flight profile.

<img width="557" height="501" alt="Aerodynamic load output plots" src="https://github.com/user-attachments/assets/616d5792-2f73-4ec4-aeca-84ebc7abc5df" />

---

## Project Structure

```
App/
├── parameterInputs.m                  # Entry point — GUI and orchestration
├── finAerodynamicsCalcs.m             # Core aerodynamic property computation
├── FinLoadCalcs.mlx                   # Load calculation across flight profile
│
├── plotRocketFlightProfile.m          # Trajectory visualization with regime shading
├── plotFinShape.m                     # Subsonic fin planform plot
├── plotFinShapeSupersonic.m           # Supersonic fin plot with Mach cones
│
├── calculateMachNumber.m              # Local Mach from speed & altitude (ISA)
├── calculateAirDensity.m             # ISA air density model
├── calculateReynoldsNumber.m          # Re via Sutherland's viscosity law
├── calculateCenterOfPressure.m        # Spanwise CoP for different planforms
├── calculateFinArea.m                 # Trapezoidal planform area
├── classifyFinShape.m                 # Trailing-edge sweep classification
├── machConeAngle.m                    # Mach cone half-angle
│
├── subsonic_loads.mlx                 # Subsonic load model
├── tansonic_loads.mlx                 # Transonic load model
├── transsonic_loads.mlx               # Transonic load model (alternate)
├── supersonic_loads.mlx               # Supersonic load model
├── supersonic_sweep_lift.mlx          # Swept-wing supersonic lift
├── supersonic_sweep_drag.mlx          # Swept-wing supersonic drag
├── supersonicShockwave.mlx            # Oblique shock analysis
├── supersonicShockwave_Sweep.mlx      # Swept oblique shock analysis
│
├── disp_assumption.m                  # Unique-assumption printer
├── disp_warning.m                     # Unique-warning dialog manager
├── hypothetical_student_rocket_profile.csv  # Example trajectory input
│
└── Misc/
    └── supersonicWaveStudy_Newtonian_vs_Linearized.mlx  # Theory comparison study
```

---

## CSV Input Format

The trajectory file must contain two columns with these exact headers:

| Altitude (m) | Speed (m/s) |
|--------------|-------------|
| 0.0          | 0.0         |
| 30.3         | 10.4        |
| ...          | ...         |

---

## Limitations

- Atmosphere model valid only in the troposphere (< 11 km altitude)
- No viscous interaction or real-gas effects
- Transonic regime uses simplified interpolation, not full nonlinear methods
- Single isolated fin — no fin-body interference or multi-fin effects
- Not validated against CFD, wind tunnel, or flight data

---
 
## Note
 
This project was created with the assistance of AI tools.
