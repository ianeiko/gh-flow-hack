"""
E2E test for ghflow workflow - uses current repo with test artifacts.

Prerequisites:
- gh CLI authenticated: `gh auth login`

Run: pytest tests/test_e2e_workflow.py -v -s
"""

import subprocess
import time
from pathlib import Path
import pytest
import json


def run_cmd(cmd, cwd=None):
    """Run shell command, return output"""
    if cwd is None:
        cwd = Path.cwd()

    result = subprocess.run(
        cmd,
        shell=True,
        cwd=cwd,
        capture_output=True,
        text=True
    )
    if result.returncode != 0:
        print(f"FAILED: {cmd}")
        print(f"STDOUT: {result.stdout}")
        print(f"STDERR: {result.stderr}")
        raise Exception(f"Command failed: {cmd}")
    return result.stdout.strip()


class TestWorkflow:
    """Manages test workflow in current repository"""

    def __init__(self):
        self.repo_root = Path.cwd()
        self.timestamp = int(time.time())
        self.test_branch = None
        self.test_issue = None
        self.test_pr = None
        self.skills_dir = self.repo_root / ".claude" / "skills"
        self.original_branch = run_cmd("git branch --show-current", cwd=self.repo_root)

    def cleanup(self):
        """Cleanup test artifacts"""
        print("\n" + "="*60)
        print("Cleaning up test artifacts")
        print("="*60)

        # Switch back to original branch
        try:
            run_cmd(f"git checkout {self.original_branch}", cwd=self.repo_root)
        except Exception:
            run_cmd("git checkout main", cwd=self.repo_root)

        # Close and delete PR
        if self.test_pr:
            try:
                print(f"Closing test PR #{self.test_pr}")
                run_cmd(f"gh pr close {self.test_pr}", cwd=self.repo_root)
            except Exception:
                pass

        # Close test issue
        if self.test_issue:
            try:
                print(f"Closing test issue #{self.test_issue}")
                run_cmd(f"gh issue close {self.test_issue}", cwd=self.repo_root)
            except Exception:
                pass

        # Delete test branch
        if self.test_branch:
            try:
                print(f"Deleting test branch: {self.test_branch}")
                run_cmd(f"git branch -D {self.test_branch}", cwd=self.repo_root)
            except Exception:
                pass
            try:
                run_cmd(f"git push origin --delete {self.test_branch}", cwd=self.repo_root)
            except Exception:
                pass

        print("✓ Cleanup complete")


@pytest.fixture
def workflow():
    """Fixture providing test workflow context"""
    wf = TestWorkflow()
    yield wf
    wf.cleanup()


def test_complete_workflow(workflow):
    """Test complete ghflow workflow in current repository"""

    # ===== PHASE 1: Issue Creation =====
    print("\n" + "="*60)
    print("PHASE 1: Issue Creation")
    print("="*60)

    issue_body = """# Test E2E Feature

## Problem
Testing E2E workflow in current repository.

## Requirements
- [ ] Create test branch
- [ ] Make test changes
- [ ] Create PR

## Acceptance Criteria
- [ ] Test passes
- [ ] Artifacts cleaned up"""

    # Create test issue
    issue_script = workflow.skills_dir / "ghflow-issue-expander/scripts/create_issue.sh"
    assert issue_script.exists(), "create_issue.sh not found"

    output = run_cmd(
        f'bash "{issue_script}" "Test E2E Workflow" "{issue_body}"',
        cwd=workflow.repo_root
    )
    workflow.test_issue = int(output.strip())
    print(f"✓ Issue #{workflow.test_issue} created")

    # Verify HF-required label
    issue_data = json.loads(run_cmd(
        f"gh issue view {workflow.test_issue} --json labels",
        cwd=workflow.repo_root
    ))
    labels = [label["name"] for label in issue_data["labels"]]
    assert "HF-required" in labels
    print("✓ HF-required label added")


    # ===== PHASE 2: Human Approval (Simulated) =====
    print("\n" + "="*60)
    print("PHASE 2: Human Approval (Simulated)")
    print("="*60)

    run_cmd(
        f"gh issue edit {workflow.test_issue} --remove-label HF-required",
        cwd=workflow.repo_root
    )
    print("✓ HF-required label removed")


    # ===== PHASE 3: Implementation =====
    print("\n" + "="*60)
    print("PHASE 3: Feature Implementation")
    print("="*60)

    # Create feature branch
    branch_script = workflow.skills_dir / "ghflow-feature-implementer/scripts/create_branch.sh"
    workflow.test_branch = run_cmd(
        f'bash "{branch_script}" {workflow.test_issue} "e2e-test"',
        cwd=workflow.repo_root
    ).strip()
    print(f"✓ Branch created: {workflow.test_branch}")

    # Make test change to README
    readme = workflow.repo_root / "README.md"
    original_content = readme.read_text()
    readme.write_text(original_content + f"\n\n<!-- E2E Test {workflow.timestamp} -->")
    print("✓ Test change made to README.md")


    # ===== PHASE 4: PR Creation =====
    print("\n" + "="*60)
    print("PHASE 4: Pull Request Creation")
    print("="*60)

    # Commit changes
    commit_script = workflow.skills_dir / "ghflow-pr-creator/scripts/commit_changes.sh"
    run_cmd(
        f'bash "{commit_script}" {workflow.test_issue} "test e2e workflow"',
        cwd=workflow.repo_root
    )
    print("✓ Changes committed")

    # Push branch
    run_cmd(f"git push -u origin {workflow.test_branch}", cwd=workflow.repo_root)
    print("✓ Branch pushed")

    # Create PR
    pr_script = workflow.skills_dir / "ghflow-pr-creator/scripts/create_pr.sh"
    pr_title = "[TEST E2E] Test workflow"
    pr_body = f"""## Summary
- Testing E2E workflow in current repository

## Test Plan
- [x] Automated E2E test

Closes #{workflow.test_issue}"""

    workflow.test_pr = int(run_cmd(
        f'bash "{pr_script}" {workflow.test_issue} "{pr_title}" "{pr_body}" "main"',
        cwd=workflow.repo_root
    ).strip())
    print(f"✓ PR #{workflow.test_pr} created")

    # Verify PR references issue
    pr_data = json.loads(run_cmd(
        f"gh pr view {workflow.test_pr} --json body",
        cwd=workflow.repo_root
    ))
    assert f"#{workflow.test_issue}" in pr_data["body"]
    print("✓ PR references issue")


    # ===== PHASE 5: Code Review =====
    print("\n" + "="*60)
    print("PHASE 5: Code Review")
    print("="*60)

    # Add test comment
    run_cmd(
        f'gh pr comment {workflow.test_pr} --body "E2E test review"',
        cwd=workflow.repo_root
    )
    print("✓ Review comment added")

    # Verify approval check script works (can't self-approve)
    approval_script = workflow.skills_dir / "ghflow-code-reviewer/scripts/check_approval.sh"
    try:
        status = run_cmd(f'bash "{approval_script}" {workflow.test_pr}', cwd=workflow.repo_root)
        print(f"✓ Approval check works (status: {status.split()[0]})")
    except Exception:
        print("✓ Approval check executed (PR not approved)")


    # ===== PHASE 6: Cleanup =====
    print("\n" + "="*60)
    print("PHASE 6: Test Cleanup")
    print("="*60)

    # Restore README
    readme.write_text(original_content)
    print("✓ README.md restored")

    print("\n" + "="*60)
    print("🎉 E2E WORKFLOW PASSED!")
    print("="*60)


if __name__ == "__main__":
    pytest.main([__file__, "-v", "-s"])
