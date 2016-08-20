library(imager)
im <- load.image("C:\\Users\\cr203945\\Downloads\\HW\\6.png")
im.gray <- grayscale(im)

#im.df<-as.data.frame(im.gray)

thmb <- resize(im.gray,28,28)
t.df<-as.data.frame(thmb)
t.df$v255<-t.df$value*255*255
t.df$final<-255-t.df$v255
trans<-t(t.df$final)
im.df<-as.data.frame(trans)
colnames(im.df)<-x
test<-as.h2o(im.df)
pred <- h2o.predict(model, newdata =test)
pred
