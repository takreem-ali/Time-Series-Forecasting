library(forecast)
library(smooth)
library(Mcomp)
library(tseries)
library(parallel)
library(foreach)
library(doSNOW)
library(dplyr)
library(openxlsx)

raw_data <- lapply(M3, I)
sub_data<- sub("^N", "", names(raw_data))
data_range <- sub_data > 1500 & sub_data <= 2500
data <- raw_data[data_range][grep("9$", names(raw_data[data_range]))] 
rm(raw_data,data_range,sub_data)
horizon <- 18
no_models <- 2
ets_MAPEs <- arima_MAPEs <- data.frame()
ets_APEs <- arima_APEs <- matrix(NA, 100,horizon)
strategy_MAPE <- strategy_MPE <- strategy_MASE <- data.frame()
model_selected<-c()
ts_characteristics <- matrix(NA, 100, 4)
cores <- detectCores()
cl <- makeCluster(cores-1, type = "SOCK")
registerDoSNOW(cl)
for (i in 1:100){
  print(i)
  y <- data[[i]]$x
  yout <- data[[i]]$xx
  ytlen = data[[i]]$n - horizon
  yt<- head(y, ytlen)
  fit_ets <- ets(yt)
  fit_arima <- auto.arima(yt, method = "CSS")
  ts_characteristics[i,1] <- data[[i]]$type
  ts_characteristics[i,2] <- fit_ets$component[3] != "N" 
  ts_characteristics[i,3] <- fit_ets$component[2] != "N" 
  ts_characteristics[i,4] <- as.logical(fit_ets$component[4])
  if(ytlen-12 < 25) {
    ytstart<-ytlen-6+1
  }else{
    ytstart<-ytlen-12+1  
  }
  origins <- ytstart:ytlen
  MAPEs <- foreach(origin=origins, .combine = 'cbind', .packages = 'forecast') %dopar% {
    library(forecast)
    yt <- head(y, origin)
    yv <- y[(origin+1):(origin+horizon)]
    cvfit_ets <- ets(yt, model = paste(fit_ets$components[1],
                                       fit_ets$components[2],
                                       fit_ets$components[3],sep = ""),
                     damped = as.logical(fit_ets$components[4]))
    fcs_ets <- forecast(cvfit_ets, h=horizon)$mean
    ets_APE <- 100 *(abs(yv - fcs_ets)/abs(yv))
    ets_MAPE <- mean(ets_APE)
    
    cvfit_arima <- Arima(yt, order=c(fit_arima$arma[1],fit_arima$arma[6],fit_arima$arma[2]),
                         seasonal = c(fit_arima$arma[3],fit_arima$arma[7],fit_arima$arma[4]),
                         method = "CSS")
    fcs_arima <- forecast(cvfit_arima, h=horizon)$mean
    arima_APE<- 100 *(abs(yv - fcs_arima)/abs(yv))
    arima_MAPE <- mean(arima_APE)
    list(ets_MAPE, arima_MAPE,ets_APE,arima_APE)
  }
  ets_MAPEs <- bind_rows(ets_MAPEs,MAPEs[1,])
  arima_MAPEs <- bind_rows(arima_MAPEs, MAPEs[2,])
  ets_APEs[i, 1:horizon] <-  colMeans(foreach(j=1:length(MAPEs[3,]), .combine = 'rbind') %dopar% {
    MAPEs[3,][[j]]
  }, na.rm = TRUE)
  arima_APEs[i, 1:horizon] <-  colMeans(foreach(j=1:length(MAPEs[4,]), .combine = 'rbind') %dopar% {
    MAPEs[4,][[j]]
  }, na.rm = TRUE)
naive_fit <- naive(y, h = horizon)
naive_fcs <- forecast(naive_fit)$mean
if (rowMeans(ets_MAPEs[i,],na.rm = TRUE) > rowMeans(arima_MAPEs[i,],na.rm = TRUE)){
  fit <- auto.arima(y)
  model_selected = c(model_selected,"ARIMA")
  fcs <- forecast(fit, h=horizon)$mean
  strategy_MAPE[i, 1:horizon]<- 100 *(abs(yout - fcs)/abs(yout))
  strategy_MPE[i, 1:horizon]<- 100 *((yout - fcs)/(yout))
  strategy_MASE[i, 1:horizon]<- abs(yout - fcs)/accuracy(naive_fit)[3]
}else{
  fit <- ets(y)
  model_selected = c(model_selected,"ETS")
  fcs <- forecast(fit, h=horizon)$mean
  strategy_MAPE[i,1:horizon]<- 100 *(abs(yout - fcs)/abs(yout))
  strategy_MPE[i,1:horizon]<- 100 *((yout - fcs)/(yout))
  strategy_MASE[i, 1:horizon]<- abs(yout - fcs)/accuracy(naive_fit)[3]
}
}
  stopCluster(cl)

    plot(1:18,type = "n",
       main = "Average training set MAPE of 100 time series",
       xlab="Horizon", ylab="MAPE %",
       ylim=c(0,40))
  legend("topleft",legend=c("ETS","ARIMA"),col=2:3,lty=1)
  lines(1:18, colMeans(ets_APEs), type="l",col=2)
  lines(1:18, colMeans(arima_APEs), type="l",col=3)
 
   horizon = 18
  naive_fcs_MAPE<-sma_fcs_MAPE<-ses_fcs_MAPE<-autoets_fcs_MAPE<-autoarima_fcs_MAPE<-data.frame()
  naive_fcs_MPE<-sma_fcs_MPE<-ses_fcs_MPE<-autoets_fcs_MPE<-autoarima_fcs_MPE<-data.frame()
  naive_fcs_MASE<-sma_fcs_MASE<- ses_fcs_MASE<-autoets_fcs_MASE<-autoarima_fcs_MASE<-data.frame()
  cores <- detectCores()
  cl <- makeCluster(cores-1, type = "SOCK")
  registerDoSNOW(cl)
  
  for (i in 1:100){
    print(i)
    
    y <- data[[i]]$x
    yout <- data[[i]]$xx
    
    m1 <-  naive(y, h = horizon)
    m2 <- sma(y,order = 20, h = horizon)
    m3 <-  ses(y, h = horizon)
    m4 <-  ets(y)
    m5 <-  auto.arima(y)
    
    forecasts <- foreach(j = 1, combine = 'rbind', .packages = 'forecast') %dopar% {
     library(forecast)
       naive_fcs <-  forecast(m1)$mean
      sma_fcs <- m2$forecast
      ses_fcs <-  forecast(m3)$mean
      autoets_fcs <-  forecast(m4)$mean
      autoarima_fcs <-  forecast(m5)$mean
      list(naive_fcs, ses_fcs, ses_fcs, autoets_fcs, autoarima_fcs)
    }
    
    naive_fcs <- forecasts[[1]][[1]]
    naive_fcs_MAPE[i, 1:horizon] <- 100 *(abs(yout - naive_fcs)/abs(yout))
    naive_fcs_MPE[i, 1:horizon] <- 100 *((yout - naive_fcs)/(yout))
    naive_fcs_MASE[i,1:horizon] <- abs(yout - naive_fcs)/accuracy(m1)[3]
    
    sma_fcs <- forecasts[[1]][[2]]
    sma_fcs_MAPE[i, 1:horizon] <- 100 *(abs(yout - sma_fcs)/abs(yout))
    sma_fcs_MPE[i, 1:horizon] <- 100 *((yout - sma_fcs)/(yout))
    sma_fcs_MASE[i,1:horizon] <- abs(yout - sma_fcs)/accuracy(m1)[3]
    
    ses_fcs <- forecasts[[1]][[3]]
    ses_fcs_MAPE[i, 1:horizon] <- 100 *(abs(yout - ses_fcs)/abs(yout))
    ses_fcs_MPE[i, 1:horizon] <- 100 *((yout - ses_fcs)/(yout))
    ses_fcs_MASE[i, 1:horizon] <- abs(yout - ses_fcs)/accuracy(m1)[3]
    
    autoets_fcs <- forecasts[[1]][[4]]
    autoets_fcs_MAPE[i, 1:horizon] <- 100 *(abs(yout - autoets_fcs)/abs(yout))
    autoets_fcs_MPE[i, 1:horizon] <- 100 *((yout - autoets_fcs)/(yout))
    autoets_fcs_MASE[i, 1:horizon] <- abs(yout - autoets_fcs)/accuracy(m1)[3]
    autoarima_fcs <- forecasts[[1]][[5]]
    autoarima_fcs_MAPE[i, 1:horizon] <- 100 *(abs(yout - autoarima_fcs)/abs(yout))
    autoarima_fcs_MPE[i, 1:horizon] <- 100 *((yout - autoarima_fcs)/(yout))
    autoarima_fcs_MASE[i, 1:horizon] <- abs(yout - autoarima_fcs)/accuracy(m1)[3]
    rm(forecasts)
  }
  stopCluster(cl)
  
  categories <- unique(ts_characteristics[,1]) 
  categories_table <- matrix(NA,nrow = 6,ncol = length(categories))
  rownames(categories_table) <- c("Model Strategy","Naive","Simple Exponential Smoothing","Moving Average", "Auto ETS", "Auto ARIMA")
  colnames(categories_table) <- categories
  i <- 1
  for (category in categories){
    filtered_strategy_MAPE <- filter(strategy_MAPE, ts_characteristics[,1] == category)
    filtered_naive_MAPE <- filter(naive_fcs_MAPE, ts_characteristics[,1] == category) 
    filtered_ses_MAPE <- filter(ses_fcs_MAPE, ts_characteristics[,1] == category) 
    filtered_sma_MAPE <- filter(sma_fcs_MAPE, ts_characteristics[,1] == category)
    filtered_autoets_MAPE <- filter(autoets_fcs_MAPE, ts_characteristics[,1] == category)
    filtered_autoarima_MAPE <- filter(autoarima_fcs_MAPE, ts_characteristics[,1] == category)
    
    categories_table[1,i] <-mean(rowMeans(filtered_strategy_MAPE,na.rm = TRUE))
    categories_table[2,i] <-mean(rowMeans(filtered_naive_MAPE))
    categories_table[3,i] <-mean(rowMeans(filtered_ses_MAPE))
    categories_table[4,i] <-mean(rowMeans(filtered_sma_MAPE))
    categories_table[5,i] <-mean(rowMeans(filtered_autoets_MAPE))
    categories_table[6,i] <-mean(rowMeans(filtered_autoarima_MAPE))
    
    i <- i + 1
  }
  
  rm(filtered_strategy_MAPE, filtered_naive_MAPE,filtered_ses_MAPE,filtered_sma_MAPE,filtered_autoets_MAPE,filtered_autoarima_MAPE)
  conditions <- list(c(TRUE, TRUE, FALSE),    
                     c(TRUE, TRUE, TRUE),    
                     c(FALSE, TRUE, TRUE),    
                     c(FALSE, TRUE, FALSE),   
                     c(TRUE, FALSE, FALSE),   
                     c(FALSE, FALSE, FALSE))  
  
  ts_characteristic_table <- matrix(NA,nrow = 6,ncol = 6)
  rownames(ts_characteristic_table) <- c("Model Strategy","Naive",
                                         "Simple Exponential Smoothing",
                                         "Moving Average",
                                         "Auto ETS", "Auto ARIMA")
  colnames(ts_characteristic_table) <- c("Seasonality+Trend",
                                         "Seasonality+DTrend",
                                         "DTrend",
                                         "Trend",
                                         "Seasonality",
                                         "No Trend/Seasonality")
  i <- 1
  for (condition in conditions){
    filter_index <-
      ts_characteristics[,2] == condition[1] & 
      ts_characteristics[,3] == condition[2] & 
      ts_characteristics[,4] == condition[3]
    filtered_strategy_MAPE <- filter(strategy_MAPE, filter_index)
    filtered_naive_MAPE <- filter(naive_fcs_MAPE, filter_index) 
    filtered_ses_MAPE <- filter(ses_fcs_MAPE, filter_index) 
    filtered_sma_MAPE <- filter(sma_fcs_MAPE, filter_index)
    filtered_autoets_MAPE <- filter(autoets_fcs_MAPE, filter_index)
    filtered_autoarima_MAPE <- filter(autoarima_fcs_MAPE, filter_index)
    
    ts_characteristic_table[1,i] <-mean(rowMeans(filtered_strategy_MAPE,na.rm = TRUE))
    ts_characteristic_table[2,i] <-mean(rowMeans(filtered_naive_MAPE))
    ts_characteristic_table[3,i] <-mean(rowMeans(filtered_ses_MAPE))
    ts_characteristic_table[4,i] <-mean(rowMeans(filtered_sma_MAPE))
    ts_characteristic_table[5,i] <-mean(rowMeans(filtered_autoets_MAPE))
    ts_characteristic_table[6,i] <-mean(rowMeans(filtered_autoarima_MAPE))
    i <- i + 1
  }
  
  rm(filtered_strategy_MAPE,filtered_naive_MAPE,filtered_ses_MAPE,filtered_sma_MAPE,filtered_autoets_MAPE,filtered_autoarima_MAPE)

  wb <- createWorkbook()
  add_sheet_and_write <- function(data, sheetName) {
    addWorksheet(wb, sheetName)
    writeData(wb, sheetName, data)
  }
  add_sheet_and_write(ets_MAPEs, "ETS MAPEs")
  add_sheet_and_write(arima_MAPEs, "ARIMA MAPEs")
  add_sheet_and_write(as.data.frame(ets_APEs), "ETS APEs")  
  add_sheet_and_write(as.data.frame(arima_APEs), "ARIMA APEs")
  add_sheet_and_write(strategy_MAPE, "Strategy MAPE")
  add_sheet_and_write(strategy_MPE, "Strategy MPE")
  add_sheet_and_write(strategy_MASE, "Strategy MASE")
    add_sheet_and_write(naive_fcs_MAPE, "Naive MAPE")
  add_sheet_and_write(sma_fcs_MAPE, "SMA MAPE")
  add_sheet_and_write(ses_fcs_MAPE, "SES MAPE")
  add_sheet_and_write(autoets_fcs_MAPE, "AutoETS MAPE")
  add_sheet_and_write(autoarima_fcs_MAPE, "AutoARIMA MAPE")
  add_sheet_and_write(naive_fcs_MPE, "Naive MPE")
  add_sheet_and_write(sma_fcs_MPE, "SMA MPE")
  add_sheet_and_write(ses_fcs_MPE, "SES MPE")
  add_sheet_and_write(autoets_fcs_MPE, "AutoETS MPE")
  add_sheet_and_write(autoarima_fcs_MPE, "AutoARIMA MPE")
  add_sheet_and_write(naive_fcs_MASE, "Naive MASE")
  add_sheet_and_write(sma_fcs_MASE, "SMA MASE")
  add_sheet_and_write(ses_fcs_MASE, "SES MASE")
  add_sheet_and_write(autoets_fcs_MASE, "AutoETS MASE")
  add_sheet_and_write(autoarima_fcs_MASE, "AutoARIMA MASE")
  add_sheet_and_write(model_selected, "Models Selected")
  add_sheet_and_write(ts_characteristic_table, "Data Characteristic")
  add_sheet_and_write(categories_table, "Category")
saveWorkbook(wb, "Benchmark_Results.xlsx", overwrite = TRUE)

plot(1:18,type = "n",
     main = "Average training set MAPE over time series",
     xlab="Horizon", ylab="MAPE %",
     ylim=c(0,30))
legend("topleft",legend=c("ETS","ARIMA"),col=2:3,lty=1, cex=0.5)
lines(1:18, colMeans(ets_APEs), type="l",col=2)
lines(1:18, colMeans(arima_APEs), type="l",col=3)

plot(1:18,type = "n",
     main = "Average MAPE",
     xlab="Horizon", ylab="MAPE",
     ylim=c(0,40))
legend("bottomright",legend=c("Model Strategy","Naive","Simple Exponential Smoothing","Moving Average","Auto ETS","Auto ARIMA"),col=c(1:4,7,8),lty=1,cex = 0.3)
lines(1:18, colMeans(strategy_MAPE), type="l",col=1)
lines(1:18, colMeans(naive_fcs_MAPE), type="l",col=2)
lines(1:18, colMeans(ses_fcs_MAPE), type="l",col=3)
lines(1:18, colMeans(sma_fcs_MAPE), type="l",col=4)
lines(1:18, colMeans(autoets_fcs_MAPE), type="l",col=7)
lines(1:18, colMeans(autoarima_fcs_MAPE), type="l",col=8)
plot(1:18,type = "n",
     main = "Average MASE",
     xlab="Horizon", ylab="MASE",
     ylim=c(0,5))
legend("bottomright",legend=c("Model Strategy","Naive","Simple Exponential Smoothing","Moving Average","Auto ETS","Auto ARIMA"),col=c(1:4,7,8),lty=1,cex = 0.3)
lines(1:18, colMeans(strategy_MASE), type="l",col=1)
lines(1:18, colMeans(naive_fcs_MASE), type="l",col=2)
lines(1:18, colMeans(ses_fcs_MASE), type="l",col=3)
lines(1:18, colMeans(sma_fcs_MASE), type="l",col=4)
lines(1:18, colMeans(autoets_fcs_MASE), type="l",col=7)
lines(1:18, colMeans(autoarima_fcs_MASE), type="l",col=8)
plot(1:18,type = "n",
     main = "Average MPE",
     xlab="Horizon", ylab="MPE",
     ylim=c(-30,20))
legend("topleft",legend=c("Model Strategy","Naive","Simple Exponential Smoothing","Moving Average","Auto ETS","Auto ARIMA"),col=c(1:4,7,8),lty=1,cex = 0.3)
lines(1:18, colMeans(strategy_MPE), type="l",col=1)
lines(1:18, colMeans(naive_fcs_MPE), type="l",col=2)
lines(1:18, colMeans(ses_fcs_MPE), type="l",col=3)
lines(1:18, colMeans(sma_fcs_MPE), type="l",col=4)
lines(1:18, colMeans(autoets_fcs_MPE), type="l",col=7)
lines(1:18, colMeans(autoarima_fcs_MPE), type="l",col=8)
