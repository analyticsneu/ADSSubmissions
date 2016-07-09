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

View(train.data)


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
View(benchmark.data)


# for (i in 1:7) {
#   benchmark.data[[paste("wp",i,sep="")]] <- NA
# }

train.data <- rbind(train.data, benchmark.data)
benchmark.data <- benchmark.data[, "date", drop = F]

test.diff <- 544
benchmark.data.test <- benchmark.data
benchmark.data$date <- benchmark.data.test$date - as.difftime(test.diff, unit="days")
View(benchmark.data.test)

benchmark.data$start <- benchmark.data$date - as.difftime(1:48, unit="hours")
benchmark.data$date <- as.character(benchmark.data$date)
benchmark.data$start <- as.character(benchmark.data$start)
benchmark.data <- data.table(benchmark.data, key="date")


benchmark.data.test$start <- benchmark.data.test$date - as.difftime(1:48, unit="hours")
benchmark.data.test$date <- as.character(benchmark.data.test$date)
benchmark.data.test$start <- as.character(benchmark.data.test$start)
benchmark.data.test <- data.table(benchmark.data.test, key="date")


train.data$date <- as.character(train.data$date)
train.data <- data.table(train.data)

train.data <- train.data[,list(farm = rep(1:7, each = length(wp1)),
    wp = c(wp1,wp2,wp3,wp4,wp5,wp6,wp7)
  ), by="date"]


train.data$date <- as.POSIXct(train.data$date, tz = "GMT")
train.data$hour <- as.factor(format(train.data$date, "%H"))
train.data$month <- as.factor(format(train.data$date, "%m"))
train.data$year <- as.factor(format(train.data$date, "%Y"))
train.data$date <- as.character(train.data$date)
setkeyv(train.data, c("date", "farm"))

rm(i, test.diff)


# wind forecast

library(data.table)
data.forecast.keys.dt <- NULL
data.forecast.others.dt <- NULL
min.forecast <- as.POSIXct(min(benchmark.data$start), tz = "GMT")
min.forecast <- min.forecast - as.difftime(35, unit="hours")
View(min.forecast)

for (i in 1:7) {
  data.forecast.cur <- read.csv(fn.dat.raw.dir(paste("windforecasts_wf",
                                                     i, ".csv", sep="")))
  data.forecast.cur$date <- as.POSIXct(
    as.character(data.forecast.cur$date),
    format = "%Y%m%d%H", tz = "GMT")
  
  
  data.forecast.cur$pdate <- data.forecast.cur$date + as.difftime(data.forecast.cur$hors, unit="hours")
  data.forecast.cur <- data.forecast.cur[
    data.forecast.cur$pdate >=min.forecast, ]
  data.forecast.cur$date <- as.character(data.forecast.cur$date)
  data.forecast.cur$pdate <- as.character(data.forecast.cur$pdate)
  data.forecast.cur$wd_cut <- cut(data.forecast.cur$wd, seq(0,360,30),
                                  include.lowest = T)
  data.forecast.cur <- data.forecast.cur[!is.na(data.forecast.cur$ws),]
  data.forecast.cur$farm <- i
  keys.forescast <- data.forecast.cur$date %in% c(benchmark.data.test$start,
                                                  benchmark.data$start)
  keys.blacklist <- data.forecast.cur$pdate %in% c(benchmark.data.test$date,
                                                   benchmark.data$date)
  keys.others <- !keys.forescast & !keys.blacklist 
  keys.tr <- keys.blacklist & data.forecast.cur$pdate %in% c(benchmark.data.test$date)
  
  data.forecast.cur$start <- data.forecast.cur$date
  data.forecast.cur$date <- data.forecast.cur$pdate
  data.forecast.cur$dist <- data.forecast.cur$hors
  data.forecast.cur$dist <- as.factor(sprintf("%02d", 
                                              data.forecast.cur$hors))
  
  data.forecast.cur$start <- as.POSIXct(data.forecast.cur$start, tz = "GMT")
  data.forecast.cur$turn <- as.factor(format(
    data.forecast.cur$start, "%H"))
  data.forecast.cur$start <- as.character(data.forecast.cur$start)
  data.forecast.cur$set <- NA
  data.forecast.cur$set[keys.forescast] <- rep(1:(sum(keys.forescast)/48), 
                                               each=48)
  data.forecast.cur$set[keys.others] <- rep(1:(sum(keys.others)/(36*4)), 
                                            each=(36*4))
  data.forecast.cur$set[keys.tr] <- rep(1:(sum(keys.tr)/(48*4)), 
                                        each=(48*4))
  data.forecast.keys.dt <- rbind(data.forecast.keys.dt, 
                                 data.forecast.cur[keys.forescast | keys.tr,])
  data.forecast.others.dt <- rbind(data.forecast.others.dt, 
                                   data.forecast.cur[keys.others,])
  
  View(data.forecast.cur)
}



cols.forecast <- c("date","farm","start", "dist","turn", "set",
                   "ws","wd","wd_cut")
keys.forescast <- c("date", "farm")
data.forecast.keys.dt <- data.table(data.forecast.keys.dt[, cols.forecast],
                                    key = c(keys.forescast))
data.forecast.others.dt <- data.table(data.forecast.others.dt[, cols.forecast],
                                      key = keys.forescast)

data.forecast.all.dt <- rbind(data.forecast.keys.dt,
                              data.forecast.others.dt)
setkeyv(data.forecast.all.dt, keys.forescast)

rm(min.forecast,i,data.forecast.cur,keys.others,
   cols.forecast,keys.forescast,keys.blacklist,keys.tr)


# history features

library(data.table)

train.data2 <- data.table(train.data)
View(train.data2)
train.data2 <- train.data2[!is.na(train.data2$wp),]
setkeyv(train.data2, c("date", "farm"))

cols.feat <- c("start", "farm", "dist")
data.feat.dt <- data.frame(unique(rbind(
  data.forecast.keys.dt[, 1, by=cols.feat],
  data.forecast.others.dt[, 1, by=cols.feat])))
data.feat.dt$V1 <- NULL

data.feat.dt$start <- as.POSIXct(
  data.feat.dt$start, tz = "GMT")

hist.length <- 6
for (i in 1:hist.length) {
  data.col <- paste("wp_hm",sprintf("%02d", i),sep="")
  data.col.key <- data.table(as.character(data.feat.dt$start - 
                                            as.difftime(i-1, unit="hours")), 
                             data.feat.dt$farm)
  data.feat.dt[[data.col]] <- train.data2[data.col.key]$wp
}

for (i in 1:hist.length) {
  data.col <- paste("wp_hp",sprintf("%02d", i),sep="")
  data.colm <- paste("wp_hm",sprintf("%02d", i),sep="")
  data.col.key <- data.table(as.character(data.feat.dt$start + 
                                            as.difftime(48+i, unit="hours")), 
                             data.feat.dt$farm)
  data.feat.dt[[data.col]] <- train.data2[data.col.key]$wp
  data.feat.dt[[data.col]][is.na(data.feat.dt[[data.col]])] <- 
    data.feat.dt[[data.colm]][is.na(data.feat.dt[[data.col]])]
}


for (i in 1:hist.length) {
  data.colm <- paste("wp_hm",sprintf("%02d", i),sep="")
  data.colp <- paste("wp_hp",sprintf("%02d", i),sep="")
  data.coln <- paste("wp_hn",sprintf("%02d", i),sep="")
  data.feat.dt[[data.coln]] <- data.feat.dt[[data.colm]]
  data.feat.dt[[data.coln]][as.integer(data.feat.dt$dist) > 24] <- 
    data.feat.dt[[data.colp]][as.integer(data.feat.dt$dist) > 24]
  data.feat.dt[[data.colp]] <- NULL
  data.feat.dt[[data.colm]] <- NULL
}



data.feat.dt$start <- as.character(data.feat.dt$start)
data.feat.dt$dist_prev <- NULL
data.feat.dt$V1 <- NULL
data.feat.dt <- data.table(data.feat.dt, key=c("start", "farm", "dist"))

rm(train.data2,i,data.col, 
   data.col.key,cols.feat,data.colm,
   data.colp,data.coln)






