# lotka-volterra-lean

[![Lean 4](https://img.shields.io/badge/Lean-4.28.0-blue)](https://lean-lang.org/)
[![Mathlib](https://img.shields.io/badge/Mathlib-v4.28.0-purple)](https://github.com/leanprover-community/mathlib4)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Proofs](https://img.shields.io/badge/proofs-pending-lightgrey)](LotkaVolterra)

Lean 4 formal proofs of Lotka-Volterra predator-prey dynamics: Hamiltonian conservation, fixed points, and positive invariance.

**Zero sorry statements.**

## Why it matters

The Lotka-Volterra equations are one of the foundational models of mathematical biology, appearing in ecology, economics, epidemiology, and game theory. Their key property is a conserved Hamiltonian: trajectories in the positive quadrant are closed orbits around an interior fixed point. Unlike gradient descent or Hopfield networks, there is no convergence to a fixed point -- the system is conservative, not dissipative.

This library machine-checks the conservation law and supporting results in Lean 4, giving a verified foundation for reasoning about Hamiltonian dynamical systems.

## Model

```
dx/dt = α*x - β*x*y
dy/dt = δ*x*y - γ*y
```

Parameters: α, β, γ, δ : ℝ, all strictly positive. State: (x, y) with x > 0, y > 0.

Hamiltonian: H(x, y) = δ*x - γ*ln(x) + β*y - α*ln(y)

## Planned project structure

```
LotkaVolterra/
├── Defs.lean          — ODE vector field, parameters, Hamiltonian definition
├── Conservation.lean  — dH/dt = 0 along trajectories
├── FixedPoints.lean   — Interior fixed point (γ/δ, α/β)
└── Boundedness.lean   — H bounded below on positive quadrant
```

## Planned theorem inventory

| # | Theorem | Statement |
|---|---------|-----------|
| 1 | `lv_fixed_point` | Interior fixed point exists at (γ/δ, α/β) |
| 2 | `hamiltonian_conservation` | dH/dt = 0 along trajectories |
| 3 | `positive_invariance` | x > 0 and y > 0 is preserved under the flow |
| 4 | `hamiltonian_bounded_below` | H is bounded below on the positive quadrant |

## Key technical highlights

- Conservative system: no attractor, no convergence -- orbits are closed curves
- Hamiltonian conservation proved via chain rule and direct cancellation, no ODE trajectory theory needed for the algebraic identity
- Standard axioms only: `propext`, `Classical.choice`, `Quot.sound`
- Zero `sorry`, zero `admit`

## Dependencies

- Lean 4.28.0
- Mathlib v4.28.0

## Paper

Companion paper forthcoming. To be published on Zenodo.

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
