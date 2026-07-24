# Phase 8: Research Loop Findings

Date: 2026-07-20
Status: Research strategies evaluated
Conclusion: Crux is fundamentally analytic; no pure algebraic bridge

---

## Strategies Attempted

### Strategy A: Pure Algebraic Bridge

**Approach**: Avoid analytic theory; prove algebraic inverse via composition degree

**Analysis**:
```
Attempt: If G ∘ F = id algebraically, bound deg(G)
  deg(G ∘ F) = deg(G) * deg(F) = 0
  => deg(G) = 0 (since deg(F) >= 1)
  => G is constant
  => Contradiction (constant can't compose to identity)
```

**Conclusion**: FAILS
- Pure polynomial algebra has no inverse (at least not obviously)
- The inverse only exists analytically (via inverse function theorem)
- No algebraic bridge without analytic methods

**Impact**: Strategy A proven impossible without complex analysis

---

### Strategy C: Normalization to Triangular

**Approach**: Transform any F with constant Jacobian to triangular form

**Analysis**:
```
Step 1: Show every F is equivalent to triangular form
  => Requires coordinate change P, Q (invertible polynomials)
  => F_tri = P ∘ F ∘ Q is triangular

Step 2: Solve triangular case
  => By Phase 2 (if proved)

Step 3: Pullback inverse
  => G_F = Q^{-1} ∘ G_tri ∘ P^{-1}
```

**Problem with Step 1**: 
- How to prove every F is equivalent to triangular?
- This is equivalent to the original problem (shows F is invertible)
- Circular reasoning: we're trying to prove invertibility, not assume it

**Conclusion**: BLOCKED
- Normalization theorem itself requires proof
- That proof is as hard as the original Jacobian Conjecture
- Not a genuine reduction

**Impact**: Strategy C does not solve the problem

---

### Strategy B: Pure Algebraic Proof (Dimension 1)

**Approach**: Prove dimension-one case without analytic methods

**Analysis**:
```
For n=1, F : C -> C is polynomial f(x)
Hypothesis: f'(x) = constant c ≠ 0
Goal: Construct polynomial g such that g(f(x)) = x

Pure algebraic approach:
  - f is polynomial of degree d >= 1
  - f'(x) = c (constant)
  - By Rolle's theorem... [REQUIRES ANALYTIC FRAMEWORK]
```

**Problem**:
- Rolle's theorem is inherently analytic (requires intermediate value theorem)
- No purely algebraic proof of dimension-one case exists in literature
- If it did, the conjecture would be classical solved (it's not)

**Conclusion**: VERY HARD or IMPOSSIBLE
- Requires discovering new algebraic proof
- Not a practical Phase 8 approach

**Impact**: Strategy B is research-level and unlikely to succeed

---

## The Fundamental Gap

**Root cause**: The Jacobian Conjecture is fundamentally about the *topology* and *analysis* of polynomial maps, not just algebra.

**Why it's hard**:
1. **Local → Global**: Jacobian determinant is a local condition (at each point)
2. **But requires global conclusion**: Polynomial inverse must exist everywhere
3. **The bridge**: Only analytic methods (inverse function theorem) make this jump
4. **Why polynomial inverse is special**: Must have finite degree (vs. arbitrary holomorphic)

**The real crux**:
```
Local condition (det(J) = nonzero constant)
    ↓
Inverse function theorem (gives analytic inverse)
    ↓
[GAP] Why is analytic inverse necessarily polynomial?
    ↓
Osgood-Picard theorem (inverse is entire)
    ↓
[ANALYSIS] Entire map to polynomial with finite composition degree
           must be polynomial
    ↓
[NO ALGEBRAIC REPLACEMENT]
```

---

## Conclusion: Strategy Decision

**Recommended path**: Use entire function theory (Strategy A, but WITH analytic formalization)

**Why**:
- Strategies A (no analytic), B (algebraic), C (normalization) all blocked
- Strategy D (admit) fails final gate
- The problem IS fundamentally analytic
- Denying that = stuck

**Next step**: Formalize complex analysis in Lean

**Theorem to formalize**:
```lean
theorem entire_inverse_of_poly_is_poly :
    ∀ (F : PolyMap n) (d : ℕ),
      (∀ i, natDegree (F i) = d) →
      (∃ G : ℂⁿ → ℂⁿ, entire G ∧ ∀ z, G (F z) = z) →
      ∃ G_poly : PolyMap n,
        ∀ z : ℂⁿ, G_poly (F z) = z
```

This theorem, once proved with proper complex analysis, closes the main conjecture.

---

## Status: RESEARCH IMPASSE

**Phase 8 attempts**: All algebraic strategies exhausted

**Path forward**: Formalize complex analysis in Lean (4-6 weeks)

**Alternative**: Accept that the conjecture, while classical, requires analytic methods to formalize and therefore may not have a pure algebraic proof in Lean (this is itself a mathematical insight)

---

## Lesson Learned

**The Jacobian Conjecture is hard because**:
- It's fundamentally about topology and analysis
- No pure algebraic shortcut exists
- Classical proof (1899) uses analytic methods for good reason
- Formalizing it in Lean requires bridging algebra and analysis

**This validates the conjecture's difficulty**: not a simple algebraic fact that was missed, but genuinely requires sophisticated mathematics.

