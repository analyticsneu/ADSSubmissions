d<-read.csv("C:\\Users\\cr203945\\Documents\\NEU\\Image recognition Project\\TrainImgForAzure.csv")

ascii <- function(n) { rawToChar(as.raw(n)) }
#<br><br>chr(asc("a")) # 97<br>[1] "a"<br>

for (i in 1: nrow(d)){
  d[i,"Character"]<-ascii(d[i,"Label"])
}



n<-colnames(d)
data<-d[c("Character", n)]

write.csv(data, file = "TrainImgWithAsciiLabelBI.csv")

Freq.table<-as.data.frame(table(d$Character))

colnames(Freq.table)[1]<-"Image"
colnames(Freq.table)[2]<-"Frequency"

write.csv(Freq.table, file = "FrequencyTable.csv")
