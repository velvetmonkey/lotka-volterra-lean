/-
  Lotka–Volterra — the Hamiltonian is bounded below on the positive quadrant.

  Key fact: for a, b > 0 and x > 0, a x − b ln(x) ≥ b (1 − ln(b/a)).
  This uses  ln t ≤ t − 1  (i.e., `Real.log_le_sub_one_of_pos`).
-/
import RequestProject.LotkaVolterra.Defs

namespace LotkaVolterra

open Real in
/-- A single branch bound: for a, b, x > 0 we have  a x − b ln x ≥ b (1 + ln(a / b)). -/
lemma linear_minus_log_bound {a b x : ℝ} (ha : 0 < a) (hb : 0 < b) (hx : 0 < x) :
    b * (1 + Real.log (a / b)) ≤ a * x - b * Real.log x := by
      have := Real.log_le_sub_one_of_pos ( div_pos ( mul_pos ha hx ) hb );
      rw [ Real.log_div ( by positivity ) ( by positivity ), Real.log_mul ( by positivity ) ( by positivity ) ] at this;
      rw [ Real.log_div ] <;> nlinarith [ mul_div_cancel₀ ( a * x ) hb.ne' ]

variable (p : Params)

/-
The Hamiltonian H is bounded below on the open positive quadrant.
    Specifically, H(x, y) ≥ γ (1 + ln(δ/γ)) + α (1 + ln(β/α)).
-/
theorem H_bounded_below (x y : ℝ) (hx : 0 < x) (hy : 0 < y) :
    p.γ * (1 + Real.log (p.δ / p.γ)) + p.α * (1 + Real.log (p.β / p.α)) ≤ p.H x y := by
      unfold LotkaVolterra.Params.H;
      convert add_le_add ( linear_minus_log_bound p.hδ p.hγ hx ) ( linear_minus_log_bound p.hβ p.hα hy ) using 1 ; ring

/-
Existential form: H is bounded below.
-/
theorem H_bdd_below :
    ∃ C, ∀ x y, 0 < x → 0 < y → C ≤ p.H x y := by
      exact ⟨ _, fun x y hx hy => H_bounded_below p x y hx hy ⟩

/-! ### Positive invariance -/

/-
If x(t₀) = 0 then x'(t₀) = 0 : the x-axis is invariant.
-/
theorem dx_zero_on_axis (y : ℝ) : p.dx 0 y = 0 := by
  unfold LotkaVolterra.Params.dx; ring;

/-
If y(t₀) = 0 then y'(t₀) = 0 : the y-axis is invariant.
-/
theorem dy_zero_on_axis (x : ℝ) : p.dy x 0 = 0 := by
  unfold LotkaVolterra.Params.dy; ring;

/-
Along solutions, x(t) > 0 and y(t) > 0 for all t implies d/dt[ln x] is bounded,
    preventing blow-down to zero in finite time.  Here we show the derivative of ln(x(t))
    is independent of x, which establishes the key structural fact.
-/
theorem log_prey_deriv {x y : ℝ → ℝ} (sol : IsSolution p x y)
    (hx_pos : ∀ t, 0 < x t) :
    ∀ t, HasDerivAt (fun t => Real.log (x t)) (p.α - p.β * y t) t := by
      intro t;
      convert HasDerivAt.log ( sol.hx t ) ( ne_of_gt ( hx_pos t ) ) using 1 ; ring;
      exact eq_div_of_mul_eq ( ne_of_gt ( hx_pos t ) ) ( by unfold LotkaVolterra.Params.dx; ring )

/-
The derivative of ln(y(t)) depends only on x(t), not on y(t).
-/
theorem log_pred_deriv {x y : ℝ → ℝ} (sol : IsSolution p x y)
    (hy_pos : ∀ t, 0 < y t) :
    ∀ t, HasDerivAt (fun t => Real.log (y t)) (p.δ * x t - p.γ) t := by
      intro t; convert ( sol.hy t |> HasDerivAt.log <| ne_of_gt ( hy_pos t ) ) using 1; ring;
      rw [ ← div_eq_mul_inv, eq_div_iff ] <;> nlinarith [ hy_pos t, p.hγ, p.hδ, show p.dy ( x t ) ( y t ) = p.δ * x t * y t - p.γ * y t from rfl ]

end LotkaVolterra