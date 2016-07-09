library(zoo)
library(tree)
data.values <- read.table("D:\\Northeastern University\\ADS\\Assignment\\Midterm\\ads\\ad.data", sep=',', header = FALSE)

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

data.names <- read.table("D:\\Northeastern University\\ADS\\Assignment\\Midterm\\ads\\ad.names", sep=':', header = FALSE)
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
smp_size <- floor(0.75 * nrow(data1))


#Set the seed to make your partition reproductible
set.seed(300)
train_ind <- sample(seq_len(nrow(data1)), size = smp_size)

#Split the data into training and testing
train <- data1[train_ind, ]
test <- data1[-train_ind, ]

############## feature selection trial ###########
# library(FSelector)
# 
# 
# subset <- cfs(isAd~., data1)
# f <- as.simple.formula(subset, "isAd")
# print(f)
# 
# library(mlbench)
# 
# 
# subset <- consistency(isAd~., data1)
# f <- as.simple.formula(subset, "Class")
#print(f)
####################### Final Feature selection ##################

# control <- rfeControl(functions=rfFuncs, method="cv", number=10)
# # run the RFE algorithm
# results <- rfe(data1[,1:1558], data1$isAd, rfeControl=control)
# # summarize the results
# print(results)
# # list the chosen features
# predictors(results)
# # plot the results
# plot(results, type=c("g", "o"))

#############glm#############

model<-glm(isAd~height+width+aratio+`ancurl*click`+`url*ads`+`ancurl*com`+`ancurl*http+www`+`url*images+home`+`url*ad`,family=binomial(link = "logit"),data = train)
summary(model)

#Run the model on the test set
test_prob<-predict(model,test,type = "response")
pred<-rep("noAd",length(test_prob))

pred[test_prob>=0.5]<-1
pred[test_prob<0.5]<-0
#pred<-as.factor(pred)

pred<-factor(pred, levels=c(0,1), labels=c("noAd","ad"))

library(ROCR)
library(caret)
confusionMatrix(test$isAd,pred)
prediction<-prediction(test_prob,test$isAd)
performance<-performance(prediction,measure = "tpr",x.measure = "fpr")
plot(performance,main="ROC curve", xlab="1-specificity",ylab="Sensitivity")

#test$probs=test_prob
#test$prob=sort(test$probs,decreasing = T)
#lift<-lift(isAd~prob,data=test)
perf <- performance(prediction,"lift","rpp")
plot(perf, main="lift curve", colorize=T)



