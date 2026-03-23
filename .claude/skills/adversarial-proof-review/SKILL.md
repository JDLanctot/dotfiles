---
name: adversarial-proof-review
description: Stress-tests a mathematical or physical proof by spawning three independent adversarial reviewer subagents in parallel, each seeing only the proof with no surrounding context. Merges their feedback, presents it to the user for approval issue by issue, then implements the approved fixes. Use when asked to review a proof adversarially, find holes in a proof, stress-test a derivation, get adversarial feedback on a mathematical argument, or when another skill (e.g. latex-proof-explorer) needs to run the review phase on a completed proof. Triggers on phrases like "review this proof", "find holes in this", "adversarial review", "stress-test this derivation", "what's wrong with this proof", or "can you critique this".
---

# Adversarial Proof Review

## Overview

Spawn three independent adversarial reviewer subagents in parallel, each receiving only the proof text. Collect, merge, and prioritize their findings. Walk the user through each issue for approval. Implement approved fixes.

## Step 1: Launch Three Parallel Reviewers

Spawn three subagents simultaneously using the Task tool with `subagent_type: general-purpose`. Each receives **only the proof** — no paper, no context, no framing beyond the reviewer prompt below. Fresh context is the point: the reviewers should not have access to the author's intent or surrounding explanation.

### Reviewer prompt template

Pass each subagent exactly this prompt, substituting `[PROOF]` with the proof text:

```
You are reviewing a mathematical proof. Your role is adversarial: find every flaw, gap, or weakness. Do not give credit for steps that merely look plausible.

Examine the proof for:
1. Logical gaps -- steps asserted without justification
2. Unsubstantiated claims -- results used but not proved or cited
3. Dimensional or units inconsistencies
4. Unjustified approximations, limits, or truncations
5. Missing hypotheses or boundary conditions required for the argument to hold
6. Circular reasoning -- the conclusion used (directly or indirectly) in its own proof
7. Counterexamples -- a specific case where the argument breaks down
8. Scope creep -- the result claimed is stronger than what the proof actually establishes
9. Notational ambiguities that could conceal errors
10. Dependence on results that are themselves unproved or only conjectured

Return a numbered list of issues. For each issue state:
- Which line, step, or expression is affected (quote it if possible)
- What specifically is wrong
- Severity: FATAL (the proof does not work as written) or FIXABLE (can be patched with an additional lemma, hypothesis, or caveat)

Do not suggest fixes. Only identify problems. Be terse.

PROOF:
[PROOF]
```

## Step 2: Merge and Present Feedback

After all three reviewers return, consolidate their findings:

- Assign each unique issue a number (I-1, I-2, ...)
- Record which reviewers raised it (R1, R2, R3)
- Mark any issue raised by two or more reviewers as **HIGH PRIORITY**
- Group by severity: FATAL issues first, then FIXABLE
- Strip near-duplicates (same step, same flaw, different wording -- keep the clearest formulation)

Present the merged list to the user in this format:

```
FATAL issues
------------
[I-1] [R1, R2] **HIGH PRIORITY** Step 3 -- "...quoted text..." -- [issue description]
[I-2] [R3]     Step 7 -- [issue description]

FIXABLE issues
--------------
[I-3] [R1, R2, R3] **HIGH PRIORITY** Equation (4) -- [issue description]
[I-4] [R2]          Hypothesis -- [issue description]
```

## Step 3: User Approval Loop

For each issue, ask: **approve fix** or **dismiss**.

- If the user wants to batch-approve or batch-dismiss, accept that.
- If the user wants to discuss an issue before deciding, engage briefly, then ask again.
- Keep a running tally of approved vs dismissed issues.

Do not begin implementing fixes until the user has made a decision on every issue (or explicitly says to start with what has been approved so far).

## Step 4: Implement Approved Fixes

Work through approved issues in order of severity (FATAL first):

- **FIXABLE**: add the missing lemma, hypothesis, citation, or caveat and patch the affected step in the proof
- **FATAL**: identify the root cause of the failure, propose an alternative approach for the broken step, and ask the user to confirm the direction before rewriting

After all fixes are applied, present the complete revised proof.

Offer to re-run the adversarial review on the revised proof (Step 1--4 again). This is particularly useful after fixing FATAL issues, which can expose new gaps.
