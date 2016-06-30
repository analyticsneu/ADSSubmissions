library(foreach)
#install.packages('weatherData')
library(weatherData)


start_date = as.Date("2014-1-1")
end_date = as.Date("2014-12-31")
days = seq(start_date, end_date, by = "day")

#weather.temp<-data.frame()


foreach(day = days, .combine='rbind') %dopar% {
  w<-getDetailedWeather("BOS", day,opt_custom_columns=T, custom_columns=c(1,2))
  write.table(w, file = "Temperature.csv", append = TRUE,sep = ",", col.names=!file.exists("temperature12.csv"))
}


weather<-read.csv("Temperature.csv", header = T)
a<-as.POSIXlt(weather$TimeEST)
print(weather$TimeEST)

tm2 <- as.POSIXct(weather$TimeEST, format = "%m/%d%Y %H:%M")
tm2
require(lubridate)

weather$Newtime <- mdy_hm(weather$TimeEST)

wNw<-aggregate(list(temperature = weather$Temperature), 
          list(hourofday = cut(weather$Newtime, "1 hour")), 
          mean)

write.csv(wNw, file="finalTemp3.csv",col.names = T)
