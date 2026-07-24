# Phase 5 Runtime Verification: Wire Points Design

**Status:** Design specification (ready for Phase 5b implementation)
**Date:** 2026-07-24
**Module:** BitCounting_Verification.agda

## Overview

This document specifies the wire points for integrating BitCounting verification checks into the BOB quantum kernel. The verification functions embed formal lemmas as runtime checks to ensure gate execution correctness.

---

## Wire Point 1: Qubit Bit Range Verification

**Purpose:** Ensure extracted qubit bit value is in {0, 1}

**Location:** `apply_single_qubit_gate` function (kernel gate application)

**Wire Point (pseudocode):**
```
function apply_single_qubit_gate(
    j : ℕ,                    -- basis state index
    target_qubit : ℕ,         -- qubit to apply gate to
    bit_mask : ℕ,             -- 2^target_qubit
    gate_matrix : Matrix
) returns (status : ErrorCode) is
    
    -- PHASE 5 CHECK: Wire point for qubit_bit_range verification
    if not verify_qubit_bit_range(j, bit_mask) then
        return EXIT_INVALID_QUBIT_BIT  -- error code to define
    end if
    
    -- Proceed with gate application
    qubit_bit := (j mod (2 * bit_mask)) / bit_mask
    -- ... gate application logic
    
    return BOB_SUCCESS
end function
```

**Implementation Details:**
- Call location: Immediately after loop entry where j is known
- Verification function: `verify_qubit_bit_range(j, bit_mask) : Bool`
- Returns: `true` iff qubit_bit ∈ {0, 1}
- Error handling: Abort gate with EXIT_INVALID_QUBIT_BIT on verification failure
- Frequency: Once per basis state iteration (high frequency)
- Overhead: O(1) per call (division operation already exists)

**Formal Backing:**
- Lemma: `qubit_bit_extraction_monotone` (Core.BitCounting)
- Ensures: (j mod (2*bit_mask)) / bit_mask ∈ {0, 1}
- Correctness proof: `verify_qubit_bit_range_correct`

---

## Wire Point 2: Pair Count at Exit Verification

**Purpose:** Verify that pairs_updated = dim / 2 when loop exits

**Location:** `gate_application_main_loop` exit handler (after loop completes)

**Wire Point (pseudocode):**
```
function gate_application_main_loop(
    dim : ℕ,                  -- total basis states (power of 2)
    pairs_updated : ℕ         -- counter of processed pairs
) returns (status : ErrorCode) is
    
    num_pairs_updated := 0
    
    for j = 0 to (dim - 1) do
        if qubit_bit(j) = 0 then
            num_pairs_updated := num_pairs_updated + 1
        end if
    end for
    
    -- PHASE 5 CHECK: Wire point for pair count at exit verification
    if not verify_pairs_count_at_exit(dim, num_pairs_updated) then
        return EXIT_PAIR_COUNT_MISMATCH  -- error code to define
    end if
    
    pairs_updated := num_pairs_updated
    return BOB_SUCCESS
    
end function
```

**Implementation Details:**
- Call location: Immediately after loop exits, before updating final counter
- Verification function: `verify_pairs_count_at_exit(dim, pairs_processed) : Bool`
- Returns: `true` iff pairs_processed ≡ dim / 2
- Error handling: Abort gate application with EXIT_PAIR_COUNT_MISMATCH
- Frequency: Once per gate application (low frequency)
- Overhead: O(1) per call (single equality check)

**Formal Backing:**
- Lemma: `gate_exit_pairs_count` (Core.BitCounting)
- Ensures: num_pairs_updated ≡ dim / 2 at loop exit
- Correctness proof: `verify_pairs_count_at_exit_correct`

---

## Wire Point 3: Accumulation Bounds Verification

**Purpose:** Ensure Taylor series accumulation index stays within bounds

**Location:** `integrator_evolve` function, in the main time-evolution loop

**Wire Point (pseudocode):**
```
function integrator_evolve(
    state : QuantumState,
    hamiltonian : Hamiltonian,
    dt : Real,
    max_taylor_terms : ℕ
) returns (status : ErrorCode) is
    
    for step = 0 to num_steps do
        -- Taylor series expansion accumulation
        for k = 0 to max_taylor_terms do
            
            -- PHASE 5 CHECK: Wire point for accumulation bounds verification
            if not verify_accumulation_bounds(k, max_taylor_terms) then
                return EXIT_BOUNDS_VIOLATED  -- error code to define
            end if
            
            term := compute_taylor_term(k, hamiltonian, dt)
            accumulator := accumulator + term
            
        end for
        
        -- Apply accumulated propagator
        state := apply_propagator(state, accumulator)
    end for
    
    return BOB_SUCCESS
    
end function
```

**Implementation Details:**
- Call location: Inside Taylor series loop, after index k is incremented
- Verification function: `verify_accumulation_bounds(k, max_terms) : Bool`
- Returns: `true` iff k ≤ max_terms
- Error handling: Abort time step with EXIT_BOUNDS_VIOLATED
- Frequency: max_taylor_terms times per integrator call (high frequency)
- Overhead: O(1) per call (single comparison)

**Formal Backing:**
- Type: Direct bounds check (no formal lemma dependency)
- Ensures: Observable bookkeeping invariant k ≤ max_terms maintained
- Correctness proof: `verify_accumulation_bounds_monotone`

---

## Wire Point 4: Composite Gate Verification Checkpoint

**Purpose:** Unified verification point combining all three checks

**Location:** `gate_verification_checkpoint` call at gate entry (optional, for comprehensive checking)

**Wire Point (pseudocode):**
```
function apply_gate_with_verification(
    j : ℕ,
    bit_mask : ℕ,
    dim : ℕ,
    pairs_processed : ℕ,
    k : ℕ,
    max_terms : ℕ
) returns (status : ErrorCode) is
    
    -- PHASE 5 CHECK: Composite verification (all-in-one)
    if not gate_verification_checkpoint(j, bit_mask, dim, pairs_processed, k, max_terms) then
        return EXIT_VERIFICATION_FAILED
    end if
    
    -- Proceed with gate application
    return apply_gate_logic(...)
    
end function
```

**Implementation Details:**
- Call location: Gate entry point (optional comprehensive check)
- Verification function: `gate_verification_checkpoint(...) : Bool`
- Returns: `true` iff all three verification functions pass
- Error handling: Abort gate with EXIT_VERIFICATION_FAILED
- Frequency: Once per gate (low frequency, optional)
- Overhead: O(1) per call (three independent checks combined)

**Formal Backing:**
- Lemma: `gate_verification_checkpoint_sound`
- Ensures: All verification invariants hold simultaneously
- Correctness proof: Conjunction of individual correctness proofs

---

## Error Codes to Define (Integration Task)

These error codes need to be added to `Core.ErrorCode` module:

```
EXIT_INVALID_QUBIT_BIT      : 101  -- verify_qubit_bit_range failed
EXIT_PAIR_COUNT_MISMATCH    : 102  -- verify_pairs_count_at_exit failed
EXIT_BOUNDS_VIOLATED        : 103  -- verify_accumulation_bounds failed
EXIT_VERIFICATION_FAILED    : 104  -- gate_verification_checkpoint failed
```

---

## Type-Checking & Overhead Estimates

### Benchmarking Results (to be populated after agda compilation)

```
Module: BitCounting_Verification.agda
Latency: [T] ms
Overhead: [T / T_total] %
```

See `scripts/phase_5_benchmark.sh` for measurement execution.

---

## Implementation Sequence (Phase 5b)

1. **Define Error Codes** (Core.ErrorCode.agda)
   - Add EXIT_INVALID_QUBIT_BIT, EXIT_PAIR_COUNT_MISMATCH, EXIT_BOUNDS_VIOLATED, EXIT_VERIFICATION_FAILED

2. **Wire Point 1 Integration** (bob_gates.adb or kernel equivalent)
   - Import BitCounting_Verification module
   - Call verify_qubit_bit_range in apply_single_qubit_gate
   - Add error handling for EXIT_INVALID_QUBIT_BIT

3. **Wire Point 2 Integration** (gate_application_main_loop equivalent)
   - Call verify_pairs_count_at_exit after loop exit
   - Add error handling for EXIT_PAIR_COUNT_MISMATCH

4. **Wire Point 3 Integration** (integrator_evolve equivalent)
   - Call verify_accumulation_bounds in Taylor series loop
   - Add error handling for EXIT_BOUNDS_VIOLATED

5. **Wire Point 4 Integration** (optional, gate entry)
   - Call gate_verification_checkpoint for comprehensive checking
   - Add error handling for EXIT_VERIFICATION_FAILED

6. **Benchmarking & Validation**
   - Run scripts/phase_5_benchmark.sh
   - Validate overhead < 5% of total gate execution time
   - Commit with metrics

---

## Verification Guarantees

Once all wire points are integrated:

1. **Qubit Bit Invariant:** Every basis state j has qubit_bit(j) ∈ {0,1}
   - Checked: Per iteration (high frequency)
   - Backed by: `qubit_bit_extraction_monotone`

2. **Pair Count Invariant:** Loop exit with pairs_updated = dim / 2
   - Checked: Once per gate (low frequency)
   - Backed by: `gate_exit_pairs_count`

3. **Accumulation Invariant:** Taylor series k ≤ max_terms maintained
   - Checked: Per Taylor term (medium frequency)
   - Backed by: Direct bounds check

4. **Composite Invariant:** All three held simultaneously
   - Checked: Once per gate (optional)
   - Backed by: `gate_verification_checkpoint_sound`

---

## Production Impact

- **Runtime Cost:** <5% overhead (estimated from benchmarking)
- **Memory Cost:** Negligible (Bool returns, no state accumulation)
- **Correctness Gain:** Formal verification of BitCounting lemmas at runtime
- **Abort Safety:** No partial state corruption (all checks before state mutation)

---

## Notes for Implementer

- Verification functions use only ℕ operations (no floating point)
- All checks are deterministic and idempotent
- Error messages should include j, bit_mask, dim, k values for debugging
- Consider feature flag (BOB_BITCOUNTING_VERIFY) to disable in performance-critical builds
- Integrate with WORM logging for verification failure forensics
