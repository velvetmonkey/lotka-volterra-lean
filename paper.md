# lotka-volterra-lean: Formal Proofs of Hamiltonian Conservation and Positive Invariance in Lean 4

Ben Cassie  
2026

## Abstract

`lotka-volterra-lean` is a Lean 4 / Mathlib library formalising core structural facts about the classical Lotka-Volterra predator-prey system. The library defines positive parameters, the two-dimensional vector field, classical solutions, and the Hamiltonian $H(x,y) = \delta x - \gamma \log x + \beta y - \alpha \log y$. It proves existence and uniqueness of the interior fixed point, conservation of the Hamiltonian along positive trajectories, lower boundedness of the Hamiltonian on the positive quadrant, axis-invariance identities, and logarithmic derivative structure. The development contains zero `sorry`, zero `admit`, and no project-specific axioms. Its significance is that it formalises a conservative dynamical system: unlike gradient descent, Hopfield networks, contraction systems, or accelerated optimisation, the Lotka-Volterra model does not converge by dissipating energy; it preserves a Hamiltonian and exhibits neutral recurrent motion.

## 1. Introduction

The Lotka-Volterra equations are one of the foundational models of mathematical biology. In their classical predator-prey form, they describe the interaction between a prey population $x$ and a predator population $y$:

```text
dx/dt = α*x - β*x*y
dy/dt = δ*x*y - γ*y
```

The parameters $\alpha,\beta,\gamma,\delta$ are strictly positive. The prey population grows at intrinsic rate $\alpha$ and is reduced by encounters with predators at rate $\beta xy$. The predator population grows through prey encounters at rate $\delta xy$ and decays at intrinsic rate $\gamma$.

This model is mathematically important because it is not a convergence system. In the positive quadrant, the classical Lotka-Volterra system has an interior equilibrium at $(\gamma/\delta,\alpha/\beta)$, but generic trajectories do not converge to that point. Instead, the system preserves a Hamiltonian-like conserved quantity:

```text
H(x,y) = δ*x - γ*ln(x) + β*y - α*ln(y).
```

Level sets of this conserved quantity describe recurrent predator-prey cycles. The model is therefore a useful counterpoint to the dissipative systems that dominate optimisation and learning theory. Gradient descent decreases an objective. Hopfield networks decrease an energy. Contraction systems forget initial conditions exponentially. Nesterov acceleration decreases a Lyapunov potential. Lotka-Volterra, by contrast, conserves its Hamiltonian.

`lotka-volterra-lean` formalises this conservative structure in Lean 4 / Mathlib. It defines the vector field, classical solutions, and Hamiltonian; proves the interior fixed point and its uniqueness among positive equilibria; proves that the Hamiltonian has derivative zero along positive solutions; proves that the Hamiltonian is bounded below on the positive quadrant; and proves axis and logarithmic derivative identities used to express positive-region structure.

The contribution is not a new theorem about Lotka-Volterra dynamics. It is a machine-checked, importable formalisation of standard identities under precise hypotheses. This matters because conservative dynamical systems require a different proof discipline from descent systems. A conserved quantity is not a Lyapunov function in the dissipative sense: it organises trajectories without forcing convergence.

## 2. Library Overview

The project is organised into four Lean modules plus a root import file:

- `LotkaVolterra/Defs.lean` defines `Params`, vector field components `dx` and `dy`, `IsSolution`, and Hamiltonian `H`.
- `LotkaVolterra/FixedPoints.lean` proves interior fixed point existence and uniqueness.
- `LotkaVolterra/Conservation.lean` proves the conservation law `dH/dt = 0` along positive trajectories.
- `LotkaVolterra/Boundedness.lean` proves the Hamiltonian lower bound, axis identities, and logarithmic derivative structure.
- `LotkaVolterra.lean` is the root module importing the library.

The project depends on:

- Lean `v4.28.0`
- Mathlib `v4.28.0`

The formal parameter structure is:

```lean
structure Params where
  α : ℝ
  β : ℝ
  γ : ℝ
  δ : ℝ
  hα : 0 < α
  hβ : 0 < β
  hγ : 0 < γ
  hδ : 0 < δ
```

The vector field is defined by:

```lean
noncomputable def Params.dx (x y : ℝ) : ℝ :=
  p.α * x - p.β * x * y

noncomputable def Params.dy (x y : ℝ) : ℝ :=
  p.δ * x * y - p.γ * y
```

A classical solution is a pair of real-valued functions whose derivatives agree with the vector field:

```lean
structure IsSolution (x y : ℝ -> ℝ) : Prop where
  hx : ∀ t, HasDerivAt x (p.dx (x t) (y t)) t
  hy : ∀ t, HasDerivAt y (p.dy (x t) (y t)) t
```

The Hamiltonian is:

```lean
noncomputable def Params.H (x y : ℝ) : ℝ :=
  p.δ * x - p.γ * Real.log x + p.β * y - p.α * Real.log y
```

The repository is available at:

<https://github.com/velvetmonkey/lotka-volterra-lean>

## 3. Theorem Inventory

The current Lean source contains eleven theorem or lemma declarations. The README and project roadmap refer to a full `positive_invariance` theorem; in the current source, that full theorem is not declared as a separate result. Instead, the source proves the axis-invariance and logarithmic-derivative ingredients that support the positive-quadrant invariance argument.

1. `fixed_point_dx` — The prey component of the vector field vanishes at $(\gamma/\delta,\alpha/\beta)$.
2. `fixed_point_dy` — The predator component of the vector field vanishes at $(\gamma/\delta,\alpha/\beta)$.
3. `fixed_point_unique` — The point $(\gamma/\delta,\alpha/\beta)$ is the only positive equilibrium.
4. `conservation_law` — For positive solutions, `HasDerivAt (fun t => H(x t, y t)) 0 t` for every `t`.
5. `linear_minus_log_bound` — For `a,b,x > 0`, `b*(1 + log(a/b)) ≤ a*x - b*log x`.
6. `H_bounded_below` — The Hamiltonian is bounded below on the positive quadrant by the explicit constant.
7. `H_bdd_below` — Existential form: there exists a constant lower bound for `H` on the positive quadrant.
8. `dx_zero_on_axis` — If `x = 0`, then the prey component `dx` is zero.
9. `dy_zero_on_axis` — If `y = 0`, then the predator component `dy` is zero.
10. `log_prey_deriv` — Along positive solutions, `d/dt[ln x] = α - β*y`.
11. `log_pred_deriv` — Along positive solutions, `d/dt[ln y] = δ*x - γ`.

The fixed-point results are:

```lean
theorem fixed_point_dx :
    p.dx (p.γ / p.δ) (p.α / p.β) = 0

theorem fixed_point_dy :
    p.dy (p.γ / p.δ) (p.α / p.β) = 0

theorem fixed_point_unique {x y : ℝ} (hx : 0 < x) (hy : 0 < y)
    (hdx : p.dx x y = 0) (hdy : p.dy x y = 0) :
    x = p.γ / p.δ ∧ y = p.α / p.β
```

The conservation result is:

```lean
theorem conservation_law {x y : ℝ -> ℝ} (sol : IsSolution p x y)
    (hx_pos : ∀ t, 0 < x t) (hy_pos : ∀ t, 0 < y t) :
    ∀ t, HasDerivAt (fun t => p.H (x t) (y t)) 0 t
```

The lower-bound results are:

```lean
lemma linear_minus_log_bound {a b x : ℝ}
    (ha : 0 < a) (hb : 0 < b) (hx : 0 < x) :
    b * (1 + Real.log (a / b)) ≤ a * x - b * Real.log x

theorem H_bounded_below (x y : ℝ) (hx : 0 < x) (hy : 0 < y) :
    p.γ * (1 + Real.log (p.δ / p.γ)) +
      p.α * (1 + Real.log (p.β / p.α)) ≤ p.H x y

theorem H_bdd_below :
    ∃ C, ∀ x y, 0 < x -> 0 < y -> C ≤ p.H x y
```

The positive-region structural lemmas are:

```lean
theorem dx_zero_on_axis (y : ℝ) :
    p.dx 0 y = 0

theorem dy_zero_on_axis (x : ℝ) :
    p.dy x 0 = 0

theorem log_prey_deriv {x y : ℝ -> ℝ} (sol : IsSolution p x y)
    (hx_pos : ∀ t, 0 < x t) :
    ∀ t, HasDerivAt (fun t => Real.log (x t)) (p.α - p.β * y t) t

theorem log_pred_deriv {x y : ℝ -> ℝ} (sol : IsSolution p x y)
    (hy_pos : ∀ t, 0 < y t) :
    ∀ t, HasDerivAt (fun t => Real.log (y t)) (p.δ * x t - p.γ) t
```

The absence of a standalone `positive_invariance` theorem should be read narrowly: the library proves the local algebraic and logarithmic identities behind positive invariance, but the global forward-invariance statement is not yet packaged as a named theorem in the current source.

## 4. Key Technical Highlights

### Hamiltonian Conservation

The central theorem is `conservation_law`. It proves that for any positive classical solution `(x,y)`, the function

```text
t ↦ H(x(t), y(t))
```

has derivative zero at every time `t`.

The Hamiltonian is the sum of four terms:

```text
δ*x(t) - γ*ln(x(t)) + β*y(t) - α*ln(y(t)).
```

The proof composes derivative rules for each term. The linear terms use scalar multiplication of the derivative of `x` and `y`. The logarithmic terms use `HasDerivAt.log`, requiring the positivity hypotheses `0 < x t` and `0 < y t`. The solution structure supplies:

```text
x'(t) = α*x(t) - β*x(t)*y(t),
y'(t) = δ*x(t)*y(t) - γ*y(t).
```

After substituting these expressions into the derivative of `H`, the terms cancel algebraically. The positive and negative `δαx`, `δβxy`, `αδxy`, and `αγy` contributions reduce to zero. In Lean, this cancellation is carried by unfolding the vector field and closing the resulting real algebra.

This is the defining conservative feature of the library. The Hamiltonian does not merely fail to increase; it is exactly constant along positive trajectories.

### The Linear-Minus-Log Bound

The theorem `H_bounded_below` rests on the scalar inequality `linear_minus_log_bound`:

```text
b(1 + log(a/b)) ≤ a*x - b*log(x)
```

for `a,b,x > 0`.

This inequality is a formal expression of the fact that a positive linear term eventually dominates the logarithm, while the logarithmic singularity controls the approach to zero. The Lean proof derives it from Mathlib's logarithmic inequality:

```lean
Real.log_le_sub_one_of_pos
```

which is the standard bound `log z ≤ z - 1` for positive `z`.

Applied once with `(a,b,x) = (δ,γ,x)` and once with `(a,b,x) = (β,α,y)`, the scalar inequality yields:

```text
H(x,y) ≥ γ(1 + log(δ/γ)) + α(1 + log(β/α)).
```

This gives an explicit lower bound for the Hamiltonian on the positive quadrant. The existential theorem `H_bdd_below` packages the same result in a form suitable for later arguments that only require the existence of some lower bound.

### Conservative, Not Dissipative

Most optimisation and learning systems are analysed through dissipation. Gradient descent lowers an objective. Hopfield networks lower an energy. Contraction systems shrink distances between trajectories. Nesterov accelerated gradient descent lowers a specially weighted Lyapunov potential.

Lotka-Volterra is different. The Hamiltonian is not a descent function. The theorem `conservation_law` says:

```text
dH/dt = 0.
```

This changes the qualitative interpretation of the system. There is an equilibrium, and `fixed_point_unique` proves that the positive equilibrium is unique, but the conservation law prevents generic positive trajectories from simply descending into it. Instead, the Hamiltonian level set constrains the motion.

This conservative framing is the distinctive point of `lotka-volterra-lean`. It provides a checked example of neutral dynamics: structure without convergence, recurrence without forgetting, and stability without attraction in the dissipative sense.

### Positive-Region Structure

The current source does not package full positive-quadrant forward invariance as a named theorem, but it proves the identities that support the usual argument.

First, the coordinate axes are invariant at the vector-field level:

```text
x = 0 ⇒ dx/dt = 0,
y = 0 ⇒ dy/dt = 0.
```

These are the theorems `dx_zero_on_axis` and `dy_zero_on_axis`. Geometrically, the vector field is tangent to the coordinate axes. A trajectory starting exactly on an axis has no instantaneous velocity away from that axis in the corresponding coordinate.

Second, the logarithmic derivative theorems show that inside the positive quadrant:

```text
d/dt[ln x] = α - βy,
d/dt[ln y] = δx - γ.
```

These identities isolate the relative growth rates of prey and predator populations. They are the local analytic form of positivity preservation: as long as the solution is positive, the logarithms evolve with finite derivatives determined by the other population.

Together, the axis identities and logarithmic derivative structure give the formal ingredients for positive invariance. A future extension can package them into a global theorem once the required trajectory-level infrastructure is added.

### Standard Axioms Only

The library introduces no project-specific axioms. It is written against Lean 4 and Mathlib, uses ordinary classical mathematics where needed, and contains zero `sorry` and zero `admit`.

## 5. Relation to Sibling Libraries

`lotka-volterra-lean` is part of the same Lean 4 formalisation programme as `gradient-descent-lean`, `hopfield-lean`, `contraction-lean`, `nesterov-lean`, and `kuramoto-lean`.

`gradient-descent-lean` formalises dissipative optimisation. Its convergence theorems show that gradient descent decreases function values and approaches minimisers at explicit rates. `lotka-volterra-lean` is the conservative counterpoint: its central theorem says that the Hamiltonian is preserved, not decreased.

`hopfield-lean` formalises a discrete Lyapunov argument for associative memory. Hopfield asynchronous updates move downhill in an energy landscape until no further state-changing update is possible. Lotka-Volterra trajectories do not behave that way. They move along Hamiltonian level sets rather than down them.

`contraction-lean` studies exponential forgetting: trajectories of a contraction system converge toward each other, erasing differences in initial conditions. Lotka-Volterra has no such forgetting mechanism in the conservative idealisation. Initial conditions select a Hamiltonian level set, and the system remains constrained by that conserved value.

`nesterov-lean` formalises accelerated optimisation through a continuous Lyapunov potential. Although both projects use potential-like quantities, their meanings are opposite. Nesterov's potential decreases to certify convergence; Lotka-Volterra's Hamiltonian is conserved to certify recurrent structure.

`kuramoto-lean` formalises synchronisation dynamics, gradient identities, and Lyapunov descent for coupled oscillator systems. It sits between pure optimisation and oscillatory dynamics. Lotka-Volterra contributes the explicitly conservative end of the spectrum: oscillation structured by a conserved Hamiltonian rather than synchronisation through dissipation.

Together, these libraries cover several important dynamical patterns:

- descent and convergence;
- acceleration by a decreasing potential;
- discrete attractor dynamics;
- contraction and forgetting;
- synchronisation;
- Hamiltonian conservation and neutral recurrence.

The shared value is that these mechanisms become precise, importable Lean artifacts.

## 6. Significance for AI Safety

AI safety arguments often rely on dynamical metaphors: systems converge, stabilise, synchronise, forget perturbations, or preserve invariants. Formalising these mechanisms matters because the differences between them are not cosmetic. A conserved quantity and a decreasing Lyapunov function imply very different futures.

Lotka-Volterra is valuable in this landscape because it is a minimal formal example of non-dissipative dynamics. It shows that a system can have a distinguished equilibrium and a bounded invariant quantity without converging to that equilibrium. This is a useful warning for reasoning about learning systems, agent populations, ecological feedback loops, and multi-agent dynamics: boundedness is not convergence, and stability is not always attraction.

The Hamiltonian conservation theorem makes this distinction precise. It rules out an interpretation of the model as gradient-like descent. The lower-bound theorem also has a subtle role: the Hamiltonian is bounded below, but because it is conserved rather than decreasing, boundedness does not force convergence. That contrast is exactly the kind of assumption boundary that formal verification exposes.

The positive-region structure also matters. Many models in biology, economics, and AI describe quantities that should remain non-negative: populations, probabilities, resources, intensities, or weights. The Lotka-Volterra vector field encodes this through multiplicative factors and logarithmic structure. Formalising these facts gives future work a starting point for checked positivity and invariance arguments.

This library does not certify real ecological systems, nor does it formalise numerical solvers, stochastic perturbations, or global closed-orbit theorems. Its value is foundational. It supplies a checked conservative system beside the existing checked dissipative systems, allowing future formal work to distinguish descent, conservation, recurrence, and convergence rather than treating all stability arguments as the same shape.

## 7. Conclusion

`lotka-volterra-lean` provides a compact Lean 4 / Mathlib formalisation of core facts about the classical Lotka-Volterra predator-prey system. It defines positive parameters, the vector field, classical solutions, and the Hamiltonian. It proves the interior fixed point, uniqueness of the positive equilibrium, Hamiltonian conservation along positive trajectories, an explicit Hamiltonian lower bound, axis-invariance identities, and logarithmic derivative identities.

The project is deliberately focused. It does not formalise global existence, closed orbit theorems, Poincare-Bendixson theory, numerical simulation, stochastic dynamics, or a standalone full positive-invariance theorem. Instead, it supplies a reliable formal core for the conservative Hamiltonian structure of the model. That core can now be imported and extended by future work on mathematical biology, multi-agent dynamics, ecological feedback, Hamiltonian systems, and AI safety.

## References

Lotka, A. J. (1925). *Elements of Physical Biology*. Williams & Wilkins.

Volterra, V. (1926). *Fluctuations in the abundance of a species considered mathematically*. Nature, 118, 558-560.

The Mathlib Community. (2024). *The Lean Mathematical Library*. GitHub repository. <https://github.com/leanprover-community/mathlib4>

Cassie, B. (2026). *gradient-descent-lean*. Zenodo. DOI: 10.5281/zenodo.20472996. <https://doi.org/10.5281/zenodo.20472996>

Cassie, B. (2026). *kuramoto-lean*. Zenodo. DOI: 10.5281/zenodo.20468619. <https://doi.org/10.5281/zenodo.20468619>

Cassie, B. (2026). *hopfield-lean*. Zenodo. DOI: 10.5281/zenodo.20474169. <https://doi.org/10.5281/zenodo.20474169>

Cassie, B. (2026). *nesterov-lean*. Zenodo. DOI: 10.5281/zenodo.20474481. <https://doi.org/10.5281/zenodo.20474481>

Cassie, B. (2026). *lotka-volterra-lean: Formal Proofs of Hamiltonian Conservation and Positive Invariance in Lean 4*. GitHub repository. <https://github.com/velvetmonkey/lotka-volterra-lean>
