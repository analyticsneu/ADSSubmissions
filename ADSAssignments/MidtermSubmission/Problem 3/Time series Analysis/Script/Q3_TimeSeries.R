library(ggplot2)
library(forecast)
library(ggfortify)
library(DMwR)

fn.dat.raw.dir <- function(fname) {
  return (paste("D:\\NEU\\ADS\\mideterm\\forecasts\\", fname, sep = ""))
}


setwd("C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\")

#train.csv
train.data<-read.csv("C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\train.csv", header = T,
                     colClasses = c("character", "numeric",
                                    "numeric","numeric","numeric",
                                    "numeric","numeric","numeric"))

train.data$date <- as.POSIXct(train.data$date, format = "%Y%m%d%H", tz = "GMT")

#View(train.data)


#benchmark.csv
benchmark.data <- read.csv("C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\benchmark.csv", header = T,
                           colClasses = c("integer","character", "numeric",
                                          "numeric","numeric","numeric",
                                          "numeric","numeric","numeric"))
benchmark.data$date <- as.POSIXct(
  benchmark.data$date,
  format = "%Y%m%d%H", tz = "GMT")

rownames(benchmark.data) <- benchmark.data$id
benchmark.data$id <- NULL
#View(benchmark.data)


train.data <- rbind(train.data, benchmark.data)

#write.csv(train.data, file = "C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\Timeseries_data.csv")

# train data is 2009/7/1 and 2010/12/31

final.data<-train.data
final.data<-final.data[order(date),]

#train<-final.data[which(final.data$date>=as.POSIXct("2009-07-01 00:00:00") & final.data$date<=as.POSIXct("2010-12-31 23:00:00")),]
train<-final.data[which(final.data$date<=as.POSIXct("2010-12-31 23:00:00")),]


train<-train[1:(nrow(train)-5),]
head(train)
tail(train)

##### data wrangling #####

train[is.na(train)]
train[which(train$wp1==0),]

########## trial 1 ARIMA ############3

 ARTS<-ts(train$wp1, freq = 365*24, start = 2009)

 # autoplot(Sales,ts.colour = 'blue', ts.linetype = 'dashed',main = "ACTUAL TIME-SERIES GRAPH")
 # 
 # #Decompose
 # Decomposed <- decompose(Sales,type = "additive")
 # DecomposedPlot <- autoplot(Decomposed,ts.colour = "blue",main = "Decomposed Graphs")
 # print(DecomposedPlot)
 # 
 # autoplot(acf(na.action = na.exclude,x =Sales,lag.max = 24),main = "ACF Graphs",conf.int.colour = "blue")
 # autoplot(pacf(na.action = na.exclude,x =Sales,lag.max = 24),main = "PACF Graphs",conf.int.colour = "blue")
 # 
 #ARIMA
 
 fit <- auto.arima(ARTS)
 Summary <- summary(fit)
 
 fc <-forecast.Arima(fit,h=48)
fc$mean
 
 ########## trial 2 ####### 
 
 ##### neural net time series for wp1 ######
 train$wp1[which(train$wp1==0)]<-mean(train$wp1)
 uq<-quantile(train$wp1,.75)+1.5*IQR(train$wp1)
 train$wp1[train$wp1>uq]<-uq
 boxplot(train$wp1)
 
 fit  <- nnetar(train$wp1,decay=0.01, maxit=250, repeats=40)
 f<-forecast(fit,h=544*24+13)
 fv<-as.data.frame(as.numeric(f$mean))
 
 ## 2011/1/1 to 2012/6/28
 train.data<-train.data[order(train.data$date),]
out<-train.data[which(train.data$date>=as.POSIXct("2010-12-31 19:00:00")),]


out <- out[!duplicated((out$date)),]
head(out)
tail(out)

nrow(out)
nrow(fv)

result<-cbind(out$date,fv)
colnames(result)<-c("Date", "wf1 forecast")

write.csv(result, file="C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\WF1Forecast.csv")


##### neural net time series for wp2 ######
boxplot(train$wp2)
train$wp2[which(train$wp2==0)]<-mean(train$wp2)
uq<-quantile(train$wp2,.75)+1.5*IQR(train$wp2)
train$wp2[train$wp2>uq]<-uq
boxplot(train$wp2)

fit  <- nnetar(train$wp2,decay=0.01, maxit=250, repeats=40)
f<-forecast(fit,h=544*24+13)
fv2<-as.data.frame(as.numeric(f$mean))


result2<-cbind(result,fv2)
colnames(result2)<-c("Date", "wf1 forecast", "wf2 forecast")

write.csv(result2, file="C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\WF2Forecast.csv")

##### neural net time series for wp3 ######
boxplot(train$wp3)
train$wp3[which(train$wp3==0)]<-mean(train$wp3)
uq<-quantile(train$wp3,.75)+1.5*IQR(train$wp3)
train$wp3[train$wp3>uq]<-uq
boxplot(train$wp3)

fit  <- nnetar(train$wp3,decay=0.01, maxit=250, repeats=40)
f3<-forecast(fit,h=544*24+13)
fv3<-as.data.frame(as.numeric(f3$mean))


result3<-cbind(result2,fv3)
colnames(result3)<-c("Date", "wf1 forecast", "wf2 forecast", "wf3 forecast")

write.csv(result3, file="C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\WF3Forecast.csv")


##### neural net time series for wp4 ######
boxplot(train$wp4)
train$wp4[which(train$wp4==0)]<-mean(train$wp4)
uq<-quantile(train$wp4,.75)+1.5*IQR(train$wp4)
train$wp4[train$wp4>uq]<-uq
boxplot(train$wp4)

fit  <- nnetar(train$wp4,decay=0.01, maxit=250, repeats=40)
f4<-forecast(fit,h=544*24+13)
fv4<-as.data.frame(as.numeric(f4$mean))


result4<-cbind(result3,fv4)
colnames(result4)<-c("Date", "wf1 forecast", "wf2 forecast", "wf3 forecast", "wf4 forecast")

write.csv(result4, file="C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\WF4Forecast.csv")



##### neural net time series for wp5 ######
boxplot(train$wp5)
train$wp5[which(train$wp5==0)]<-mean(train$wp5)
uq<-quantile(train$wp5,.75)+1.5*IQR(train$wp5)
train$wp5[train$wp5>uq]<-uq
boxplot(train$wp5)

fit  <- nnetar(train$wp5,decay=0.01, maxit=250, repeats=40)
f5<-forecast(fit,h=544*24+13)
fv5<-as.data.frame(as.numeric(f5$mean))


result5<-cbind(result4,fv5)
colnames(result5)<-c("Date", "wf1 forecast", "wf2 forecast", "wf3 forecast", "wf4 forecast", "wf5 forecast")

write.csv(result5, file="C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\WF5Forecast.csv")


##### neural net time series for wp6 ######
boxplot(train$wp6)
train$wp6[which(train$wp6==0)]<-mean(train$wp6)
uq<-quantile(train$wp6,.75)+1.5*IQR(train$wp6)
train$wp6[train$wp6>uq]<-uq
boxplot(train$wp6)

fit  <- nnetar(train$wp6,decay=0.01, maxit=250, repeats=40)
f6<-forecast(fit,h=544*24+13)
fv6<-as.data.frame(as.numeric(f6$mean))


result6<-cbind(result5,fv6)
colnames(result6)<-c("Date", "wf1 forecast", "wf2 forecast", "wf3 forecast", "wf4 forecast", "wf5 forecast", "wf6 forecast")

write.csv(result6, file="C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\WF6Forecast.csv")


##### neural net time series for wp7 ######
boxplot(train$wp7)
train$wp7[which(train$wp7==0)]<-mean(train$wp7)
uq<-quantile(train$wp7,.75)+1.5*IQR(train$wp7)
train$wp7[train$wp7>uq]<-uq
boxplot(train$wp7)

fit  <- nnetar(train$wp7,decay=0.01, maxit=250, repeats=40)
f7<-forecast(fit,h=544*24+13)
fv7<-as.data.frame(as.numeric(f7$mean))


result7<-cbind(result6,fv7)
colnames(result7)<-c("Date", "wf1 forecast", "wf2 forecast", "wf3 forecast", "wf4 forecast", "wf5 forecast", "wf6 forecast", "wf7 forecast")

write.csv(result7, file="C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 3\\Time series\\WF7Forecast.csv")
