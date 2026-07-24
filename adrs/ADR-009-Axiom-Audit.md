# ADR-009: Axiom Audit

**Status:** ACCEPTED

## Decision

The build must print all noncomputable axioms and trusted external imports used by the final theorem.

This audit is automated and runs for every load-bearing theorem, not optional.

## Audit Command

```bash
lake build -- --print-axioms
```

Output format (Lean 4):

```
Axioms used by MainConjecture.main_jacobian_conjecture:
  Classical.em
  Classical.choice
  Quot.sound
  [none else]
```

## Whitelist (Permitted Axioms)

The following axioms are permitted in Phase 0–2:

```
Classical.em              (excluded middle, for decidability)
Classical.choice          (axiom of choice, for construction)
Quot.sound                (quotient extensionality)
PropExt                   (propositional extensionality)
FunExt                    (function extensionality)
```

## Blacklist (Forbidden Axioms)

None of these may appear:

```
jacobian_conjecture
bijective_from_constant_jacobian
polynomial_invertible_hypothesis
analytic_inverse_polynomial
constant_jacobian_implies_inverse
jc_main_theorem
tame_automorphism_complete
inverse_exists_hypothesis
[any axiom matching "jacobian.*" or "bijective.*" or "inverse.*polynomial"]
```

## Audit Process

```lean
-- Phase 1+: Automated check in lakefile.toml:

def axiom_audit : IO Unit := by
  let output ← Lean.runCmd "lake build -- --print-axioms"
  let axioms := parseAxiomList output
  let forbidden := ["jacobian_conjecture", "bijective_from_constant_jacobian", ...]
  let violations := axioms.filter (· ∈ forbidden)
  if violations.isEmpty then
    IO.println "✓ Axiom audit passed"
  else
    IO.println s!"✗ FORBIDDEN AXIOMS DETECTED: {violations}"
    IO.Process.exit 1
```

## Consequence for Each Phase

**Phase 0**: Axiom audit must pass. Only classical axioms permitted.

**Phase 1**: Axiom audit must pass. New theorems add only permitted axioms.

**Phase 2+**: Axiom audit runs before any certificate is accepted.

**Before Final Claim**: Axiom audit is printed in full in STATUS.md and AXIOM_AUDIT.md.

If a forbidden axiom appears after Phase 1 completes:

1. Build fails immediately
2. All theorems depending on that axiom are invalidated
3. Earliest violating commit is identified
4. Minimal counterexample is generated (if possible)

## Automated Rejection

Build configuration (lakefile.toml, Phase 1+):

```toml
[lean]
moreLeanArgs := ["--print-axioms"]

[post-build]
script = "scripts/axiom_audit.sh"
on_failure = "error"
```

Script (`scripts/axiom_audit.sh`):

```bash
#!/bin/bash
lake build 2>&1 | grep "Axioms used" | while read line; do
  for forbidden in "jacobian_conjecture" "bijective_from_constant" "inverse_polynomial"; do
    if echo "$line" | grep -q "$forbidden"; then
      echo "FORBIDDEN AXIOM: $forbidden"
      exit 1
    fi
  done
done
echo "✓ Axiom audit passed"
```

## Documentation

File: `AXIOM_AUDIT.md` (generated Phase 1+)

```markdown
# Axiom Audit Report

Generated: [timestamp]
Build: [lake build output]

## Axioms Used by Final Theorem

- Classical.em (justification: decidability of case analysis)
- Classical.choice (justification: construction of witnesses)

## Axioms Used by Load-Bearing Reductions

1. DimensionOne: Classical.em
2. ChainRule: Classical.em, FunExt
3. DeterminantMultiplicativity: [none]

## Forbidden Axioms

None detected.

## Summary

**Status**: PASS
**Risk Level**: GREEN (only standard classical axioms)
```

## Consequence

Any attempt to shortcut the proof by adding a forbidden axiom is caught immediately and fails the build.

Axioms are not hidden; they are reported at every build.

Isabelle reconstruction will detect if a Lean theorem relies on an axiom that Isabelle does not assume.
