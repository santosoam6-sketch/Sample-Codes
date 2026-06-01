# TLF — Adverse Events Reporting

Clinical TLF generation from CDISC ADaM data using R.

**Data:** `pharmaverseadam::adae` / `pharmaverseadam::adsl` (open-source CDISC pilot data, no proprietary data)

## Scripts

| File | Description |
|---|---|
| `01_create_ae_summary_table.R` | TEAE summary table — SOC/PT hierarchy, n(%) by arm, sorted by descending frequency, exported to HTML via `{gt}` |
| `02_create_visualizations.R` | AE severity bar chart (Figure 1) and top-10 AE incidence forest plot with 95% Wilson CIs (Figure 2) |

## Outputs

- `ae_summary_table.html` — formatted TEAE summary table
- `ae_severity_by_arm.png` — AE severity distribution by treatment arm
- `ae_top10.png` — top 10 most frequent AEs with 95% CI

## Packages
`dplyr`, `tidyr`, `ggplot2`, `scales`, `gt`, `gtsummary`, `pharmaverseadam`
