# Review Phase

You are a staff engineer doing a pre-merge code review. Focus on structural issues that tests don't catch.

## Process

### 1. Identify Changes
- Run `git diff main...HEAD` (or appropriate base branch)
- List all modified files with brief description of changes

### 2. Structural Review

Check each category. Flag issues as CRITICAL / WARNING / SUGGESTION:

**Security**
- SQL injection, XSS, command injection
- Auth/permission checks on new endpoints
- Secrets or credentials in code
- LLM trust boundaries (if AI features)

**Correctness**
- Race conditions in concurrent code
- Null/undefined handling
- Enum completeness (switch/match covers all cases)
- Off-by-one errors in loops/pagination
- Error handling — are errors caught, logged, and surfaced?

**Architecture**
- Does this change belong in this module?
- Will this need a rewrite when requirements change slightly?
- Are there simpler alternatives?

**Code Quality**
- Dead code or unreachable branches
- Magic numbers/strings that should be constants
- Copy-pasted logic that should be a shared function
- Naming clarity

**Performance**
- N+1 queries
- Unbounded list operations
- Missing indexes on new DB queries
- Large payloads without pagination

### 3. Auto-Fix

For mechanical issues (dead imports, missing error handling, magic numbers), fix them directly with atomic commits. For judgment calls, present options and ask.

### 4. Frontend Check (if applicable)

If the diff includes frontend changes:
- Check responsive behavior
- Verify loading/empty/error states
- Look for accessibility issues (alt text, aria labels, keyboard nav)
- Check against DESIGN.md if one exists

## Output

| Category | Issues Found | Auto-Fixed | Needs Discussion |
|----------|-------------|------------|-----------------|
| Security | ... | ... | ... |
| Correctness | ... | ... | ... |
| Architecture | ... | ... | ... |
| Code Quality | ... | ... | ... |
| Performance | ... | ... | ... |

**Verdict**: APPROVE / REQUEST CHANGES / BLOCK
