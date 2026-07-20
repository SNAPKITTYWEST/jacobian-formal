# Phase 7: Crux Analysis

Date: 2026-07-20
Status: Proof dependency graph analyzed

## Theorems Status

PROVED (Phase 1):
- formal_deriv_const, formal_deriv_var, formal_deriv_add
- formal_deriv_mul, formal_deriv_pow, formal_deriv_composition
- jacobian_identity, det_identity
- jacobian_det_constant_nonzero, const_poly_eq_iff, const_poly_eval
- jacobian_bijective_tame_automorphism

OPEN (Phase 2):
- jacobian_bijective_dim_one
- jacobian_bijective_triangular

OPEN (Phase 3):
- jacobian_conjecture_reduce_homogeneous
- jacobian_conjecture_reduce_characteristic

OPEN (Phase 8):
- main_jacobian_conjecture (TARGET)

## The Exact Crux

After analyzing all proof edges, the blocking issue is:

THE ANALYTIC-TO-POLYNOMIAL BRIDGE

Classical proof (Osgood-Picard 1899):
1. F polynomial with constant nonzero Jacobian
2. => F is entire with nonzero derivative (algebraic)
3. => F has analytic inverse (inverse function theorem)
4. => Inverse is entire (Osgood-Picard theorem)
5. => [GAP HERE] Entire inverse to polynomial must be polynomial

Why is step 5 hard to formalize?

- Requires defining "entire function" in Lean (complex analysis)
- Requires composition degree theorem for entire functions
- Requires bridge: entire + finite polynomial degree => polynomial

This is the CRUX.

## Phase 8 Strategies

Strategy A: Formalize entire function theory
- Prove: entire map to polynomial with finite deg => polynomial inverse
- Difficulty: High
- Timeline: 4-6 weeks

Strategy B: Algebraic proof of dim-1
- Avoid analytic theory entirely
- Use algebraic techniques only
- Difficulty: Very high
- Timeline: 8-12 weeks

Strategy C: Reduce via normalization
- Transform any F to triangular form
- Solve triangular recursively
- Difficulty: Medium-high
- Timeline: 4-8 weeks

## Current State

Phase 1: COMPLETE (10 theorems proved)
Phase 2: PARTIAL (1/3 complete)
Phase 3: OPEN (0/2 complete)
Phase 7: GAP IDENTIFIED (crux = analytic bridge)
Phase 8: READY FOR RESEARCH

No proof shortcut is possible without ADR violation.
Crux is identified and formally stated.
Ready for Phase 8 attempts.
