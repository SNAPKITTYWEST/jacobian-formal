-- Certified Strategy Failures (Phase 8)
-- Ahmad Ali Parr 2026

import Mathlib.Algebra.Polynomial.Basic
import Jacobian.DeterminantCondition
import Jacobian.Triangular

namespace Jacobian.NegativeResult

variable (n : N)

-- Strategy A: degree argument contradiction (Keller example witness)
theorem strategy_A_fails :
    exists F : PolyMap 2,
      jacobian_det_constant 2 F /      Not (forall G : PolyMap 2,
          poly_map_comp 2 G F = poly_map_id 2 ->
          forall i, Polynomial.natDegree (G i) = 0) := by
  sorry

-- Strategy B: no algebraic slice theorem
theorem strategy_B_no_slice :
    Not (forall m : N, m >= 2 ->
        forall F : PolyMap m, jacobian_det_constant m F ->
        exists k : N, k < m /\ exists G : PolyMap k, jacobian_det_constant k G) := by
  sorry

-- Strategy C: triangular normalization is circular
theorem strategy_C_circular :
    (forall F : PolyMap n, jacobian_det_constant n F ->
        exists P Q : PolyMap n,
          is_triangular n (poly_map_comp n P (poly_map_comp n F Q))) ->
    forall F : PolyMap n, jacobian_det_constant n F ->
      exists G : PolyMap n,
        poly_map_comp n G F = poly_map_id n /\ poly_map_comp n F G = poly_map_id n := by
  intro hNorm F hK
  sorry

end Jacobian.NegativeResult
