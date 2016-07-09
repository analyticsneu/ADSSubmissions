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

smp_size <- floor(0.75 * nrow(data.final))

####### splitting data ###########
set.seed(1000)
train=sample(1:nrow(data.final),smp_size)
data_test<-data.final[-train,]
isAd.test<-data.final$Y[-train]


#library(rJava)



library(tree)
f<-Y~X1+X2+X3+X4+X5+X12+X14+X16+X17+X23+count_2
tree1 = tree(Y~.,data=data.final,subset=train)
summary(tree1)
tree_pred=predict(tree1,data_test,type="class")
#Display the tree structure and node labels
plot(tree1)
text(tree1, pretty =0) #Pretty=0 includes the category names

#tree_pred=predict(tree,data_test,type="tree")
table(tree_pred,isAd.test) ##confusion matrix

library(caret)

fit.pr = predict(tree1,newdata=data_test,type="vector")[,2]
fit.pred = prediction(fit.pr,data_test$Y)
fit.perf = performance(fit.pred,"tpr","fpr")
plot(fit.perf,lwd=2,col="blue",     main="ROC:  Classification Trees")
abline(a=0,b=1)

test_prob<-predict(tree1,data_test,type = "response")
data_test$probs<-fit.pr
data_test$prob<-sort(data_test$probs,decreasing = T)
lift<-lift(Y~prob,data_test)
lift
xyplot(lift,plot = "gain")
