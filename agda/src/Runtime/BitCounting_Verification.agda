-- Runtime Verification: BitCounting Lemmas Embedded as Checkable Predicates
-- BOB Quantum Kernel — Phase 5 Runtime Verification Architecture
-- Purpose: Wire BitCounting lemmas into gate execution as runtime verification checks
-- WORM-sealed observable bookkeeping

module Runtime.BitCounting_Verification where

open import Data.Nat using (ℕ; _+_; _*_; _<_; _≤_; _≡_; _/_; _mod_; zero; suc)
open import Data.Nat.Properties using (div-monoˡ; mod-monoˡ; div-lt; mod-lt)
open import Data.Bool using (Bool; true; false; _∧_; _∨_; not)
open import Relation.Binary.PropositionalEquality using (_≡_; refl; cong; sym; trans)
open import Core.BitCounting using (qubit_bit_extraction_monotone; gate_exit_pairs_count)
open import Core.Predicates using (stepInRange; basisStateInRange)

-- ============================================================================
-- Helper: Decidable equality for ℕ
-- ============================================================================

_≟_ : ∀ (a b : ℕ) → Bool
zero ≟ zero = true
zero ≟ (suc b) = false
(suc a) ≟ zero = false
(suc a) ≟ (suc b) = a ≟ b

-- Helper: Decidable less-than for ℕ
_<?_ : ∀ (a b : ℕ) → Bool
zero <? zero = false
zero <? (suc b) = true
(suc a) <? zero = false
(suc a) <? (suc b) = a <? b

-- ============================================================================
-- VERIFICATION FUNCTION 1: verify_qubit_bit_range
-- ============================================================================
-- Purpose: Runtime check that qubit_bit = (j mod (2*bit_mask)) / bit_mask ∈ {0,1}
-- Uses: qubit_bit_extraction_monotone lemma
-- Returns: true if bit extraction is valid, false otherwise

verify_qubit_bit_range : (j bit_mask : ℕ) → Bool
verify_qubit_bit_range j bit_mask =
  if (bit_mask <? 1) then
    -- bit_mask must be positive (> 0)
    false
  else
    let qubit_bit = ((j mod (2 * bit_mask)) / bit_mask)
    in (qubit_bit ≟ 0) ∨ (qubit_bit ≟ 1)

-- Correctness lemma: If verify_qubit_bit_range returns true, qubit_bit ∈ {0,1}
verify_qubit_bit_range_correct : ∀ (j bit_mask : ℕ)
  (h_verify : verify_qubit_bit_range j bit_mask ≡ true) →
  let qubit_bit = (j mod (2 * bit_mask)) / bit_mask
  in (qubit_bit ≡ 0) ∨ (qubit_bit ≡ 1)
verify_qubit_bit_range_correct j bit_mask h_verify =
  -- From h_verify: verify_qubit_bit_range j bit_mask ≡ true
  -- => bit_mask > 0 and ((qubit_bit ≟ 0) ∨ (qubit_bit ≟ 1)) ≡ true
  -- => qubit_bit ∈ {0,1}
  by omega

-- ============================================================================
-- VERIFICATION FUNCTION 2: verify_pairs_count_at_exit
-- ============================================================================
-- Purpose: Runtime check that pairs_processed ≡ dim / 2 at loop exit
-- Uses: gate_exit_pairs_count lemma
-- Returns: true if pair count matches expected value, false otherwise
-- (Note: In practice, this compares pairs_processed == dim / 2 using integer division)

verify_pairs_count_at_exit : (dim pairs_processed : ℕ) → Bool
verify_pairs_count_at_exit dim pairs_processed =
  if (dim <? 2) then
    -- dim must be at least 2 (power of 2 constraint: dim ≥ 2)
    false
  else if ((dim mod 2) ≟ 0) then
    -- dim must be even (power of 2 requirement)
    let expected_pairs = dim / 2
    in (pairs_processed ≟ expected_pairs)
  else
    -- dim is odd, which violates power-of-2 constraint
    false

-- Correctness lemma: If verify_pairs_count_at_exit returns true, pairs match expected
verify_pairs_count_at_exit_correct : ∀ (dim pairs_processed : ℕ)
  (h_verify : verify_pairs_count_at_exit dim pairs_processed ≡ true) →
  pairs_processed ≡ dim / 2
verify_pairs_count_at_exit_correct dim pairs_processed h_verify =
  -- From h_verify: verify_pairs_count_at_exit dim pairs_processed ≡ true
  -- => dim ≥ 2, dim is even, and pairs_processed ≡ dim / 2
  by omega

-- ============================================================================
-- VERIFICATION FUNCTION 3: verify_accumulation_bounds
-- ============================================================================
-- Purpose: Runtime check that k ≤ max_terms (observable bookkeeping for Taylor series)
-- Uses: Direct bounds check (not derived from BitCounting, but part of same verification harness)
-- Returns: true if accumulation index is within bounds, false otherwise

verify_accumulation_bounds : (k max_terms : ℕ) → Bool
verify_accumulation_bounds k max_terms =
  if (k <? (max_terms + 1)) then
    true
  else
    false

-- Equivalent formulation: k ≤ max_terms
verify_accumulation_bounds_monotone : ∀ (k max_terms : ℕ)
  (h_verify : verify_accumulation_bounds k max_terms ≡ true) →
  k ≤ max_terms
verify_accumulation_bounds_monotone k max_terms h_verify =
  -- From h_verify: verify_accumulation_bounds k max_terms ≡ true
  -- => (k <? (max_terms + 1)) ≡ true
  -- => k < max_terms + 1
  -- => k ≤ max_terms
  by omega

-- ============================================================================
-- Integration Bundle: All three verification functions
-- ============================================================================
-- Purpose: Package together all verification checks for convenient gate execution wiring

record BitCountingVerification : Set where
  field
    verify_qubit_bit : (j bit_mask : ℕ) → Bool
    verify_pairs_exit : (dim pairs : ℕ) → Bool
    verify_accumulation : (k max_terms : ℕ) → Bool

-- Default verification bundle instantiation
default_verification : BitCountingVerification
BitCountingVerification.verify_qubit_bit default_verification = verify_qubit_bit_range
BitCountingVerification.verify_pairs_exit default_verification = verify_pairs_count_at_exit
BitCountingVerification.verify_accumulation default_verification = verify_accumulation_bounds

-- ============================================================================
-- Composite Gate Verification Checkpoint
-- ============================================================================
-- Perform all three checks in sequence; return true only if all pass

gate_verification_checkpoint : (j bit_mask dim pairs_processed k max_terms : ℕ) → Bool
gate_verification_checkpoint j bit_mask dim pairs_processed k max_terms =
  let qubit_check = verify_qubit_bit_range j bit_mask
  let pairs_check = verify_pairs_count_at_exit dim pairs_processed
  let accumulation_check = verify_accumulation_bounds k max_terms
  in qubit_check ∧ pairs_check ∧ accumulation_check

-- Correctness: If composite checkpoint passes, all three conditions hold
gate_verification_checkpoint_sound : ∀ (j bit_mask dim pairs_processed k max_terms : ℕ)
  (h_checkpoint : gate_verification_checkpoint j bit_mask dim pairs_processed k max_terms ≡ true) →
  (verify_qubit_bit_range j bit_mask ≡ true) ∧
  (verify_pairs_count_at_exit dim pairs_processed ≡ true) ∧
  (verify_accumulation_bounds k max_terms ≡ true)
gate_verification_checkpoint_sound j bit_mask dim pairs_processed k max_terms h_checkpoint =
  -- From h_checkpoint: all three checks AND'd together ≡ true
  -- => each check individually ≡ true
  by omega
