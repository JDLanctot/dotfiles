# Editorial Lenses — Detailed Criteria

## Table of Contents
1. [What Professional Editors Do](#professional-editors)
2. [Lens 1: Steelman](#steelman)
3. [Lens 2: Strawman](#strawman)
4. [Lens 3: Ideation](#ideation)
5. [Lens 4: Artistic Embellishment](#artistic)
6. [Lens 5: Engineered Simplification](#simplification)

---

## 1. What Professional Editors Do {#professional-editors}

Senior developmental editors at publishing houses and journals apply at minimum:

**Structural editing**: Is the document's argument arc correct? Does the beginning set up what the
end resolves? Is the order of sections optimal for the reader's comprehension, or optimal for the
writer's convenience (these often differ)?

**Line editing**: Sentence-level clarity. Does each sentence say exactly one thing? Are subject
and verb adjacent? Is the active voice used where appropriate? Are nominalisations ("the
utilisation of") replaced with verbs ("using")?

**Copyediting**: Consistency of style, spelling, hyphenation, capitalisation, notation. In LaTeX:
consistent use of macros, consistent spacing around operators, consistent citation style.

**Logic auditing**: Does each claim follow from what precedes it? Are there hidden assumptions that
the reader must supply? Are causal claims supported? Are correlational claims misrepresented as
causal?

**Framing auditing**: Is the problem statement biased toward a particular solution? Does the
abstract / introduction accurately represent what the body delivers? Are conclusions stronger than
the evidence warrants?

**Tone calibration**: Is the register consistent? Does the writing condescend, over-qualify, or
claim unearned authority? Is hedging excessive or insufficient for the genre?

**Audience empathy**: Does the document meet the reader where they are? A reader who skips the
background section — will they still follow the argument? A reader who reads linearly — will they
understand each term before it is used?

---

## 2. Lens 1: Steelman {#steelman}

**Role**: Act as the document's most capable advocate. Find the strongest version of every claim
and ensure the text actually makes that strongest case.

**What to look for:**

- **Underspecified claims**: A claim that is true in a strong form but only stated in a weak form.
  Example: "This approach is better" when the data supports "This approach reduces error by 40% in
  the studied regime."
- **Missing evidence**: Claims that are probably true but unsupported. Add citations, quantitative
  specifics, or worked examples that make the claim undeniable.
- **Buried key insight**: The most important idea often appears once, in the middle, without
  fanfare. Elevate it.
- **Incomplete definitions**: Terms used in a technical sense that are only colloquially defined.
  Tighten the definition to foreclose misreading.
- **Missing qualifications that actually strengthen**: Some claims are stronger with a precise
  scope restriction than without one. "This holds for all X with property Y" is stronger than "This
  sometimes holds."
- **Failure to anticipate and rebut**: The document ignores an obvious counter-argument that a
  steelman would address pre-emptively. Addressing it shows command of the field.
- **Weak conclusion language**: Conclusions that hedge when the evidence supports confidence.

**Improvement targets:**
- Replace vague comparatives with quantified claims wherever possible
- Add one well-chosen example or analogy per major claim
- Move the thesis/key claim to the strongest rhetorical position (usually end of intro)
- Ensure every technical term is defined at its first use with precision
- Add a paragraph acknowledging the strongest objection and rebutting it

---

## 3. Lens 2: Strawman {#strawman}

**Role**: Act as the harshest credible critic. Find every point where a reader could dismiss,
misread, or legitimately object to the argument.

**What to look for:**

- **Non-sequiturs**: A concludes B, but B does not follow from A without an unstated premise.
  Make the unstated premise explicit or justify it.
- **Circular reasoning**: The conclusion is assumed in the premises. "X is correct because it
  follows the correct procedure" when the correctness of the procedure is what is being established.
- **False dichotomy**: "Either A or B; not A; therefore B" when C, D, and E are also possible.
- **Overgeneralisation**: A result demonstrated in a specific setting is claimed to hold generally.
- **Conflation**: Two distinct concepts treated as equivalent. Common examples: probability and
  frequency, correlation and causation, sufficiency and necessity.
- **Undefined scope**: Claims with no stated domain of applicability are trivially vulnerable.
- **Unsupported causal claims**: "X causes Y" requires more than correlation or temporal sequence.
- **Missing base rates**: Relative improvements ("50% better") without absolute baselines are
  misleading.
- **Straw-manning the opposition**: If the document dismisses competing views, are those views
  represented fairly? Misrepresenting opposition weakens credibility.
- **Rhetorical sleight of hand**: Loaded language, question-begging terms, or emotional appeals
  substituting for argument.
- **Gaps in logic chain**: Steps A to B to C where B to C is asserted but not demonstrated.
- **Inconsistent standards**: Evidence held to different standards depending on whether it supports
  or undermines the thesis.

**Improvement targets:**
- Write out the logical form of each major argument; verify validity
- For each causal claim, state the mechanism explicitly or downgrade to correlation
- Add explicit scope qualifiers to every generalisation
- Replace loaded terms with neutral descriptions where the argument can stand without them

---

## 4. Lens 3: Ideation {#ideation}

**Role**: Act as an expansionist intellectual. Identify what the document implicitly points toward
but does not pursue — novel extensions, analogies, related causes, tangential implications that
would enrich the reader's mental model.

**What to look for:**

- **Unexplored analogies**: The document's structure or argument mirrors a well-known result in
  another domain. Naming the analogy lets readers apply their existing knowledge.
- **Missing upstream causes**: The document explains phenomenon X but does not ask what causes X,
  when a cause is knowable and relevant.
- **Missing downstream implications**: The result implies consequence Y but the document stops
  before naming it.
- **Adjacent open problems**: The framework developed could be applied to a related unsolved
  problem. Noting this scopes future work.
- **Counter-intuitive corollaries**: Results that are technically implied but not stated because
  they seem surprising. Stating them increases the document's intellectual payoff.
- **Historical or disciplinary context**: The argument replicates, extends, or contradicts prior
  work in a way that is not acknowledged. Noting the lineage gives the reader a map.
- **Generalization opportunities**: A result proven for a specific case generalises. Noting the
  generalization (even informally) increases the paper's apparent contribution.
- **Practical applications left unstated**: Theoretical results with obvious engineering or policy
  implications that the document does not mention.

**Improvement targets:**
- Add one "this is analogous to..." sentence per major result where an analogy exists
- Add a "implications for..." sentence or paragraph per major finding
- Add a brief "future work" or "open questions" note if the document is technical
- Name the intellectual lineage explicitly in the introduction or background

---

## 5. Lens 4: Artistic Embellishment {#artistic}

**Role**: Act as a prose stylist and rhetorician. Find every place where the writing is technically
correct but inert. Make the reader want to keep reading.

**What to look for:**

- **Weak opening**: The first sentence or paragraph does not create tension, curiosity, or a strong
  image. A reader should not be able to put the document down after the first paragraph.
- **Burying the lede**: The most interesting claim appears halfway through. Move tension to the
  front.
- **Uniform sentence rhythm**: Paragraphs where all sentences have the same length and structure
  feel like a list. Vary rhythm: long sentences build complexity, short ones land conclusions.
- **Nominalisation and passive voice overuse**: "The utilisation of the method was performed by the
  team" vs. "The team used the method." Active verbs move writing forward.
- **Abstract without concrete**: Every abstract claim needs at least one concrete instantiation.
  The reader's mind grips concrete images, not abstractions.
- **Flat transitions**: "Furthermore", "In addition", "Moreover" are connective tissue without
  meaning. Replace with transitions that state the logical relationship.
- **Missing the emotional stakes**: Even technical writing has stakes. What is lost if this problem
  goes unsolved? What is gained? Naming this creates urgency.
- **Ending on a whimper**: Conclusions that summarise rather than resonate. The last sentence
  should leave the reader with something to think about, not a recap of what they just read.
- **Over-hedging**: Excessive "it could be argued that", "it may be the case that", "perhaps"
  hedges weaken the author's voice without adding intellectual honesty. Reserve hedges for genuine
  uncertainty.

**Improvement targets:**
- Rewrite the opening sentence to create immediate tension or curiosity
- Find the single most interesting claim and move it earlier
- Vary sentence length: identify any paragraph where all sentences are within 5 words of the same
  length and break the rhythm
- Replace 3 flat transitions with transitions that name the logical move
- Rewrite the final sentence to resonate rather than recap

---

## 6. Lens 5: Engineered Simplification {#simplification}

**Role**: Act as a technical minimalist. Cut everything that does not carry weight. Reduce every
sentence to its load-bearing structure.

**What to look for:**

- **Redundant pairs**: "Each and every", "null and void", "first and foremost" — one word does the
  work.
- **Empty throat-clearing**: Introductory clauses that delay the sentence's subject. "It is worth
  noting that X" -> "X." "The fact that X is the case" -> "X."
- **Over-explained obvious steps**: In technical documents, steps a competent reader would perform
  automatically. In persuasive documents, inferences the reader can draw themselves.
- **Excessive qualification in body text**: If every sentence has a hedge, the document is
  unreadable. Move qualifications to footnotes or a limitations section where they belong.
- **Duplicate information**: The same fact stated in the abstract, intro, body, and conclusion. The
  intro should forward-reference; the conclusion should not just repeat.
- **Zombie nouns**: Nominalisations that can be converted to verbs: "the achievement of agreement"
  -> "agreeing", "the demonstration of X" -> "demonstrating X" or just "X".
- **Long paragraphs with one idea**: If a 10-sentence paragraph contains one claim, it can usually
  be cut to 3-4 sentences without losing anything.
- **Overlong examples**: An example should illuminate one point. Any sentence in an example that
  does not serve that point should be cut.
- **Unnecessary background**: Background sections that explain things the target audience already
  knows.
- **Nested clauses that obscure the main verb**: Untangle by splitting into two sentences.

**Improvement targets:**
- Remove all "it is worth noting that" / "it is important to emphasize" constructions
- Cut every paragraph by at least 10% by removing redundancy without removing content
- Identify the three longest sentences in the document; restructure at least two of them
- Convert five nominalisations to active verbs
- Identify any section where the same information appears more than once; cut the weaker instance
