# Business Analytics Report: Time Series Forecasting

This repository contains a comprehensive suite of scripts, data, and results focused on time series forecasting. These methodologies are designed for business analytics professionals aiming to derive insights and make data-driven decisions using advanced forecasting techniques.

---

## **Overview**

Time series forecasting is crucial for various business applications, including demand forecasting, revenue prediction, and resource allocation. This repository consolidates multiple forecasting methods, evaluates their performance, and provides actionable insights for decision-making.

**Key Features:**
- Exploratory data analysis to understand time series behavior.
- Manual and automated forecasting methods.
- Performance evaluation using business-relevant metrics.

---

## **Methodologies**

### **1. Data Exploration**
- **Script**: `Data Exploration.R`
- **Objective**: Perform exploratory analysis to uncover trends, seasonality, and anomalies.
- **Key Outputs**:
  - Seasonal and trend decomposition.
  - Correlation analysis using ACF and PACF.
  - Visualizations: seasonal plots, subseries plots, and lag plots.

### **2. ARIMA Modelling**
- **Script**: `Manual Arima Modelling.R`
- **Objective**: Develop ARIMA models manually to capture autoregressive and seasonal patterns.
- **Key Models**:
  - ARIMA(0,1,1)(0,1,1) with the lowest AIC score.
  - Forecast comparison with actual out-of-sample data.
- **Evaluation**:
  - Residual diagnostics to ensure stationarity and model fit.

### **3. ETS (Exponential Smoothing) Modelling**
- **Script**: `Manual ETS Modelling.R`
- **Objective**: Apply ETS models for trend and seasonality without requiring stationarity.
- **Key Models**:
  - ETS(AAN), ETS(AAA), ETS(MAM), and others.
- **Evaluation**:
  - Comparison of ETS variations based on MAPE and residuals.
  - Forecast plots with prediction intervals.

### **4. Regression Modelling**
- **Script**: `Regression Modelling.R`
- **Objective**: Forecast using regression models with trend and seasonal components.
- **Key Features**:
  - Incorporation of dummy variables for seasonality.
  - Linear regression with trend and interaction terms.
- **Evaluation**:
  - Adjusted R-squared values to assess model fit.
  - Forecast comparison with out-of-sample data.

### **5. Batch Forecasting**
- **Script**: `Batch Forecasting.R`
- **Objective**: Automate forecasting across multiple time series using ARIMA and ETS.
- **Key Outputs**:
  - Selection of the best-performing model for each series.
  - Performance metrics (MAPE, MASE, MPE) for each model.
  - Consolidated benchmarking results.

---

## **Evaluation Metrics**

Business relevance is emphasized by evaluating models using:

1. **MAPE (Mean Absolute Percentage Error)**: Measures forecasting accuracy as a percentage.
2. **MASE (Mean Absolute Scaled Error)**: Scaled error metric for robustness across series.
3. **MPE (Mean Percentage Error)**: Highlights forecasting bias.

**Results are visualized in:**
- Comparison charts for MAPE, MASE, and MPE.
- Tables summarizing the performance by model and time series characteristics.

---

## **Usage Instructions**

### **1. Prerequisites**
Install the required R packages:
```R
install.packages(c("forecast", "tseries", "ggplot2", "fpp2", "smooth", "dplyr", "openxlsx"))
