

data1<-read.csv("C:\\Users\\cr203945\\Documents\\NEU\\Midsem\\Problem 1\\default of credit card clients.csv", header = T, stringsAsFactors = F)
#colnames(data1)<-c(data1[1,])


#n<- c(data1[2,])
#colnames(data1)<-n
data1<-data1[-1,]
data1<-data1[,-1]
View(data1)

df<-data.frame(data1[,6:11])
df
levels=unique(do.call(c,df)) #all unique values in df
levels
out <- sapply(levels,function(x)rowSums(df==x)) #count occurrences of x in each row
colnames(out) <- levels
head(out)
colnames(out)<-c("count2","count-1","count0", "count-2","count1","count3","count4","count8","count7","count5","count6")


data.final<-cbind(data1,out)
colnames(data.final)
View(data.final)
