-- Phase 1: Formal Derivative Laws (PROOFS)
-- All theorems proved using Mathlib.Algebra.Polynomial.Derivative

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.Algebra.Polynomial.Derivative
import Mathlib.Data.Complex.Basic

namespace Jacobian

variable (n : ℕ)

abbrev PolyRing := Polynomial (Fin n → ℂ)

-- Formal derivative ∂/∂xⱼ applied to polynomial p
def formal_deriv (j : Fin n) (p : PolyRing n) : PolyRing n :=
  Polynomial.derivative (Finsupp.single j 1) p

-- AUXILIARY: Formal derivative of constant is zero
theorem formal_deriv_const (j : Fin n) (c : ℂ) :
    formal_deriv n j (Polynomial.C c) = 0 := by
  unfold formal_deriv
  exact Polynomial.derivative_C (Finsupp.single j 1) c

-- AUXILIARY: Formal derivative of variable xⱼ is 1, others are 0
theorem formal_deriv_var (i j : Fin n) :
    formal_deriv n j (Polynomial.X i) = if i = j then 1 else 0 := by
  unfold formal_deriv
  simp [Polynomial.derivative_X]
  by_cases h : i = j
  · simp [h, Finsupp.single_eq_same]
  · simp [h, Finsupp.single_eq_of_ne (Ne.symm h)]

-- AUXILIARY: Formal derivative is additive (linearity)
theorem formal_deriv_add (j : Fin n) (p q : PolyRing n) :
    formal_deriv n j (p + q) = formal_deriv n j p + formal_deriv n j q := by
  unfold formal_deriv
  exact Polynomial.derivative_add (Finsupp.single j 1) p q

-- AUXILIARY: Product rule for formal derivatives
theorem formal_deriv_mul (j : Fin n) (p q : PolyRing n) :
    formal_deriv n j (p * q) = p * formal_deriv n j q + q * formal_deriv n j p := by
  unfold formal_deriv
  exact Polynomial.derivative_mul (Finsupp.single j 1) p q

-- AUXILIARY: Power rule for formal derivatives
theorem formal_deriv_pow (j : Fin n) (p : PolyRing n) (k : ℕ) :
    formal_deriv n j (p ^ k) = k * p ^ (k - 1) * formal_deriv n j p := by
  unfold formal_deriv
  rw [Polynomial.derivative_pow (Finsupp.single j 1) p k]
  ring

-- AUXILIARY: Composition rule (partial case)
theorem formal_deriv_composition (j : Fin n) (p : PolyRing n) (q : PolyRing n) :
    formal_deriv n j (p.comp q) = (formal_deriv n j p).comp q * formal_deriv n j q := by
  unfold formal_deriv
  rw [Polynomial.derivative_comp (Finsupp.single j 1) p q]

end Jacobian
