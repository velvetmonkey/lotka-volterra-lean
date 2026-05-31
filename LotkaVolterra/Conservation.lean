/-
  Lotka–Volterra — conservation of the Hamiltonian along trajectories.

  For any solution (x, y) with x(t) > 0, y(t) > 0 for all t,
  d/dt H(x(t), y(t)) = 0.
-/
import RequestProject.LotkaVolterra.Defs

namespace LotkaVolterra

variable (p : Params)

/-
The Hamiltonian is conserved: its time-derivative along any positive
    solution of the Lotka–Volterra system is identically zero.
-/
theorem conservation_law {x y : ℝ → ℝ} (sol : IsSolution p x y)
    (hx_pos : ∀ t, 0 < x t) (hy_pos : ∀ t, 0 < y t) :
    ∀ t, HasDerivAt (fun t => p.H (x t) (y t)) 0 t := by
      intro t
      unfold Params.H;
      convert HasDerivAt.sub ( HasDerivAt.add ( HasDerivAt.sub ( HasDerivAt.const_mul p.δ ( sol.hx t ) ) ( HasDerivAt.const_mul p.γ ( HasDerivAt.log ( sol.hx t ) ( ne_of_gt ( hx_pos t ) ) ) ) ) ( HasDerivAt.const_mul p.β ( sol.hy t ) ) ) ( HasDerivAt.const_mul p.α ( HasDerivAt.log ( sol.hy t ) ( ne_of_gt ( hy_pos t ) ) ) ) using 1 ; ring;
      unfold Params.dx Params.dy; ring;
      grind

end LotkaVolterra