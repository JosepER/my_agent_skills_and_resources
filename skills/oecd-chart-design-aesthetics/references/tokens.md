# OECD chart tokens (CSS)

```css
@import url("https://fonts.googleapis.com/css2?family=Noto+Sans:wght@400;500;700;800&family=Noto+Sans+Display:wght@400;500;700;800&display=swap");

:root {
  --oecd-font: "Noto Sans", "Noto Sans Display", system-ui, sans-serif;
  --oecd-font-display: "Noto Sans Display", "Noto Sans", system-ui, sans-serif;

  /* text */
  --oecd-title: #101D40;          /* midnight blue */
  --oecd-text: #586179;           /* dark grey: subtitle, axes, legend, notes */
  --oecd-line-label: #353C61;

  /* structure */
  --oecd-grid: #C2CBD6;           /* grey 300 */
  --border-width-075: 0.75px;     /* axes + gridlines */
  --border-width-1: 1px;
  --oecd-border: #DEE3E9;
  --border-radius-8: 8px;         /* charts >= 500px wide */
  --border-radius-4: 4px;         /* charts < 500px, buttons, tooltips */
  --oecd-icon: #156DF9;

  /* highlight */
  --oecd-ocean: #48A7FF;          /* baseline (OECD) */
  --oecd-cyan: #45DEFF;           /* highlight */
  --oecd-pale-blue: #E6F2FF;      /* stacked-bar row highlight */
  --oecd-light-grey-2: #E8EDF2;   /* period / projection band */

  /* neutral sequential ramp */
  --oecd-n1: #000533; --oecd-n2: #232A52; --oecd-n3: #464E70; --oecd-n4: #69738F;
  --oecd-n5: #8C98AE; --oecd-n6: #AFBCCC; --oecd-n7: #C2D8E6;

  /* spacing */
  --oecd-space-12: 12px; --oecd-space-16: 16px; --oecd-space-24: 24px; --oecd-space-30: 30px;
}

.oecd-card { border: var(--border-width-1) solid var(--oecd-border); border-radius: var(--border-radius-8); padding: var(--oecd-space-30); background: #fff; }
@container (max-width: 499px) { .oecd-card { border-radius: var(--border-radius-4); } }
.oecd-title    { font: 700 18px/22px var(--oecd-font); color: var(--oecd-title); }
.oecd-subtitle { font: 500 17px/22px var(--oecd-font-display); color: var(--oecd-text); }
.oecd-axis, .oecd-legend { font: 400 16px/22px var(--oecd-font-display); color: var(--oecd-text); }
.oecd-axis .is-highlight { font-weight: 800; }
.oecd-note, .oecd-tooltip { font: 400 14px/18px var(--oecd-font-display); color: var(--oecd-text); }
.oecd-tooltip { border: 1px solid var(--oecd-border); border-radius: var(--border-radius-4); background: #fff; }
.oecd-tooltip b { font-weight: 700; }
```

Line dash arrays (SVG `stroke-dasharray`), all 2px except the 3px highlight: `none`, `12 2 2 2`, `6 6`, `18 2 18 2`, `2 2`, `4 4 18 4`, `2 2 16 2 2 2`.
