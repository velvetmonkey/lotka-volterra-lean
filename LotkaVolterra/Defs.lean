/-
  Lotka–Volterra predator-prey model — core definitions.

  System:  dx/dt = α x − β x y,   dy/dt = δ x y − γ y
  Parameters α, β, γ, δ > 0.
  Hamiltonian / conserved quantity:  H(x, y) = δ x − γ ln x + β y − α ln y.
-/
import Mathlib

namespace LotkaVolterra

/-! ### Parameters -/

/-- Strictly positive parameters for the Lotka–Volterra system. -/
structure Params where
  α : ℝ
  β : ℝ
  γ : ℝ
  δ : ℝ
  hα : 0 < α
  hβ : 0 < β
  hγ : 0 < γ
  hδ : 0 < δ

variable (p : Params)

/-! ### Vector field -/

/-- Prey growth rate: dx/dt = α x − β x y -/
noncomputable def Params.dx (x y : ℝ) : ℝ := p.α * x - p.β * x * y

/-- Predator growth rate: dy/dt = δ x y − γ y -/
noncomputable def Params.dy (x y : ℝ) : ℝ := p.δ * x * y - p.γ * y

/-! ### Solutions -/

/-- A classical solution of the LV system on all of ℝ. -/
structure IsSolution (x y : ℝ → ℝ) : Prop where
  hx : ∀ t, HasDerivAt x (p.dx (x t) (y t)) t
  hy : ∀ t, HasDerivAt y (p.dy (x t) (y t)) t

/-! ### Hamiltonian / conserved quantity -/

/-- The Hamiltonian  H(x, y) = δ x − γ ln x + β y − α ln y. -/
noncomputable def Params.H (x y : ℝ) : ℝ :=
  p.δ * x - p.γ * Real.log x + p.β * y - p.α * Real.log y

end LotkaVolterra
