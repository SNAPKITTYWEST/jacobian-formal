# Open Gaps — Jacobian Conjecture Formalization

**Phase 0 Status**: Definitions complete, no proofs yet.

**Claim Level**: 0 (Definitions compile)

This document lists the exact theorems and lemmas that must be proved to progress through each phase.

## Phase 1 Gaps (Foundational Algebra)

### Required Algebraic Lemmas

```lean
-- Formal Derivative Laws
theorem formal_deriv_const : ∀ c, formal_deriv n j (const_poly n c) = const_poly n 0
theorem formal_deriv_var : ∀ i, formal_deriv n j (Polynomial.X i) = if i = j then 1 else 0
theorem formal_deriv_add : ∀ p q, formal_deriv n j (p + q) = formal_deriv n j p + formal_deriv n j q
theorem formal_deriv_mul : ∀ p q, formal_deriv n j (p * q) = 
  p * formal_deriv n j q + q * formal_deriv n j p  -- Product rule
theorem formal_deriv_pow : ∀ p (k : ℕ), formal_deriv n j (p ^ k) =
  k * p ^ (k - 1) * formal_deriv n j p  -- Power rule

-- Jacobian Properties
theorem jacobian_identity : jacobian n poly_map_id = 1  -- Identity matrix
theorem jacobian_composition : jacobian n (poly_map_comp n F G) =
  (jacobian n F).map (fun p => p.comp _) * jacobian n G  -- Chain rule

-- Determinant Multiplicativity
theorem det_mul : ∀ (A B : Matrix (Fin n) (Fin n) ℂ),
  Matrix.det (A * B) = Matrix.det A * Matrix.det B

-- Jacobian of Inverse (when inverse exists)
theorem jacobian_of_inverse :
  ∀ (F G : PolyMap n),
    poly_map_comp n F G = poly_map_id n →
    det (jacobian n F) * det (jacobian n G) = 1

-- Constant Jacobian Under Affine Equivalence
theorem jacobian_det_affine_invariant :
  ∀ (F : PolyMap n) (A : Matrix (Fin n) (Fin n) ℂ) (b : Fin n → ℂ),
    det A ≠ 0 →
    jacobian_det n F = jacobian_det n (fun i => F (fun j => ∑ k, A i k * _ j + b i))
```

**Status**: All OPEN (not yet proved)

**Dependency**: None of these depend on each other; they are foundational.

**Estimated effort**: 2–4 weeks (standard algebra textbook results, should be in Mathlib or port quickly)

---

## Phase 2 Gaps (Restricted Cases)

### Dimension-One Theorem

```lean
-- The Jacobian Conjecture is true in dimension one
theorem jacobian_bijective_dim_one_full :
  ∀ (F : PolyMap 1),
    jacobian_det_constant 1 F →
    poly_inverse_exists 1 F
```

**Proof Strategy**: Classical result from complex analysis.
- If F : ℂ → ℂ is a polynomial with constant nonzero Jacobian, F' ≠ 0 everywhere.
- Polynomials of degree ≥ 2 have roots for F' or argument principle applies.
- Explicit construction or invoke classical result.

**Status**: OPEN

**Dependencies**: Phase 1 lemmas (formal derivatives, Jacobian properties)

**Reference**: Classical; should appear in Lean literature

---

### Affine Maps (Restricted Case)

```lean
-- Affine maps (degree 1) with constant Jacobian are bijective
theorem jacobian_bijective_affine :
  ∀ (F : PolyMap n),
    (∀ i, degree (F i) ≤ 1) →
    jacobian_det_constant n F →
    poly_inverse_exists n F
```

**Proof Strategy**: Affine maps are linear algebra. Jacobian is constant (the linear part). If det(Jacobian) ≠ 0, linear map is bijective.

**Status**: OPEN

**Dependencies**: Phase 1 lemmas, linear algebra from Mathlib

---

## Phase 3 Gaps (Known Reductions)

### Reduction to Homogeneous Case

```lean
-- If conjecture holds for homogeneous maps of degree d,
-- then it holds for all maps
theorem jacobian_conjecture_reduce_homogeneous :
  (∀ d : ℕ, ∀ F : PolyMap n,
    (∀ i, isHomogeneous (F i) d) →
    jacobian_det_constant n F →
    poly_inverse_exists n F) →
  (∀ F : PolyMap n,
    jacobian_det_constant n F →
    poly_inverse_exists n F)
```

**Proof Strategy**: Technical; cite Rees reduction or similar.

**Status**: OPEN

**Dependencies**: Phase 3 research into reliable reductions

---

## Phase 4 Gaps (Constraint Encoding)

### Prolog Certificate Format

```lean
-- Prolog certificate schema (Phase 4 implementation)
structure PrologCertificate where
  theorem_id : String
  dimension : ℕ
  degree_bound : ℕ
  -- ... (see ADR-008)

-- Total parser (no exceptions)
def PrologCertificate.parse (json : String) : Option PrologCertificate

-- Validator (rejects malformed)
def PrologCertificate.validate (cert : PrologCertificate) : Except String Unit
```

**Status**: PENDING Phase 4

**Dependencies**: ADR-008 implementation

---

## Phase 5 Gaps (Certificate Verification)

### Certificate Verification Theorem

```lean
-- For each Prolog certificate, a Lean theorem that verifies it
theorem certificate_valid_cert_id :
  ∀ cert : PrologCertificate,
    PrologCertificate.validate cert = ok () →
    -- semantic interpretation of cert holds in Lean
    CertificateSemantics cert
```

**Status**: PENDING Phase 4+5

**Dependencies**: Prolog solver output; Phase 4 implementation

---

## Phase 6 Gaps (Isabelle Independence)

### Isabelle Reconstruction

```
-- Isabelle file: isabelle/Jacobian_Verification.thy

-- Definitions (independent)
definition jacobian_formal :: ...
definition jacobian_det :: ...

-- Lemmas (independent reconstruction)
lemma formal_deriv_chain_rule :: ...
lemma jacobian_composition :: ...
lemma det_mul :: ...

-- Agreement with Lean:
-- All statements must agree (up to syntax) with Lean versions
```

**Status**: PENDING Phase 6

**Dependencies**: Completion of Phase 1–2 theorems

---

## Phase 7 Gaps (Open-Gap Isolation)

### Dependency Graph

```
main_jacobian_conjecture
  ├── poly_inverse_exists (OPEN: must be proved from Jacobian hypothesis)
  │   └── [needs specific lemma or reduction]
  │
  ├── jacobian_det_constant (DEFINITION: fixed in hypothesis)
  │   └── [formalized in Phase 0]
  │
  └── [other dependencies discovered during proof]
```

**Status**: PENDING Phase 7

**Dependencies**: Attempted proofs in Phase 1–5; identifies which edge is the crux

---

## Summary of Open Problems (By Phase)

| Phase | Theorem | Difficulty | Dependency |
|:------|:--------|:-----------|:-----------|
| 1 | Formal derivative laws | Easy | Mathlib |
| 1 | Jacobian of composition (chain rule) | Medium | Formal derivatives |
| 1 | Jacobian of inverse | Medium | Jacobian composition |
| 2 | Dimension one | Hard | Phase 1 + classical result |
| 2 | Affine maps | Easy | Linear algebra |
| 3 | Homogeneous reduction | Medium | Research literature |
| 4 | Prolog constraint solver | Hard (engineering) | ADR-008 spec |
| 5 | Certificate validation loop | Medium | Phase 4 output |
| 6 | Isabelle independent reconstruction | Medium | Isabelle/HOL expertise |
| 7 | Open crux identification | Hard (research) | Phase 1–5 complete |
| 8 | Full theorem proof | **Research problem** | Crux identified in Phase 7 |

## How to Proceed

1. **Phase 1**: Prove formal derivative laws using Mathlib
2. **Phase 2**: Tackle dimension-one via classical references or Mathlib port
3. **Phase 3**: Formalize one known reduction from literature
4. **Phases 4–6**: Engineering (constraint encoding, Isabelle reconstruction)
5. **Phase 7**: Identify the actual research crux
6. **Phase 8**: Attack the crux

If Phase 7 reveals that all algebraic dependencies are closed but the full theorem remains unproved, the remaining gap is the **core mathematical difficulty** of the Jacobian Conjecture.

---

**No proof path is hidden.** Every open gap is named and localized.
