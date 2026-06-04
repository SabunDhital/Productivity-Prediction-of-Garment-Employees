# Productivity Prediction of Garment Employees

**Tool:** Stata &nbsp;|&nbsp; **Method:** OLS Regression, Interaction Terms, Robust Standard Errors, General-to-Specific Modeling &nbsp;|&nbsp; **Course:** ECON 521 — Econometrics, University of South Dakota

---

## Overview

This project applies Ordinary Least Squares (OLS) regression to examine the determinants of worker productivity at a garment manufacturing factory in Bangladesh. Using daily team-level observations from January to November 2015, the analysis identifies key operational and structural factors that influence actual productivity, and tests whether those effects differ across departments.

The project follows the Wooldridge econometric framework, progressing through four model specifications with increasing complexity — from a baseline OLS model to a final model with a department-productivity interaction term and heteroskedasticity-robust standard errors.

---

## Dataset

- **Source:** [UCI Machine Learning Repository — Productivity Prediction of Garment Employees](https://archive.ics.uci.edu/dataset/597/productivity+prediction+of+garment+employees)
- **Observations:** 1,197 team-day records
- **Period:** January 1, 2015 – November 3, 2015
- **Departments:** Finishing (42.3%) and Sewing (57.7%)

### Key Variables

| Variable | Type | Description |
|---|---|---|
| `actual_productivity` | Continuous | Dependent variable — actual % productivity delivered by each team |
| `targeted_productivity` | Continuous | Daily productivity target set by management |
| `smv` | Continuous | Standard Minute Value — time allocated for the task |
| `incentive` | Continuous | Financial incentive paid to workers (converted to USD) |
| `idle_time` | Continuous | Minutes lost due to production disruptions |
| `idle_men` | Continuous | Number of workers idled during the shift |
| `no_of_style_change` | Count (0–2) | Number of product style changes during the shift |
| `no_of_workers` | Continuous | Total workers in the team |
| `department` | Categorical | Finishing or Sewing |
| `week` | Categorical | Week of the month (Week 1–5) |
| `day` | Categorical | Day of the week |

> **Note:** `wip` (Work in Progress) was dropped due to 506 missing values (all from the finishing department). `overtime` was excluded due to potential endogeneity — teams missing targets are more likely to work overtime, violating OLS exogeneity assumptions.

---

## Methodology

### Data Cleaning
- Trimmed whitespace and corrected spelling inconsistencies in the `department` variable (`"sweing"` → `"sewing"`)
- Renamed `quarter` to `week` to better reflect the actual time periods
- Encoded categorical variables (`department`, `day`, `week`) as dummy variables
- Converted `incentive` from Bangladeshi Taka (BDT) to USD using the 2015 exchange rate (1 USD = 110 BDT)
- Created a binary `target_achieved` indicator (1 if actual ≥ targeted productivity)

### Model Progression (General-to-Specific)

| Model | Specification | R² | Adj. R² |
|---|---|---|---|
| Model 1 | Baseline OLS with core predictors | 0.246 | 0.242 |
| Model 2 | + Department, week, and day dummies | 0.270 | 0.260 |
| Model 3 | Parsimonious model (dropped insignificant variables; removed `no_of_workers` due to VIF > 10) | 0.232 | 0.228 |
| Model 4 | + Interaction term (targeted productivity × department) + robust standard errors | 0.277 | — |

---

## Key Findings

- **Targeted productivity** is the strongest predictor of actual productivity (coefficient ≈ 0.71 across models). Management-set targets drive output significantly.
- **Sewing workers respond ~5× more strongly to targets than finishing workers.** The interaction term (targeted productivity × sewing department) has a coefficient of 0.788 (p < 0.001), meaning a one-unit increase in targeted productivity increases actual productivity by 0.219 in finishing but by 1.007 in sewing.
- **SMV has a small but consistent negative effect** (coefficient ≈ −0.003 to −0.007), meaning more complex, time-intensive tasks reduce actual productivity.
- **Idle men significantly reduce productivity** (coefficient ≈ −0.0073), highlighting the cost of unplanned downtime.
- **Style changes hurt productivity** (coefficient ≈ −0.020), suggesting that product variety introduces inefficiency at the team level.
- **Week 5 productivity is ~9.4 percentage points higher** than Week 1, consistent with end-of-month deadline pressure driving output.
- **Heteroskedasticity was detected** via the residual vs. fitted plot (increasing spread at higher fitted values). Robust standard errors were applied in the final model — key variables remained statistically significant after correction.

---

## Business Implications

1. Set ambitious but realistic productivity targets — targeted productivity is the single biggest lever management has.
2. Apply **department-specific targeting strategies**: sewing teams are far more responsive to targets than finishing teams.
3. Minimize unplanned disruptions — every additional idle worker reduces productivity by approximately 0.73 percentage points.
4. Reduce style change frequency where possible; each additional style change costs ≈2 percentage points of productivity.
5. Address SMV at the process design level to reduce complexity of high-SMV tasks.

---

## Files

| File | Description |
|---|---|
| `garment_productivity.do` | Stata do-file — complete analysis including cleaning, EDA, 4 regression models, VIF checks, and diagnostics |
| `garments_worker_productivity.csv` | Raw dataset (1,197 observations, 15 variables) |
| `Productivity_of_GarmentEmployee_Sabun_Dhital.docx` | Full research report with regression tables, figures, and interpretation |

---

## How to Reproduce

1. Download the dataset from [UCI ML Repository](https://archive.ics.uci.edu/dataset/597/productivity+prediction+of+garment+employees) or use the included CSV
2. Open `garment_productivity.do` in Stata
3. Update the file path in the `import delimited` command to match your local directory
4. Run the do-file top to bottom — all outputs (tables, graphs, model results) will be generated automatically

**Stata version used:** Stata 17 (compatible with Stata 15+)

---

## Author

**Sabun Dhital**  
MS in Business Analytics — University of South Dakota, Beacom School of Business  
[LinkedIn](https://www.linkedin.com/in/sabundhital) | [Portfolio](https://sabundhital.com.np)

*Submitted to Dr. Mike Allgrunn, ECON 521 — Econometrics, May 2025*
