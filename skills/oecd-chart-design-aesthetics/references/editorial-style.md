# OECD editorial style for charts

From the *OECD Style Guide* (fourth edition, 2025). Only the rules that affect chart content are included: labels, titles, notes, sources, numbers and dates. Where the style guide and the chart design system examples disagree on wording, the style guide wins. The design system still governs visual design.

## Contents
1. Titles and subtitles
2. Source line
3. Notes
4. Country names, groupings and territorial footnotes
5. Numbers and percentages
6. Currency
7. Units of measure
8. Dates and time periods
9. Statistical symbols
10. Abbreviations and spelling

## 1. Titles and subtitles
- Use sentence case: capitalise only the first word and proper nouns. If the title has a colon, capitalise the first word after it.
  - Right: "Real incomes have been weak in most OECD countries"
  - Wrong: "Real Incomes Have Been Weak In Most OECD Countries"
- Never put a note marker on a title.
- Spell out days and months in titles and subtitles. Write out numbers one to ten in words in titles (e.g. "Ten years of PISA").

## 2. Source line
- Every figure cites its source below the chart. Format: `Source: Author(s) (Year), Title, URL.` Put titles of standalone works in italics where the medium allows. Include the URL when one exists.
  - `Source: OECD (2022), Women's leadership in environmental action, https://doi.org/...`
- Several sources: separate them with semicolons after "Sources:".
- If the chart is adapted from an existing figure: `Source: Based on OECD (2022), Global Plastics Outlook, Figure 2.2, URL.`
- Never write "Source: OECD" or "Source: Authors". For OECD data published here for the first time, name the data itself, for example "OECD Survey of …" or "Country consultation …".
- For OECD Data Explorer data, use the short link from its "Share" button.
- Notes never carry sources, and sources never carry notes.

## 3. Notes
- Write notes below the chart and above the source, starting with "Note:" (or "Notes:" if there are several).
- Mark notes with superscript numerals 1, 2, 3 …, numbered separately from the report's main text. Put a marker next to the label it refers to, never on the title. Inside the notes, use "1. …", "2. …".
- Don't nest notes, and don't put notes inside sources.

## 4. Country names, groupings and territorial footnotes
- Use only the OECD official names for lists, tables and graphics, as listed by the OECD Directorate for Legal Affairs (LEG). Common pitfalls:

  | Use | Not |
  |---|---|
  | Türkiye | Turkey |
  | Czechia | Czech Republic |
  | Slovak Republic | Slovakia |
  | Korea | South Korea, Republic of Korea |
  | China (People's Republic of) in lists | PRC |
  | United States, United Kingdom | USA, U.S., Great Britain |

  For less common names, or sensitive ones such as Chinese Taipei, Cyprus, India or the Islamic Republic of Iran, tell the user the LEG list is the authority. Don't invent forms.
- **Order**: alphabetical in English, unless the chart shows a ranking or another meaningful order. Sorting by value counts as a ranking. China is alphabetised under "C" (China, People's Republic of).
- **ISO codes** (AUS, DEU …) should generally be avoided. If space forces them, say that a key to the codes is needed elsewhere (e.g. the report's reader's guide).
- **Groupings**: "OECD" for the average or aggregate label, and "OECD area" for the region. Write "euro area" in lowercase; as a chart label it becomes "Euro area" (not "Euro Area"). Use "EU" and "EU22" (the OECD's EU Member countries) only if they are explained elsewhere. Use the standard acronyms: G7, G20, BRIICS, LAC, MENA, ASEAN.
- **Territorial footnotes**: these are mandatory. Any chart with statistical data on Israel supplied by the Israeli authorities, or that mentions Kosovo or refers to the Republic of Cyprus, must carry the official LEG disclaimer footnote. If you don't have the exact wording, add a placeholder note and tell the user to insert the official text.
- No flags drawn as emoji. Use maps only from the LEG map model.

## 5. Numbers and percentages
- Thousands are separated with a space, never a comma or full stop: `4 000`, `1 275 103`. Use a non-breaking or thin space in code. Years take no space (`2025`).
- Decimal point, never a comma. Always a leading zero: `0.45`, not `.45`.
- Negative numbers: minus sign with no space after it, `-446.2`. Use a real minus `−` or a non-breaking hyphen so the sign can't wrap.
- Percentages: `%` with no space (`5%`). Round to **one decimal place**. If any value in a series has a decimal, give whole numbers as `.0` too (`2.0%`, `2.2%`). In labels, repeat `%` on each value in a list. A hyphenated range takes one `%` (`10-20%`).
- Percentage points: `p.p.`, defined in the text on first use.
- Round large numbers in labels (`1.2 billion`, not `1 198 650 000`). In axes and labels with little space, these are allowed: thsd/k, mln/M, bln/G, tln/T.

## 6. Currency
- ISO code before the amount, separated by a space: `USD 1 000`, `EUR 20 million`, `CAD -225`.
- Symbols (`$`, `€`) are allowed in charts only when space is tight. They go directly before the number with no space (`$1 000`). Don't use them where they could be ambiguous (several dollar currencies).
- Don't mix codes, symbols and names in one chart.
- Money values are whole numbers or have two decimals.

## 7. Units of measure
- Put a space between the number and the unit: `3 km`, `80 t`, `1 L`.
- Use only the standard abbreviations: mm, cm, m, km, m2, km2, g, kg, t, Mt (million tonnes), L, hL, °C, s, min, hr, y, kWh, km/h, pkm, tkm, vkm, `t eq. CO2`. Never use Fahrenheit. Never put units in bold or italics.
- Put the unit in the subtitle or axis title (e.g. "% of GDP", "USD per capita"), not on every tick, unless the chart needs it there.

## 8. Dates and time periods
- Write dates as `15 April 1998` (no ordinals, no commas). Datasets and technical labels use `DD-MM-YYYY`. Use the 24-hour clock.
- Year ranges use all four digits with a hyphen: `1998-2001`, `2024-2033`. A period that spans two calendar years (fiscal or school year) uses a slash: `2025/26`.
- Quarters in charts: `Q1 2024`. Ranges: `Q2 2020-Q1 2021`.
- Decades: `1990s` (no apostrophe).
- Abbreviate months in axes only when space is short: Jan., Feb., Mar., Apr., May, June, July, Aug., Sept., Oct., Nov., Dec. Spell them out in titles and subtitles.
- Use months, quarters or years, not seasons.

## 9. Statistical symbols (tables, labels, tooltips)
| Symbol | Meaning |
|---|---|
| `..` | missing value |
| `n.a.` | not available |
| `x` | not applicable |
| `0` | nil or negligible |
| `\|` | break in series |
| `c` | confidential |
| `e` | estimated value |
| `f` | forecast value |
| `p` | provisional |

Explain any symbol used in the chart's note. Mark forecast or projection periods visually as well, with the light grey `#E8EDF2` band (see palettes.md).

## 10. Abbreviations and spelling
- Use abbreviations in charts only when space is tight. Acronyms are uppercase with no full stops (OECD, PISA). They must be explained in the surrounding text or the note.
- Common chart abbreviations: `vs.`, `Q` (quarter).
- British English spelling throughout: labour, organisation, programme, centre, modelling. Write "per cent" in words only at the start of a sentence; use `%` elsewhere.
