/-
  Lotka–Volterra — interior fixed point.

  The unique interior equilibrium is (x*, y*) = (γ/δ, α/β).
-/
import RequestProject.LotkaVolterra.Defs

namespace LotkaVolterra

variable (p : Params)

/-
At the interior fixed point (γ/δ, α/β) the prey equation vanishes.
-/
theorem fixed_point_dx : p.dx (p.γ / p.δ) (p.α / p.β) = 0 := by
  unfold LotkaVolterra.Params.dx; ring;
  norm_num [ p.hβ.ne' ]

/-
At the interior fixed point (γ/δ, α/β) the predator equation vanishes.
-/
theorem fixed_point_dy : p.dy (p.γ / p.δ) (p.α / p.β) = 0 := by
  unfold LotkaVolterra.Params.dy;
  rw [ mul_div_cancel₀ _ ( ne_of_gt p.hδ ), sub_self ]

/-
The interior fixed point is the *unique* positive equilibrium.
-/
theorem fixed_point_unique {x y : ℝ} (hx : 0 < x) (hy : 0 < y)
    (hdx : p.dx x y = 0) (hdy : p.dy x y = 0) :
    x = p.γ / p.δ ∧ y = p.α / p.β := by
      unfold LotkaVolterra.Params.dx LotkaVolterra.Params.dy at *; rw [ eq_div_iff ( by linarith [ p.hδ ] ), eq_div_iff ( by linarith [ p.hβ ] ) ] ; constructor <;> nlinarith;

end LotkaVolterra