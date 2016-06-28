setwd("C:\\Software")
#Reading Hourly_Filled_Data.csv file for further processing
raw.data<-read.csv("C:\\Software\\r files\\Hourly_Filled_Data.csv", header = T)
View(raw.data)
#Create KWH_Class column
avg_kWh<-mean(raw.data$kWh)
KWH_Class<-ifelse(raw.data$kWh>avg_kWh,"Above_Normal","Optimal")
raw.data<-data.frame(raw.data,KWH_Class)
raw.data$X<-NULL

#Train and Test data
smp_size <- floor(0.75 * nrow(raw.data))
set.seed(1000)
train_ind <- sample(seq_len(nrow(raw.data)), size = smp_size)
train <- raw.data[train_ind, ]
test <- raw.data[-train_ind, ]

##i)Logistic Regression
log_reggression_model<-glm(KWH_Class~-kWh-Date,family = 'binomial',data=train)
summary(log_reggression_model)
prediction_values<-predict(log_reggression_model,type='response')
confusionMatrix_log_reg<-table(prediction_values,train$KWH_Class)
confusionMatrix_log_reg

##############################################
##ii)Classification Tree
library(tree)
tree=tree(KWH_Class~.-kWh-Date,raw.data)
summary(tree)
plot(tree)
text(tree,pretty = 0)
set.seed(1000)
train_data=sample(1:nrow(raw.data),6000)
test_data=raw.data[-train_data,]
tree.train=tree(KWH_Class~.-kWh-Date,raw.data,subset=train_data)
KWH.test=KWH_Class[-train_data]
tree.pred=predict(tree.train,test_data,type = "class")
confusion_mat_tree=table(tree.pred,KWH.test)

write.csv("Account No",file = "ClassificationPerformancemetrics.csv")
write.table(raw.data[1,1],file = "ClassificationPerformancemetrics.csv",append = T,col.names = F, sep=",")
write.table("Classification Tree",file =  "ClassificationPerformancemetrics.csv",append =T , sep=",")

write.table(confusion_mat_tree,file =  "ClassificationPerformancemetrics.csv",append =T , sep=",")
##prune the tree
cv.rawdata=cv.tree(tree,FUN = prune.misclass)
names(cv.rawdata)
cv.rawdata
prune.rawdata=prune.misclass(tree,best = 8)
plot(prune.rawdata)
text(prune.rawdata,pretty = 0)
pred_rawdata=predict(prune.rawdata,test_data,type = "class")
table(pred_rawdata,KWH.test)

#######################################################################
##Neural Network
raw.data<-read.csv("C:\\Software\\r files\\Hourly_Filled_Data.csv", header = T)
View(raw.data)
avg_kWh<-mean(raw.data$kWh)
KWH_Class<-ifelse(raw.data$kWh>avg_kWh,1,0)
raw.data<-data.frame(raw.data,KWH_Class)
raw.data$X<-NULL

smp_size <- floor(0.75 * nrow(raw.data))
set.seed(2000)
train_neural <- sample(seq_len(nrow(raw.data)), size = smp_size)

train.neural <- raw.data[train_neural, ]
test.neural <- raw.data[-train_neural, ]

neuralnettt<-neuralnet(KWH_Class~month+PeakHour+hour+day,data=train.neural,hidden=2,err.fct = "ce",linear.output = FALSE)
neuralnettt
neuralnettt$result.matrix
plot(neuralnettt)
testFormat<-test.neural[,c("month","PeakHour","hour","day")]
net.results <- compute(neuralnettt, testFormat)
y<-net.results$net.result
Kwh<-ifelse(y>0.5,1,0)
xx=table(Kwh,test.neural$KWH_Class)

write.table("Neural Network",file =  "ClassificationPerformancemetrics.csv",append =T , sep=",")
write.table(table(Kwh,test.neural$KWH_Class),file = "ClassificationPerformancemetrics.csv",append = T,col.names = F, sep=",")
