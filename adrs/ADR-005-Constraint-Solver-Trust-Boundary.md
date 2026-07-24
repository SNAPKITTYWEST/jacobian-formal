# ADR-005: Constraint-Solver Trust Boundary

**Status:** ACCEPTED

## Decision

Prolog and all constraint solvers are **untrusted certificate producers**.
Lean is the **certificate verifier**.

No solver output is a proof until checked by Lean.

## Trust Model

```
Prolog (untrusted)  ──generates candidate certificates──>  Lean (verifier)
                                                               ↓
                                                          Parse & validate
                                                               ↓
                                                        Accept or REJECT
```

## What Prolog May Do

- Enumerate finite cases
- Solve coefficient constraints for bounded degrees
- Search dependency graphs
- Derive candidate substitutions
- Identify logical contradictions
- Emit candidate certificates with full metadata

## What Prolog Cannot Do

- Assert an unrestricted theorem based on bounded search
- Convert "no counterexample found" into proof
- Use floating-point equality for polynomial identities
- Call a result "proved" without Lean verification
- Hide recursion cutoffs or search bounds
- Hide incomplete branches or timeouts

## Certificate Anatomy

Every Prolog certificate must include:

```json
{
  "theorem_id": "string",
  "dimension": integer,
  "degree_bound": integer,
  "assumptions": [...],
  "substitutions": [...],
  "polynomial_identities": [...],
  "normalization_trace": [...],
  "branch_coverage": "complete|partial|bounded",
  "search_bounds": {...},
  "solver_version": "string",
  "source_hash": "string",
  "result_hash": "string",
  "timestamp": "ISO8601"
}
```

## Lean Verification

Lean verifies:

1. **Syntax**: JSON parses
2. **Structure**: All required fields present
3. **Semantics**: Substitutions are valid polynomial maps
4. **Identities**: Each polynomial identity evaluates to zero
5. **Composition**: Stated compositions match Lean definitions
6. **Domain**: Dimension and degree bounds are consistent
7. **Completeness**: Branch coverage matches claims

## Consequence

Phase 4 (Constraint Encoding) may emit Prolog certificates.
Phase 5 (Certificate Verification) accepts or rejects each in Lean.

No Prolog success bypasses Lean checking.
