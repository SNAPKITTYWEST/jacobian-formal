# SovMonster_Gaps Manual Proof Analysis (2026-07-21)

## TARGET 1: spe_roundtrip_from_tight_frame (Line 205)

**Status**: BLOCKED_BY_UNDERSPECIFIED_STATEMENT

**The stated theorem**:
```lean
theorem spe_roundtrip_from_tight_frame
    (F : TightFrame n r) (x : Matrix n n ℂ) :
    ∑ i, Matrix.trace (x * F.elements i) • F.elements i = x
```

**Mathematical Analysis**:

The identity **Σᵢ tr(x Eᵢ) • Eᵢ = x** is NOT generally valid for arbitrary matrices Eᵢ with just Σᵢ Eᵢ = I.

This identity holds if and only if:
1. The Eᵢ are **rank-1 projectors** (so tr(x Eᵢ) • Eᵢ ≈ x * Eᵢ), OR
2. The frame satisfies a **dual-frame condition**: ∃ F̃ᵢ such that tr(x * Eᵢ) = tr(x * F̃ᵢ)

The `TightFrame` structure as defined only guarantees:
- Eᵢ.PosSemidef (positive semidefinite)
- Σᵢ Eᵢ = 1 (completeness)
- Orthogonality condition (equiangular overlap)

**What IS provable** (from Σᵢ Eᵢ = I):
```lean
∑ i, x * F.elements i = x  -- This follows directly from mul_sum
```

**Recommendation**: Either:
A. Add the rank-1 projector hypothesis to F, OR
B. Change the theorem statement to the valid version: `∑ i, x * F.elements i = x`, OR  
C. Prove the frame duality and include it as a hypothesis

**Verdict**: Cannot close without modifying theorem statement or adding hypotheses.

---

## TARGET 2: fidelity_self_eq_one (Line 250)

**Status**: BLOCKED_BY_LIBRARY_GAP

**The stated theorem**:
```lean
theorem fidelity_self_eq_one
    (ρ : Matrix n n ℂ) (hρ : ρ.PosSemidef) (htr : Matrix.trace ρ = 1) :
    quantum_fidelity ρ ρ hρ hρ = 1
```

**The blocking step** (line 268):
```lean
have h2 : ((√ρ)^4).sqrt = ρ := by sorry
```

**Why it's blocked**:

The proof requires: **For PSD ρ, √((√ρ)⁴) = ρ**

This is equivalent to: **√(ρ²) = ρ for PSD ρ**

Mathlib has:
- `Matrix.sqrt_sq`: A.sqrt * A.sqrt = A for PSD A ✓
- `Matrix.sqrt` definition (functional calculus)

Mathlib does NOT have:
- Spectral theorem for general matrices (needed to conclude √(ρ²) = ρ)
- Or an explicit lemma `Matrix.sqrt_pow` stating this
- Or a statement that (√A)² = A implies √(A²) = A

**Proof sketch** (requires spectral theorem):
```
For PSD ρ with spectral decomposition ρ = U Σ U*:
  - ρ² = U Σ² U*
  - √(ρ²) = U √(Σ²) U* = U Σ U* = ρ  [since √(σ²) = σ for σ ≥ 0]
```

**Verdict**: Needs either:
1. Community contribution of spectral theorem to Mathlib, OR
2. Use of external library with eigenvalue decomposition, OR
3. Replacement with a theorem provable without spectral calculus

---

## SUMMARY

| Theorem | Difficulty | Obstruction | Path |
|---------|-----------|-----------|------|
| `spe_roundtrip_from_tight_frame` | Medium | Statement underspecified | Modify theorem statement OR add hypothesis |
| `fidelity_self_eq_one` | High | Mathlib gap (no spectral theorem) | Community PR OR accept as open |
| `sqrt_congruence_trace` | High | Cyclic trace + sqrt + congruence | Same spectral theorem gap |
| `fibonacci_channel_is_cp` | High | Choi matrix + kronecker tensors | Needs Mathlib CP map bundled type |
| `cp_map_contraction_on_complement` | Very High | Perron-Frobenius + superoperator | Analysis phase only |

---

**Recommendation**: The two near-proofs cannot be closed without either:
1. Modifying theorem statements (for SPE roundtrip)
2. Adding hypotheses (for both)
3. Waiting for Mathlib enhancements (spectral theorem, CP map API)

The most honest path: Document these as **open mathematical problems requiring new Mathlib infrastructure**, not as provable theorems that need tactics tweaking.

---

**Analysis Date**: 2026-07-21  
**Analyzer**: Manual proof attempt + mathematical validity check
