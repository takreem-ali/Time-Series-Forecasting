# Comprehensive Time Series Forecasting with the M3 Competition Dataset

This repository presents a comprehensive business analytics report on time series forecasting, utilizing various statistical and machine learning models to analyze and predict future trends. The analysis covers exploratory data insights, forecasting models, evaluation metrics, and actionable business insights.

---

## Dataset Overview

The dataset used for this analysis is sourced from the M3 competition dataset, containing various time series data across industries like finance, retail, and manufacturing. Each time series includes:
- **In-sample Data (`x`)**: Historical observations used for model training.
- **Out-of-sample Data (`xx`)**: Future observations used to evaluate forecast accuracy.

---

### Key Characteristics of the Dataset

The M3 Competition dataset is meticulously organized to evaluate forecasting methods across diverse domains and time frequencies. Its structure facilitates robust model comparison and ensures the applicability of insights to real-world scenarios.

---

#### Key Components
1. **Time Series Distribution**:
   - The dataset comprises **3003 time series** distributed across six domains:
     - **Micro**: Small-scale business data.
     - **Industry**: Manufacturing and production.
     - **Finance**: Economic and stock market indicators.
     - **Demographics**: Population, births, deaths, etc.
     - **Macroeconomics**: National and global economic metrics.
     - **Others**: Miscellaneous series not classified in the above.

2. **Time Frequencies**:
   - The dataset includes time series of different frequencies:
     - **Yearly (645 series)**: Data recorded annually.
     - **Quarterly (756 series)**: Data recorded every quarter.
     - **Monthly (1428 series)**: Data recorded every month.
     - **Other frequencies**: Weekly, daily, and hourly series (a smaller portion).

3. **Components of Each Series**:
   - Each time series has two distinct parts:
     - **In-sample data (`x`)**: Historical observations used for training forecasting models.
     - **Out-of-sample data (`xx`)**: A pre-defined forecast horizon (e.g., next 18 months for monthly series) reserved for evaluating model accuracy.

4. **Lengths of Series**:
   - The in-sample length varies by series, reflecting the real-world scenarios from which the data was collected.
   - The out-of-sample lengths are standardized for each frequency:
     - **Yearly**: 6 years.
     - **Quarterly**: 8 quarters.
     - **Monthly**: 18 months.

---

#### Purpose of Structuring
- The consistent segmentation of in-sample and out-of-sample data ensures that models can be benchmarked on their ability to generalize beyond observed data.
- Grouping by domain and frequency allows researchers to identify methods that perform best under specific conditions (e.g., seasonal vs. non-seasonal data).

---

# Time Series Forecasting with ARIMA and ETS Models

## Overview
This repository explores **time series forecasting** using data from the [M3 Competition](https://forecasters.org/resources/time-series-data/m3-competition/). Forecasting techniques include **manual modeling** of individual series and **batch forecasting** across multiple series. Both methods employ rigorous statistical techniques like ARIMA and ETS, supplemented by exploratory data analysis and evaluation metrics.

## Table of Contents
1. [Manual Forecasting](#manual-forecasting)
   - Data Exploration
   - Statistical Analysis
   - Forecasting Results
2. [Batch Forecasting](#batch-forecasting)
   - Strategy Overview
   - Model Selection
   - Performance Evaluation

---

## Manual Forecasting

### Data Exploration
Manual forecasting focuses on **series 1910**, which records the total shipment of glass containers from 1981 to 1992. The dataset is divided into two subsets:
- **In-sample data**: Used for training models.
- **Out-of-sample data**: Used for validation.

#### Key Observations
- **Seasonality**: Clear recurring patterns at the monthly level.
- **Trend**: A slight downward trend in the early years.
- **Variability**: Irregular fluctuations and occasional outliers, possibly due to external factors like market disruptions.
- **Autocorrelation**: Analyzed using ACF and PACF plots, indicating no significant autocorrelation.

### Statistical Analysis
#### Regression Modeling
- Multiple linear regression models incorporating **trend** and **seasonality** were tested.
- The model with the highest adjusted \( R^2 \) value (0.7572) was chosen.
- Residual diagnostics confirmed a good fit, with normally distributed residuals and constant variance.

#### ARIMA Modeling
- Stationarity was achieved through differencing, validated by ADF and KPSS tests.
- The final model was ARIMA(2,1,1)(0,1,2)[12], selected using AIC optimization.
- Residual analysis showed white noise, confirming model adequacy.

#### ETS Modeling
- The ETS (M,N,A) model (Multiplicative error, No trend, Additive seasonality) provided the best fit based on AICc.
- This model accurately captured seasonal patterns and the stabilization of the trend over time.

### Forecasting Results
- **Regression**: Accurate short-term projections, but limited in capturing non-linear trends.
- **ARIMA**: Robust for medium- to long-term forecasts, with predictions closely aligned to observed data.
- **ETS**: Better for short-term forecasts due to emphasis on recent observations.

Graphs showcasing predictions with confidence intervals (80%, 90%, 95%, and 99%) validate the reliability of the models.

---

## Batch Forecasting

### Strategy Overview
Batch forecasting applies automated modeling to **100 monthly time series** extracted from the M3 dataset. Each series is analyzed independently to select the most suitable model (ARIMA or ETS).

### Model Selection
- **Cross-Validation**:
  - Rolling origin evaluation ensures models are validated on unseen data.
  - MAPE (Mean Absolute Percentage Error) is used for model comparison.
- **ETS**: Selected for series with strong seasonality and stable patterns.
- **ARIMA**: Preferred for series with weaker seasonality or more complex trends.

### Performance Evaluation
- **Error Metrics**:
  - MAPE: Measures prediction accuracy.
  - MASE: Compares model accuracy against naive benchmarks.
  - MPE: Highlights over- or under-predictions.
- **Key Insights**:
  - ARIMA models were used for 52% of series, while ETS was chosen for 48%.
  - Both models outperformed benchmarks (Naive, Simple Exponential Smoothing, Moving Average).
  - ARIMA showed stability for long-term forecasts, while ETS excelled in short-term accuracy.

### Results Summary
- ETS and ARIMA delivered comparable performance for short-term horizons.
- For longer-term predictions, ARIMA demonstrated more stable accuracy.
- Visualizations include:
  - Forecast plots with confidence intervals.
  - Residual diagnostics (ACF, PACF, Q-Q plots).

---
