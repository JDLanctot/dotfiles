---
name: latex-proof-explorer
description: Analyzes a LaTeX mathematics or physics paper and proposes proof trajectories that could verify or challenge its framework, then writes those proofs in LaTeX and stress-tests them with adversarial subagent review. Use when asked to identify potential proofs, derive results, write proofs in LaTeX, stress-test mathematical claims, propose what someone would try to prove or disprove, strawman or steelman a framework, or generate adversarial feedback on a proof. Triggers on phrases like "what proofs would verify this", "write a proof for", "derive this result", "what would challenge this framework", "steelman/strawman these ideas", "propose proof directions", or "review this proof adversarially".
---

# LaTeX Proof Explorer

## Overview

Three-phase skill: (1) read a LaTeX paper and propose proof trajectories with strawman/steelman analysis, (2) write chosen proofs in LaTeX using the document's own environments, (3) stress-test each proof with three independent adversarial reviewers and implement user-approved fixes.

## Phase 1: Read the Paper and Propose Trajectories

### Discover document structure

Read `main.tex` to find:
- Which sections are included via `\input{}` or `\include{}`
- Which `.cls` or `.sty` files define the theorem environments
- Any custom commands or macros relevant to the mathematics

Read the `.cls`/`.sty` to catalogue available theorem-like environments and math packages before writing any LaTeX.

### Read the mathematics

Read each section file. Extract:
- Every postulate, definition, axiom, proposition, lemma, theorem, and conjecture
- All boxed or named equations (`\label{eq:...}`)
- Claims explicitly marked as "pending proof", "conjectured", "sketch", or "open"
- Remarks that flag unresolved assumptions or boundary conditions
- Results imported from prior literature without re-derivation

### Propose 3-5 proof trajectories

For each trajectory provide:

**Starting point** -- a specific labeled equation, definition, or postulate in the paper.

**Target** -- a specific result the trajectory aims to reach or refute (either a claim in the paper, or a known result from the literature the framework should reproduce).

**Bridge** -- the mathematical techniques connecting them: e.g., substitution, chain rule, dimensional analysis, limiting case, variational principle, symmetry argument, inequality chain, perturbation expansion, topological invariant, generating function, etc. Be specific about which intermediate steps are needed.

**Strawman** -- the single strongest reason this trajectory fails: a missing hypothesis, a dimensional mismatch, a known counterexample, a circular dependency, an unjustified approximation, or a step that is true in the special case but false in general.

**Steelman** -- the single strongest reason this trajectory succeeds: an analogy with an established result in another domain, a known consistency condition the approach satisfies, or evidence that the techniques are well-matched to the structure of the problem.

Frame each as: "Starting from [label], one would apply [technique] to reach [target], because [physical/mathematical motivation]."

See `references/proof-techniques.md` for a taxonomy of applicable techniques across domains.

## Phase 2: Write the Proof in LaTeX

Once the user selects a trajectory, write the proof using the document's existing environments (discovered in Phase 1).

General conventions applicable to most LaTeX math documents:
- Use `\begin{proof}...\end{proof}` for the proof body (amsthm)
- New results: `\begin{lemma}`, `\begin{proposition}`, or `\begin{theorem}` as appropriate
- Assign `\label{...}` to every new result and every key step
- Cross-reference existing paper results via `\ref{eq:...}`, `\ref{prop:...}`, etc.
- Make each logical step explicit -- do not skip steps that the adversarial review will target
- Flag every place where an assumption is being used with a comment `% assumes: ...`

Write the proof as a standalone LaTeX fragment that can be inserted into the paper's source.

## Phase 3: Adversarial Review

After writing a proof, invoke the **`adversarial-proof-review`** skill, passing it the completed proof LaTeX fragment. That skill handles everything: spawning three independent parallel reviewers, merging and prioritizing their feedback, walking through the user approval loop, implementing approved fixes, and offering to re-run the review on the revised proof.

## Resources

- **`references/proof-techniques.md`**: Taxonomy of mathematical and physical proof techniques across domains
