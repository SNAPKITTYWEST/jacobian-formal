-- Phase 1: Determinant Condition (PROOFS)

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Data.Complex.Basic
import Jacobian.JacobianMatrix

namespace Jacobian

variable (n : ℕ)

abbrev PolyRing := Polynomial (Fin n → ℂ)
abbrev PolyMap := Fin n → PolyRing n

def jacobian_det (F : PolyMap n) : PolyRing n :=
  Matrix.det (jacobian n F)

def const_poly (c : ℂ) : PolyRing n :=
  Polynomial.C c

def jacobian_det_constant (F : PolyMap n) : Prop :=
  ∃ c : ℂ, c ≠ 0 ∧ jacobian_det n F = const_poly n c

-- AUXILIARY: If det(JF) is constant and nonzero, it's nonzero as a polynomial
theorem jacobian_det_constant_nonzero (F : PolyMap n) 
    (h : jacobian_det_constant n F) :
    jacobian_det n F ≠ 0 := by
  obtain ⟨c, hc_ne, hc_eq⟩ := h
  rw [hc_eq]
  unfold const_poly
  intro h_zero
  have : c = 0 := by
    have := Polynomial.C_eq_zero.mp h_zero
    exact this
  exact hc_ne this

-- AUXILIARY: Constant polynomial is determined by its value
theorem const_poly_eq_iff (c₁ c₂ : ℂ) :
    (const_poly n c₁ : PolyRing n) = const_poly n c₂ ↔ c₁ = c₂ := by
  unfold const_poly
  constructor
  · intro h
    have := Polynomial.C_injective h
    exact this
  · intro h; rw [h]

-- AUXILIARY: Evaluating constant polynomial gives the constant
theorem const_poly_eval (c : ℂ) (x : Fin n → ℂ) :
    (const_poly n c).eval x = c := by
  unfold const_poly
  simp [Polynomial.eval_C]

end Jacobian
