# ADR-010: Final Claim Gate

**Status:** ACCEPTED

## Decision

The phrase **"Jacobian Conjecture proved"** is forbidden until all 15 conditions below pass simultaneously.

If even one condition fails, the status remains **OPEN**.

## The 15 Conditions

### Statement & Formalization (1–4)

1. **MainConjecture.lean contains the exact full theorem**
   - File path: `lean/Jacobian/MainConjecture.lean`
   - Theorem name: `main_jacobian_conjecture`
   - Statement matches QA_PROMPT formal-target exactly

2. **The theorem contains no sorry, admit, placeholder, or equivalent escape**
   - `grep -r "sorry\|admit\|placeholder" lean/Jacobian/MainConjecture.lean` returns empty
   - No `unsafe` keyword
   - No unchecked casts or fabricated oracles

3. **The axiom audit reveals no target-equivalent assumption**
   - `lake build -- --print-axioms` output contains no axiom in the forbidden list (ADR-009)
   - Forbidden list includes any axiom naming or asserting: jacobian_conjecture, bijective_from_constant, polynomial_invertible, inverse_exists, etc.

4. **All reductions are checked in the required direction**
   - Every file in `lean/Jacobian/Reductions.lean` declares direction: (A → B) or (B ↔ A)
   - Bidirectional reductions prove both directions
   - One-way reductions are labeled and justified

### Generality (5–8)

5. **The theorem is universally quantified over arbitrary positive n**
   - Type signature includes `(n : ℕ) (h_pos : n > 0)` or equivalent
   - Not fixed to any particular dimension
   - Not bounded by a computable constant

6. **The map is an arbitrary polynomial endomorphism of ℂⁿ**
   - Type signature: `(F : Fin n → Polynomial (Fin n → ℂ))`
   - Not restricted to any subclass (triangular, homogeneous, tame, etc.)
   - No additional hypotheses on F beyond the Jacobian condition

7. **The hypothesis is exactly that the Jacobian determinant is a nonzero constant**
   - Type signature includes: `(h_jac : ∃ c : ℂ, c ≠ 0 ∧ det (jacobian F) = C c)`
   - Or equivalent formulation
   - Not weakened to: Jacobian is nonzero at a point, or locally invertible, or analytic bijection

8. **The conclusion includes a polynomial two-sided inverse**
   - Conclusion: `∃ G : Fin n → Polynomial (Fin n → ℂ), G ∘ F = id ∧ F ∘ G = id`
   - Not: "analytic inverse exists", "locally invertible", "injective", "bijective" alone
   - The map G is polynomial, not analytic or set-theoretic

### Build & Reproducibility (9–10)

9. **Clean CI reproduces the proof**
   - Fresh checkout from git
   - `lake update && lake build` succeeds on a clean machine
   - No environment variables, no cached artifacts, no machine-specific paths
   - Build log is reproducible

10. **Independent reviewers find no weakened definition**
    - Three independent reviewers (not author, not collaborators) read:
      - `lean/Jacobian/Definitions.lean` (polynomial map, Jacobian, determinant)
      - `lean/Jacobian/MainConjecture.lean` (final theorem)
    - All three agree the definitions are standard, not weakened
    - Review notes are filed in `INDEPENDENT_REVIEW.md`

### Independent Reconstruction (11–12)

11. **Isabelle reconstructs the designated load-bearing proof chain**
    - File: `isabelle/Jacobian_Verification.thy`
    - Isabelle independently proves (does not import Lean's proof):
      - Formal derivative laws (chain rule, product rule)
      - Jacobian of composition and identity
      - Determinant multiplicativity
      - Any reduction used in the main proof
    - Isabelle proof statements agree with Lean statements (to within formal syntax)
    - Any disagreement is recorded in `INDEPENDENT_VERIFICATION.md` and reconciled

12. **The proof dependency graph has no unresolved node**
    - File: `PROOF_DEPENDENCY_GRAPH.md`
    - Every theorem in the graph has a proof (no sorry nodes)
    - Every `FULL_CONJECTURE` theorem that the main theorem depends on is proved (not auxiliary or restricted)
    - No circular dependencies
    - The final edge points to `main_jacobian_conjecture` with status PROVED

### External Verification (13–14)

13. **Every external certificate is independently checked**
    - If Phase 4 emitted any Prolog certificates:
      - Each certificate parses (ADR-008 total parser)
      - Each certificate validates (ADR-008 validator)
      - Each certificate is verified by a Lean theorem marked `CERTIFICATE_VERIFIED` (ADR-007)
    - If no certificates were emitted, this condition is vacuously true

14. **STATUS.md changes from OPEN to PROVED through an accepted ADR**
    - New ADR file: `adrs/ADR-011-Proof-Complete.md`
    - ADR-011 supersedes ADR-000 and declares status PROVED
    - ADR-011 contains:
      - Exact version hash of the proof
      - Build command that reproduces it
      - Checksums of all Lean files
      - Date and reviewer signatures
    - No circular supersession (ADR-000 → ADR-011 only, never reverse)

### Final Release (15)

15. **The final release contains complete sources, hashes, versions, and receipts**
    - Tagged git release: `v1.0-jacobian-proved`
    - Release notes include:
      - Full source (all Lean, Isabelle, supporting files)
      - SHA-256 hash of each file
      - Lean version (e.g., `lean 4.4.0`)
      - Lake version
      - Isabelle version
      - Git commit hash
      - All 15 conditions and verification status
      - Link to independent review reports
    - Release signed with GPG key

## Enforcement

A script runs before any announcement:

```bash
#!/bin/bash

conditions_met=0
checks=(
  "grep -q 'main_jacobian_conjecture' lean/Jacobian/MainConjecture.lean"
  "! grep -r 'sorry\|admit' lean/Jacobian/MainConjecture.lean"
  "! lake build -- --print-axioms | grep -i 'jacobian_conjecture'"
  "grep -q 'arbitrary positive n' PROOF_DEPENDENCY_GRAPH.md"
  "test -f INDEPENDENT_REVIEW.md"
  "test -f isabelle/Jacobian_Verification.thy"
  "test -f adrs/ADR-011-Proof-Complete.md"
  "git tag v1.0-jacobian-proved"
)

for check in "${checks[@]}"; do
  if eval "$check"; then
    ((conditions_met++))
  else
    echo "FAILED: $check"
  fi
done

if [ $conditions_met -eq 15 ]; then
  echo "✓ ALL CONDITIONS MET"
  echo "Release approved: v1.0-jacobian-proved"
else
  echo "✗ FAILED: $((15 - conditions_met)) conditions not met"
  echo "Status remains: OPEN"
  exit 1
fi
```

## Consequence

Until all 15 conditions pass, the status in README, papers, and public announcements is:

> **Jacobian Conjecture: OPEN**
> 
> Phase [current level]: [deliverables] proved.
> Next open problem: [exact statement].

If a condition fails mid-build, all dependent theorems are invalidated and must be reproved.

The phrase "proved" appears only in the release tag name, nowhere else, until all conditions pass.
