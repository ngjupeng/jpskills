---
name: handoff
description: a HANDOFF.md file for the current session so the next Claude instance can continue seamlessly.
---

Write a HANDOFF.md file for the current session so the next Claude instance can continue seamlessly.

## Required Sections

### Current Progress
- What task was being worked on
- What's been completed
- What's partially done

### What Worked
- Approaches that succeeded
- Key decisions made and why

### Dead Ends
- What was tried and failed
- Why it failed (so next instance doesn't retry)

### Current State
- Files modified (list with brief description of changes)
- Any uncommitted changes
- Test/build status

### Next Steps
- Concrete, ordered list of what to do next
- Any blockers or open questions

### Key Context
- Architecture decisions that aren't obvious from code
- Constraints or requirements that were discussed
- Any user preferences expressed during session

Write this to `HANDOFF.md` in the current working directory.
