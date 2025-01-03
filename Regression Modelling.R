library (Mcomp)
library(forecast)
library(tseries)
library(ggplot2)
library(fpp2)
library(xts)

M3[[1910]]$description
str(M3[[1910]])

data <- M3[[1910]]$x #Insample Data
dataout <- M3[[1910]]$xx #OutSample Data

dataout

# Build a linear model
fit1 <- tslm(data ~ season) 
fit2 <- tslm(data ~ trend) 
fit3 <- tslm(data ~ season+trend) 

summary(fit1) #Adjusted R-squared:  0.6393
summary(fit2) #Adjusted R-squared:  0.1041 
summary(fit3) #Adjusted R-squared:  0.7572 

checkresiduals(fit3)

#Forecast with dummy variables and seasonality
dummy <-read.csv("Dummy Variable.csv")
dummy_ts <- ts(dummy, start=1, frequency=12) 
dummy_ts
fit4<-tslm(Data~M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11, dummy_ts)
summary(fit4) #Adjusted R-squared:  0.6393 
fit5<-tslm(Data~trend+M1+M2+M3+M4+M5+M6+M7+M8+M9+M10+M11, dummy_ts)
summary(fit5) #Adjusted R-squared:  0.7572
fit6<-tslm(Data~trend+M1+M2+M3+M4+M5+M6+M7+M8+M9+M10, dummy_ts)
summary(fit6) #Adjusted R-squared:  0.7538
fit7<-tslm(Data~trend+M1+M3+M4+M5+M6+M7+M8+M9+M10, dummy_ts)
summary(fit7) #Adjusted R-squared:  0.7514 
fit3$fitted

plot(data, lwd = 2, main = "Actual VS Fitted Values")
legend("topright", c("Actual observations", "Fitted values"), lty=1, col = 1:2,cex = 0.7)
lines(fit3$fitted, col = "red")

#Forecast 18 months
fc <- forecast(fit3, h=18, level=c(80,90,95,99))
plot (fc, main="18-month Forecast")
lines(dataout, lty=2, lwd=1)
legend("topright", 
       legend=c("Observed Data", "Predicted", "OutSample Data", ""), 
       col=c("black", "deepskyblue","black" ), 
       lty=c(1, 1, 2), 
       pch=c(NA, NA, 15, 15), 
       merge=TRUE, 
       cex=0.4)

#Manual plot with different color shading
fcs <- forecast(fit3, h=18,level = c(80, 90,95,99))

plot(data, xlim=c(1981,1993),ylim = c(3000,7000), main = "Focecasts from linear regression model 3")
lines(fcs$mean, col = "darkblue",lwd = 2, lty = 2)
lines(fcs$lower[,1], col = "dodgerblue4") 
lines(fcs$upper[,1], col = "dodgerblue4")
lines(fcs$lower[,2], col = "deepskyblue")
lines(fcs$upper[,2], col = "deepskyblue") 
lines(fcs$lower[,3], col = "cadetblue") 
lines(fcs$upper[,3], col = "cadetblue") 
lines(fcs$upper[,4], col = "cyan")
lines(fcs$upper[,4], col = "cyan")
legend("topright", legend=c("Point Forecast", "80%", "90%", "95%", "99% "),
       col=c("black", "blue", "deepskyblue", "cadetblue", "cyan"),
       lty=1,
       lwd=1, 
       cex=0.8) 

#Residual Analysis for Linearity
cbind(Fitted = fit3$fitted,Residuals=fit3$residuals) %>%
  as.data.frame() %>%
  ggplot(aes(x=Fitted, y=Residuals)) + geom_point()+
  labs(title="Plot of fitted values VS residuals")+
  theme(plot.title = element_text(hjust = 0.5))
checkresiduals(fit3)

#Residual Analysis for Normality 
qqnorm(fit3$residuals)
qqline(fit3$residuals)

