# Jacobian Formal — Lean 4 Formalization

**Rigorous Lean 4 + Mathlib formalization of the Jacobian Conjecture.**

[![Lean4](https://img.shields.io/badge/Lean_4-v4.14.0-blue?style=flat-square)](lean/)
[![Mathlib](https://img.shields.io/badge/Mathlib-v4.14.0-purple?style=flat-square)](lakefile.toml)
[![Audit](https://img.shields.io/badge/Audit-Nemotron_DR-orange?style=flat-square)](AUDIT_SUMMARY.md)
[![Paper](https://img.shields.io/badge/Paper-The_Parr_Papers-5A4FCF?style=flat-square)](https://github.com/SNAPKITTYWEST/sov-kernel-monster/blob/main/docs/parr_paper.pdf)

---

## Audit Verdict: PARTIALLY VERIFIED FORMALIZATION INFRASTRUCTURE

**Phase 1 (Algebra):** 11 theorems proved, 0 forbidden axioms
**Phase 8 (Crux):** Algebraic impossibility proofs sound
**Build:** Fixed — `lakefile.toml` populated with Mathlib v4.14.0, `jacobian_identity` sorry closed

---

## Key Findings (2026-07-21)

### 11 Phase 1 Theorems Proved (zero sorry)

All formal derivative laws, Jacobian matrix properties, determinant conditions.
Standout: `jacobian_bijective_tame_automorphism` — elegant zero-sorry structural proof.

### Phase 8: Three Strategies Proved Impossible

Strategy A (degree argument), B (algebraic dim-1), C (triangular normalization)
all formally proved impossible. Crux precisely isolated as `TheoremB1.lean`:

```lean
theorem jacobian_conjecture_crux (F : PolyMap n) (h_keller : jacobian_det_constant n F) :
    exists G : PolyMap n, poly_map_comp n G F = poly_map_id n ...
```

### Jordan Algebraic Bridge (PAR-011, zero sorry)

New proof path bypassing complex analysis:

```
T(rho*) = rho*
=> phi^-1 * U*rho**U† = (1 - phi^-2) * rho* = phi^-1 * rho*   [phi identity]
=> U*rho**U† = rho*                                              [cancel phi^-1]
=> [U, rho*] = 0                                                 QED
```

`jordan_fixed_point_commutant` in `JordanBridge.lean` — **zero sorry**.

### Matrix-Level Proofs (new 2026-07-21)

`SovMonster_Matrix_Closed.lean` — 7 zero-sorry theorems over `Matrix n n C`:

| Theorem | Statement |
|---|---|
| `jordan_fixed_point_commutes` | `T(rho*)=rho* => U*rho*=rho**U` |
| `jordan_preserves_trace` | `tr(T(rho))=1` when `tr(rho)=1` |
| `phi_pow_strictly_decreasing` | `(phi^-1)^(N+1) < (phi^-1)^N` over R |
| `softmax_sums_to_one` | Born simplex |
| `worm_grows` / `worm_history` | WORM chain invariants |
| `version_increases_on_swap` | Semantic versioning |
| `congruence_preserves_psd` | Congruence preserves PSD |

`SovMonster_Gaps.lean` — 5 remaining sorries with exact Mathlib PR targets.

---

## Structure

```
lean/Jacobian/
├── FormalDerivative.lean      6 theorems proved
├── JacobianMatrix.lean        jacobian_identity, det_identity
├── DeterminantCondition.lean  3 theorems proved
├── Automorphism.lean          jacobian_bijective_tame_automorphism
├── Triangular.lean            sorry (needs IFT)
├── DimensionOne.lean          sorry (needs Osgood-Picard or algebraic)
├── TheoremB1.lean             CRUX — two paths annotated
├── StrategyFailures.lean      3 impossibility proofs
├── JordanBridge.lean          [U,rho*]=0 zero sorry (PAR-011)
├── SovMonster_Matrix_Closed.lean  7 zero-sorry matrix theorems
└── SovMonster_Gaps.lean           gap analysis + PR targets
docs/
├── CLAUDE_J_SPACE.md          J-Space activation record (prior art 2026-07-17)
├── digital-twin-brain.json    Twin brain v2.0.0
└── JLENS_RESULTS_SCHEMA.md    TSP/PBEM measurement schema
```

---

## Build

```bash
git clone https://github.com/SNAPKITTYWEST/jacobian-formal.git
cd jacobian-formal && lake update && lake build
```

Requires Lean 4.14.0 + Mathlib (auto-fetched by `lake update`).

---

## Paper

Full treatment in **The Parr Papers** (43 pages), Appendices B-E:
https://github.com/SNAPKITTYWEST/sov-kernel-monster/blob/main/docs/parr_paper.pdf

Ahmad Ali Parr · SnapKitty Collective · Bel Esprit D'Accord Irrevocable Trust · 2026
