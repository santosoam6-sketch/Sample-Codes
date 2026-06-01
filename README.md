# Sample Codes — R & SAS

Statistical programming samples demonstrating R and SAS skills in preclinical and clinical contexts. All code is original; proprietary data has been excluded.

---

## R Samples

### [`TLF Generation/`](R%20Samples/TLF%20Generation/)
Clinical adverse event TLF generation using CDISC ADaM data (pharmaverse).
- TEAE summary table (SOC/PT hierarchy, n(%) by arm) rendered as publication-ready HTML via `{gt}`
- AE severity distribution bar chart and top-10 AE incidence forest plot with 95% Wilson CIs via `{ggplot2}`

### [`DART Analysis/`](R%20Samples/DART%20Analysis/)
Developmental and Reproductive Toxicology (DART) analysis in R Markdown.
- LOEL/NOEL agreement analysis across study-chemical combinations
- Study design similarity comparisons (species, strain, route, method)
- Dose-response characterization and most-sensitive-endpoint identification

---

## SAS Samples

### [`Cochran Armitage Program/`](SAS%20Samples/Cochran%20Armitage%20Program/)
Macro-driven Cochran-Armitage trend test with one- and two-sided options.
- Parameterized `%analyze` macro handles direction (`U`, `L`, `2`) and extracts Z-statistic and p-values by name from ODS output
- Verified against published reference data (Shirley/Williams 1980)

### [`PK Program/`](SAS%20Samples/PK%20Program/)
Pharmacokinetic analysis macros for dose proportionality and parameter summarization.
- `%dose_prop`: fits log-log mixed model (PROC MIXED, Kenward-Roger df) for dose proportionality; outputs slope estimate with CI, log-log scatter, and linear plot to RTF
- `%table_pk`: generates cohort-by-parameter summary table (mean ± SD [n]) with dynamic column handling via PROC TRANSPOSE and PROC REPORT

---

## Skills Demonstrated
| Area | Tools |
|---|---|
| Clinical TLF programming | R (`dplyr`, `gt`, `ggplot2`, `pharmaverseadam`) |
| Preclinical statistics | R (`lme4`, `FSA`, `car`), DART endpoints |
| SAS macro programming | `%macro`, ODS, PROC MIXED, PROC FREQ, PROC REPORT |
| PK analysis | Dose proportionality, Cmax, mixed-effects modeling |
| Trend testing | Cochran-Armitage, one- and two-sided |
