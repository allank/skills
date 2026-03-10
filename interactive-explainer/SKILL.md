---
name: interactive-explainer
inspired-by: https://simonwillison.net/guides/agentic-engineering-patterns/interactive-explanations/
description: Builds a self-contained interactive HTML visualisation that makes a process, algorithm, decision logic, or system visually and experientially understandable. Primary input is a linear walkthrough, but works directly from code, documents, or concept descriptions too — and can invoke the linear-walkthrough skill as an intermediate step if the source material lacks sufficient clarity or structure. Use when the user wants to "see how this works", wants an interactive version of a walkthrough, wants to explain a process visually to an audience, or asks to "visualise", "animate", or "build an interactive explanation" of anything. Richer and more interactive is always preferred, as long as it makes the logic clearer rather than decorating it.
---

# Interactive Explainer

You build interactive HTML visualisations that make abstract processes, algorithms, and decision logic _experiential_ — something the reader can manipulate and explore, not just read. The goal is to eliminate cognitive debt: after using the visualisation, the reader should feel like they _understand_ the logic, not just that they've seen it described.

## Source Material

Preferred input is a **linear walkthrough** (from the `linear-walkthrough` skill), because walkthroughs are already structured as a logical narrative with clear sections and identified connections. If none exists:

- Work directly from source material (code, document, concept description)
- If the source material is dense, ambiguous, or poorly structured, **invoke the `linear-walkthrough` skill first** to extract a clear narrative, then use that as input. This produces better visualisations than trying to interpret raw complexity directly.

## Before You Build

Identify two things:

### 1. What is the core thing to make understandable?

Read the walkthrough and ask: _what is the single most important thing a reader struggles to grasp from reading alone?_ This is usually one of:

- A **decision algorithm** — branching logic that leads to different outcomes based on inputs
- A **sequential process** — stages that execute in order, each transforming something
- A **system with interacting parts** — components that affect each other
- A **concept with a key mechanism** — an abstract idea that becomes clear when you can "turn the dial"

The visualisation should be built around _that one thing_, not an exhaustive diagram of everything.

### 2. What visualisation type fits?

| Core content                         | Visualisation type                                                                                   |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------- |
| Decision algorithm / flowchart       | **Interactive decision tree** — live inputs that traverse the logic and highlight the resulting path |
| Sequential pipeline / process stages | **Animated step-through** — stages that activate in sequence with explanations at each step          |
| System with interacting components   | **Clickable component diagram** — click to explore each part; relationships animate on hover/click   |
| Parameter-driven concept             | **Live explorer** — sliders/inputs that change the output in real time, showing cause and effect     |
| Comparative options                  | **Side-by-side toggle** — switch between options and see what changes                                |

If the content is complex enough to merit it, combine types — e.g. a decision tree that also shows parameter effects as sliders. Richer is better _if it adds clarity_. Never add visual complexity that requires the user to understand the visualisation before they can understand what it's visualising.

**Propose the approach briefly before building.** One sentence on what you'll build and why, then proceed unless the user redirects. Don't wait for approval — describe and build.

## Building the HTML

### Output requirements

- **Single self-contained `.html` file** — all CSS and JavaScript inline, no external file dependencies
- **CDN libraries are permitted** when they meaningfully improve the output (D3.js for complex graphs, Chart.js for data, anime.js for animation). Note any CDN dependencies so the user knows an internet connection is needed to render them. Prefer libraries hosted on reliable CDNs (cdnjs, unpkg, jsdelivr).
- **Vanilla JS is preferred** for simple interactions — don't pull a library for something you can do cleanly in 30 lines of JS

### Design principles

**Clarity before richness.** Every visual element should earn its place by making the logic clearer. If removing something makes the visualisation easier to understand, remove it.

**Interactive, not passive.** The user should be able to change something and see the logic respond. A static diagram is documentation; an interactive one is understanding.

**Self-orienting.** The visualisation should include:

- A clear title
- A one-line description of what it shows
- Brief labels or tooltips on interactive controls so the user knows what they're manipulating

**Smooth and intentional.** Transitions should be smooth (200–400ms CSS transitions for most things). Animation should have a purpose — use it to show _movement through logic_ (a path being highlighted, a stage activating), not decoration.

### Visual style

Use a clean, modern design. Suggested defaults:

```css
/* Colour palette */
--bg: #f8f9fa;
--surface: #ffffff;
--border: #e2e8f0;
--text-primary: #1a202c;
--text-secondary: #718096;
--accent: #4f46e5; /* active / selected state */
--accent-light: #eef2ff; /* highlight backgrounds */
--success: #059669; /* terminal / result states */
--warning: #d97706; /* warning callouts */
--muted: #cbd5e0; /* inactive / disabled */

/* Typography */
font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
```

For node/flowchart diagrams:

- Active/selected nodes: `accent` fill, white text
- Inactive nodes: `surface` fill, `border` stroke, `text-secondary` text
- The _current path_ through a decision tree should be clearly highlighted vs the greyed-out unchosen branches

### Patterns for common visualisation types

#### Interactive decision tree

Structure: inputs on the left or top; the tree in the centre; result panel at the bottom or right.

- Inputs should be the actual decision parameters (sliders, dropdowns, toggles)
- As inputs change, the active path through the tree updates in real time — highlight the traversed nodes and dim the unchosen branches
- The result card shows the outcome with a brief explanation of _why_ this path was taken
- Avoid drawing the entire tree if it's large — show the active path prominently and collapse or dim unused branches

#### Animated step-through

Structure: a linear sequence of stages across the top or side; a detail panel that shows what's happening at the current stage.

- Each stage is a card or node; the active one is highlighted
- Prev/Next controls (and optionally auto-play with speed control)
- The detail panel explains the stage in plain language — this is not just a label, it's the "tour guide" commentary
- Animate transitions between stages (content fades, progress bar advances)

#### Live explorer

Structure: controls (sliders, inputs) in a sidebar; the main area shows the output updating in real time.

- Label every control clearly with its name and current value
- Show cause-and-effect — when a parameter changes, the thing that changes in the output should be visually obvious (highlight it briefly, animate it)
- Include axis labels, legends, or annotations as needed

## Saving and opening

Save to:

```
/Users/allan/Documents/AIBrain/03. Resources/Walkthroughs/<name>.html
```

Name it after the source walkthrough or subject matter — e.g. `Interactive - Pricing Strategy Selection.html`.

After saving, you MUST open it in the default browser immediately — do not ask the user to do this:

```bash
open "/Users/allan/Documents/AIBrain/03. Resources/Walkthroughs/<name>.html"
```

Run this command yourself before finishing. Then tell the user where the file was saved and confirm it's open.
