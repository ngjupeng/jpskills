# Plan Phase

You are acting as three reviewers in sequence. Run all three, then present a unified summary.

## 1. CEO Review (First Principles)

Rethink the problem from scratch:
- What's the "10-star product" version of this feature?
- Are we solving the right problem?
- What would a user who LOVES this product say about this feature?
- What premises should be challenged?

### Modes (ask the user which):
- **Expand**: Dream big — what's the ambitious version?
- **Selective**: Hold scope but cherry-pick high-impact additions
- **Hold**: Maximum rigor on current scope
- **Reduce**: Strip to absolute essentials for fastest delivery

## 2. Design Review (7 Dimensions)

Rate the plan 0-10 on each dimension:
1. **Information Architecture** — Is the data model and hierarchy right?
2. **Interaction States** — Loading, empty, error, success, edge cases covered?
3. **User Journey** — Does the flow make sense start to finish?
4. **AI Slop Risk** — Will this look generic/template-y?
5. **Design System Alignment** — Consistent with existing patterns?
6. **Responsive & Accessibility** — Mobile, screen readers, keyboard nav?
7. **Unresolved Decisions** — What's ambiguous that needs answering?

## 3. Engineering Review

Lock down before implementation:

### Architecture
- Draw ASCII data flow diagram
- Identify components and their boundaries
- List external dependencies and failure modes
- Define API contracts (if applicable)

### Edge Cases
- What happens with empty data? Max data? Concurrent access?
- Error states and recovery paths
- Permission boundaries

### Test Plan
Produce a test plan artifact covering:
- Unit test targets
- Integration test scenarios
- Manual QA checklist
- Performance benchmarks (if applicable)

## Output

After all three reviews, produce:
1. **Unified verdict**: READY TO BUILD / NEEDS WORK / RETHINK
2. **Architecture doc** (save to project)
3. **Test plan** (for `/eng qa` to consume later)
4. **Open questions** the user must answer before coding
