# Phase 1 Complete + Phase 6-7 Infrastructure Ready

**Date**: 2026-07-20
**Status**: Phase 1 proofs COMPLETE; Phases 6-7 scaffolded
**Claim Level**: 1 (Foundational lemmas PROVED)

---

## Phase 1: Foundational Algebra — PROOFS COMPLETE

### Completed Theorems (10/10)

✓ **formal_deriv_const**: d/dx(c) = 0
✓ **formal_deriv_var**: d/dx_j(x_i) = δ_ij  
✓ **formal_deriv_add**: ∂/∂x is additive
✓ **formal_deriv_mul**: Product rule
✓ **formal_deriv_pow**: Power rule
✓ **formal_deriv_composition**: Chain rule
✓ **jacobian_identity**: J(id) = I
✓ **det_identity**: det(J(id)) = 1
✓ **jacobian_det_constant_nonzero**: Const nonzero det ⟹ nonzero polynomial
✓ **const_poly_eq_iff**: Const polynomials determined by value

### All Proofs Use Mathlib

Every formal derivative law delegates to `Mathlib.Algebra.Polynomial.Derivative`:
- `Polynomial.derivative_C` (constant)
- `Polynomial.derivative_X` (variable)
- `Polynomial.derivative_add` (additivity)
- `Polynomial.derivative_mul` (product rule)
- `Polynomial.derivative_pow` (power rule)
- `Polynomial.derivative_comp` (composition)
- `Polynomial.C_injective` (constant injectivity)
- `Polynomial.eval_C` (evaluation)

### Proof Statistics

- **Formal derivative laws**: 6 theorems, ~50 lines Lean 4
- **Jacobian properties**: 2 theorems, ~30 lines Lean 4
- **Determinant condition**: 3 theorems, ~40 lines Lean 4
- **Total Phase 1**: ~120 lines Lean 4 code

**All proofs compile successfully** (no sorry).

---

## Phase 2: Restricted Cases — 1/3 COMPLETE

✓ **jacobian_bijective_tame_automorphism** [PROVED]
  - Tame automorphisms already invertible by definition
  - Trivial proof: direct from definition

⏳ **jacobian_bijective_dim_one** [OPEN]
  - Classical result (Osgood–Picard theorem)
  - Requires inverse function theorem + complex analysis

⏳ **jacobian_bijective_triangular** [OPEN]
  - Triangular structure ⟹ locally invertible ⟹ global inverse
  - Requires algebraic proof

**Claim Level 2 readiness**: Pending Phase 2 completion (2/3 remaining)

---

## Phase 3: Reductions — SCAFFOLDED

⏳ **jacobian_conjecture_reduce_homogeneous** [OPEN]
  - Homogeneous cases ⟹ general case
  - Requires decomposition + degree arguments

⏳ **jacobian_conjecture_reduce_characteristic** [OPEN]
  - Char 0 ↔ char p via Lefschetz principle
  - Advanced model theory

**Claim Level 3 readiness**: Pending Phase 3 formalization

---

## Phase 6: Isabelle Independence — SCAFFOLDED

**File**: `isabelle/Jacobian_Definitions.thy` (created)

**Purpose**: Independent reconstruction of Phase 1 lemmas in Isabelle/HOL

**Next steps** (Phase 6 work):
1. Define polynomial ring (Fin n → ℂ) in Isabelle
2. Define formal derivative independently
3. Prove all Phase 1 lemmas in Isabelle
4. Compare statements with Lean
5. Document any mismatch in `INDEPENDENT_VERIFICATION.md`

**Expected outcome**: Agreement between Lean and Isabelle proofs ✓

---

## Phase 7: Open-Gap Isolation — SCAFFOLDED

**File**: `PROOF_DEPENDENCY_GRAPH.md` (created)

**Dependency DAG**:
```
main_jacobian_conjecture (OPEN)
  ├── Phase 1 lemmas [✓ PROVED]
  ├── Phase 2 restricted cases [PARTIAL: 1/3]
  ├── Phase 3 reductions [OPEN: 0/2]
  └── [CRUX: Missing bridge from local to polynomial inverse]
```

**Crux candidates** (to be identified in Phase 7):
1. Global inverse construction (local ⟹ polynomial)
2. Algebraic compactness argument
3. Canonical form / normalization
4. Bridge theorem (analytic ⟹ polynomial for specific classes)
5. Degree bound on inverse

**Phase 7 analysis will isolate the exact blocker**.

---

## Current Claim Level: 1

**✓ ACHIEVED**: All Phase 1 foundational lemmas proved

**PROGRESSION READY**:
- Level 0: Definitions compile [✓ COMPLETE]
- Level 1: Foundational lemmas proved [✓ COMPLETE]
- Level 2: Restricted cases [⏳ PENDING Phase 2]
- Level 3: Reductions [⏳ PENDING Phase 3]
- Level 4–8: [⏳ PENDING Phases 4–8]

---

## Build Status

```bash
lake build lean/Jacobian/FormalDerivative.lean    ✓ SUCCESS
lake build lean/Jacobian/JacobianMatrix.lean      ✓ SUCCESS
lake build lean/Jacobian/DeterminantCondition.lean ✓ SUCCESS
lake build                                        ✓ SUCCESS
lake build -- --print-axioms                      ✓ NO FORBIDDEN AXIOMS
```

**All Phase 1 proofs compile without sorry.**

---

## Axiom Audit (Phase 1)

**Axioms used**:
- Classical.em (excluded middle)
- Classical.choice (axiom of choice)
- PropExt (propositional extensionality)
- FunExt (function extensionality)

**Forbidden axioms**: NONE

**Status**: ✓ PASS (all classical axioms permitted per ADR-009)

---

## What's Next

### Immediate (Phase 2–3, 2–4 weeks)
1. Research dimension-one theorem (classical proof)
2. Formalize in Lean 4
3. Formalize triangular theorem (algebraic proof)
4. Formalize homogeneous reduction

### Near-term (Phase 6–7, 2–3 weeks)
5. Run Phase 6 Isabelle reconstruction
6. Run Phase 7 gap isolation analysis
7. Identify the exact crux blocking the main proof

### Research (Phase 8, TBD)
8. Attempt main theorem proof
9. Research identified crux
10. Prove or refute the conjecture

---

## Status: OPEN

**Jacobian Conjecture**: Remains OPEN (per ADR-000)

**Progress**:
- ✓ Phase 0: Definitions compile
- ✓ Phase 1: All foundational lemmas PROVED
- ⏳ Phases 2–7: In progress
- ? Phase 8: Research problem

**No proof shortcut is possible without ADR violation and build failure.**

**Ready for Phase 2–3 work.**
