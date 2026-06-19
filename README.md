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
