#!/bin/bash

# Phase 5 Runtime Verification Benchmarking Script
# BOB Quantum Kernel — BitCounting Lemma Performance Analysis
# Purpose: Measure type-checking latency and estimate production overhead
#
# Usage: bash scripts/phase_5_benchmark.sh
# Output: Console report with timing breakdown and overhead percentage

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
AGDA_SRC="${PROJECT_ROOT}/agda/src"
AGDA_COMPILER="${AGDA:-agda}"

# Color codes for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Declare associative array for timing results
declare -A TIMINGS

echo -e "${BLUE}=================================================================================${NC}"
echo -e "${BLUE}Phase 5 Runtime Verification Benchmarking${NC}"
echo -e "${BLUE}BOB Quantum Kernel — BitCounting Lemma Type-Check Performance${NC}"
echo -e "${BLUE}=================================================================================${NC}"
echo ""

# Check if agda compiler is available
if ! command -v ${AGDA_COMPILER} &> /dev/null; then
  echo -e "${YELLOW}WARNING: agda compiler not found in PATH${NC}"
  echo "Expected: ${AGDA_COMPILER}"
  echo "Skipping benchmarks (install Agda to enable measurements)"
  exit 0
fi

echo -e "${BLUE}Agda compiler found:${NC} $(${AGDA_COMPILER} --version 2>&1 | head -1)"
echo ""

# Function to measure type-checking time
benchmark_module() {
  local module_path="$1"
  local module_name="$2"

  if [ ! -f "${module_path}" ]; then
    echo -e "${YELLOW}SKIPPED${NC} (file not found): ${module_name}"
    TIMINGS["${module_name}"]="SKIPPED"
    return 1
  fi

  echo -n "Benchmarking ${module_name}... "

  # Time the agda type-check in milliseconds
  # Note: This requires the Agda compiler to be installed
  local start_ns=$(date +%s%N 2>/dev/null || date +%s000000000)

  if timeout 30 ${AGDA_COMPILER} --type-check "${module_path}" > /dev/null 2>&1; then
    local end_ns=$(date +%s%N 2>/dev/null || date +%s000000000)
    local elapsed_ms=$(( (end_ns - start_ns) / 1000000 ))
    TIMINGS["${module_name}"]="${elapsed_ms}"
    echo -e "${GREEN}${elapsed_ms} ms${NC}"
  else
    echo -e "${YELLOW}FAILED (timeout or error)${NC}"
    TIMINGS["${module_name}"]="FAILED"
    return 1
  fi
}

# ============================================================================
# CORE INVARIANT MODULES
# ============================================================================

echo -e "${BLUE}=== CORE INVARIANT MODULES ===${NC}"
benchmark_module "${AGDA_SRC}/Invariants/EvolutionLoop.agda" "EvolutionLoop.agda"
benchmark_module "${AGDA_SRC}/Invariants/EulerLoop.agda" "EulerLoop.agda"
benchmark_module "${AGDA_SRC}/Invariants/MatrixAccumulationLoop.agda" "MatrixAccumulationLoop.agda"
benchmark_module "${AGDA_SRC}/Invariants/GateApplicationLoop.agda" "GateApplicationLoop.agda"

echo ""

# ============================================================================
# RUNTIME VERIFICATION (NEW)
# ============================================================================

echo -e "${BLUE}=== RUNTIME VERIFICATION (PHASE 5) ===${NC}"
benchmark_module "${AGDA_SRC}/Runtime/BitCounting_Verification.agda" "BitCounting_Verification.agda"

echo ""

# ============================================================================
# CORE FOUNDATION MODULES
# ============================================================================

echo -e "${BLUE}=== CORE FOUNDATION MODULES ===${NC}"
benchmark_module "${AGDA_SRC}/Core/BitCounting.agda" "BitCounting.agda"
benchmark_module "${AGDA_SRC}/Core/ErrorCode.agda" "ErrorCode.agda"
benchmark_module "${AGDA_SRC}/Core/QuantumState.agda" "QuantumState.agda"
benchmark_module "${AGDA_SRC}/Core/Hamiltonian.agda" "Hamiltonian.agda"
benchmark_module "${AGDA_SRC}/Core/Predicates.agda" "Predicates.agda"

echo ""

# ============================================================================
# RESULTS SUMMARY
# ============================================================================

echo -e "${BLUE}=================================================================================${NC}"
echo -e "${BLUE}TYPE-CHECK BENCHMARK RESULTS (Phase 5)${NC}"
echo -e "${BLUE}=================================================================================${NC}"
echo ""

declare -A modules_with_times
total_ms=0
failed_count=0
skipped_count=0
valid_count=0

# Collect results
for module in "${!TIMINGS[@]}"; do
  timing="${TIMINGS[$module]}"
  if [[ "$timing" == "SKIPPED" ]]; then
    ((skipped_count++))
  elif [[ "$timing" == "FAILED" ]]; then
    ((failed_count++))
  else
    ((valid_count++))
    ((total_ms += timing))
    modules_with_times["$module"]="$timing"
  fi
done

# Print organized results
echo -e "${YELLOW}Invariant Loops:${NC}"
for module in "EvolutionLoop.agda" "EulerLoop.agda" "MatrixAccumulationLoop.agda" "GateApplicationLoop.agda"; do
  if [[ -n "${modules_with_times[$module]}" ]]; then
    printf "  %-40s %6d ms\n" "$module" "${modules_with_times[$module]}"
  fi
done

echo ""
echo -e "${YELLOW}Runtime Verification (NEW):${NC}"
for module in "BitCounting_Verification.agda"; do
  if [[ -n "${modules_with_times[$module]}" ]]; then
    printf "  %-40s %6d ms\n" "$module" "${modules_with_times[$module]}"
  fi
done

echo ""
echo -e "${YELLOW}Core Foundation:${NC}"
for module in "BitCounting.agda" "ErrorCode.agda" "QuantumState.agda" "Hamiltonian.agda" "Predicates.agda"; do
  if [[ -n "${modules_with_times[$module]}" ]]; then
    printf "  %-40s %6d ms\n" "$module" "${modules_with_times[$module]}"
  fi
done

echo ""
echo -e "${BLUE}--- Summary ---${NC}"
printf "  Total type-checked modules: %-3d\n" "$valid_count"
printf "  Skipped (file not found):   %-3d\n" "$skipped_count"
printf "  Failed (error/timeout):     %-3d\n" "$failed_count"
printf "  Total time (valid):         %5d ms\n" "$total_ms"

echo ""

# ============================================================================
# OVERHEAD CALCULATION
# ============================================================================

if [[ $valid_count -gt 0 ]]; then
  # Extract BitCounting_Verification timing
  bitcounterverif_time="${modules_with_times[BitCounting_Verification.agda]}"

  if [[ -n "$bitcounterverif_time" && "$total_ms" -gt 0 ]]; then
    overhead_percent=$(( (bitcounterverif_time * 100) / total_ms ))
    echo -e "${YELLOW}BitCounting_Verification Module Overhead:${NC}"
    printf "  Latency:  %6d ms\n" "$bitcounterverif_time"
    printf "  Overhead: %6d %% (of total type-check time)\n" "$overhead_percent"
    echo ""
  fi
fi

echo -e "${BLUE}=================================================================================${NC}"
echo -e "${GREEN}Phase 5 Benchmark Complete${NC}"
echo -e "${BLUE}=================================================================================${NC}"
