
# Comprehensive Time Series Forecasting with the M3 Competition Dataset

This repository presents a detailed business analytics report on time series forecasting, leveraging statistical and machine learning models to analyze and predict future trends. The analysis includes exploratory data insights, forecasting model implementation, evaluation metrics, and actionable insights for industry applications.

## Dataset Overview

The dataset analyzed in this project originates from the Makridakis M3 Competition, a widely recognized benchmarking dataset for time series forecasting. It comprises diverse time series from industries such as finance, retail, and manufacturing, providing a robust basis for evaluating forecasting methods.

### Key Characteristics of the Dataset

#### 1. Time Series Distribution
The dataset includes 3003 time series distributed across six domains:
- **Micro**: Small-scale business data, including product-level sales.
- **Industry**: Manufacturing and production data.
- **Finance**: Economic indicators and stock market trends.
- **Demographics**: Population statistics, including births and deaths.
- **Macroeconomics**: National and global economic measures.
- **Others**: Miscellaneous series not categorized above.

#### 2. Time Frequencies
The dataset comprises time series with varying frequencies:
- **Yearly**: 645 series recorded annually.
- **Quarterly**: 756 series recorded quarterly.
- **Monthly**: 1428 series recorded monthly.
- **Other Frequencies**: Weekly, daily, and hourly series (a smaller portion).

Each time series includes:
- **In-sample Data (x)**: Historical observations used for training models.
- **Out-of-sample Data (xx)**: Future observations reserved for model evaluation.

---

## Time Series Forecasting Models

### Manual Forecasting

#### Data Exploration
Manual forecasting focused on **series 1910**, representing monthly glass container shipments from 1981 to 1992. Key observations from the data include:
- **Seasonality**: Monthly patterns were observed, with certain months consistently exhibiting higher or lower shipments.
- **Trends**: A slight downward trend was detected in earlier years.
- **Outliers**: Occasional spikes and dips suggest external influences on shipment volumes.

Exploratory visualizations:
- **Seasonal Plots**: Highlight monthly seasonality.
- **Decomposition**: Breaks down data into trend, seasonal, and residual components for clearer insights.

#### Forecasting Models

##### ARIMA (AutoRegressive Integrated Moving Average)
- **Strengths**: Robust for medium- and long-term predictions; handles non-stationary data effectively.
- **Stationarity Testing**: ADF and KPSS tests confirmed stationarity after differencing.
- **Selected Model**: ARIMA(2,1,1)(0,1,2)[12], chosen for its low AIC and accurate residual patterns.
- **Forecasting Results**: Provided precise predictions over an 18-month horizon with confidence intervals (80%, 90%, 95%, 99%).

##### ETS (Exponential Smoothing State Space Model)
- **Strengths**: Effective for short-term forecasting with pronounced seasonality.
- **Selected Model**: ETS (M,N,A), optimized using AICc.
- **Forecasting Results**: Captured seasonal variations accurately with consistent short-term predictions.

##### Regression Modeling
- **Exploration**: Trend, seasonality, and their combinations were analyzed.
- **Best Model**: Regression including both trend and seasonality (Adjusted \(R^2 = 0.7572")).
- **Residual Analysis**: Indicated a good fit with normally distributed errors and minimal bias.
- **Forecasting Results**: Projected 18-month trends with multiple confidence levels.

---

### Batch Forecasting

#### Strategy Overview
Batch forecasting applied automated ARIMA and ETS models to 100 monthly time series extracted from the M3 dataset (series 1501–2500 ending in ‘9’). Each series was independently analyzed to select the most suitable model based on Mean Absolute Percentage Error (MAPE).

#### Performance Evaluation

##### Cross-Validation
- **Method**: Rolling origin cross-validation with dynamically determined validation windows.
- **Goal**: Robust evaluation of model performance across varying horizons.

##### Benchmarking
- **Baseline Models**: Naive, Moving Average, and Simple Exponential Smoothing.
- **Comparison**: ETS and ARIMA outperformed baseline models in both short- and long-term forecasts.

##### Results Summary
- **Short-Term Horizons**: ETS demonstrated slightly better performance due to its emphasis on recent data.
- **Long-Term Horizons**: ARIMA exhibited more stable accuracy, suggesting better adaptability to long-term patterns.
- **Model Usage**: ARIMA was selected for 52% of series, ETS for 48%.

---

## Evaluation Metrics

### MAPE (Mean Absolute Percentage Error)
- **Definition**: Measures the average percentage error between predicted and actual values.
- **Findings**:
  - Both ARIMA and ETS maintained low MAPE values across short-term horizons.
  - ARIMA demonstrated greater stability in longer-term forecasts.

### MASE (Mean Absolute Scaled Error)
- **Definition**: Compares forecast errors against a naive benchmark.
- **Findings**: ETS outperformed Naive and Simple Exponential Smoothing in all evaluated series.

### MPE (Mean Percentage Error)
- **Definition**: Indicates model bias by considering the direction of errors.
- **Findings**: Both ARIMA and ETS exhibited minimal bias, with MPE close to zero across horizons.

---

## Key Insights and Business Applications

1. **Seasonality Insights**: The analysis of glass container shipments revealed consistent seasonal trends, aiding inventory and production planning.
2. **Model Recommendations**:
   - **Short-Term**: ETS is preferable for its accuracy in capturing recent patterns.
   - **Long-Term**: ARIMA provides better stability and adaptability.
3. **Automated Forecasting**: The batch forecasting approach enables scalable and efficient prediction across diverse time series.
4. **Error Metrics**: Comprehensive evaluation using MAPE, MASE, and MPE ensures robust model selection.

---

## Repository Contents

1. **Scripts**:
   - `Batch_Forecasting.R`: Implements batch forecasting with ARIMA and ETS models.
   - `Manual_ARIMA_Modelling.R`: Detailed ARIMA modeling for series 1910.
   - `Manual_ETS_Modelling.R`: ETS modeling for series 1910.
   - `Regression_Modelling.R`: Linear regression models with trend and seasonality.
   - `Data_Exploration.R`: Exploratory analysis of time series data.

2. **Documentation**:
   - Detailed markdown files explaining the methodology and results.
   - Visualizations illustrating key findings.

3. **Outputs**:
   - Forecast results for all models.
   - Error metrics comparisons.

---

## Conclusion

Forecasting provides critical insights for decision-making in various industries. This project demonstrates:
- Expertise in time series analysis and model selection.
- Application of advanced forecasting techniques to real-world datasets.
- Clear communication of results through comprehensive metrics and visualizations.

By combining manual and automated approaches, the analysis achieves high accuracy and scalability, showcasing the practical value of predictive analytics in business and beyond.
