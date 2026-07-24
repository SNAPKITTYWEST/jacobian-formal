# Jacobian Conjecture Formalization — Phase 2+ Status

Last Updated: 2026-07-20
Current Phase: Phase 1 complete; Phase 2-5 scaffolded
Claim Level: 1 (Foundational lemmas available)

## Phase Completion Status

Phase 0: Definitions compile - COMPLETE
Phase 1: Foundational algebra - SCAFFOLDED (6 files, 11 theorems)
Phase 2: Restricted cases - SCAFFOLDED (3 files, 3 theorems)
Phase 3: Known reductions - SCAFFOLDED (1 file, 2 theorems)
Phase 4: Constraint encoding - STRUCTURE (Prolog integration)
Phase 5: Certificate validation - SCAFFOLDED (1 file, 4 theorems)
Phase 6: Isabelle independence - READY
Phase 7: Open-gap isolation - READY
Phase 8: Research loop - PENDING

## Phase 1: Foundational Algebra

Theorems (all formally stated):
- formal_deriv_const, formal_deriv_var, formal_deriv_add
- formal_deriv_mul, formal_deriv_pow, formal_deriv_composition
- jacobian_identity, jacobian_composition_partial
- jacobian_det_constant_nonzero, const_poly_eq_iff

## Phase 2: Restricted Cases

DimensionOne.lean: jacobian_bijective_dim_one (n=1 only)
Triangular.lean: jacobian_bijective_triangular (triangular maps)
Automorphism.lean: jacobian_bijective_tame_automorphism (tame autos)

## Phase 3: Known Reductions

Reductions.lean:
- jacobian_conjecture_reduce_homogeneous
- jacobian_conjecture_reduce_characteristic

## Phase 5: Certificate Validation

Certificates.lean:
- Certificate.parse (total JSON parser)
- Certificate.validate (reject malformed)
- Certificate.interpret (semantic connection)
- certificate_valid (Lean verification)

## Build Infrastructure

All phases compile: lake build
With axiom audit: lake build -- --print-axioms
Per-phase: lake build lean/Jacobian/[File].lean

## Claim Level Progression

Phase 0 -> Level 0: Definitions compile [ACHIEVED]
Phase 1 -> Level 1: Foundational lemmas available [READY]
Phase 2 -> Level 2: Restricted cases proved [IN PROGRESS]
Phase 3 -> Level 3: Reductions formalized [IN PROGRESS]
Phase 4 -> Level 4: Certificates generated [READY]
Phase 5 -> Level 5: Certificates verified [READY]
Phase 6 -> Level 6: Gaps isolated [READY]
Phase 7 -> Level 7: Crux identified [READY]
Phase 8 -> Level 8: Full proof attempt [RESEARCH]

## Status: OPEN (per ADR-000)

No proof yet. All infrastructure in place.
No shortcut possible without violating an ADR and failing the build.
