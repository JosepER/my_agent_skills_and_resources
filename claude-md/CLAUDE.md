# CLAUDE.md

General guidelines for all my work. Language-specific coding rules live in skills.

## Reporting skills used

- At the start of each reply, state in one short line all the skills used so far in the session (e.g. "Skills used: oecd-writing-style, oecd-chart-design-aesthetics"), or "Skills used: none".

## Language-specific style

- Before writing, editing or reviewing Python code (`.py` files or `.ipynb` notebooks), load the `python-style` skill and follow it.

## Working on existing scripts

- When reviewing or editing existing scripts, **don't change their file type (e.g. `.py` ↔ `.ipynb`) without asking for permission first**.
- The coding guidelines apply to new code. Don't rewrite existing code to match without asking for permission first.
- When making edits to existing code, **prefer small, reviewable edits**:  keep diffs easy to follow.
- If a larger refactor seems worthwhile, propose it and wait for approval before doing it.

## Script sections

- Scripts can be split into sections with a header comment: the comment marker and a space, the section name and a space, then dashes up to **column 79** (the whole line is exactly 79 characters).
- Keep sections in a logical top-to-bottom order.
- Add comments and notes explaining the section's purpose and any important details if these aren't self explanatory.

## Readability first

- Prefer code that is easy to read over code that is clever or short.
- Use descriptive names for variables, functions and classes.
- Keep functions and methods small and focused on one task.
- Avoid deep nesting; use early returns instead.
- Avoid dense one-liners when a few clear lines say the same thing better.

## Explicit patterns and decisions

- Make design patterns and decisions explicit. When code follows a pattern (e.g. pipeline, strategy, factory, record type), name it in the function's documentation or a short comment.
- When a non-obvious choice is made (a library, an algorithm, a trade-off), add a brief comment explaining **why**.
- Prefer explicit over implicit: explicit imports (no wildcard imports), explicit return types, explicit named arguments for anything non-obvious.

## Functional style for simple data processing

- For simple data transformations, use a functional style:
  - Pure functions with no side effects.
  - Compose small functions into a pipeline.
  - Don't mutate inputs; return new values.
- Use classes only when there's real state or behavior to encapsulate.

## Documentation and types

- **Always** document every module, function, class, and method, using the language's standard documentation format (e.g. docstrings in Python, roxygen2 comments in R).
- **Always** add type annotations where the language supports them.
- Use typed, named structures for structured data rather than bare dicts, lists or tuples.
