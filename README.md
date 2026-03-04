# Cancer Incidence & Mortality Analysis (2015 US County-Level Data)

> Statistical analysis of cancer incidence and death rates across US counties using multiple linear regression, exploring the influence of income, poverty, and regional factors.

![US Cancer Incidence Map](https://user-images.githubusercontent.com/42464701/233954306-a0027fe7-1f58-49df-8114-2620c8843d8b.png)

---

## Overview

This project analyzes county-level cancer data from the [American Cancer Society (2015)](https://www.cancer.org/) to:
- Identify regional patterns in cancer incidence and mortality
- Quantify the relationship between socioeconomic factors and cancer rates
- Build predictive regression models for incidence and death rates

The analysis spans **five key areas**:
1. **Regional Investigation** — State, region, and county-level cancer incidence patterns
2. **Income-Stratified Analysis** — Cancer rates across four income brackets
3. **Socioeconomic Correlations** — Impact of poverty, location, and population on outcomes
4. **Correlation Analysis** — Identifying the strongest predictors of cancer rates
5. **Regression Modeling** — Multiple linear regression with interaction terms and assumption validation

## Key Findings

| Finding | Detail |
|---------|--------|
| **Regional disparity** | The Northeast US has significantly higher cancer incidence rates |
| **Income effect** | Lower-income populations face higher cancer risk and mortality |
| **Poverty correlation** | Positive correlation between poverty estimates and cancer rates |
| **Best predictor set** | Income, poverty, population, and regional features yield the most accurate models |

## Methodology

Both analyses follow the same rigorous pipeline:

```
Raw Data → Cleaning & Feature Engineering → Model Building → Assumption Checking → Model Selection
```

1. **Data Preprocessing** — Remove missing values, engineer `Region` feature from state abbreviations, categorize five-year trends
2. **Feature Engineering** — Create categorical variables for trend direction (low/stable/high/unknown)
3. **Model Building** — Progressive linear regression models with increasing complexity
4. **Assumption Validation** — Linearity, multicollinearity, independent errors (ACF), normality of residuals, homoscedasticity
5. **Model Selection** — Final models include interaction terms (`popEst2015 × medIncome`)

## Project Structure

```
├── data/
│   ├── cancer_data_2015.xlsx           # Raw county-level cancer dataset
│   └── excel_analysis.xlsx             # Supplementary Excel-based analysis
│
├── analysis/
│   ├── death_rate_analysis.R           # Linear regression: predicting death rates
│   └── incidence_rate_analysis.R       # Linear regression: predicting incidence rates
│
├── reports/
│   └── executive_summary.pdf           # Full executive summary with findings
│
├── visualizations/
│   └── cancer_incidence_us_map.png     # US cancer incidence heatmap
│
└── README.md
```

## Regression Models

### Death Rate Analysis
Three progressive models, with **Model 3** selected as best:
- **Model 1**: `deathRate ~ PovertyEst + popEst2015 + incidenceRate + avgDeathsPerYear + medIncome`
- **Model 2**: Adds `Region` feature, removes non-significant variables
- **Model 3**: Adds interaction term `popEst2015 × medIncome`

### Incidence Rate Analysis
Four progressive models, with **Model 4** selected as best:
- **Model 1**: `incidenceRate ~ PovertyEst + popEst2015 + deathRate + avgDeathsPerYear + medIncome`
- **Model 2**: Adds trend and annual count features
- **Model 3**: Incorporates `Region`, removes weak predictors
- **Model 4**: Adds interaction term `popEst2015 × medIncome`

## Visualizations

| Cancer Incidence by Region | Income vs. Death Rate |
|---|---|
| ![Cancer Map](https://user-images.githubusercontent.com/42464701/233954167-c9da58f5-1353-4537-8038-142b750a2f0e.png) | ![Income Analysis](https://user-images.githubusercontent.com/42464701/233954545-8c6f9e07-7dbc-4042-909f-a71c0f02a453.png) |

| Regional Comparison | Correlation Matrix |
|---|---|
| ![Regional](https://user-images.githubusercontent.com/42464701/233954760-db6d6036-8552-45e9-8eb7-0a3a217098b2.png) | ![Correlation](https://user-images.githubusercontent.com/42464701/233955473-75f69539-0804-43df-8bd7-a8e576ecf89d.png) |

## Tech Stack

- **Language**: R (base)
- **Methods**: Multiple linear regression, correlation analysis, residual diagnostics
- **Data**: County-level cancer statistics (American Cancer Society, 2015)

## Getting Started

1. Clone the repository
   ```bash
   git clone https://github.com/johnmelwin/CancerAnalysis2015.git
   cd CancerAnalysis2015
   ```

2. Open either R script in RStudio:
   - Load data from `data/cancer_data_2015.xlsx`
   - Run `analysis/death_rate_analysis.R` or `analysis/incidence_rate_analysis.R`

3. View the full executive summary in `reports/executive_summary.pdf`
