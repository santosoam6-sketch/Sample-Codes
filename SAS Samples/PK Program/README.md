# PK Program

Pharmacokinetic analysis macros for dose proportionality and parameter summarization.

**Data:** Proprietary — not included. File paths in the program are placeholders (`/* change file path */`).

## Macros

### `%dose_prop(dataset, param, alpha, outp)`
Dose proportionality analysis for a single PK parameter.

- Filters to the specified parameter and log-transforms dose and result
- Fits a log-log mixed model via `PROC MIXED` (Kenward-Roger df) with subject-level random intercept and slope
- Outputs slope estimate with confidence interval
- Produces log-log scatter plot and linear dose-response plot via `PROC SGPLOT`
- Exports table and figures to RTF

| Parameter | Description |
|---|---|
| `dataset` | Input PK dataset |
| `param` | PK parameter (e.g., `Cmax`, `AUC`) |
| `alpha` | Significance level (e.g., `0.05`) |
| `outp` | Output directory path |

### `%table_pk(dataset, outp)`
Summary table of PK parameters across cohorts.

- Calculates mean, SD, and n per parameter per cohort via `PROC MEANS`
- Formats cells as `mean (SD) [n]`
- Transposes to wide format (cohort as columns) via `PROC TRANSPOSE`
- Dynamically reads cohort names from data — no hard-coding required
- Renders final table via `PROC REPORT` with auto-generated column labels

## Outputs

- `sample_Cmax_ams.rtf` — dose proportionality table and plots for Cmax
- `sample_summary_pk_ams.rtf` — PK parameter summary table

## Style
Custom RTF style template (`styles.out_style`) based on `styles.journal` with Times New Roman, 10pt throughout and formatted table borders.
