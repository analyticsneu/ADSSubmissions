

data1<-read.csv("C:\\Rutuja\\ADS\\midterm\\Problem 1\\default of credit card clients.csv", header = T, stringsAsFactors = F)

data1<-data1[-1,]
data1<-data1[,-1]
#View(data1)

df<-data.frame(data1[,6:11])
df
levels=unique(do.call(c,df)) #all unique values in df
levels
out <- sapply(levels,function(x)rowSums(df==x)) #count occurrences of x in each row
colnames(out) <- levels
head(out)
colnames(out)<-c("count2","count_1","count0", "count_2","count1","count3","count4","count8","count7","count5","count6")


data.final<-cbind(data1,out)
colnames(data.final)
#View(data.final)
data.final<-data.frame(data.final)
data.final$Y<-factor(data.final$Y, levels=c(0,1), labels=c(0,1))

rm(df)

smp_size <- floor(0.75 * nrow(data.final))
set.seed(1000)
train=sample(1:nrow(data.final),smp_size)
data_test<-data.final[-train,]
data_train<-data.final[train,]
isAd.test<-data.final$isAd[-train]

##################################
#model<-glm(isAd~height+width+aratio+data1$`ancurl*click`+ data1$`url*ads`+data1$`ancurl*com`+data1$`ancurl*http+www`+data1$`url*images+home`+data1$`url*ad`,family=binomial(link = "logit"),data = train)
f<-Y~X1+X2+X3+X4+X5+X12+X14+X16+X17+X23+count_2
model<-glm(f,data = data_train)

summary(model)


test_prob<-predict(model,data_test,type = "response")
pred1<-rep(0,length(test_prob))

pred1[test_prob>0.5]<-1

pred<-factor(pred1, levels=c(0,1), labels=c(0,1))

library(ROCR)
library(caret)
confusionMatrix(data_test$Y,pred)
prediction<-prediction(test_prob,data_test$Y)
#prediction<-prediction(pred,test$isAd)

performance<-performance(prediction,measure = "tpr",x.measure = "fpr")
plot(performance,main="ROC curve", xlab="1-specificity",ylab="Sensitivity")

data_test$probs<-test_prob
data_test$prob<-sort(data_test$probs,decreasing = T)
lift<-lift(Y~prob,data_test)
lift
xyplot(lift,plot = "gain")
#perf <- performance(prediction,"lift","rpp")
#plot(perf, main="lift curve", colorize=T)

