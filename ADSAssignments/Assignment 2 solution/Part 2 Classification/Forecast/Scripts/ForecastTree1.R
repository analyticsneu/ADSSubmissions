raw.data<-read.csv("C:\\Software\\r files\\Hourly_Filled_Data.csv", header = T)
avg_kWh<-mean(raw.data$kWh)
KWH_Class<-ifelse(raw.data$kWh>avg_kWh,"Above_Normal","Optimal")
raw.data<-data.frame(raw.data,KWH_Class)
#install.packages("tree")
raw.data$X<-NULL
library(tree)
tree=tree(KWH_Class~.-kWh-Date,raw.data)
summary(tree)
plot(tree)
text(tree,pretty = 0)
set.seed(1000)
train_data=sample(1:nrow(raw.data),6000)
test_data=raw.data[-train_data,]
tree.train=tree(KWH_Class~-Date,raw.data,subset=train_data)
KWH.test=KWH_Class[-train_data]
f1<-read.csv("C:\\Software\\r files\\forecastInput_1.csv", header = T)
Account<-c(nrow(f1))
Account<-t(Account)
f1<-cbind(f1,Account)
tree.pred=predict(tree.train,f1,type = "class")

finalOP<-cbind(f1,tree.pred)
write.csv(finalOP,"forecastOutput1_999999999_ClassificationTree.csv")