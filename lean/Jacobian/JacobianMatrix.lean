-- Phase 1: Jacobian Matrix Properties (PROOFS)

import Mathlib.Algebra.Polynomial.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Data.Complex.Basic
import Jacobian.FormalDerivative

namespace Jacobian

variable (n : N)

abbrev PolyRing := Polynomial (Fin n -> C)
abbrev PolyMap := Fin n -> PolyRing n

def formal_deriv (j : Fin n) (p : PolyRing n) : PolyRing n :=
  Polynomial.derivative (Finsupp.single j 1) p

def jacobian (F : PolyMap n) : Matrix (Fin n) (Fin n) (PolyRing n) :=
  fun i j => formal_deriv n j (F i)

def jacobian_det (F : PolyMap n) : PolyRing n :=
  Matrix.det (jacobian n F)

def poly_map_id : PolyMap n :=
  fun i => Polynomial.X i

-- AUXILIARY: Jacobian of identity map is identity matrix
theorem jacobian_identity :
    jacobian n poly_map_id = 1 := by
  ext i j
  unfold jacobian poly_map_id formal_deriv
  simp only [Matrix.one_apply]
  by_cases h : i = j
  . simp [h, Polynomial.derivative_X, Finsupp.single_eq_same]
  . simp [h, Polynomial.derivative_X,
          Finsupp.single_eq_of_ne (Ne.symm h),
          Finsupp.single_ne_zero_iff,
          show i != j from h]

-- AUXILIARY: Determinant of identity is 1
theorem det_identity :
    jacobian_det n poly_map_id = 1 := by
  unfold jacobian_det
  rw [jacobian_identity]
  simp [Matrix.det_one]

end Jacobian
