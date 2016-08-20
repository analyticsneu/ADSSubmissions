
library(h2o)
h2o.init(nthreads = -1) # This means nthreads = num available cores
h2o.removeAll()
train <- h2o.importFile(path = "C:\\Users\\cr203945\\Documents\\NEU\\Deep Learning\\HandwritingRecognition\\train.csv")
test <- h2o.importFile(path = "C:\\Users\\cr203945\\Documents\\NEU\\Deep Learning\\HandwritingRecognition\\test.csv")

# # To see a brief summary of the data, run the following command
# summary(test)
# summary(train)
# 
MNIST_DIGITStrain =train
#par( mfrow = c(10,10), mai = c(0,0,0,0))
for(i in 2:5){
  y = as.matrix(MNIST_DIGITStrain[i, 1:784])
  dim(y) = c(28, 28)
  png(filename=paste(i,".png", sep = ""))
  image( y[,nrow(y):1], axes = FALSE, col = gray(255:0 / 255))
  dev.off()
  #text( 0.2, 0, MNIST_DIGITStrain[i,785], cex = 3, col = 2, pos = c(3,4))
}

MNIST_DIGITStrain =train
#par( mfrow = c(10,10), mai = c(0,0,0,0))
for(i in 1:10){
  y = as.matrix(MNIST_DIGITStrain[i, 1:784])
  dim(y) = c(28, 28)
  png(filename=paste(i,".png", sep = ""))
  image( y[,nrow(y):1], axes = FALSE, col = gray(255:0 / 255))
  dev.off()
  #text( 0.2, 0, MNIST_DIGITStrain[i,785], cex = 3, col = 2, pos = c(3,4))
}


# Specify the response and predictor columns
y <- "C785"
x <- setdiff(names(train), y)

# We encode the response column as categorical for multinomial
#classification
train[,y] <- as.factor(train[,y])
test[,y] <- as.factor(test[,y])

# Train a Deep Learning model and validate on a test set
model <- h2o.deeplearning(model_id="HW_dl_model_basic",
                          x = x,
                          y = y,
                          training_frame = train,
                          validation_frame = test,
                          activation = "Rectifier",
                          hidden = c(200,200,200),
                          epochs = 100)

model_cv_Rectifier <- h2o.deeplearning(x = x,
                             y = y,
                             training_frame = train,
                             model_id="HW_dl_model_Rectifier", 
                             distribution = "multinomial",
                             activation = "Rectifier",
                             hidden = c(200,200,200),
                             input_dropout_ratio = 0.2,
                             l1 = 1e-5,
                             epochs = 10,
                             nfolds = 5)





path <- h2o.saveModel(model, 
                      path="C:\\Users\\cr203945\\Documents\\NEU\\Shiny\\Model\\deeplearning_HW_Basic_model", force=TRUE)

path_rect <- h2o.saveModel(model_cv_Rectifier, 
                      path="./deeplearning_HW_Rectifier_model", force=TRUE)
#
#It can be loaded later with the following command:
#
print(path)
m_loaded <- h2o.loadModel(path)
summary(m_loaded)
h2o.confusionMatrix(m_loaded)
h2o.performance(model, train = TRUE)
#plot(h2o.performance(m_loaded)) ## display ROC curve
# Get MSE only
h2o.mse(model)
pred <- h2o.predict(model, newdata =test)
prob<-as.data.frame(pred)
prob[1,1]