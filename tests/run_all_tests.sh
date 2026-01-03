#!/bin/bash
# Master test runner for ghflow - runs all skill tests and E2E tests

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

SKILLS_DIR="/Users/jneiku/code/gh-flow-hack/.claude/skills"
TESTS_DIR="/Users/jneiku/code/gh-flow-hack/tests"

# Test result tracking
SKILL_TESTS_PASSED=0
SKILL_TESTS_FAILED=0
E2E_PASSED=0
E2E_FAILED=0

echo -e "${BLUE}==================================================================="
echo "ghflow Test Suite - Running All Tests"
echo "===================================================================${NC}"
echo ""

# Run skill-specific tests
echo -e "${BLUE}Phase 1: Running Skill Unit Tests${NC}"
echo "-------------------------------------------------------------------"

for skill_dir in "$SKILLS_DIR"/ghflow-*/; do
    skill_name=$(basename "$skill_dir")
    test_script="$skill_dir/tests/test_scripts.sh"

    if [ -f "$test_script" ]; then
        echo ""
        echo -e "${YELLOW}Testing: $skill_name${NC}"
        echo "-------------------------------------------------------------------"

        if bash "$test_script"; then
            echo -e "${GREEN}✓ $skill_name tests passed${NC}"
            ((SKILL_TESTS_PASSED++))
        else
            echo -e "${RED}✗ $skill_name tests failed${NC}"
            ((SKILL_TESTS_FAILED++))
        fi
    else
        echo -e "${YELLOW}⚠ No tests found for $skill_name${NC}"
    fi
done

# Run E2E tests
echo ""
echo ""
echo -e "${BLUE}Phase 2: Running End-to-End Tests${NC}"
echo "-------------------------------------------------------------------"

if [ -f "$TESTS_DIR/test_e2e_workflow.py" ]; then
    cd "$TESTS_DIR"

    # Activate venv if it exists
    if [ -f .venv/bin/activate ]; then
        source .venv/bin/activate
    fi

    if pytest test_e2e_workflow.py -v -s; then
        echo -e "${GREEN}✓ E2E tests passed${NC}"
        E2E_PASSED=1
    else
        echo -e "${RED}✗ E2E tests failed${NC}"
        E2E_FAILED=1
    fi
else
    echo -e "${YELLOW}⚠ E2E test file not found${NC}"
fi

# Final summary
echo ""
echo ""
echo -e "${BLUE}==================================================================="
echo "Test Summary"
echo "===================================================================${NC}"
echo ""
echo "Skill Unit Tests:"
echo "  Passed: $SKILL_TESTS_PASSED"
echo "  Failed: $SKILL_TESTS_FAILED"
echo ""
echo "E2E Tests:"
if [ $E2E_PASSED -eq 1 ]; then
    echo -e "  ${GREEN}✓ Passed${NC}"
elif [ $E2E_FAILED -eq 1 ]; then
    echo -e "  ${RED}✗ Failed${NC}"
else
    echo "  ⚠ Skipped"
fi
echo ""

TOTAL_FAILED=$((SKILL_TESTS_FAILED + E2E_FAILED))

if [ $TOTAL_FAILED -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎉 ALL TESTS PASSED!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "❌ SOME TESTS FAILED"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 1
fi
