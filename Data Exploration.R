library (Mcomp)
library(forecast)
library(tseries)
library(ggplot2)
library(fpp2)

M3Forecast
M3[[1910]]$description
str(M3[[1910]])

data <- M3[[1910]]$x
dataout <- M3[[1910]]$xx
is.ts(data)
data
dataout
plot(data, ylab="Glass Container Shipment")
mean(data)
max(data)
which.max(data)
min(data)
which.min(data)
var(data)
sd(data)
median(data)
plot(diff(data, s=12)) #white noise
ggAcf((diff(data, s=12)))
length(data)
autoplot(data)
ggAcf(data) 
ggseasonplot(data)
gglagplot(data)
ggsubseriesplot(data)
seasonplot(data)
summary(data)
plot(decompose(data))
adf.test(data)
acf(data)
pacf(data)
boxplot(data~cycle(data))
tsoutliers(data) #44 51, 5070.402 4710.555
shapiro.test(data)
Box.test(data, lag=log(126))  #X-squared = 87.305, df = 4.8363, p-value < 2.2e-16
