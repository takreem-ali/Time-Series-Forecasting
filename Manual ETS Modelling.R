library (Mcomp)
library(forecast)
library(tseries)
library(ggplot2)
library(fpp2)
library(smooth)

M3[[1910]]$descriptiond
str(M3[[1910]])

data <- M3[[1910]]$x
dataout <- M3[[1910]]$xx
data
dataout
dec_data <- decompose(data, type="additive")
plot(dec_data)
stl_data <- stl(data, s.window=5, t.window=5)
plot(stl_data)
ets(data) #MNA

# Model 1:
fit1 <- ets(data, model="ANN")
summary(fit1) #2141.005

# Model 2: 
fit2 <- ets(data, model="AAN",  damped=FALSE)
summary(fit2) #2146.365

# Model 3: 
fit3 <- ets(data, model="AAN", damped = TRUE)
summary(fit3) #2148.945

# Model 4:
fit4 <- ets(data, model="AAA",  damped=FALSE)
summary(fit4) #1995.338

# Model 5: 
fit5 <- ets(data, model="MAM", damped=TRUE)
summary(fit5) #1993.069

# Model 6:
fit6<-ets(data, model="MNA", damped=FALSE)
summary(fit6) #1989.227

fcs<-forecast(fit6, h=18, level = c(80,90,95,99))
plot(fcs)
plot(data,xlim=c(1981, 1993), ylim=c(3500,6500))
lines(dataout, lty=2, lwd=1)
lines(forecast(fit1)$mean, col="yellow")
lines(forecast(fit2)$mean, col="blue")
lines(forecast(fit3)$mean, col="orange")
lines(forecast(fit4)$mean, col="green")
lines(forecast(fit5)$mean, col="pink")
lines(forecast(fit6)$mean, col="red")
fit7 <- es(data, model="MNA")
plot(fit7)
cbind('Residuals' = residuals(fit6),
      'Forecast errors' = residuals(fit6,type='response')) %>%
  autoplot(facet=TRUE) + xlab("Year") + ylab("")