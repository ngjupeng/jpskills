---
name: eng
description: Full engineering workflow — plan, design, review, QA, ship. Powered by gstack (by Garry Tan). Use when building, reviewing, or shipping code.
---

# Engineering Workflow

A complete engineering pipeline. Tell me which phase you need, or describe what you're doing and I'll pick the right one.

Based on [gstack](https://github.com/garrytan/gstack) by Garry Tan. Original skills included with full content.

## Phases

| Command | Skill | What it does |
|---------|-------|-------------|
| `/eng plan` | plan-ceo-review | Rethink from first principles, find the 10-star version |
| `/eng plan design` | plan-design-review | Rate plan across 7 design dimensions (0-10) |
| `/eng plan eng` | plan-eng-review | Lock architecture, data flow, edge cases, test plan |
| `/eng design` | design-consultation | Build complete design system → DESIGN.md |
| `/eng review` | review | Staff engineer pre-merge diff review |
| `/eng design review` | design-review | Visual QA — find and fix UI inconsistencies |
| `/eng qa` | qa | Headless browser testing + find and fix bugs |
| `/eng qa report` | qa-only | Same testing, report-only (no fixes) |
| `/eng ship` | ship | Tests → version → changelog → push → PR |
| `/eng docs` | document-release | Auto-update all docs after shipping |
| `/eng retro` | retro | Weekly retrospective from git metrics |
| `/eng browse` | browse | Headless browser commands |
| `/eng cookies` | setup-browser-cookies | Import browser cookies for auth testing |

## Routing

Based on the user's request, read the corresponding SKILL.md from the subdirectory:

- Plan (CEO): `plan-ceo-review/SKILL.md`
- Plan (Design): `plan-design-review/SKILL.md`
- Plan (Eng): `plan-eng-review/SKILL.md`
- Design system: `design-consultation/SKILL.md`
- Code review: `review/SKILL.md`
- Design review: `design-review/SKILL.md`
- QA (fix): `qa/SKILL.md`
- QA (report): `qa-only/SKILL.md`
- Ship: `ship/SKILL.md`
- Docs: `document-release/SKILL.md`
- Retro: `retro/SKILL.md`
- Browse: `browse/SKILL.md`
- Cookies: `setup-browser-cookies/SKILL.md`

Read the full SKILL.md for the selected phase and follow its instructions exactly.

## Workflow Pipeline

```
/eng plan          → architecture + test plan
/eng plan design   → design dimension scoring
/eng plan eng      → data flow + edge cases
    ↓
/eng design        → DESIGN.md (design system)
    ↓
(user writes code)
    ↓
/eng review        → staff engineer diff review
/eng design review → visual QA + fixes
    ↓
/eng qa            → browser testing + bug fixes
    ↓
/eng ship          → tests → version → changelog → PR
    ↓
/eng docs          → update README, ARCHITECTURE, CHANGELOG
    ↓
/eng retro         → weekly metrics + retrospective
```

$ARGUMENTS
