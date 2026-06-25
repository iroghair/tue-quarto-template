# TU/e Quarto Presentation Templates

This project provides a local Quarto presentation setup with both:
- a widescreen Reveal.js deck and TU/e-inspired cover slide
- a TU/e Beamer PDF deck based on the bundled LaTeX theme

## Files

- `template.qmd`: minimal starter Reveal.js deck — edit this for new presentations.
- `presentation.qmd`: full showcase of all available slide layouts (requires Python/Jupyter for code slides; see below).
- `presentation-beamer.qmd`: starter TU/e Beamer PDF deck using the extension format `tue-beamer`.
- `_quarto.yml`: Quarto project settings.
- `_extensions/tue/`: local project support files, including the original TU/e Beamer assets plus the Reveal cover-slide filter and CSS.
- `_extensions/tue/title-slide.lua`: metadata-driven cover slide generator for Reveal.js.
- `_extensions/tue/assets/tue-reveal.css`: TU/e Reveal styling, including the semi-transparent scarlet cover band.
- `assets/tue-cover-background.jpg`: title-slide background extracted from the TU/e corporate PowerPoint.

## Installation

There are two ways to use this theme, depending on your workflow.

### Option 1 — New project from scratch (`quarto use template`)

Creates a new folder with the extension, starter assets, and a minimal `template.qmd` ready to edit:

```bash
quarto use template iroghair/tue-quarto-template
```

Quarto will ask for a directory name. The resulting folder is a self-contained project — open `template.qmd` and start editing.

### Option 2 — Add to an existing project (`quarto add`)

Installs only the `_extensions/tue/` format into your current project:

```bash
quarto add iroghair/tue-quarto-template
```

Then set `format: tue-revealjs` (or `tue-beamer`) in your `.qmd` front matter and provide your own cover image and logo assets.

## Usage

Render the Reveal deck with:

```bash
quarto render template.qmd
```

Render the Beamer PDF deck with:

```bash
quarto render presentation-beamer.qmd
```

The Reveal cover slide is generated from document metadata. Update `title`, `subtitle`, `author`, `date`, `tue-cover-image`, and `tue-cover-logo` in your `.qmd` file to customize it.

### Running the demonstration file with Python code

`presentation.qmd` contains executable Python code blocks (plots, computations) that require a Jupyter kernel. The project ships a `pyproject.toml` and `uv.lock` to reproduce the exact environment.

[Install uv](https://docs.astral.sh/uv/getting-started/installation/) if you don't have it, then install the environment once:

```bash
uv sync
```

Then render through uv so that Quarto picks up the managed Python environment:

```bash
uv run quarto render presentation.qmd
```

The widescreen Reveal.js defaults live in `_quarto.yml`, so new `.qmd` decks in this folder will inherit the same layout and styling.

## TU/e Colour Palette

All colours are exposed as CSS custom properties in `_extensions/tue/assets/tue-reveal.css` and can be referenced as `var(--tue-<name>)` in any inline style or custom class.

| Variable | Hex | Swatch | Role |
|----------|-----|--------|------|
| `--tue-scarlet` | `#c81818` | 🟥 | Primary brand |
| `--tue-deep-blue` | `#101073` | 🟦 | Secondary brand (PMS 2748) |
| `--tue-light-grey` | `#f1efef` | ⬜ | Slide background |
| `--tue-warm-red` | `#f73131` | 🔴 | Legacy warm red |
| `--tue-cyan` | `#00a2de` | 🔵 | Process Cyan |
| `--tue-pink` | `#d6004a` | 🩷 | PMS 206 |
| `--tue-blue` | `#0066cc` | 💙 | PMS 300 |
| `--tue-purple` | `#ad20ad` | 🟣 | PMS 253 |
| `--tue-orange` | `#ff9a00` | 🟧 | PMS 137 |
| `--tue-yellow` | `#ffdd00` | 🟨 | PMS Yellow 012 |
| `--tue-yellow-green` | `#cedf00` | 🟩 | PMS 396 |
| `--tue-green` | `#84d200` | 💚 | PMS 375 |

## Callout / Text-Box Classes

Position these anywhere on a slide using `.absolute` with `top`, `left`, `right`, `bottom` attributes. All styling (colours, padding, borders) is handled by the class — only positioning is needed in the markup.

| Class | Appearance | Usage |
|-------|-----------|-------|
| `.tue-box-key` | White card, scarlet border, subtle shadow | Key findings, important results |
| `.tue-box-secondary` | Deep-blue background, white text, smaller font | Side notes, secondary info |
| `.tue-box-callout` | Light scarlet tint, thick left border | Callouts, warnings, highlights |

### Example

```markdown
::: {.absolute .tue-box-key top=120 left=200}
**Key Finding** — Reaction rate doubles above 800 °C.
:::

::: {.absolute .tue-box-secondary top=400 left=80}
Supplementary detail placed freely on the canvas.
:::

::: {.absolute .tue-box-callout top=260 right=160}
Callout box — draws audience attention.
:::
```

## Morph Boxes

Animated shape transitions between slides using Reveal.js `auto-animate`. Combine the base class `.tue-morphbox` with shape and colour modifiers. Only `width`, `height`, and optionally `margin` need to be set inline.

### Shape modifiers

| Class | Shape |
|-------|-------|
| *(base)* | Rounded rectangle (16 px radius) |
| `.tue-morphbox--pill` | Pill / stadium (60 px radius) |
| `.tue-morphbox--circle` | Circle (50% radius) |

### Colour modifiers

| Class | Colour |
|-------|--------|
| `.tue-morphbox--scarlet` | TU/e Scarlet |
| `.tue-morphbox--deep-blue` | TU/e Deep Blue |
| `.tue-morphbox--cyan` | TU/e Cyan |
| `.tue-morphbox--orange` | TU/e Orange |
| `.tue-morphbox--green` | TU/e Green |
| `.tue-morphbox--purple` | TU/e Purple |
| `.tue-morphbox--pink` | TU/e Pink |
| `.tue-morphbox--blue` | TU/e Blue |

### Example (3-slide morph sequence)

```markdown
## Step 1 {auto-animate=true}

::: {.tue-morphbox .tue-morphbox--scarlet data-id="demo" style="width:220px;height:220px;"}
Start
:::

## Step 2 {auto-animate=true}

::: {.tue-morphbox .tue-morphbox--pill .tue-morphbox--deep-blue data-id="demo" style="width:600px;height:120px;"}
Wider
:::

## Step 3 {auto-animate=true}

::: {.tue-morphbox .tue-morphbox--circle .tue-morphbox--cyan data-id="demo" style="width:320px;height:320px;"}
Round
:::
```

The `data-id` attribute must match across slides for Reveal.js to animate the transition.
