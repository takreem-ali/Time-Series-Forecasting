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

   ![Time Series Distribution](figures/time_series_distribution.png)

2. **Time Frequencies**:
   - The dataset includes time series of different frequencies:
     - **Yearly (645 series)**: Data recorded annually.
     - **Quarterly (756 series)**: Data recorded every quarter.
     - **Monthly (1428 series)**: Data recorded every month.
     - **Other frequencies**: Weekly, daily, and hourly series (a smaller portion).

   ![Time Frequencies](figures/time_frequencies.png)

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

This structured approach makes the M3 dataset an invaluable resource for testing and comparing forecasting methodologies in both academic research and practical business applications.

![Dataset Visualization](figures/dataset_visualization.png)

---

## Methodologies and Models

### 1. Data Exploration
- **Objective**: Gain insights into the structure and behavior of time series.
- **Key Steps**:
  - Visualize trends, seasonality, and anomalies using seasonal plots, ACF, PACF, and decomposition.
  - Statistical tests like ADF and KPSS to check stationarity.
  - Outlier detection and summary statistics.

![Seasonal Plot](figures/seasonal_plot.png)
![ACF and PACF](figures/acf_pacf.png)
![Decomposition](figures/decomposition.png)

### 2. ARIMA Modelling
- **Script**: `Manual Arima Modelling.R`
- **Objective**: Build ARIMA models to handle autoregressive and moving average components.
- **Highlights**:
  - Optimal model selected based on AIC and residual diagnostics.
  - Seasonal differencing applied to handle periodic patterns.
- **Key Outputs**:
  - ARIMA(0,1,1)(0,1,1) selected for its accuracy.
  - Forecast comparison with out-of-sample data.

![ARIMA Forecast](figures/arima_forecast.png)

### 3. ETS (Exponential Smoothing) Modelling
- **Script**: `Manual ETS Modelling.R`
- **Objective**: Model data with exponential smoothing techniques for seasonality and trend.
- **Highlights**:
  - Multiple models tested, including ETS(AAN), ETS(AAA), and ETS(MAM).
  - Model selection based on residuals and forecasting accuracy.
- **Key Outputs**:
  - ETS(MNA) provided the best performance with minimal errors.
  - Prediction intervals visualized for decision-making.

![ETS Forecast](figures/ets_forecast.png)

### 4. Regression Modelling
- **Script**: `Regression Modelling.R`
- **Objective**: Employ regression analysis incorporating trend and seasonal dummy variables.
- **Highlights**:
  - Adjusted R-squared used for model evaluation.
  - Forecasting extended using trend and seasonal components.
- **Key Outputs**:
  - Regression models with seasonality outperformed simpler approaches.
  - Linear regression forecasts visualized against actual data.

![Regression Forecast](figures/regression_forecast.png)

### 5. Batch Forecasting
- **Script**: `Batch Forecasting.R`
- **Objective**: Automate forecasting for multiple time series using ARIMA and ETS models.
- **Highlights**:
  - Parallel processing for efficiency.
  - Dynamic model selection based on out-of-sample accuracy.
- **Key Outputs**:
  - Benchmark results consolidated across series.
  - Performance metrics evaluated for ARIMA, ETS, and baseline models.

![Batch Forecasting](figures/batch_forecasting.png)

---

## Evaluation Metrics

To assess the performance and business impact of the models, the following metrics were utilized:

1. **MAPE (Mean Absolute Percentage Error)**:
   - Measures percentage error in forecasts.
   - Lower values indicate better accuracy.

2. **MASE (Mean Absolute Scaled Error)**:
   - Compares errors to a naive baseline.
   - Robust metric for varying scales.

3. **MPE (Mean Percentage Error)**:
   - Highlights bias in forecasts (underestimation or overestimation).

**Visualization of Results**:
- Forecast performance plotted across horizons for all models.
- Summary tables showing model-specific metrics by series type and characteristics.

![MAPE](figures/evaluation_metrics_mape.png)
![MASE](figures/evaluation_metrics_mase.png)

---

## Business Insights

This analysis equips businesses with:
1. **Forecasting Reliability**:
   - ARIMA models excel in data with strong autoregressive components.
   - ETS models are better suited for seasonality-driven series.

2. **Decision Support**:
   - Forecast intervals provide clarity for risk and uncertainty management.
   - Regression models enable scenario analysis with trend and seasonal adjustments.

3. **Efficiency Gains**:
   - Batch forecasting streamlines prediction across large datasets.
   - Automated model selection reduces manual effort.

---

## Usage Instructions

### 1. Prerequisites
Install the required R packages:
```r
install.packages(c("forecast", "tseries", "ggplot2", "fpp2", "smooth", "dplyr", "openxlsx"))
