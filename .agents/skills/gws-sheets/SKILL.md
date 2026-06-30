---
name: gws-sheets
description: "Google Sheets: read ranges, write/update values, append rows, create spreadsheets, and add formulas via the gws CLI. Use when reading or writing a Google Sheet, building or updating a spreadsheet tracker, or setting cell formulas programmatically."
metadata:
  version: 0.22.5
  openclaw:
    category: "productivity"
    requires:
      bins:
        - gws
    cliHelp: "gws sheets --help"
---

# sheets

> **PREREQUISITE:** Read `../gws-shared/SKILL.md` for auth, global flags, and security rules. If missing, run `gws generate-skills` to create it.

Reads and writes Google Sheets.

```bash
gws sheets <resource|+helper> <method> [flags]
```

## Helper Commands (use these for common tasks)

| Command | Description |
|---------|-------------|
| `+read` | Read values from a range |
| `+append` | Append a row (or rows) to the end of a table |

### Read values

```bash
# Single range — always double-quote ranges (the ! triggers zsh history expansion)
gws sheets +read --spreadsheet SPREADSHEET_ID --range "Sheet1!A1:D10"

# Whole sheet
gws sheets +read --spreadsheet SPREADSHEET_ID --range Sheet1 --format table
```

`+read` is read-only — it never modifies the spreadsheet.

### Append rows

```bash
# Single row of simple strings
gws sheets +append --spreadsheet SPREADSHEET_ID --values 'AAPL,Apple,Equity,100'

# Multiple rows as a JSON array of arrays
gws sheets +append --spreadsheet SPREADSHEET_ID --json-values '[["AAPL","Apple",100],["MSFT","Microsoft",50]]'
```

Use `--values` for a single simple row; `--json-values` for bulk multi-row inserts.

## Core Resources (raw API for full control)

```bash
gws sheets spreadsheets <method>           # create, get, batchUpdate, getByDataFilter
gws sheets spreadsheets values <method>    # get, update, append, clear, batchGet, batchUpdate, batchClear
gws sheets spreadsheets sheets <method>    # add/delete/duplicate tabs (via spreadsheets.batchUpdate)
```

### Create a spreadsheet

```bash
gws sheets spreadsheets create --json '{"properties":{"title":"Portfolio Tracker"}}'
```

The response includes `spreadsheetId` and `spreadsheetUrl`. Record the ID/link — never credentials.

### Read a range (raw)

```bash
gws sheets spreadsheets values get --params '{"spreadsheetId":"ID","range":"Sheet1!A1:D10"}'
```

### Write / overwrite a range

`valueInputOption` controls parsing:
- `USER_ENTERED` — values are parsed as if typed in the UI; **strings beginning with `=` become live formulas** and numbers/dates are auto-typed. Use this for formulas and normal data entry.
- `RAW` — stored verbatim, no parsing. Use when you must store a literal string that starts with `=`.

```bash
# Write plain values
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"ID","range":"Sheet1!A1:C2","valueInputOption":"USER_ENTERED"}' \
  --json '{"range":"Sheet1!A1:C2","majorDimension":"ROWS","values":[["Ticker","Qty","Value"],["AAPL",100,"=B2*C$1"]]}'
```

### Write formulas

With `valueInputOption: "USER_ENTERED"`, any cell whose value is a string starting with `=` is stored as a formula and recalculated natively by Sheets — no separate recalc step.

```bash
# Set a column of formulas
gws sheets spreadsheets values update \
  --params '{"spreadsheetId":"ID","range":"Sheet1!E2:E4","valueInputOption":"USER_ENTERED"}' \
  --json '{"range":"Sheet1!E2:E4","majorDimension":"COLUMNS","values":[["=C2*D2","=C3*D3","=C4*D4"]]}'
```

Common formulas: `=SUM(B2:B10)`, `=B2/$B$11`, `=MEDIAN(F2:F8)`, `=QUARTILE(F2:F8,3)`, `=INDEX(B5:D5,1,$B$1)`, `=GOOGLEFINANCE("AAPL","price")` (live quotes — verify and date any GOOGLEFINANCE value before treating it as a fact).

### Write to multiple ranges at once

```bash
gws sheets spreadsheets values batchUpdate \
  --params '{"spreadsheetId":"ID"}' \
  --json '{"valueInputOption":"USER_ENTERED","data":[{"range":"Sheet1!A1","values":[["X"]]},{"range":"Sheet2!A1","values":[["Y"]]}]}'
```

### Clear a range

```bash
gws sheets spreadsheets values clear --params '{"spreadsheetId":"ID","range":"Sheet1!A2:Z1000"}'
```

### Add or rename tabs, format cells, freeze rows

Structural and formatting changes go through `spreadsheets batchUpdate` with a `requests` array (`addSheet`, `updateSheetProperties`, `repeatCell`, `mergeCells`, `updateBorders`, etc.):

```bash
gws sheets spreadsheets batchUpdate \
  --params '{"spreadsheetId":"ID"}' \
  --json '{"requests":[{"addSheet":{"properties":{"title":"Allocation"}}}]}'
```

## Discovering Commands

```bash
gws sheets --help                          # browse helpers, resources, methods
gws sheets spreadsheets values --help      # methods on a resource
gws schema sheets.spreadsheets.values.update   # required params, body shape, types
```

Use `gws schema sheets.<resource>.<method>` to build `--params` and `--json`.

## Tips

- **Always double-quote A1 ranges** — `"Sheet1!A1:D10"`, never single-quoted, because zsh treats `!` as history expansion (see `gws-shared`).
- **Formulas over hardcodes:** for any derived cell (totals, weights, margins, multiples), write a formula with `USER_ENTERED`, not a pre-computed number. The sheet must re-flex when an input changes.
- **`--dry-run`** validates a request locally without sending it — use before any write you are unsure about.
- A range can be just a tab name (`Sheet1`) to read/return the whole used area.

> [!CAUTION]
> `update`, `append`, `batchUpdate`, and `clear` are **write** commands — confirm with the user before executing, per `gws-shared` security rules.

## See Also

- [gws-shared](../gws-shared/SKILL.md) — Auth, global flags, zsh `!` and JSON quoting
- [gws-drive](../gws-drive/SKILL.md) — Locate, create, move, and share the spreadsheet file
