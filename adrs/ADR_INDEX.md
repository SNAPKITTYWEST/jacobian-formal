# ADR Index

All Architectural Decision Records for the Jacobian Conjecture formalization.

**Status**: All ADRs 000–010 ACCEPTED (immutable).

## Dependency Graph

```
ADR-000 (Truth Status) ← immutable foundation
  ├── ADR-001 (No Conjecture Axiom) ← enforces ADR-000
  │   └── ADR-009 (Axiom Audit) ← verifies ADR-001
  │
  ├── ADR-002 (Exact Polynomial Representation) ← defines data model
  │   └── ADR-003 (Jacobian Definition) ← builds on ADR-002
  │
  ├── ADR-004 (Global vs Local Inverse) ← distinguishes proof strategies
  │
  ├── ADR-005 (Constraint-Solver Trust Boundary) ← defines solver role
  │   └── ADR-008 (Certificate Checking) ← enforces ADR-005
  │
  ├── ADR-006 (Isabelle Independence) ← independent verification
  │
  ├── ADR-007 (Restricted-Case Labels) ← prevents claim confusion
  │
  └── ADR-010 (Final Claim Gate) ← depends on all above
      └── ADR-011 (Proof Complete) [future, if proved]
```

## ADR Summary

| ID | Title | Status | Key Decision |
|:---|:------|:-------|:-------------|
| 000 | Truth Status | ACCEPTED | Conjecture remains OPEN unless full proof passes all gates |
| 001 | No Conjecture Axiom | ACCEPTED | No axiom may encode the target conclusion |
| 002 | Exact Polynomial Representation | ACCEPTED | Finite-support, no floating-point |
| 003 | Jacobian Definition | ACCEPTED | Formal derivatives only, not analytic |
| 004 | Global vs Local Inverse | ACCEPTED | Local ≠ polynomial invertibility without explicit proof |
| 005 | Constraint-Solver Trust Boundary | ACCEPTED | Prolog untrusted producer; Lean verifier |
| 006 | Isabelle Independence | ACCEPTED | Isabelle reconstructs independently; no import from Lean |
| 007 | Restricted-Case Labels | ACCEPTED | Every theorem labeled: DEFINITION, AUXILIARY, RESTRICTED_CASE, etc. |
| 008 | Certificate Checking | ACCEPTED | Total parser, validator, semantic interpreter, rejection tests |
| 009 | Axiom Audit | ACCEPTED | `lake build -- --print-axioms` automated for every load-bearing theorem |
| 010 | Final Claim Gate | ACCEPTED | 15 conditions ALL must pass before "proved" announcement |

## Implementation Checklist

- [x] ADR-000 written and immutable
- [x] ADR-001 written and immutable
- [x] ADR-002 written and immutable
- [x] ADR-003 written and immutable
- [x] ADR-004 written and immutable
- [x] ADR-005 written and immutable
- [x] ADR-006 written and immutable
- [x] ADR-007 written and immutable
- [x] ADR-008 written and immutable
- [x] ADR-009 written and immutable
- [x] ADR-010 written and immutable

## Violation Protocol

If any ADR is violated:

1. Build fails immediately
2. Violating commit is identified
3. All theorems depending on violated ADR are invalidated
4. Minimal counterexample is generated
5. Downstream certificates are invalidated
6. Axiom audit is rerun
7. Independent reviewer approval required before resuming

## Supersession Rules

- Circular supersession is forbidden
- New ADR must explicitly declare which prior ADR it supersedes
- Supersession requires version bump and new ADR_INDEX entry
- Only ADR-011+ may supersede earlier ADRs

## For Phase Implementation

Each phase adheres to all applicable ADRs:

- **Phase 0** (Truthful Formalization): Adheres to ADRs 000–004
  - All definitions compile
  - No proof of conjecture claimed
  - Examples in dim 1, 2 typecheck
  - Formal Jacobian, composition, determinant connected formally

- **Phase 1** (Foundational Algebra): Adheres to ADRs 000–009
  - Formal derivative laws (chain rule, product rule, etc.)
  - Jacobian properties
  - Determinant multiplicativity
  - Axiom audit passes

- **Phase 2+** (Restricted Cases, Reductions): Adheres to ADRs 000–010
  - Every theorem labeled (ADR-007)
  - Certificates validated (ADR-008)
  - Isabelle reconstruction begins (ADR-006)

- **Final** (Full Theorem): All 15 conditions of ADR-010 pass
