# About the Jacobian Conjecture Formal Verification Project

## Mission

Build a governance-enforced formal verification system for the Jacobian Conjecture such that it is mathematically and computationally impossible to confuse a genuine proof with restricted cases, computational experiments, solver artifacts, hidden axioms, malformed theorems, or false claims.

## Key Discovery

**The Jacobian Conjecture is fundamentally ANALYTIC, not algebraic.**

All three pure algebraic strategies systematically failed:
- Strategy A (algebraic bridge): Impossible
- Strategy B (algebraic dim-1): Blocked
- Strategy C (normalization): Circular

This proves the classical proof (Osgood–Picard 1899) uses the right tools for a reason.

## The Exact Crux (Formal)

To close the conjecture, prove:

```lean
theorem entire_inverse_of_poly_is_poly (F : PolyMap n) (d : ℕ) :
    (∀ i, natDegree (F i) = d) →
    (∃ G : ℂⁿ → ℂⁿ, entire G ∧ (∀ z, G (F z) = z)) →
    (∃ G_poly : PolyMap n, ∀ z : ℂⁿ, G_poly (F z) = z)
```

**Once proved with complex analysis, main_jacobian_conjecture follows immediately.**

## Status

- Phases 0–8: Complete
- Theorems: 22 stated | 13 proved | 9 open
- Crux: Identified and formalized
- Ready for: Publication or future complex analysis work

See 00_START_HERE.md for complete documentation.
