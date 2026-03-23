---
name: document-editor
description: >
  Editorial review and improvement of written documents (LaTeX, Markdown, Word, plain text, prose).
  Use when the user asks to edit, review, improve, or polish a document in the editorial sense:
  catching logical errors, framing problems, argument structure, style, clarity, and persuasive
  force. Triggers on phrases like "edit this", "review my writing", "improve this document",
  "act as an editor", "polish this", "give me editorial feedback", "make this better".
  Does NOT apply to code review, summarization, or fact-checking tasks.
---

# Document Editor

A five-lens editorial workflow that maps a document across five professional editorial perspectives,
synthesizes a balanced edit, then refines based on user satisfaction feedback.

Read `references/editorial-lenses.md` before beginning. It contains detailed criteria for each lens.

## Phase 1: Document Reconnaissance

Read the full document. Produce a brief internal map (do not show to user unless asked):

- Core claim / thesis
- Intended audience
- Document type (argument, explainer, narrative, technical, hybrid)
- Approximate register (formal, academic, conversational, persuasive)
- Obvious structural units (sections, paragraphs, logical steps)

This map informs all five lenses.

## Phase 2: Five-Lens Analysis

Apply all five lenses to the document. For each lens, produce a concise **improvement plan** (a
prioritized list of specific changes, not a rewrite). Present all five plans to the user before
touching the document.

### The Five Lenses

| Lens                          | Role                          | Core question                                          |
| ----------------------------- | ----------------------------- | ------------------------------------------------------ |
| **Steelman**                  | Strongest possible defender   | How do we make every argument bulletproof?             |
| **Strawman**                  | Sharpest possible critic      | Where will a hostile reader push back hardest?         |
| **Ideation**                  | Expansionist thinker          | What tangents, analogies, or implications are missing? |
| **Artistic Embellishment**    | Rhetorician / prose stylist   | What would make this impossible to put down?           |
| **Engineered Simplification** | Technical editor / minimalist | What can be cut or compressed without losing meaning?  |

See `references/editorial-lenses.md` for detailed criteria and professional editorial standards
applied within each lens.

### Output Format for Phase 2

Present as five numbered sections. Each section: lens name, 3-7 specific actionable improvements
with a one-sentence rationale each. Example entry:

> **3. Strengthen the transition at paragraph 4** — The current transition ("Furthermore...") does
> not signal the logical shift from evidence to conclusion; replace with a sentence that names the
> inference explicitly.

## Phase 3: Democratic Synthesis

Before editing, identify overlapping concerns across lenses. Prioritize changes that satisfy
multiple lenses simultaneously (e.g., a Strawman weakness that can be fixed by a Steelman
addition that also enables Simplification). Flag genuine tensions (e.g., Artistic Embellishment
wants a longer anecdote; Simplification wants it cut) and resolve each tension explicitly with a
brief rationale for which lens wins and why.

Produce a **consolidated edit plan** listing all changes in document order, with the lens(es) that
motivated each change noted in brackets.

## Phase 4: Apply the Consolidated Edit

Edit the document. Preserve the document's format (LaTeX commands, Markdown syntax, Word styles).
Do not restructure sections unless the synthesis plan explicitly calls for it.

After editing, present the revised document (or the changed sections for long documents) and a
`Summary of Changes` section that maps each major change to its guiding lens force(s).

### Required `Summary of Changes` Format

List 4-8 major edits in document order. For each item include:

- **Change**: what was changed (specific, not generic)
- **Why**: editorial rationale in one sentence
- **Guiding lens force(s)**: one or more from Steelman, Strawman, Ideation,
  Artistic Embellishment, Engineered Simplification

Use this compact format:

`1) <change> - Why: <rationale> - Guiding lens force(s): <lens list>`

This mapping is mandatory because it gives the user context to answer the phase-5 Likert ratings.

### Example `Summary of Changes`

`1) Replaced a broad opening claim with a scoped thesis sentence - Why: narrows overclaim risk and makes the argument defensible - Guiding lens force(s): Steelman, Strawman`

`2) Added a concrete analogy after the second paragraph - Why: improves accessibility for non-specialist readers without changing technical accuracy - Guiding lens force(s): Ideation, Artistic Embellishment`

`3) Cut repetitive transition text between sections 3 and 4 - Why: reduces drag and improves pacing while preserving meaning - Guiding lens force(s): Engineered Simplification`

`4) Added one sentence naming the inference from evidence to conclusion - Why: closes a logical gap a critical reader would challenge - Guiding lens force(s): Steelman, Strawman`

## Phase 5: Likert Feedback and Refinement

After presenting the edited document, collect satisfaction ratings using the AskUserQuestion tool.
Ask two batches (the tool supports up to 4 questions per call):

Before asking the Likert questions, explicitly reference the just-shown `Summary of Changes` as the
basis for scoring each lens.

**Batch 1 (4 questions):** Steelman, Strawman, Ideation, Artistic Embellishment
**Batch 2 (1 question):** Engineered Simplification

For each lens, ask: "How satisfied are you that [lens goal] was applied to this document?"
Use a 1-5 scale: 1 = Not nearly enough, 3 = About right, 5 = Far too much.

### Interpretation and Refinement

| Rating | Action                                                          |
| ------ | --------------------------------------------------------------- |
| 1 or 2 | Apply significantly more of this lens                           |
| 3      | No further changes for this lens                                |
| 4 or 5 | Dial back this lens (if reversible); note for future iterations |

For lenses rated 1 or 2, produce a **targeted refinement pass** applying more of those lenses
specifically, without undoing changes from lenses rated 3 or above. Present the refined document
and a brief diff summary.

If multiple lenses are rated low, apply them in a single combined refinement pass. If a low-rated
lens conflicts with a high-rated lens, honor the high-rated lens and note the constraint to the user.

## Professional Editorial Standards Applied Throughout

Beyond the five lenses, apply these baseline professional standards at all times:

- **Logic and argument structure**: Identify non-sequiturs, unsupported leaps, circular reasoning,
  false dichotomies, and misattributed causation
- **Framing**: Identify when the problem is stated in a way that precludes the best solution, or
  when the conclusion is implied before the argument is made
- **Consistency**: Flag terminology drift, contradictory claims, and inconsistent notation
- **Audience calibration**: Flag jargon undefined for the stated audience; flag over-explanation
  for an expert audience
- **Proportionality**: Identify sections that spend more words than their importance warrants
- **Claims vs. evidence**: Mark every unsupported empirical claim
