---
name: blog-plot-generator
description: Use when Claude is asked to turn an MDX blog post into publication-ready matplotlib visuals by creating figure scripts, always adding a `plot_00_*` hero splash script, rendering images, wiring embeds/frontmatter image paths, and performing a compressed-image visual QA pass for overlap/layout issues.
---

# Blog Plot Generator

Create article-aware visualizations from MDX content by generating runnable Python scripts and image embeds.

## Workflow

1. Locate the target MDX file and extract the article thesis, major sections, and key claims.
2. Pick a deliberate visual direction (editorial, brutalist, refined minimal, etc.) and one memorable motif to keep all figures cohesive.
3. Draft a visualization plan with 3-5 figures that each explain one specific point from the article.
4. Reserve index `00` for a post-level hero concept; define how it represents the whole article, not one subsection.
5. Define a per-figure layout map before coding (data region, annotation region, empty whitespace for labels).
6. Create `.graphic-generator/<slug>/` and write one Python script per figure, always including `plot_00_<topic>.py` for splash art.
7. Run scripts to render images into `public/blog/<slug>/` (or the project's configured static assets folder).
8. Update the MDX file to include each non-hero figure at the most relevant section.
9. Update MDX frontmatter `image` to the hero output from `plot_00_<topic>.py`.
10. Generate compressed review copies and visually inspect for overlap/layout defects before finalizing.

Always produce between 3 and 5 images inclusive, with one reserved as the hero (`plot_00_*`).

## Figure Selection Rules

- Map each figure to one claim from the article; avoid decorative plots.
- Prefer explanatory chart types: line, bar, scatter, histogram/KDE, box/violin, heatmap, slope chart, before/after comparison.
- Include at least one "mechanism" chart (how something changes) and one "comparison" chart (A vs B).
- Use synthetic or transformed data when the article has no raw dataset, but keep values plausible and label as illustrative in captions or axis labels.
- Name scripts and images predictably using zero-padded indexes:
  - Hero script: `.graphic-generator/<slug>/plot_00_<topic>.py`
  - Hero image: `public/blog/<slug>/hero-<topic>.png`
  - Script: `.graphic-generator/<slug>/plot_01_<topic>.py`
  - Image: `public/blog/<slug>/plot-01-<topic>.png`

## Plot Quality Standard

Use repository plotting utilities for cohesive styling. Do not use seaborn.

- Always import and call `.graphic-generator/utils.py` helpers in every script:
  - `set_mpl()` before creating figures
  - `update_plot(ax)` (or `update_plot_3d`) before save
  - `get_diverging_hex(...)` and/or `get_bar_chart_pair(...)` for color selection
- Keep figure sizes around `(9, 5)` unless a specific chart needs different proportions
- Export with `dpi=180` or higher and `bbox_inches="tight"`
- Remove chart junk (heavy borders, unnecessary ticks, overlong text)

## Aesthetic Direction Rules

Treat each article set like a mini design system, not unrelated charts.

- Choose one primary palette family from `get_diverging_hex(...)` and reuse it consistently across all figures.
- Use one accent family from `get_bar_chart_pair(...)` for highlights/callouts only.
- Keep hierarchy intentional: strong headline, quieter body labels, restrained annotation density.
- Avoid generic defaults: no seaborn themes, no random palette per chart, no template-like layouts.
- Every figure should feel like part of the same story arc and visual identity.

## Splash Infographic Rules

Generate hero/splash art for every blog run (not optional), using `plot_00_<topic>.py`.

Build a multi-region composition with strict separation between text and data.

- Use a `GridSpec` or explicit panel layout with separate axes for:
  - Header/title band
  - Workflow/flowchart panel
  - Data chart panel
  - Supporting note/callout panel
- Hard rule: **text and UI panels must never overlap plotted data regions**.
- Put explanatory copy in dedicated side or top panels, not inside chart coordinates.
- If using chart annotations, place them in blank space only and verify arrow paths avoid data.
- Prefer `fig.savefig(...)` when using figure-level decorative axes/backgrounds; avoid `tight_layout()` warnings from incompatible axes.
- Use filenames:
  - Script: `.graphic-generator/<slug>/plot_00_<topic>.py`
  - Image: `public/blog/<slug>/hero-<topic>.png`

The hero should capture the whole post's thesis and tone. Do not mechanically reuse a fixed template; vary layout and composition per article while preserving readability constraints.

## Compressed Visual QA Pass

After rendering all PNGs, run a second-pass review using compressed copies to quickly surface layout mistakes that are easy to miss at full size.

- Create reduced previews for each output (for example 30-40% scale or JPEG/WebP quality 60-75) under `public/blog/<slug>/_review/`.
- Inspect every compressed preview directly.
- Reject and revise any figure with:
  - Text extending outside callout boxes/cards/panels
  - Labels or annotation arrows colliding with data, other labels, or each other
  - Arrow routes drawn through dense plotted regions when whitespace alternatives exist
  - Excessive dead whitespace or cramped spacing between major components
  - Any panel overlap that breaks visual hierarchy
- Re-render and re-check compressed previews until all figures pass.

## Writing for Naive Readers

Every chart must be understandable by someone who hasn't read the article yet. A reader glancing at the figure should immediately grasp the insight and what to expect from the surrounding text. Apply these rules:

### Titles State the Takeaway, Not the Topic

The title is a headline — it tells the reader **what they should conclude**, not what kind of chart they're looking at.

- BAD: "Lost-in-the-middle effect as context grows (illustrative)"
- BAD: "PRD-first planning reduces total token burn (illustrative)"
- GOOD: "AI models forget what's buried in the middle of a long conversation"
- GOOD: "Writing a plan before prompting dramatically cuts wasted AI effort"

Set titles with `fontsize=11-12`, `fontweight="bold"`, `pad=14`.

### Axis Labels Use Plain English

Translate domain jargon into language anyone can parse. Use parenthetical asides to bridge technical and plain terms.

- BAD: "Retrieval accuracy" / "Context size (thousands of tokens)"
- GOOD: "How accurately the AI recalls it" / "How long the conversation is (thousands of tokens ≈ thousands of words)"

Format axes for instant comprehension:

- Percentages: use `mticker.PercentFormatter(xmax=1.0, decimals=0)` instead of raw 0.0–1.0 decimals
- Large numbers: use commas (`f"{val:,}"`)
- Currency: prefix with `$` (`f"${val:.2f}"`)

### Legend Labels Are Self-Explanatory Phrases

Legend entries should read as short descriptions a newcomer can understand without cross-referencing the article.

- BAD: "Needle near beginning" / "Dictation loop" / "Socratic loop"
- GOOD: "Said near the beginning" / "Just tell it what to do — fix mistakes as you go" / "Ask clarifying questions first, then build"

Use parenthetical clarifiers when helpful: `"Said in the middle  (most forgotten)"`.

### No Unicode Glyphs That May Be Missing from Fonts

Standard fonts (Arial, Inter) lack many Unicode symbols. Never use emoji or special symbols (⚠, ✓, →, etc.) in labels, legends, or annotations — they will render as blank boxes or trigger font warnings. Use plain text instead:

- BAD: `"Said in the middle  ⚠"`
- GOOD: `"Said in the middle  (most forgotten)"`

## Annotation & Callout Rules

Annotations are the highest-value addition to a naive-reader chart. They tell the reader exactly where to look and what to notice. But they must be positioned carefully or they create visual noise.

### Always Add Quantitative Callouts

Every comparison chart should include at least one annotation showing the key numeric difference: "~65% saved", "75% cheaper", "Only 45% recall". Use boxed text for standalone callouts:

```python
ax.text(
    x, y, "~65% saved",
    ha="center", va="center", fontsize=10,
    color="#444", fontweight="bold",
    bbox=dict(boxstyle="round,pad=0.3", fc="white", ec="#ccc", lw=0.8),
)
```

### Position Annotations in Blank Space — Never on Data

Before placing any annotation, mentally map the chart's blank regions:

- **Line charts**: above or below all lines at a given x-range, or to the right of the last data point
- **Bar charts**: in the horizontal gap between bar groups, or above all bar tops
- **Fill areas**: outside the shaded region, not inside it

**Checklist before placing `xytext`:**

1. At this (x, y), does any line, bar, or fill pass through?
2. Does the arrow path from `xytext` to `xy` cross through data?
3. If yes to either, move the text or curve the arrow.

### Curve Arrows Around Data

When a straight arrow from `xytext` to `xy` would cross a plotted line or bar, add a `connectionstyle` to route around it:

```python
arrowprops=dict(
    arrowstyle="->", color=cool, lw=1.0,
    connectionstyle="arc3,rad=0.35"  # positive = curve left, negative = curve right
)
```

### Label Endpoints of Lines

For cumulative or comparison line charts, annotate the final value of each line to the right of the last data point:

```python
ax.annotate(
    f"  {final_value:,} tokens",
    xy=(last_x, final_value),
    xytext=(last_x + 0.08, final_value),
    fontsize=8.5, color=line_color, va="center",
)
```

Expand `xlim` slightly (`ax.set_xlim(start, last_x + 0.8)`) to make room for these labels.

## Footnotes

Add a footnote at the bottom of every figure noting the data is illustrative (when synthetic) and giving a one-line actionable takeaway:

```python
fig.text(
    0.5, 0.01,
    "Illustrative. Tip: put critical instructions at the start or end, never buried in the middle.",
    ha="center", va="bottom", fontsize=7.5, style="italic", color="#555",
)
```

When using footnotes, reserve bottom space in the layout:

```python
plt.tight_layout(rect=[0, 0.04, 1, 1])
```

## Script Template Requirements

For each generated script:

1. Import only required libraries (`matplotlib`, `numpy`, `pandas` as needed) plus `.graphic-generator/utils.py` helpers.
2. Build or load data deterministically (set random seed for synthetic data).
3. Create exactly one figure per script.
4. Ensure output directory exists before saving.
5. Save to the exact expected PNG path in `public/blog/<slug>/`.

Use this structure:

```python
from pathlib import Path
import sys
import numpy as np
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
GEN = ROOT / ".graphic-generator"
if str(GEN) not in sys.path:
    sys.path.append(str(GEN))

from utils import get_diverging_hex, set_mpl, update_plot

set_mpl()

OUT = ROOT / "public/blog/<slug>/plot-01-topic.png"
OUT.parent.mkdir(parents=True, exist_ok=True)

rng = np.random.default_rng(42)

# build data
# plot
update_plot(ax)

plt.tight_layout(rect=[0, 0.04, 1, 1])  # reserve space for footnote
plt.savefig(OUT, dpi=200, bbox_inches="tight")
```

## MDX Embedding Pattern

Insert each generated image near the paragraph it clarifies.

Use standard markdown image syntax unless the repo uses a custom component:

```mdx
![Short descriptive alt text](/blog/<slug>/plot-01-topic.png)
```

Write alt text that states the insight, not just the chart type.

## Completion Checklist

- 3-5 scripts created in `.graphic-generator/<slug>/`
- `plot_00_<topic>.py` exists and generates the hero image
- 3-5 PNG files rendered in `public/blog/<slug>/`
- MDX frontmatter `image` points to `/blog/<slug>/hero-<topic>.png`
- MDX updated with matching image embeds
- Filenames are consistent between scripts and MDX references
- Every figure directly supports a claim from the article
- Hero figure communicates the article-level thesis, not a single subsection only
- Every title states an insight, not a chart description
- Every axis label and legend entry is readable without domain knowledge
- Annotations sit in blank space and arrows don't cross data
- No unicode/emoji glyphs in any text rendered on the figure
- Compressed preview review completed with no overlap/layout defects
