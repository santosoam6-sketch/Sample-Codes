# DART Analysis

Developmental and Reproductive Toxicology (DART) analysis in R Markdown.

**Data:** Proprietary — not included. The `.Rmd` documents the full analytical approach.

## Overview

Exploratory analysis of LOEL/NOEL values across a multi-study, multi-chemical DART database. Key questions addressed:

- How often do LOELs agree within the same study-chemical combination?
- Are agreeing studies driven by consistent study design (species, strain, route, method)?
- Which study design factors are most common among the most sensitive endpoints?
- How do dose spacing and range compare between most-sensitive and all studies?

## Methods

- LOEL agreement rate calculation per study-chemical pair
- Study design similarity analysis (species, strain, admin route/method, dosing duration)
- Most-sensitive endpoint identification and cross-study comparison
- Dose range and spacing characterization
- Mixed-effects modeling (`lme4`) and non-parametric tests (`FSA`)

## Output
- `image.png` — sample figure from analysis

## Packages
`dplyr`, `tidyr`, `ggplot2`, `readxl`, `lme4`, `FSA`, `car`, `kableExtra`, `corrr`
