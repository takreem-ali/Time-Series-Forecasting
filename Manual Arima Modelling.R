library (Mcomp)
library(forecast)
library(tseries)
library(ggplot2)
library(fpp2)
M3[[1910]]$description
str(M3[[1910]])
data <- M3[[1910]]$x
dataout <- M3[[1910]]$xx
plot(data, type = "o")
tsdisplay(data)
nsdiffs(data)        
ndiffs(diff(data, lag = 12))
ndiffs(diff(diff(data, lag=12)))
diff_data <-diff(diff(data))
adf.test(diff_data, alternative="stationary") #Stationary
kpss.test(diff_data)  #Stationary
acf(diff_data, main="ACF for Data")
pacf(diff_data, main="PACF for Data")
model1<-Arima(data, order=c(0,1,1), seasonal=c(0,1,1))
model2 <- Arima(data, order=c(1,1,2), seasonal=c(1,1,0))
model3 <- Arima(data, order=c(2,1,1), seasonal=c(0,1,2))
summary(model1) #1572.74
summary(model2) #1576
summary(model3) #1571.18
par(mfrow=c(2,1))
acf(resid(model3), main="ACF of Residuals")
pacf(resid(model3), main="PACF of Residuals")
fcs <- forecast(model3, h=18)
plot(fcs, xlim=c(1981,1993), ylim=c(3500, 7000))
lines(dataout, col='red')