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

#write.csv(data1,"C:\\Rutuja\\ADS\\midterm\\ad-dataset\\dataInCsv.csv")
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

#####tree with all data
library(tree)
tree = tree(isAd~height+width+aratio+V1+V2+V3+V4+V5+V6,tempdata)
summary(tree)

######tree with with training data
tree_train = tree(isAd~height+width+aratio+V1+V2+V3+V4+V5+V6,data=tempdata, subset=train)

tree_pred=predict(tree_train,data_test,type="tree")
#Display the tree structure and node labels
plot(tree_pred)
text(tree_pred, pretty =0) #Pretty=0 includes the category names

table(tree_pred,isAd.test) ##confusion matrix

library(caret)

fit.pr = predict(tree_pred,newdata=data_test,type="vector")[,2]
fit.pred = prediction(fit.pr,data_test$isAd)
fit.perf = performance(fit.pred,"tpr","fpr")
plot(fit.perf,lwd=2,col="blue",     main="ROC:  Classification Trees of Q2")
abline(a=0,b=1)

test_prob<-predict(tree_pred,data_test,type = "vector")
data_test$probs<-fit.pr
data_test$prob<-sort(data_test$probs,decreasing = T)
lift<-lift(isAd~prob,data_test)
lift
xyplot(lift,plot = "gain",main="Lift curve fo")
