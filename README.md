# lotka-volterra-lean

[![thread](https://img.shields.io/badge/%F0%9F%A7%B5-how%20it%20works-1DA1F2)](https://x.com/thevelvetmonke)
[![Lean 4](https://img.shields.io/badge/Lean-4.28.0-blue)](https://lean-lang.org/)
[![Mathlib](https://img.shields.io/badge/Mathlib-v4.28.0-purple)](https://github.com/leanprover-community/mathlib4)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Proofs](https://img.shields.io/badge/proofs-11%20proved%20%2F%200%20sorry-brightgreen)](LotkaVolterra)
[![Paper](https://img.shields.io/badge/Zenodo-20474669-blue)](https://zenodo.org/records/20474669)

Lean 4 formal proofs of Lotka-Volterra predator-prey dynamics: Hamiltonian conservation, fixed points, positive invariance, and boundedness.

**12 declarations. Zero sorry statements.**

## What this is, and why it matters

This library formalizes core facts about the classical Lotka-Volterra predator-prey equations. Its headline theorem, `LotkaVolterra.conservation_law`, proves that the derivative of the logarithmic Hamiltonian is zero along every strictly positive classical solution.

The result captures why this system is conservative rather than dissipative. The proof differentiates each term of the Hamiltonian, substitutes the prey and predator differential equations, and verifies exact cancellation. Other declarations identify the unique positive equilibrium and bound the Hamiltonian below on the positive quadrant.

The conservation theorem assumes a solution on all real times and assumes both components remain strictly positive. It does not establish existence, uniqueness, or positivity of solutions. A zero derivative supplies the conservation law, but the library does not itself prove that every positive trajectory is a closed periodic orbit.

## Background and motivation

The Lotka-Volterra equations are one of the foundational models of mathematical biology, appearing in ecology, economics, epidemiology, and game theory. Their key property is a conserved Hamiltonian: trajectories in the positive quadrant are closed orbits around an interior fixed point. Unlike gradient descent or Hopfield networks, there is no convergence to a fixed point -- the system is conservative, not dissipative.

This library machine-checks the conservation law, fixed point uniqueness, positive invariance, and Hamiltonian lower bound in Lean 4 via HasDerivAt composition and Mathlib's Real.log infrastructure.

## Model

```
dx/dt = α*x - β*x*y
dy/dt = δ*x*y - γ*y
```

Parameters: `Params` structure with α, β, γ, δ : ℝ all strictly positive.

Hamiltonian: H(x, y) = δ*x - γ*ln(x) + β*y - α*ln(y)

## Project structure

```
LotkaVolterra/
├── Defs.lean          — Params, vector field (dx, dy), IsSolution, Hamiltonian H
├── FixedPoints.lean   — Interior fixed point existence and uniqueness
├── Conservation.lean  — Conservation law: dH/dt = 0 along trajectories
└── Boundedness.lean   — H bounded below, positive invariance, log-derivative structure
LotkaVolterra.lean     — Root module importing all four
```

## Theorem inventory

| # | Name | Statement |
|---|------|-----------|
| 1 | `fixed_point_dx` | Vector field dx vanishes at (γ/δ, α/β) |
| 2 | `fixed_point_dy` | Vector field dy vanishes at (γ/δ, α/β) |
| 3 | `fixed_point_unique` | (γ/δ, α/β) is the only positive equilibrium |
| 4 | `conservation_law` | HasDerivAt (fun t => H(x t, y t)) 0 t for every t |
| 5 | `dx_zero_on_axis` | x = 0 implies x' = 0 (x-axis invariant) |
| 6 | `dy_zero_on_axis` | y = 0 implies y' = 0 (y-axis invariant) |
| 7 | `log_prey_deriv` | d/dt[ln x] = α - β*y |
| 8 | `log_pred_deriv` | d/dt[ln y] = δ*x - γ |
| 9 | `linear_minus_log_bound` | a*x - b*ln x ≥ b*(1 + ln(a/b)) for x, a, b > 0 |
| 10 | `H_bounded_below` | H(x,y) ≥ γ(1 + ln(δ/γ)) + α(1 + ln(β/α)) on positive quadrant |
| 11 | `H_bdd_below` | Existential form of the lower bound |

## Key technical highlights

- Conservation law proved by composing `HasDerivAt` lemmas for each term of H and showing the derivative simplifies to zero
- `linear_minus_log_bound` derived from `Real.log_le_sub_one_of_pos` -- the key algebraic fact behind Hamiltonian boundedness
- Conservative system: no attractor, no convergence -- orbits are closed curves in the positive quadrant
- All 12 declarations verified via `#print axioms`: only `propext`, `Classical.choice`, `Quot.sound`
- Zero `sorry`, zero `admit`

## Dependencies

- Lean 4.28.0
- Mathlib v4.28.0

## Paper

**lotka-volterra-lean: Formal Proofs of Hamiltonian Conservation and Positive Invariance in Lean 4**  
Ben Cassie (2026). Zenodo.  
https://zenodo.org/records/20474669

## Cite

Cassie, B. (2026). *lotka-volterra-lean: Formal Proofs of Hamiltonian Conservation and Positive Invariance in Lean 4*. Zenodo. https://zenodo.org/records/20474669.

## Related work

- [kuramoto-lean](https://github.com/velvetmonkey/kuramoto-lean) — Lean 4 Kuramoto synchronisation
- [gradient-descent-lean](https://github.com/velvetmonkey/gradient-descent-lean) — Lean 4 gradient descent convergence
- [hopfield-lean](https://github.com/velvetmonkey/hopfield-lean) — Lean 4 Hopfield attractor convergence
- [contraction-lean](https://github.com/velvetmonkey/contraction-lean) — Lean 4 contraction theory
- [nesterov-lean](https://github.com/velvetmonkey/nesterov-lean) — Lean 4 Nesterov accelerated gradient descent

## Acknowledgements

Proofs in this library were generated using [Aristotle](https://aristotle.harmonic.fun), an AI proof assistant for Lean 4 and Mathlib. The proof discipline -- zero sorry, every Mathlib lemma name `#check`ed before use -- was specified by the author and enforced by the Lean type checker.

## Author

Ben Cassie · [@thevelvetmonke](https://x.com/thevelvetmonke)
## Part of the Lean proof corpus

One of a family of small, machine-checked Lean 4 developments. Index: [velvetmonkey/lean](https://github.com/velvetmonkey/lean) ([live index](https://velvetmonkey.github.io/lean)).
