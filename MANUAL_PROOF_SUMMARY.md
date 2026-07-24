# Manual Proof Attempt Summary — jacobian-formal (2026-07-21)

**Goal**: Close 2-4 theorems in SovMonster_Gaps.lean via manual proof attempt  
**Outcome**: Identified exact mathematical obstructions; no forceable tactics exist  
**Final Count**: 64 theorems, 43 sorries

---

## Key Finding: JordanBridge Complete ✅

Three theorems in `JordanBridge.lean` are already **fully proved with zero sorry**:
- `phi_identity` (golden ratio identity)
- `phi_cancellation` (consequence)
- `jordan_fixed_point_commutant` (commutant proof)

This provides an **algebraic bypass** of the main Jacobian crux.

---

## Blocked Proofs: Mathematical, Not Tactical

### spe_roundtrip_from_tight_frame (INVALID STATEMENT)
- Theorem as stated: `∑ᵢ tr(x Eᵢ) • Eᵢ = x`
- Requires rank-1 projector hypothesis (not stated)
- **Fix**: Modify theorem statement or add hypothesis

### fidelity_self_eq_one (MATHLIB GAP)
- Blocks on: √(ρ²) = ρ for PSD ρ
- Needs: Spectral theorem (not in Mathlib)
- **Fix**: Community Mathlib PR or accept as open

### fibonacci_channel_is_cp (MATHLIB GAP)
- Blocks on: Choi matrix + kronecker + CP map bundled type
- Needs: Mathlib enhancements
- **Fix**: Wait for Mathlib updates

### sqrt_congruence_trace (MATHLIB GAP)
- Same spectral theorem gap as fidelity_self_eq_one

---

## Status Table

| Theorem | Status | Obstruction |
|---------|--------|-------------|
| JordanBridge (3) | ✅ COMPLETE | None |
| spe_roundtrip | 🛑 INVALID | Underspecified |
| fidelity_self | 🛑 MATHLIB | Spectral theorem |
| fibonacci_channel | 🛑 MATHLIB | CP map type |
| sqrt_congruence | 🛑 MATHLIB | Spectral theorem |

---

## Recommendation

The file's philosophy is correct: **document Mathlib gaps honestly, don't force proofs.**

JordanBridge contributes 3 complete theorems. SovMonster_Gaps documents the remaining work with mathematical rigor.

---

**Session**: Manual proof attempt + gap analysis  
**Commits**: lakefile fix, two analysis documents  
**Result**: Boundary between provable theorems and infrastructure gaps clearly identified
