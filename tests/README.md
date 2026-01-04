# ghflow Tests

Comprehensive test suite for the ghflow AI-driven development workflow.

## Test Structure

Tests are organized modularly - each skill has its own test suite:

```
tests/
├── README.md                    # This file
├── QUICKSTART.md                # Quick setup guide
├── conftest.py                  # Pytest configuration
├── requirements.txt             # Test dependencies
├── run_all_tests.sh             # Master test runner (all tests)
├── test_e2e_workflow.py         # End-to-end workflow test
└── fixtures/
    └── hello-world/             # Simple test project

.claude/skills/
├── ghflow-issue-expander/tests/test_scripts.sh
├── ghflow-pr-creator/tests/test_scripts.sh
├── ghflow-code-reviewer/tests/test_scripts.sh
├── ghflow-feature-implementer/tests/test_scripts.sh
├── ghflow-orchestrator/tests/test_scripts.sh
└── ghflow-project-setup/tests/test_scripts.sh
```

## Prerequisites

### 1. GitHub CLI Authentication

```bash
gh auth login
```

### 2. Python Dependencies

```bash
pip install -r tests/requirements.txt
```

### 3. Optional: Set Test Organization

```bash
# If you want to create test repos in an org instead of personal account
export GITHUB_TEST_ORG="your-org-name"
```

## Running Tests

### All Tests (Recommended)

Run all skill unit tests and E2E test:

```bash
bash tests/run_all_tests.sh
```

This will:
1. Run unit tests for all 6 skills
2. Run the complete E2E workflow test
3. Provide comprehensive summary

**Duration:** ~10-15 minutes total

### Individual Skill Tests

Test a specific skill's scripts:

```bash
# Test issue expander
bash .claude/skills/ghflow-issue-expander/tests/test_scripts.sh

# Test PR creator
bash .claude/skills/ghflow-pr-creator/tests/test_scripts.sh

# Test code reviewer
bash .claude/skills/ghflow-code-reviewer/tests/test_scripts.sh

# Test feature implementer
bash .claude/skills/ghflow-feature-implementer/tests/test_scripts.sh

# Test orchestrator
bash .claude/skills/ghflow-orchestrator/tests/test_scripts.sh

# Test project setup
bash .claude/skills/ghflow-project-setup/tests/test_scripts.sh
```

**What each skill test covers:**

- **ghflow-issue-expander**: `create_issue.sh`, `save_issue.sh`
- **ghflow-pr-creator**: `validate_branch.sh`, `commit_changes.sh`, `create_pr.sh`
- **ghflow-code-reviewer**: `fetch_pr_reviews.sh`, `aggregate_reviews.sh`, `check_approval.sh`, `apply_fixes.sh`
- **ghflow-feature-implementer**: `fetch_issue.sh`, `create_branch.sh`, `save_task.sh`
- **ghflow-orchestrator**: `init_workflow.sh`, `check_eligible_issues.sh`, `poll_label.sh`, `invoke_skill.sh`, `cleanup_workflow.sh`
- **ghflow-project-setup**: `generate_implementation_guide.sh`, `update_claude_md.sh`

**Duration:** ~1-2 minutes per skill

### End-to-End Test Only

Test the complete workflow from idea to merged PR:

```bash
pytest tests/test_e2e_workflow.py -v -s
```

**What it tests:**
- ✅ Project setup with CLAUDE.md
- ✅ Issue creation with HF-required label
- ✅ Human approval simulation (label removal)
- ✅ Feature branch creation
- ✅ Feature implementation
- ✅ Test execution
- ✅ PR creation with proper format
- ✅ Code review simulation
- ✅ Review aggregation
- ✅ PR approval and merge
- ✅ Final feature verification

**Duration:** ~2-3 minutes (creates/destroys real GitHub repo)

## Test Scenarios

### E2E Test Scenario

The end-to-end test implements this feature:

**Idea:** "Add customizable greeting to hello world"

**Implementation:**
```python
# Before (main.py)
def main():
    print("Hello, World!")

# After (main.py)
import sys

def main() -> None:
    """Print personalized greeting."""
    name = sys.argv[1] if len(sys.argv) > 1 else "World"
    print(f"Hello, {name}!")
```

**Tests:**
```python
def test_default_greeting():
    # python main.py
    assert output == "Hello, World!\n"

def test_custom_greeting():
    # python main.py Alice
    assert output == "Hello, Alice!\n"
```

## Debugging Failed Tests

### E2E Test Failures

If the E2E test fails, it will show which phase failed:

```
PHASE 1: Issue Creation
✓ Issue #42 created
✓ HF-required label added
✗ Issue save script failed  <-- Failure point
```

**Common issues:**
1. **GitHub API rate limits** - Wait a few minutes, try again
2. **Authentication expired** - Run `gh auth login` again
3. **Permissions** - Ensure you can create repos in target org
4. **Network issues** - Check internet connection

### Script Test Failures

Script tests show specific failures:

```
TEST: create_issue.sh
✗ Failed to create issue
Output: Error: HTTP 422: Validation Failed
```

**Common issues:**
1. **Missing gh CLI** - Install with `brew install gh` (Mac) or see [GitHub CLI docs](https://cli.github.com/)
2. **Not authenticated** - Run `gh auth login`
3. **Scripts not executable** - Run `chmod +x .claude/skills/**/*.sh`

## Test Cleanup

Both test suites automatically clean up after themselves:

- **E2E test:** Deletes test repository on completion (even if test fails)
- **Script test:** Deletes test repository after all script tests complete

If a test is interrupted (Ctrl+C), you may need to manually delete test repos:

```bash
# List test repos
gh repo list | grep ghflow-test

# Delete specific test repo
gh repo delete ghflow-test-1234567890 --yes
```

## Continuous Integration

To run in CI/CD:

```yaml
# .github/workflows/test.yml
name: Test ghflow

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2

      - name: Setup Python
        uses: actions/setup-python@v2
        with:
          python-version: '3.9'

      - name: Install dependencies
        run: pip install -r tests/requirements.txt

      - name: Authenticate GitHub CLI
        run: |
          echo "${{ secrets.GITHUB_TOKEN }}" | gh auth login --with-token

      - name: Run all tests
        run: bash tests/run_all_tests.sh
```

## Writing New Tests

### Adding Tests for a New Skill Script

When you add a new script to a skill:

1. Open the skill's `tests/test_scripts.sh` file
2. Add a new test following the pattern:

```bash
# In .claude/skills/your-skill/tests/test_scripts.sh

test_start "your_script.sh - What it does"

SCRIPT="$SKILL_DIR/scripts/your_script.sh"
if [ ! -f "$SCRIPT" ]; then
    fail "Script not found: $SCRIPT"
else
    # Setup test environment
    # ...

    # Run the script
    OUTPUT=$(bash "$SCRIPT" arg1 arg2)

    # Verify results
    if [ expected condition ]; then
        pass "Test description"
    else
        fail "Test description"
    fi
fi
```

3. Run the skill's tests to verify:
```bash
bash .claude/skills/your-skill/tests/test_scripts.sh
```

### Adding Test Cases to E2E Test

To test a different feature:

1. Modify `tests/fixtures/hello-world/` with new starting code
2. Update the idea in `test_e2e_workflow.py`
3. Update the implementation code in Phase 3
4. Update expected outputs in Final Verification

### Creating Tests for a New Skill

When creating a new skill:

1. Create `tests/` directory in the skill folder
2. Create `tests/test_scripts.sh` using existing skills as template
3. Add test cases for each script in the skill
4. Make the test file executable: `chmod +x tests/test_scripts.sh`
5. Verify tests run: `bash <skill-dir>/tests/test_scripts.sh`

## Troubleshooting

### Tests are slow

The E2E test creates a real GitHub repository which takes time. This is intentional to test the real workflow. There's no way to significantly speed this up without mocking (which defeats the purpose of E2E testing).

### Rate limiting

GitHub API has rate limits. If you run tests repeatedly, you may hit limits. Wait 1 hour or use a different account.

### Tests pass but real usage fails

The tests use a simplified "hello world" project. Real projects may have additional complexity. The tests validate the core workflow mechanics, not project-specific edge cases.

## Test Coverage

Current coverage:

- ✅ **Core Workflow:** Complete idea-to-PR flow (E2E test)
- ✅ **All Skills:** Each of 6 skills has dedicated unit tests
  - ghflow-issue-expander (2 scripts tested)
  - ghflow-pr-creator (3 scripts tested)
  - ghflow-code-reviewer (4 scripts tested)
  - ghflow-feature-implementer (3 scripts tested)
  - ghflow-orchestrator (5 scripts tested)
  - ghflow-project-setup (2 scripts tested)
- ✅ **GitHub Integration:** Real API calls tested in each skill
- ✅ **State Management:** workflow-state.md updates tested
- ⚠️ **Skills:** Tested via script invocation (not as Claude skill invocations)
- ❌ **Error Handling:** Limited error scenario testing
- ❌ **Edge Cases:** Focus is on happy path

## Future Improvements

Potential enhancements:

1. **Parallel test execution** - Run script tests in parallel
2. **Error scenario testing** - Test failed PRs, rejected reviews, etc.
3. **Performance benchmarks** - Track workflow execution time
4. **Skill invocation testing** - Test actual skill executions (requires Claude API)
5. **Multiple language support** - Test with non-Python projects

## Support

If tests are failing consistently:

1. Check you have latest version: `git pull`
2. Verify gh CLI works: `gh auth status`
3. Try manual workflow first: Run `/ghflow-orchestrator` manually
4. Check [Issues](https://github.com/your-org/gh-flow-hack/issues) for known problems
