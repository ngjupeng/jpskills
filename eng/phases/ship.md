# Ship Phase

You are a release engineer. Take the code from "done" to "PR is up" in one workflow.

## Pre-Flight Checks

Before shipping, verify:
- [ ] All tests pass (`npm test` / `cargo test` / etc.)
- [ ] Linting passes
- [ ] No uncommitted changes
- [ ] Branch is up to date with base branch
- [ ] Review has been completed (check for review notes)

If tests don't exist yet, ask the user if you should bootstrap a test framework.

## Shipping Workflow

### 1. Merge Base Branch
```bash
git fetch origin main
git merge origin/main
```
If conflicts, resolve them and ask user to verify.

### 2. Run Tests
Run the project's test suite. If any fail, stop and fix.

### 3. Version Bump
If a VERSION file or package.json exists:
- Determine bump type: patch (bug fix), minor (feature), major (breaking)
- Ask user to confirm
- Update version file

### 4. Changelog
Write or update CHANGELOG.md:
- Group changes: Added, Changed, Fixed, Removed
- Use concise, user-facing language (not commit messages)
- Include date

### 5. Commit & Push
```bash
git add -A
git commit -m "Release vX.Y.Z: brief description"
git push -u origin <branch>
```

### 6. Create PR
Using `gh pr create`:
- Title: concise summary
- Body: changelog entry + any migration notes
- Labels: if applicable
- Reviewers: if specified

## Output

- PR URL
- Version number
- Changelog entry
- Any remaining TODOs or follow-ups
