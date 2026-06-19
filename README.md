# TU/e Quarto Presentation Templates

This project provides a local Quarto presentation setup with both:
- a widescreen Reveal.js deck and TU/e-inspired cover slide
- a TU/e Beamer PDF deck based on the bundled LaTeX theme

## Files

- `presentation.qmd`: starter widescreen Reveal.js deck with an automatically generated TU/e-style cover slide and a few sample content slides.
- `presentation-beamer.qmd`: starter TU/e Beamer PDF deck using the extension format `tue-beamer`.
- `_quarto.yml`: Quarto project settings.
- `_extensions/tue/`: local project support files, including the original TU/e Beamer assets plus the Reveal cover-slide filter and CSS.
- `_extensions/tue/title-slide.lua`: metadata-driven cover slide generator for Reveal.js.
- `_extensions/tue/assets/tue-reveal.css`: TU/e Reveal styling, including the semi-transparent scarlet cover band.
- `assets/tue-cover-background.jpg`: title-slide background extracted from the TU/e corporate PowerPoint.

## Usage

Render the Reveal deck with:

```bash
quarto render presentation.qmd
```

Render the Beamer PDF deck with:

```bash
quarto render presentation-beamer.qmd
```

The Reveal cover slide is generated from document metadata. Update `title`, `subtitle`, `author`, `date`, `tue-cover-image`, and `tue-cover-logo` in `presentation.qmd` to customize it.

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
