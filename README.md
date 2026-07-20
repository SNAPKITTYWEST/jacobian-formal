# Jacobian Conjecture — Rigorous Formal Verification

**Status**: OPEN (Phase 0: Definitions compile)

**Conjecture**: For every positive integer n and every polynomial map F : ℂⁿ → ℂⁿ, if det(JF) is a nonzero constant polynomial, then F is bijective with a polynomial inverse.

---

## What This Repository Contains

This project formalizes the **Jacobian Conjecture** with **maximal mathematical and computational rigor**.

The goal is **not** to prove the conjecture, but to construct governance infrastructure that makes it impossible to confuse a genuine proof with:
- a restricted case
- a computational experiment
- a bounded search
- a solver artifact
- a hidden axiom
- a malformed theorem
- a false claim

---

## Key Design Principles

### 1. Exact Definitions
- Polynomial maps: finite-support `Polynomial (Fin n → ℂ)` in Lean 4
- No floating-point; no approximations
- Formal Jacobian from formal derivatives only (not analytic)

### 2. Immutable Governance
- 10 Architectural Decision Records (ADRs 000–010) lock down every design choice
- ADR violation causes build failure
- ADRs are immutable; corrections require superseding ADRs

### 3. Explicit Claim Levels (0–8)
- Level 0: Definitions compile ✓ COMPLETE
- Level 1–8: See OPEN_GAPS.md

### 4. Automated Enforcement
- `lake build -- --print-axioms` audits for forbidden assumptions
- Build fails if any axiom encodes the conclusion
- No sorry/admit in load-bearing proofs

### 5. Independent Verification
- Isabelle independently reconstructs major proofs
- Never imports Lean assertions; always reproves
- Disagreement escalated to human review

### 6. Untrusted Solver Integration
- Prolog: untrusted certificate producer
- Lean: certificate verifier
- Every solver output validated by formal proof

---

## Building

```bash
cd /tmp/jacobian-formal
lake update
lake build
```

Expected: All definitions compile ✓

---

## Repository Structure

```
adrs/                  10 immutable ADRs (000–010)
lean/Jacobian/         Lean 4 definitions and theorems
prolog/                Constraint solver (Phase 4+)
isabelle/              Independent verification (Phase 6+)
certificates/          External certificate format (Phase 5+)
STATUS.md              Current phase and claim level
OPEN_GAPS.md           Exact list of unproved theorems
ADR_INDEX.md           ADR dependency graph
```

---

## Claim Levels

| Level | Deliverable | Status |
|:------|:-----------|:-------|
| 0 | Definitions compile | ✓ COMPLETE |
| 1–8 | See OPEN_GAPS.md | PENDING |

---

## The 15 Final Conditions

Before "Jacobian Conjecture proved" is announced, all 15 conditions in ADR-010 must pass.

Current status: OPEN (ADR-000)

---

## Phases

- **Phase 0** ✓: Definitions compile (2026-07-20)
- **Phase 1**: Foundational Algebra (TBD)
- **Phase 2**: Restricted Cases (TBD)
- **Phase 3**: Known Reductions (TBD)
- **Phase 4–8**: See OPEN_GAPS.md

---

## Trust Model

- **Lean 4**: Trusted checker
- **Isabelle**: Independent auditor
- **Prolog**: Untrusted solver
- **Classical axioms**: Permitted (em, choice, funext, propext)
- **External axioms**: Forbidden (audited at build)

---

**Status: OPEN** | Phase 0 ✓ | All ADRs immutable | Ready for Phase 1
