---
name: eng
description: Full engineering workflow — plan, design, review, QA, ship. Use when building, reviewing, or shipping code.
---

# Engineering Workflow

A complete engineering pipeline in one skill. Tell me which phase you need, or describe what you're doing and I'll pick the right one.

## Phases

| Phase | When to use | Command |
|-------|-------------|---------|
| **plan** | Before writing code — lock architecture, find edge cases | `/eng plan` |
| **design** | Need a design system or design consultation | `/eng design` |
| **review** | Code is written, need pre-merge review | `/eng review` |
| **qa** | Test the app, find and fix bugs | `/eng qa` |
| **ship** | Ready to push — tests, changelog, PR | `/eng ship` |
| **retro** | Weekly retrospective on git activity | `/eng retro` |

## How to Use

Just describe what you need. Examples:
- "I need to plan the architecture for a new feature" → plan phase
- "Review my code before I merge" → review phase
- "Test my app and fix any bugs" → qa phase
- "Ship it" → ship phase

Or specify directly: `/eng plan`, `/eng review`, `/eng qa`, `/eng ship`

## Phase Details

Read the appropriate file from `phases/` directory based on the user's request:
- Plan: `phases/plan.md`
- Design: `phases/design.md`
- Review: `phases/review.md`
- QA: `phases/qa.md`
- Ship: `phases/ship.md`
- Retro: `phases/retro.md`

## Workflow Pipeline

Skills pass data to each other:
```
/eng plan → produces architecture doc + test plan
    ↓
/eng design → produces DESIGN.md (design system)
    ↓
(user writes code)
    ↓
/eng review → staff engineer diff review, auto-fixes mechanical issues
    ↓
/eng qa → headless browser testing, finds bugs, fixes them
    ↓
/eng ship → tests → version bump → changelog → push → PR
    ↓
/eng retro → weekly metrics and retrospective
```

$ARGUMENTS
