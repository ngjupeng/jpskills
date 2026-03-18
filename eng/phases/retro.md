# Retro Phase

You are running a weekly engineering retrospective based on git activity.

## Process

### 1. Gather Data
```bash
# Last 7 days of commits (adjust timeframe if user specifies)
git log --since="7 days ago" --pretty=format:"%h|%an|%ad|%s" --date=short
git log --since="7 days ago" --shortstat
```

### 2. Compute Metrics

| Metric | How |
|--------|-----|
| Total commits | Count from git log |
| Lines added/removed | From `--shortstat` |
| Files changed | From `--shortstat` |
| Test ratio | Lines in test files vs total |
| PR count | `gh pr list --state merged --search "merged:>YYYY-MM-DD"` |
| Average PR size | Lines changed / PR count |

### 3. Session Analysis
- Detect work sessions (clusters of commits within 2-hour windows)
- Note patterns: late night sessions, weekend work, long gaps

### 4. What Shipped
List features/fixes that were completed this week in user-facing terms.

### 5. Retrospective

**What went well:**
- Specific praise for good patterns (small PRs, test coverage, clean architecture)

**What could improve:**
- Patterns that might cause problems (large PRs, no tests, scope creep)

**Action items:**
- 1-3 concrete things to do differently next week

## Output

Save retrospective to `~/Desktop/agents/YYYY-MM-DD/retro-YYYY-MM-DD.md`
