library(zoo)
library(tree)
data.values <- read.table("C:\\Rutuja\\ADS\\midterm\\ad-dataset\\ad.data", sep=',', header = FALSE)

t1<-trimws(data.values[,1])
t1[t1=="?"]<-NA
t1<-na.approx(t1)
data.values[,1]<-t1

t2<-trimws(data.values[,2])
t2[t2=="?"]<-NA
t2<-na.approx(t2)
data.values[,2]<-t2

t3<-trimws(data.values[,3])
t3[t3=="?"]<-NA
t3<-na.approx(t3)
data.values[,3]<-t3

t4<-trimws(data.values[,4])
t4[t4=="?"]<-NA
t4<-na.approx(t4)
data.values[,4]<-t4
data.values[data.values == "?"] <- NA

data.names <- read.table("C:\\Rutuja\\ADS\\midterm\\ad-dataset\\ad.names", sep=':', header = FALSE)
transposedf1 <- t(data.names[1])


mergeddata = data.values
colnames(mergeddata) = transposedf1[1,]
#View(mergeddata)
colnames(mergeddata)[1559]<-c("isAd")
data1<-mergeddata

#Transform isAd into a dichotomous factor
data1$isAd<-ifelse(data1$isAd=='ad.',1,0)
data1$isAd<-factor(data1$isAd, levels=c(0,1), labels=c("noAd","ad"))

#### splitting data######
tempdata<-data1
names(tempdata)[1400]<-"V1"
names(tempdata)[1307]<-"V2"
names(tempdata)[1244]<-"V3"
names(tempdata)[1230]<-"V4"
names(tempdata)[247]<-"V5"
names(tempdata)[399]<-"V6"
smp_size <- floor(0.75 * nrow(tempdata))

set.seed(500)
train_ind<-sample(seq_len(nrow(tempdata)),size=smp_size)

train<-tempdata[train_ind,]
test<-tempdata[-train_ind,]

#install.packages("devtools")
library(devtools)
library(neuralnet)
source_url('https://gist.githubusercontent.com/fawda123/7471137/raw/466c1474d0a505ff044412703516c34f1a4684a5/nnet_plot_update.r')
a = nnet(isAd ~ height+width+aratio+V1+V2+V3+V4+V5+V6, data=train,size=5,maxit=10000,decay=.001)
plot.nnet(a) ##neural network plot
table(test$isAd,predict(a,newdata=test,type="class"))
m<-predict(a,newdata=test,type="raw")
library(ROCR)

####ROC curve
detach(package:neuralnet, unload = TRUE)
pred = prediction(m,test$isAd)
perf = performance(pred,"tpr","fpr")
plot(perf,lwd=2,col="blue",main="ROC - Neural Network on Q2")
abline(a=0,b=1)

####Lift chart
test_prob<-predict(a,test,type = "raw")
test$probs<-test_prob
test$prob<-sort(test$probs,decreasing = T)
lift<-lift(isAd~prob,test)
lift
xyplot(lift,plot = "gain",main="Lift curve - Neural Network on Q2")

####################################33
