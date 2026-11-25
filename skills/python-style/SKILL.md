---
name: python-style
description: >-
  Personal Python coding style: Python 3.12 target, a project uv (or venv) environment instead of the computer's general Python, `.py` scripts vs Jupyter notebooks, script section headers, type hints on everything, Google-style docstrings, functional pipelines for simple data processing, and Polars over pandas for tabular data. Use whenever writing, editing, reviewing or refactoring Python code - any `.py` file or `.ipynb` notebook, a script, module, function, class or code snippet in a reply, or setting up, installing or running a Python project - even for a quick one-off script and even if style isn't mentioned.
---

# Python style

These rules add the Python specifics to the general coding guidelines in `CLAUDE.md` (readability first, explicit patterns and decisions, small reviewable edits). They apply to new code: don't rewrite existing code to match without asking for permission first.

## Python version

- Write code that targets **Python 3.12**.
- Don't add compatibility shims for older Python versions.

## Python environments

- **Never use the computer's general Python installation** (system Python, Homebrew, python.org, global `pip install`). Every project gets its own environment.
- Prefer **uv**: declare dependencies in `pyproject.toml`, commit `uv.lock` and `.python-version`, and let `uv sync` create `.venv/` in the project.
- Make uv use a Python it downloads and manages rather than one already on the computer: set `python-preference = "only-managed"` under `[tool.uv]` in `pyproject.toml`.
- Run everything through the project environment: `uv run python script.py`, `uv run pytest`. Add packages with `uv add` (or `uv add --dev`), not `pip install`.
- If uv isn't available, use a project `.venv` (`python -m venv .venv`) and call `.venv/bin/python` explicitly.
- Write commands in READMEs, CI and Dockerfiles the same way (`uv sync`, `uv run ...`). In a container the image's own Python is already dedicated to the app, so uv may use it there.
- Keep `.venv/` out of git and out of Docker build contexts.

## Scripts vs. notebooks

- Write most data-processing code as **`.py` scripts**.
- Use **Jupyter notebooks (`.ipynb`)** only when the goal is exploration or computations whose outputs (tables, plots, intermediate results) are meant to be shown.
- If code logic becomes reusable, move it into `.py` modules and import it from the script or notebook.
- Don't change the file type of an existing script (`.py` ↔ `.ipynb`) without asking for permission first.

## Script sections

- Scripts can be split into sections with a header comment: `# ` + section name + a space, then dashes up to **column 79** (the whole line is exactly 79 characters).
- Keep sections in a logical top-to-bottom order.
- Add comments and notes explaining the section's purpose and any important details if these aren't self explanatory.

```python
# Imports ---------------------------------------------------------------------
import polars as pl

# Load data -------------------------------------------------------------------
orders = pl.scan_csv("orders.csv")

# Transform -------------------------------------------------------------------
## Aggregating revenue by country
revenue = orders.group_by("country").agg(pl.col("amount").sum())

# Save results ----------------------------------------------------------------
revenue.collect().write_parquet("revenue.parquet")
```

## Explicit over implicit

- Explicit imports (no `from x import *`).
- Explicit return types.
- Explicit keyword arguments for anything non-obvious.
- When code follows a pattern (e.g. pipeline, strategy, factory, dataclass-as-record), name it in the docstring with a `Pattern:` line, as in the examples below.

## Functional style for simple data processing

- For simple data transformations, use a functional style:
  - Pure functions with no side effects.
  - Compose small functions into a pipeline.
  - Don't mutate inputs; return new values.
- Use classes only when there's real state or behavior to encapsulate.

```python
def normalize(name: str) -> str:
    """Return the name stripped and lower-cased.

    Args:
        name: The raw name.

    Returns:
        The normalized name.
    """
    return name.strip().lower()


def unique_names(names: list[str]) -> list[str]:
    """Return sorted, normalized, de-duplicated names.

    Pattern: functional pipeline (normalize -> deduplicate -> sort).

    Args:
        names: Raw names, possibly with duplicates and inconsistent casing.

    Returns:
        A sorted list of unique normalized names.
    """
    return sorted({normalize(name) for name in names})
```

## Type hints

- **Always** add type hints to every function, method, and class attribute, including return types (use `-> None` when nothing is returned).
- Use `dataclasses` (or `typing.NamedTuple` / `TypedDict`) to type structured data instead of bare dicts or tuples.
- Use `collections.abc` types (`Iterable`, `Sequence`, `Mapping`, `Callable`) for function parameters when a concrete type isn't required.

## Docstrings

- **Always** add docstrings to every module, function, class, and method.
- Use Google-style docstrings.
- Functions and methods: describe what it does, then `Args:`, `Returns:`, and `Raises:` (when relevant).
- Classes: describe the purpose, list `Attributes:`, and give each method its own docstring.

```python
from dataclasses import dataclass


@dataclass(frozen=True)
class Order:
    """A customer order.

    Pattern: immutable record (frozen dataclass).

    Attributes:
        order_id: Unique identifier of the order.
        amount: Total order amount in euros.
    """

    order_id: str
    amount: float

    def with_discount(self, rate: float) -> "Order":
        """Return a new order with a discount applied.

        Args:
            rate: Discount rate between 0 and 1.

        Returns:
            A new Order with the discounted amount.

        Raises:
            ValueError: If rate is outside [0, 1].
        """
        if not 0 <= rate <= 1:
            raise ValueError(f"rate must be between 0 and 1, got {rate}")
        return Order(order_id=self.order_id, amount=self.amount * (1 - rate))
```

## Tabular data: prefer Polars

- Prefer **Polars** over pandas for tabular data whenever feasible.
- Use the expression API (`pl.col(...)`, `with_columns`, `filter`, `group_by`, `agg`) and chain operations into readable pipelines.
- Prefer lazy mode (`pl.scan_csv`, `.lazy()` … `.collect()`) for larger datasets or multi-step queries.
- Use pandas only when a dependency requires it or a feature isn't available in Polars, and add a comment explaining why.

```python
import polars as pl


def revenue_by_country(orders: pl.LazyFrame) -> pl.DataFrame:
    """Compute total revenue per country, highest first.

    Args:
        orders: Orders with `country` and `amount` columns.

    Returns:
        A DataFrame with `country` and `revenue` columns, sorted by revenue.
    """
    return (
        orders.group_by("country")
        .agg(pl.col("amount").sum().alias("revenue"))
        .sort("revenue", descending=True)
        .collect()
    )
```
