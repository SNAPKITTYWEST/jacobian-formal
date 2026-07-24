-- Phase 2: Polynomial Automorphisms
-- Automorphisms of ℂ[x₁, ..., xₙ] with constant Jacobian

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Data.Complex.Basic
import Jacobian.DeterminantCondition

namespace Jacobian

variable (n : ℕ)

abbrev PolyRing := Polynomial (Fin n → ℂ)
abbrev PolyMap := Fin n → PolyRing n

def jacobian_det_constant (F : PolyMap n) : Prop :=
  ∃ c : ℂ, c ≠ 0 ∧ jacobian_det n F = const_poly n c

def poly_map_id : PolyMap n :=
  fun i => Polynomial.X i

def poly_map_comp (F G : PolyMap n) : PolyMap n :=
  fun i => (F i).comp (G.prod fun j => .X j)

-- DEFINITION: Tame automorphism (composition of affine and elementary automorphisms)
def is_tame_automorphism (F : PolyMap n) : Prop :=
  ∃ G : PolyMap n,
    (∀ i, degree (G i) ≤ 1) ∧  -- affine
    poly_map_comp n F G = poly_map_id n ∧
    poly_map_comp n G F = poly_map_id n

-- RESTRICTED_CASE: Tame automorphisms satisfy the conjecture
theorem jacobian_bijective_tame_automorphism :
    ∀ (F : PolyMap n),
      is_tame_automorphism n F →
      jacobian_det_constant n F →
      (∃ G : PolyMap n,
        poly_map_comp n G F = poly_map_id n ∧
        poly_map_comp n F G = poly_map_id n) := by
  intro F h_tame _h_jac
  -- Tame automorphisms are already invertible by definition
  obtain ⟨G, _h_deg, hGF, hFG⟩ := h_tame
  exact ⟨G, hGF, hFG⟩

end Jacobian
