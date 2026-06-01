# Cochran-Armitage Trend Test

Macro-driven Cochran-Armitage trend test automation in SAS.

## Overview

Parameterized `%analyze` macro that runs a Cochran-Armitage trend test and returns a clean results row with the Z-statistic and selected p-value. Supports two-sided and one-sided (upper/lower) testing.

## Macro Parameters

| Parameter | Description |
|---|---|
| `dsn` | Input dataset |
| `group` | Dose group variable (numeric score) |
| `events` | Number of events/responders |
| `total` | Total animals per group |
| `side` | Test direction: `2` (two-sided), `U` (upper), `L` (lower) |

## Approach

- Reshapes summary data to binary outcome format for `PROC FREQ`
- Extracts Z-statistic and p-values by ODS output table name (robust to output order)
- Returns a labeled results dataset with variable name, test direction, Z, and selected p-value

## Outputs

- `ca-verf-results.pdf` — verification output against published reference data

## Verification
Results verified against Shirley/Williams (1980) reference dataset.
