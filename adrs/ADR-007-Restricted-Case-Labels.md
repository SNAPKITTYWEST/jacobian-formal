# ADR-007: Restricted-Case Labels

**Status:** ACCEPTED

## Decision

Every theorem must carry an explicit label denoting its scope and claim level.

Labels are not optional comments. They are enforced in the Lean type or documentation block.

## Label Categories

Every theorem is exactly one of:

1. **DEFINITION**: Introduces a formal object (e.g., Jacobian matrix, polynomial map)
   - No proof content
   - Type signature only

2. **AUXILIARY**: Helper lemma, assumes the conjecture false, or proves a local intermediate
   - Used to structure proofs
   - Not load-bearing for the main claim

3. **RESTRICTED_CASE**: Proves the theorem only for a proper subclass (e.g., dim 1, triangular)
   - Name must include the restriction (e.g., `jacobian_bijective_dim_one`)
   - Type must include the restriction as an assumption or bounded variable

4. **REDUCTION**: Proves that conjecture for class A follows from conjecture for class B
   - Direction explicit (A → B, B → A, or equivalence)
   - Source attribution required

5. **EQUIVALENCE**: Proves statement α is equivalent to statement β
   - Both directions checked
   - Neither assumed

6. **COMPUTATIONAL_EVIDENCE**: Numerical verification for specific examples
   - Never generalized to arbitrary dimension
   - Marked as evidence, not proof

7. **CERTIFICATE_VERIFIED**: Lean verifies a Prolog-generated certificate
   - Theorem says: "This certificate is valid"
   - Not "This proves the conjecture"

8. **FULL_CONJECTURE**: The unrestricted theorem for arbitrary n
   - No bounds on dimension or degree
   - Arbitrary polynomial endomorphism
   - Assumes only the determinant hypothesis
   - Conclusion: polynomial bijective with inverse

## Label Syntax

Lean implementation (Phase 1+):

```lean
def DEFINITION {α : Type*} : Prop := True

variable {n : ℕ} (F : Fin n → Polynomial (Fin n → ℂ))

theorem jacobian_matrix_def : DEFINITION := trivial

theorem jacobian_bijective_dim_one (h : n = 1) : RESTRICTED_CASE := by
  -- proof restricted to dimension 1
  sorry

theorem reduction_triangular_to_general : REDUCTION := by
  -- if triangular ⟹ conjecture, then general?
  sorry

theorem certificate_identity_valid (cert : Certificate) : CERTIFICATE_VERIFIED := by
  -- Lean validates the certificate
  sorry

theorem jacobian_conjecture_full (h_jac : det (jacobian F) = C c) : FULL_CONJECTURE := by
  sorry -- THIS theorem is the target; all others support it
```

## Enforcement

Build rule: `grep -E "FULL_CONJECTURE.*sorry" lean/**/*.lean` must be empty before release.

Claim auditor: Before public announcement, verify that the highest label reached is the lowest incomplete label.

## Consequence

A reader cannot confuse a restricted case with the full theorem by accident.

Every theorem's claim level is explicit in the source.

Phase 2+ will measure progress by counting FULL_CONJECTURE gaps, not by line count.
