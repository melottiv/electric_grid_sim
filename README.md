
# Electric Grid Simulator using Monte Carlo and Markov Chains  
**Virginia Melotti – 16.01.2025**

## Overview

This MATLAB project simulates the behavior of an electrical network using **Markov Chain Monte Carlo (MCMC)** methods and **Monte Carlo simulation**. It evaluates the system’s safety under uncertainty, estimates transition probabilities between system states, and analyzes statistical properties of the generated data.

---

## Problem 1 – MCMC Random Number Generator

### Objective
Generate samples from an empirical distribution using MCMC. Verify that the samples are identically and independently distributed via autocorrelation and cross-correlation analysis.

### Files
- `MCMC.m`  
  Loads the distribution, runs the MCMC chain with burn-in and thinning, saves the samples, and checks sample quality.

- `MarkovStep.m`  
  Implements:
  - Proposal function: Normal distribution with user-defined σ
  - Acceptance function: Metropolis rule based on original data

- `PointsToGrid.m`  
  Discretizes points into a 6×6×6 grid for visual comparison with the input distribution.

### Results
- Autocorrelation < 0.1
- Cross-correlation has sharp central peak
- Samples closely match the original distribution

---

## Problem 2 – Monte Carlo Simulation of Grid Safety

### Objective
Estimate the **expected time** in which the voltage at node 2 is **outside safe limits**, when input parameters follow the empirical MCMC distribution.

We want to compute:

> Expected abnormal time T(X₂, Pₛ, Tₘ),  
> where abnormality means:
> - |V₂| < Vₘ or |V₂| > Vₚ  
> - Q₂ < Qₘ or Q₂ > Qₚ  

### Files
- `runSim.m`  
  Runs simulations and stores events and timestamps.

- `Tab_compute.m`  
  Computes abnormal time based on voltage (V) and reactive power (Q), using:
  - `V_ab.m`
  - `Q_ab.m`

- `Tab_estimate.m`  
  Averages results and computes confidence interval with:

- `Bootstrap.m`  
  Applies resampling to estimate error margins.

### Results
- Over 15,000 samples simulated
- Confidence interval within ±0.05s (95% confidence)

---

## Problem 3 – Transition Probabilities & Waiting Times

### Objective
Estimate:
- Transition probabilities between states (jump chain)
- Average waiting time in each state

### Files
- `calculateTransitionProbabilities.m`  
  Loads event logs, extracts sequences and timings, computes:
  - Transition matrix
  - Mean time spent in each state

- `getStateSequenceAndTimes.m`  
  Parses sequences and logs time spent per state (starting from `3V0`).

---

## Problem 4 – Hitting Time Estimation

### Objective
Estimate the **expected time to return** to state `3V0` from other states (e.g., `3VL`) using **first-step conditioning**:

```matlab
hVH = avg_time(3) + transitionProb(3,6)*avg_time(6);
hVL = avg_time(2) + transitionProb(2,5)*avg_time(5);
hAB = hVL + hVH;
