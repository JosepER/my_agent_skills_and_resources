---
name: pydotstat
description: >-
  Use when working with the pydotstat Python package or with .Stat Suite V8 at the OECD from Python - uploading SDMX-CSV dataflow files to a .Stat space (Design, Collect, Disseminate), downloading what .Stat or the OECD Data Explorer holds for a dataflow, comparing a local dataflow file with Design, Disseminate - Final and the Data Explorer, checking that a dataflow version, DSD, codelist or constraint exists in a space, or reading an upload error. Covers pydotstat.upload, pydotstat.compare_uploaded, pydotstat.core, dotstat_io.exe, the REST URLs of the spaces, data and structure queries, versions and the errors met so far.
---

# pydotstat: uploading to .Stat and comparing with what is there

`pydotstat` (https://gitlab.algobank.oecd.org/REGIONS_CITIES/pydotstat,
private) holds Python tools to interact with the .Stat Suite. Its README is
the reference for commands and options; this skill adds when to use what,
the traps, and how to read the results. Facts checked in November 2026.

- Install: `pip install git+https://gitlab.algobank.oecd.org/REGIONS_CITIES/pydotstat.git`
  (Python 3.12 or later; installs `pysdmx`, `polars`, `xlsxwriter`).
- It runs on premise only: transport goes through `dotstat_io.exe`.
- Input: one SDMX-CSV 1.0 file per dataflow, named `<DSD>@<DF>.csv`, whose
  `DATAFLOW` column holds `AGENCY:DSD@DF(version)`. That column decides the
  dataflow and the version the tools talk to.
- The package has no project settings. A project that uses it keeps its own
  notes (where its files are, its codelists, its checks) in its own skill.
- Until a project switches to the package, it may still carry the earlier
  copy as a `dotstat/` folder (`python -m dotstat.upload ...`): same tools,
  same options.

## Order of work

1. Know where the current dataflow files are, and pass that folder
   explicitly (`--folder`, or the `DOTSTAT_DIR` environment variable for
   `compare_uploaded`). Ask before rebuilding a file: the user may already
   have done it.
2. Check that the structures exist in the target space (see "Structure
   queries"): the dataflow in the file's version, its DSD, the codelists
   and the constraint. A missing one is for the user to create in the DLM.
3. Compare: `python -m pydotstat.compare_uploaded <DSD> --folder <folder>`.
4. Upload: `python -m pydotstat.upload <file> design --compare-only` first,
   read the counts, then the same command without `--compare-only`. Add
   `--yes` when no terminal prompt is possible.

Uploading to Design or beyond is outward-facing: do it only when the user
asks, for the files they name.

## Terms

Used in the code, the outputs and the replies to the user:

- `new_dataflow_csv`: the dataflow file just written by the project.
- stage, in pipeline order: `design` → `disseminate` (Disseminate - Final,
  internal access) → `final_external` (Disseminate - Final, external
  access, what the public sees). Output columns are named after both sides,
  e.g. `rows_new_dataflow_csv` and `rows_final_external`.

## Spaces

| Space | REST base URL | Read with |
|---|---|---|
| design | `https://dotstat-store.oecd.org/design/rest` | dotstat_io (login) |
| disseminate-staging | `https://dotstat-store.oecd.org/disseminate-staging/rest` | dotstat_io |
| Disseminate - Final, internal access | `https://sdmx.oecd.org/public/rest` | dotstat_io (login) |
| Disseminate - Final, external access (public) | `https://sdmx.oecd.org/public/rest` | plain HTTP |
| collect | `https://sdmx.oecd.org/collect/rest` | dotstat_io |

- The URLs are in `SPACES` of `pydotstat/core.py`. There is none for
  `process`.
- dotstat_io upload names (`-s`): collect, process, design,
  disseminatestaging, disseminatefinal.

### Disseminate - Final: internal and external access

Disseminate - Final has two steps. Every comparison covers both, in this
order: Design → internal → external.

- **Internal access**: Data Explorer source `df[ds]=DisseminateFinal`. This
  is where `-s disseminatefinal` uploads go. It also shows what is not yet
  released.
- **External access**: Data Explorer source `df[ds]=DisseminateFinalDMZ`,
  what the public sees. **It is read only: never upload to it.** Data reach
  it from the internal access.
- Both use the one REST entry point `https://sdmx.oecd.org/public/rest`:
  `disseminate` reads it with the dotstat_io login, `final_external`
  anonymously.
- Not verified: no run so far had the two accesses hold different data, so
  it is not proven that the login returns the internal data. If
  `disseminate` = `final_external` while the Data Explorer shows a
  difference between the two sources, the internal access needs another URL
  (`--disseminate-url`).

## dotstat_io.exe (`\\oecdmain\em_apps\dotstat_io\dotstat_io.exe`)

- Download: `download -p <file> -u <data query URL> -f id` (`-f both` adds
  labels). Upload: `upload -p <SDMX-CSV> -s <space> -v 1` (1 = advanced
  validation, 0 = basic).
- The ADFS login may open a browser window. **Until the user signs in, the
  command waits without printing anything, which looks like a hang**: tell
  the user to look for the sign-in window instead of starting it again. A
  stopped run can leave `dotstat_io.exe` processes behind
  (`tasklist | grep -i dotstat`).
- Pass the arguments as a list (`subprocess.run`); `&` in a URL breaks
  through cmd.exe. In PowerShell, write `"${base}?x=y"`: `"$base?x=y"` is
  read as a variable named `base?x`.
- **A failed request still exits with code 0**: it prints "An error
  occurred ... 404" or "Outcome: Error" and leaves an empty file. Treat an
  empty download as a failure (pydotstat does).
- It sometimes crashes with exit status 3221225794 (the program failed to
  start): that is not an answer from .Stat, so run the request again before
  concluding anything.
- Anonymous requests to restricted spaces answer 404, not 401.

## Data queries

- Format: `<base>/data/<AGENCY>,<DSD@DF>,<version>/<key>`, with
  `?format=csvfile` for IDs only or `csvfilewithlabels` for IDs and labels.
- **Latest version: leave the version empty** (`/data/AGENCY,DSD@DF,`). The
  word `latest` gives HTTP 400.
- A key needs one position per dimension (count the dots), or the result is
  empty. `all` or no key returns everything.
- Send a generic `User-Agent` (`sdmx-client`). The default Python client is
  refused from some networks, so use curl if needed.
- A dataflow whose structure exists but that never received data answers
  404 "doesn't contain a mapping set": pydotstat treats it as empty.

## Structure queries

Use them before an upload, to see which SDMX artefacts the space lacks.

- Format: `<base>/dataflow/<AGENCY>/<DSD@DF>/<version>?references=all`
  returns the dataflow with its DSD, codelists and constraints in one XML.
- `latest` as the version works for structures (unlike data queries). A
  version that does not exist answers 404.
- **Disseminate - Final, external access** answers anonymously (curl with
  `-A sdmx-client`). A new version missing there is normal before release.
- **Design** refuses anonymous structure queries (404, "No Results Found").
  The user reports that dotstat_io can download structures, but on
  20 November 2026 `download -p <file.xml> -u <Design dataflow URL> -f id`
  answered "Error code: 406 Not Acceptable" for every dataflow tried, with
  and without `?references=all`. The working invocation is not known yet:
  ask the user how they do it, or ask for a structure export from the DLM.
- A failed Design *data* download is a hint that the dataflow or its
  version does not exist in Design, not proof (dotstat_io may have crashed,
  or the dataflow has no data yet).
- Reading the XML: namespaces `.../v2_1/structure` and `.../v2_1/common`
  (prefixes vary, so use full namespace URIs). `Dataflow` elements also
  appear inside constraints as references: skip those without a
  `Structure` child. Constraint values are in `KeyValue` / `Value`.

## pydotstat.upload

`python -m pydotstat.upload <file or folder> <space> [--compare-only | --ignore-comparison] [--yes] [--validation basic|advanced] [--base-url URL] [--exe PATH]`

1. Downloads what the space holds for the file's dataflow and version.
2. Shows the new, removed and changed observations.
3. On acceptance, uploads the file, then deletes the removed observations
   with an SDMX-CSV 2.0 file of `ACTION=D` rows. .Stat ends up matching the
   file.

- **Deletion is real.** Check the "removed" count before accepting,
  especially when the space holds data built on other codes (an earlier
  codelist version, another geography).
- `--ignore-comparison` uploads without comparing and deletes nothing.
- Each run keeps `_dotstat_runs/<DSD@DF>_<space>_<timestamp>/` next to the
  file: `current.csv` (backup of .Stat before the upload), `review.xlsx`,
  `delete.csv` and `log.txt`.

## pydotstat.compare_uploaded

`python -m pydotstat.compare_uploaded <DSD> --folder <folder> [--dataflows DF_...] [--stages ...] [--use-cache] [--output-dir DIR] [--design-url URL] [--disseminate-url URL] [--exe PATH]`

- Compares every `<folder>/<DSD>@DF_*.csv` with `design`, `disseminate` and
  `final_external`, and those stages with each other. It prints an
  IDENTICAL/DIFFERENT overview, then the details.
- `--folder` is required unless `DOTSTAT_DIR` is set. Outputs go to
  `<folder>/_dotstat_compare/<DSD>/`: `summary.csv`, `downloads/` and
  `differences/`.
- **Each stage is compared through the latest version that holds data
  there**, not only the file's version: the tool asks for the latest
  version, then the file's version and each earlier one (1.4, 1.3, 1.2...)
  until one has data, and prints the version used. A new version often
  exists in the structure with no data yet. Never report "not compared" for
  a stage just because the file's version is missing.
- **Read the versions first**: a different version often means other
  codelist versions, so most rows differ for that reason alone.
- It matches rows by code only. When codes were renamed or reused between
  versions, "changed" and "removed + new" rows are not real revisions: the
  project needs its own matching for that.
- Columns that the other side lacks are left out of the comparison and
  listed.
- "not comparable: the target file has N duplicated key(s)": the file
  repeats a key, so it can be neither compared nor uploaded. Fix the
  process that writes it.
- How to read the results:
  - `disseminate` ≠ `final_external`: the data has not been released to
    external access yet.
  - `new_dataflow_csv` = `design` but `design` ≠ `disseminate`: the data
    has not been uploaded to Disseminate - Final yet.
- `--use-cache` reuses the downloads; `--stages` limits the stages.

## Errors

- "Sequence contains no matching element" on upload: the file doesn't match
  the structure in the space. Compare its columns, dataflow and structure
  versions, constraint values and codelist versions with the structures of
  the space.
- Duplicated keys: .Stat cannot hold two values for one key. The key is
  every column except `OBS_VALUE`, `OBS_STATUS`, `UNIT_MULT`, `DECIMALS`
  and the other attributes of the DSD.
- Codes rejected: check each dimension value against the codelist version
  the DSD references and against the constraint of the dataflow.
- An attribute with an empty attribute relationship in the DSD may reject
  mixed values: attach it to the dimension it depends on.
