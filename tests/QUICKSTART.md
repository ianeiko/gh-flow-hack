# Quick Start - Running ghflow Tests

## 30-Second Setup

```bash
# 1. Authenticate with GitHub
gh auth login

# 2. Install test dependencies (use uv for speed)
cd tests && uv venv && uv pip install -r requirements.txt

# 3. Run all tests
bash run_all_tests.sh
```

## Run Individual Test Suites

```bash
# E2E test only (complete workflow)
pytest tests/test_e2e_workflow.py -v -s

# Individual skill tests
bash .claude/skills/ghflow-issue-expander/tests/test_scripts.sh
bash .claude/skills/ghflow-pr-creator/tests/test_scripts.sh
bash .claude/skills/ghflow-feature-implementer/tests/test_scripts.sh
```

## What You'll See

```
Creating test repository: ghflow-test-1234567890

===========================================================
PHASE 0: Project Setup
===========================================================
✓ CLAUDE.md populated with implementation guide

===========================================================
PHASE 1: Issue Creation
===========================================================
✓ Issue #1 created
✓ HF-required label added

===========================================================
PHASE 2: Human Approval (Simulated)
===========================================================
✓ HF-required label removed (approval simulated)

===========================================================
PHASE 3: Feature Implementation
===========================================================
✓ Branch created: feature/issue-1-add-greeting
✓ Feature implemented in main.py
✓ Tests updated in test_main.py
✓ Tests pass

===========================================================
PHASE 4: Pull Request Creation
===========================================================
✓ Changes committed
✓ Branch pushed
✓ PR #1 created
✓ PR references issue

===========================================================
PHASE 5: Code Review (Simulated)
===========================================================
✓ Review comment added (simulated)
✓ Reviews fetched

===========================================================
PHASE 6: PR Approval & Merge
===========================================================
✓ PR approved
✓ PR approval confirmed
✓ PR merged

===========================================================
FINAL: Verification
===========================================================
✓ Switched to main branch and pulled changes
✓ Default greeting works: Hello, World!
✓ Custom greeting works: Hello, Alice!
✓ All tests pass on main branch

===========================================================
🎉 COMPLETE WORKFLOW PASSED!
===========================================================

Cleaning up test repo: ghflow-test-1234567890
```

## What the Master Test Runner Shows

When you run `bash tests/run_all_tests.sh`, you'll see:

```
===================================================================
ghflow Test Suite - Running All Tests
===================================================================

Phase 1: Running Skill Unit Tests
-------------------------------------------------------------------

Testing: ghflow-issue-expander
-------------------------------------------------------------------
TEST: create_issue.sh - Creates issue with proper format and labels
✓ Issue #1 created successfully
✓ HF-required label added
...
✓ ghflow-issue-expander tests passed

Testing: ghflow-pr-creator
-------------------------------------------------------------------
TEST: validate_branch.sh - Validates branch naming convention
✓ Valid branch name accepted
...
✓ ghflow-pr-creator tests passed

... (tests for all 6 skills) ...

Phase 2: Running End-to-End Tests
-------------------------------------------------------------------
PHASE 0: Project Setup
✓ CLAUDE.md populated
PHASE 1: Issue Creation
✓ Issue created
... (complete workflow) ...
✓ E2E tests passed

===================================================================
Test Summary
===================================================================
Skill Unit Tests:
  Passed: 6
  Failed: 0

E2E Tests:
  ✓ Passed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎉 ALL TESTS PASSED!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Troubleshooting

**Problem:** `gh: command not found`
```bash
# Mac
brew install gh

# Linux
# See https://github.com/cli/cli#installation
```

**Problem:** `gh: Must authenticate first`
```bash
gh auth login
# Follow the prompts
```

**Problem:** Test hangs at "Creating test repository"
- Check your internet connection
- Verify GitHub is accessible
- Check gh CLI: `gh auth status`

## Next Steps

- Read full docs: `tests/README.md`
- Understand what's tested: See "Test Scenarios" in README
- Add your own tests: See "Writing New Tests" in README
