---
name: oecd-chart-design-aesthetics
description: >-
  Visual design and editorial rules for OECD-style charts, from the OECD chart design system and the OECD Style Guide (2025): Noto Sans type, Neutral and 8 thematic palettes, Ocean/Cyan highlights, sequential/diverging scales, line styles, gridlines, spacing, borders, responsive widths, toolbar, tooltips, plus chart wording (sentence-case titles, source and note format, official country names, number/currency/unit/date formats, statistical symbols, territorial footnotes). Use whenever the user wants a chart, graph, plot, dashboard or dataviz in OECD style or for any OECD report, publication, data insight or website, even if the design system isn't named; country comparisons with an OECD average are a strong hint. Also use to review or restyle an existing chart against OECD conventions in any tool (D3, Vega-Lite, Plotly, matplotlib, Highcharts, ggplot, Excel, Figma).
---

# OECD chart design aesthetics

Charts should look like one family: quiet navy and grey, left-aligned text, generous spacing, and colour spent only where it carries meaning. Usually that means one highlighted country or the OECD baseline in bright blue. All measurements are in px.

Reference files:
- `references/palettes.md`: every hex value (series rows, sequential, diverging, ordered, highlight, theme pairing). **Read it before picking any colour.**
- `references/tokens.md`: CSS custom properties and type classes to paste into web charts.
- `references/editorial-style.md`: wording rules from the OECD Style Guide (2025) for titles, sources, notes, country names, numbers, currency, units, dates and statistical symbols. **Read it before writing any text in the chart.**

## Departures from the rules: always tell the user

The rules in this skill come from two sources: the OECD chart design system (visual design) and the OECD Style Guide (editorial). Users may knowingly choose something different, for example two decimal places, a different source line, "Turkey" instead of "Türkiye", or a colour outside the palettes. That is their call. Do what they ask, but never let a departure pass silently.

Whenever the request, the user's data or files, or an existing chart you are editing breaks a rule, add a short **"Departures from OECD style"** note to your reply:
- List each departure in one line: what was asked or used, the rule, and the OECD-compliant alternative. For example: "Values shown with 2 decimals (`12.35%`). OECD style rounds percentages to 1 decimal (`12.4%`)."
- Follow what the user explicitly asked for. If something the user didn't ask for breaks a rule, for example a "Source: OECD" line in data they pasted, or ISO codes in their spreadsheet, fix it to the OECD form and list the fix in the same note so they can revert it.
- Don't block, lecture or ask permission for each one. One note per reply is enough. Once the user has confirmed a departure, don't repeat it in later replies in the same conversation unless it shows up somewhere new.
- If there are no departures, say nothing.

When reviewing an existing chart, report every departure you find in the same format.


## Chart anatomy (top to bottom)

1. **Title and subtitle**, left-aligned. The **contextual toolbar** sits top-right in the same band.
2. **Legend**, under the title block.
3. **Value axis.** On horizontal bar charts it runs along the top, with vertical gridlines.
4. **Category axis**: labels sit next to the bars, right-aligned against them.
5. **Notes and Source** at the bottom, left-aligned ("Note: …", "Source: …").
6. **Info box**: a popover from the info button. It holds a definition, a divider, "Notes:", and "Source:" with a link.
7. **Contextual toolbar**: outlined icon buttons, typically expand, info and overflow "⋮" (more in the library: eye, download, share, plus).
8. **Tooltip** on hover.

Include every part that has content. A static export (PNG/PDF) drops the toolbar, info box and tooltips.

## First, establish where the chart will be used

The chart's destination decides whether the title, subtitle and source belong inside the image.

- **Report**: the figure's title, subtitle and source are set in the document text, around the image. Leave them out of the chart: no title, no subtitle and no "Source:" line. Keep everything else (legend, axes, data, highlights). The plot starts directly with the legend at the top of the card.
- **Other outputs** (web page, data insight, dashboard, slide, social media, standalone image): include the title, subtitle and source as specified in the anatomy and type tables.

If the user hasn't said which it is, and it isn't clear from context, ask before building. For example: "Is this chart for a report (title, subtitle and source go in the document text, so I'll leave them out of the image) or for another output, such as the web or a presentation, where they're needed in the chart?" Ask in the same message as any other questions, such as which palette to use.

If you can't ask (e.g. a one-shot request in a batch), or the context only implies the destination, decide and go ahead, but always tell the user what you assumed. Default to the version with title, subtitle and source. Put the message at the start of your reply, so it isn't missed. For example:

> **Assumed output: web/standalone chart**, so the title, subtitle and source are included in the image. If this is for a report, I can remove them, since they'll go in the document text.

or

> **Assumed output: report**, so the title, subtitle and source are left out of the image for the document text. Tell me if you need them in the chart.

Show this message every time the output type was assumed rather than stated by the user. Skip it only when the user said explicitly which output it is.

For a report, notes stay in the image unless the user asks to remove them.

## Typography

Use **Noto Sans** throughout, with Noto Sans Display for the Medium and Regular styles. Load it from Google Fonts on the web. Fall back to a system sans-serif only if Noto isn't available, and say so.

| Role | Desktop size/line-height | < 500px | < 300px | Weight | Colour |
|---|---|---|---|---|---|
| Title | 18/22 | 16/20 | 16/20 | Bold | `#101D40` midnight blue |
| Subtitle | 17/22 | 16/20 | 16/20 | Display Medium | `#586179` |
| Axis labels and legend | 16/22 | 16/20 | 14/18 | Display Regular. Highlighted category (e.g. OECD) Extrabold | `#586179` |
| Note / Source | 14/18 | 14/18 | 14/18 | Display Regular | `#586179` |
| Tooltip / info box | 14/18 | | | Display Regular, values Display Bold | `#586179` |

In long-form pages (data insights, H3 context), the title can be 22/24 Noto Sans Display Extrabold with a 20/22 Regular subtitle.

Text is left-aligned. Rotated axis labels go to 45° and are right-aligned so they end at the tick. Category labels next to horizontal bars are right-aligned. Label position otherwise depends on chart type.

## Colour (summary; values in `references/palettes.md`)

- **Text**: titles `#101D40`; all other text `#586179`.
- **Default palette is Neutral**: navy `#000533` through slate to pale `#C2D8E6`. Choose the row for your number of series (2 to 7) and assign darkest first.
- **Thematic palettes** (Green, Turquoise, Blue, Purple, Aubergine, Orange, Yellow, Red) are used when the page or report has a matching website theme (e.g. Forest or Grass maps to Green; see the pairing table in `references/palettes.md`). Use one palette per chart. If the user names no theme or palette, use Neutral.
- **Tell the user about the thematic palettes.** Unless they already chose a palette, add a short note when you deliver the chart. Say that it uses the default Neutral palette, and that 8 thematic palettes are available to match the page's website theme: Green, Turquoise, Blue, Purple, Aubergine, Orange, Yellow, Red. Offer to switch. Users often don't know these exist, and the right one depends on where the chart will be published, which you usually can't see. Keep it to one or two sentences. If they already chose a thematic palette, name the one you used instead.
- **Many unrelated categories** (more than 7, or a need for distinct hues): use the **14-colour ordered palette**, in its fixed order.
- **Quantitative scales**: use a **sequential** ramp for low-to-high data. Use a **diverging** pair when there is a meaningful midpoint (negative/positive, Likert, election swing): two hues with the light ends meeting in the middle.
- **Highlight and baseline**: two core blues work across all palettes.
  - **Ocean `#48A7FF`** is the baseline, typically the OECD average.
  - **Cyan `#45DEFF`** highlights a focal series or country.
  - Highlighted lines are 3px; other lines are 2px.
  - Highlight one main value, three at most.
  - Highlight a stacked-bar row with a pale blue `#E6F2FF` band and an Extrabold label.
  - Mark a period or projection, or a highlighted column in an ordered-palette chart, with a light grey `#E8EDF2` band.
- **Text emphasis**: never put a highlight colour behind text. Use weight for emphasis. A direct label at the end of a line may take that line's colour.
- **Areas**: overlapping area fills use 50% transparency.

## Lines (line charts)

| Use | Width | Dash array |
|---|---|---|
| Highlight / baseline | 3px | solid |
| Default series | 2px | solid |
| Additional series styles, in this order as needed | 2px | `12 2 2 2`, `6 6`, `18 2 18 2`, `2 2`, `4 4 18 4`, `2 2 16 2 2 2` |

Dashes keep series apart when colours get close, or when the chart has to survive greyscale printing. With many grey lines and one or two highlighted ones, label lines directly at their right end rather than through the legend.

## Gridlines, axes and borders

- Gridlines and axis lines: 0.75px, `#C2CBD6`. Draw gridlines only on the value axis, with no heavy axis line or tick marks.
- Chart card: 1px border (`#DEE3E9`). Radius 8px when the chart is 500px wide or more, 4px below 500px.
- Buttons, info box and tooltip: 1px `#DEE3E9` border, radius 4px.

## Spacing

The spacing units are **12, 16, 24 and 30px**. Use only these.
- 30px padding inside the chart card.
- 16px between the title block and the toolbar.
- 24px between the title block, legend, plot and notes.
- 12px between the category labels and the plot, and between the value-axis labels and the plot.
- Toolbar buttons: 44×44 minimum target (Apple guideline), 12px apart, icons 16px `#156DF9` from the Phosphor set (phosphoricons.com).
- Legend, desktop: square swatches with a 10px gap to the label and at least 44px per entry. Legend, mobile (< 500px): 14px round dots instead of squares.

## Grid and responsive widths

- `grid--desktop-large` (screens > 1280px): 12 columns, 1248px content width, 32px gutter.
- `grid--mobile` (screens <= 640px): 6 columns, 390px, 16px gutter.
- Chart widths snap to the grid:

| Width | Columns | When |
|---|---|---|
| 1248px | 1/1 | desktop full width |
| 821px | 2/3 | |
| 395px | 1/3 | viewport < 500px |
| 288px | 1/4 | viewport < 300px |

- When a chart narrows, shrink content, not fonts below the table above. Specifically:
  - Use the smaller type steps.
  - Wrap the legend and switch it to dots.
  - Collapse the toolbar to the "⋮" overflow.
  - Shorten the title and subtitle.
  - Use fewer ticks.
  - Move long notes into the info box.

## Tooltip and info box

- **Tooltip**: white card, 1px `#DEE3E9` border, soft shadow, small pointer. Content is a label line, a date line, then a series-colour dot with "Description text: **25%**" (the value in Display Bold). Type is 14/18 `#586179`.
- **Info box**: the indicator definition paragraph, a thin divider, "Notes:", and "Source:" with the source title as a link (`#156DF9`, underlined).

## Bar and column conventions

- Horizontal bars for country rankings: sort descending unless the order means something. Keep bars thin with small gaps. Stacked segments touch.
- Show the OECD aggregate row in its sorted position. Mark it with the Ocean ramp or a pale blue `#E6F2FF` band, plus an Extrabold label.
- Diverging bar charts: Neutral or the thematic palette for the two sides. The baseline country takes Ocean.

## Before finishing, check

- [ ] Noto Sans, with the sizes, weights and colours from the type table. Text left-aligned (rotated labels at 45°, right-aligned).
- [ ] Destination known (report vs other output). Report: no title, subtitle or source in the image. Other outputs: title, subtitle, legend (where needed), note and source all present. If the output type was assumed, the reply opens with the "Assumed output" message.
- [ ] Colours come from `references/palettes.md`: Neutral unless a thematic palette was chosen, the row matched to the series count, and at most 3 highlights in Ocean/Cyan.
- [ ] Gridlines 0.75px `#C2CBD6`. Card border 1px with an 8px radius (4px under 500px).
- [ ] Spacing only from 12, 16, 24 and 30. Toolbar targets at least 44px.
- [ ] Responsive rules followed for the target width.
- [ ] Text follows `references/editorial-style.md`:
  - sentence-case title
  - source in the `Author (Year), Title, URL` format, never "Source: OECD"
  - official country names, alphabetical unless ranked
  - thousands separated by spaces, % with 1 decimal, ISO currency codes
  - year ranges written `2019-2023`
  - territorial footnote if Israel, Kosovo or Cyprus is in the data
- [ ] Any departure from the design system or the style guide is listed in a "Departures from OECD style" note in your reply.
- [ ] Your reply names the palette used and mentions the thematic palette options (unless the user already picked one).
