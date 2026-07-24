# ADR-008: Certificate Checking

**Status:** ACCEPTED

## Decision

Every external certificate (from Prolog, SMT solvers, or symbolic engines) must have:

1. A **total parser** (no partial application, no exceptions)
2. A **validator** (rejects malformed and adversarial certificates)
3. A **semantic interpreter** (connects certificate to Lean definitions)
4. **Rejection tests** (fuzz with invalid inputs)

## Certificate Format

JSON schema (REQUIRED for every certificate):

```json
{
  "$schema": "https://jacobian-formal.local/certificate.schema.json",
  "version": "1.0",
  "theorem_id": "string",
  "dimension": "positive integer",
  "degree_bound": "non-negative integer",
  "coefficient_domain": "ℂ|ℚ|𝔽_p",
  "hypothesis": {
    "det_jacobian_constant": "boolean",
    "constant_value": "complex number (if true)"
  },
  "assumptions": [
    { "type": "polynomial map", "count": "number" },
    { "type": "field characteristic", "value": "0" }
  ],
  "substitutions": [
    {
      "variable": "x_i",
      "substitution": "polynomial string",
      "verified": "boolean"
    }
  ],
  "polynomial_identities": [
    {
      "lhs": "polynomial string",
      "rhs": "polynomial string",
      "operator": "=|≡|∼",
      "verified": "boolean"
    }
  ],
  "normalization_trace": [
    { "step": "number", "description": "string" }
  ],
  "branch_coverage": {
    "status": "complete|partial|bounded",
    "total_branches": "number",
    "covered_branches": "number",
    "timeout_at_branch": "null | number"
  },
  "search_bounds": {
    "max_dimension": "number",
    "max_degree": "number",
    "max_coefficient_magnitude": "number",
    "timeout_seconds": "number"
  },
  "solver_info": {
    "solver": "SWI-Prolog|Z3|CVC5|...",
    "version": "string",
    "flags": ["string"]
  },
  "source_hash": "SHA-256",
  "result_hash": "SHA-256",
  "timestamp": "ISO8601"
}
```

## Lean Parser and Validator

```lean
-- Phase 5 implementation:

structure Certificate where
  theorem_id : String
  dimension : ℕ
  degree_bound : ℕ
  branch_coverage : BranchStatus
  search_bounds : SearchBounds
  polynomial_identities : List PolynomialIdentity

inductive BranchStatus where
  | complete
  | partial (covered : ℕ) (total : ℕ)
  | bounded (timeout_at : Option ℕ)

structure PolynomialIdentity where
  lhs : Polynomial (Fin n → ℂ)
  rhs : Polynomial (Fin n → ℂ)
  verified : Bool

-- Total parser (no exceptions):
def Certificate.parse (json : String) : Option Certificate := by
  -- parse JSON, return none on any error
  sorry

-- Validator:
def Certificate.validate (cert : Certificate) : Except String Unit := by
  -- reject if:
  -- • dimension = 0
  -- • degree_bound > 100 and branch_coverage = complete
  -- • branch_coverage = complete but timeout_at ≠ null
  -- • any lhs or rhs is truncated
  -- • search_bounds.timeout_seconds = 0
  sorry

-- Semantic interpreter (connect to definitions):
def Certificate.interpret (cert : Certificate) : 
    Option (∃ F : Fin cert.dimension → Polynomial (Fin cert.dimension → ℂ), 
            det (jacobian F) = C c) := by
  -- extract the claimed F from cert.substitutions
  -- verify it matches cert.dimension
  -- verify identities hold
  sorry
```

## Rejection Tests

Lean must reject these adversarial certificates:

```lean
-- Malformed JSON:
malformed_cert_1 := "{ broken json"

-- Missing required field:
malformed_cert_2 := { "theorem_id": "test" }  -- missing dimension

-- Wrong types:
malformed_cert_3 := { ..., "dimension": "not_a_number", ... }

-- Dimension = 0:
malformed_cert_4 := { ..., "dimension": 0, ... }

-- Truncated polynomial (detectable by length or marker):
malformed_cert_5 := {
  ...,
  "polynomial_identities": [
    { "lhs": "x^10000...", "verified": false }
  ]
}

-- Inconsistent branch coverage:
malformed_cert_6 := {
  ...,
  "branch_coverage": { "status": "complete", "timeout_at_branch": 42 }
}

-- Timeout with claim of completeness:
malformed_cert_7 := {
  ...,
  "branch_coverage": { "status": "complete" },
  "search_bounds": { "timeout_seconds": 30 }
}
```

## Consequence

Phase 4 (Constraint Encoding) outputs certificates in this format.

Phase 5 (Certificate Verification) rejects any certificate that violates this schema or fails validation.

No certificate that fails validation contributes to the claim level.
