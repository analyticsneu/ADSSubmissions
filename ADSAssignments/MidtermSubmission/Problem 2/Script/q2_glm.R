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

####### splitting data ###########
set.seed(100)
train=sample(1:nrow(tempdata),smp_size)
data_test<-tempdata[-train,]
data_train<-tempdata[train,]
isAd.test<-tempdata$isAd[-train]

##################################
model<-glm(isAd~height+width+aratio+V1+V2+V3+V4+V5+V6,family=binomial(link = "logit"),data = data_train)

summary(model)


test_prob<-predict(model,data_test,type = "response")
pred1<-rep(0,length(test_prob))

pred1[test_prob>0.5]<-1

pred<-factor(pred1, levels=c(0,1), labels=c("noAd","ad"))

library(ROCR)
library(caret)
confusionMatrix(data_test$isAd,pred)
prediction<-prediction(test_prob,data_test$isAd)
#prediction<-prediction(pred,test$isAd)

performance<-performance(prediction,measure = "tpr",x.measure = "fpr")
plot(performance,main="ROC curve", xlab="1-specificity",ylab="Sensitivity")

data_test$probs<-test_prob
data_test$prob<-sort(data_test$probs,decreasing = T)
lift<-lift(isAd~prob,data_test)
lift
xyplot(lift,plot = "gain", main="Lift curve for Q2 logistic regression")

