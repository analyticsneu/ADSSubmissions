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


neuralnettt<-neuralnet(KWH_Class~month+PeakHour+hour+day,data=train.neural,hidden=,err.fct = "ce",linear.output = FALSE)
neuralnettt
neuralnettt$result.matrix
plot(neuralnettt)
f1<-read.csv("C:\\Software\\r files\\forecastInput_1.csv", header = T)
testFormat<-f1[,c("month","PeakHour","hour","day")]
net.results <- compute(neuralnettt, testFormat)
y<-net.results$net.result
Kwh<-ifelse(y>0.5,"Above_Normal","Optimal")
final_forcast<-cbind(f1,Kwh)
View(final_forcast)
write.csv(final_forcast,"forecastOutput1_999999999_NeuralNetwork.csv")
xx=table(Kwh,f1$KWH_Class)
