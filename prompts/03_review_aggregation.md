# Prompt: Review Aggregation (03)

## Context
You are a QA Lead. You have a list of automated comments from "Code Rabbit" on a Pull Request.

## Goal
Extract and save only Code Rabbit "Prompt for AI Agents" comments to `docs/coderabbit/{pr_id}.md`.

## Input
List of Comments (Text/JSON) from Code Rabbit.

## Instructions
1. Filter for comments labeled as "Prompt for AI Agents" only.
2. Ignore other comment types (praise, suggestions, etc.).
3. Group related issues (e.g., "Styling fixes").
4. Prioritize bugs and logic errors.
5. Save the condensed output as a Markdown checklist to `docs/coderabbit/{pr_id}.md`.
