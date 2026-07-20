# Phase 1: Foundational Algebra — Structure

**Status**: IN PROGRESS

## Lean 4 Files Created (Phase 1)

### FormalDerivative.lean
- `formal_deriv_const`: Derivative of constant is zero
- `formal_deriv_var`: Derivative of variable xⱼ is δᵢⱼ
- `formal_deriv_add`: Additivity
- `formal_deriv_mul`: Product rule
- `formal_deriv_pow`: Power rule
- `formal_deriv_composition`: Composition rule (partial)

### JacobianMatrix.lean
- `jacobian_identity`: Jacobian of identity = I
- `jacobian_composition_partial`: Composition (partial statement)

### DeterminantCondition.lean
- `jacobian_det_constant_nonzero`: If det(JF) constant and nonzero, then nonzero
- `const_poly_eq_iff`: Constant polynomials are determined by value

### DimensionOne.lean
- `jacobian_bijective_dim_one`: RESTRICTED_CASE for dim 1 (structure only)

### MainConjecture.lean
- `main_jacobian_conjecture`: FULL_CONJECTURE (target theorem, status OPEN)

## Phase 1 Status

- [x] Formal derivative laws formalized
- [x] Jacobian properties structure in place
- [x] Determinant condition formally stated
- [x] Target theorem marked OPEN
- [ ] All proofs completed (still working)

## Next: Proof Implementation

Each theorem requires a proof. Use Mathlib theorems for polynomial derivatives.

Example pattern:
```lean
theorem formal_deriv_add (j : Fin n) (p q : PolyRing n) :
    formal_deriv n j (p + q) = formal_deriv n j p + formal_deriv n j q := by
  simp [formal_deriv, Polynomial.derivative_add]
```

## Phase 1 Completion Criteria

[✓] All Phase 1 theorems have formal statements
[✓] All theorems are labeled (AUXILIARY, DEFINITION, etc.)
[ ] All proofs compile without sorry
[ ] Axiom audit shows only Classical axioms
[ ] Isabelle reconstruction ready (Phase 6)

## Build Command

```bash
cd /tmp/jacobian-formal
lake build lean/Jacobian/FormalDerivative.lean
lake build lean/Jacobian/JacobianMatrix.lean
lake build lean/Jacobian/DeterminantCondition.lean
lake build lean/Jacobian/DimensionOne.lean
lake build lean/Jacobian/MainConjecture.lean
```

Expected: Files compile (some sorry allowed in Phase 1 as structural placeholders).

## Claim Level After Phase 1

If all Phase 1 theorems are proved (no sorry):
- **New Level**: 1 (Foundational algebraic lemmas verified)
- **Theorem Count**: 10+ AUXILIARY lemmas proved
- **Dependencies**: Ready for Phase 2 (restricted cases)
