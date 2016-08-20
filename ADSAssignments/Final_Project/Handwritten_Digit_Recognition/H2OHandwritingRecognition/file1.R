
library(h2o)
h2o.init(nthreads = -1) # This means nthreads = num available cores

train <- h2o.importFile(path = "C:\\Users\\cr203945\\Documents\\NEU\\Deep Learning\\HandwritingRecognition\\train.csv")
test <- h2o.importFile(path = "C:\\Users\\cr203945\\Documents\\NEU\\Deep Learning\\HandwritingRecognition\\test.csv")

# To see a brief summary of the data, run the following command
summary(test)
summary(train)

MNIST_DIGITStrain =train
par( mfrow = c(10,10), mai = c(0,0,0,0))
for(i in 1:100){
  y = as.matrix(MNIST_DIGITStrain[i, 1:784])
  dim(y) = c(28, 28)
  image( y[,nrow(y):1], axes = FALSE, col = gray(255:0 / 255))
  text( 0.2, 0, MNIST_DIGITStrain[i,785], cex = 3, col = 2, pos = c(3,4))
}

# Specify the response and predictor columns
y <- "C785"
x <- setdiff(names(train), y)

# We encode the response column as categorical for multinomial
#classification
train[,y] <- as.factor(train[,y])
test[,y] <- as.factor(test[,y])

# Train a Deep Learning model and validate on a test set
model <- h2o.deeplearning(x = x,
                          y = y,
                          training_frame = train,
                          validation_frame = test,
                          distribution = "multinomial",
                          activation = "RectifierWithDropout",
                          hidden = c(200,200,200),
                          input_dropout_ratio = 0.2,
                          l1 = 1e-5,
                          epochs = 10)

model_cv <- h2o.deeplearning(x = x,
                             y = y,
                             training_frame = train,
                             distribution = "multinomial",
                             activation = "RectifierWithDropout",
                             hidden = c(200,200,200),
                             input_dropout_ratio = 0.2,
                             l1 = 1e-5,
                             epochs = 10,
                             nfolds = 5)




# View the specified parameters of your deep learning model
model@parameters

# Examine the performance of the trained model
#model # display all performance metrics

h2o.performance(model, train = TRUE) # training set metrics
h2o.performance(model, valid = TRUE) # validation set metrics

# Get MSE only
h2o.mse(model, valid = TRUE)

# Cross-validated MSE
h2o.mse(model_cv, xval = TRUE)


# Perform classification on the test set (predict class labels)
# This also returns the probability for each class
pred <- h2o.predict(model, newdata = test)
# Take a look at the predictions
head(pred)


# 
# par(mfrow=c(1,1))
# y = as.matrix(test[1, 1:784])
# dim(y) = c(28, 28)
# image( y[,nrow(y):1], axes = FALSE, col = gray(255:0 / 255))
# text( 0.2, 0, pred, cex = 3, col = 2, pos = c(3,4))

# Train a Deep Learning model and validate on a test set
# and save the variable importances
model_vi <- h2o.deeplearning(x = x,
                             y = y,
                             training_frame = train,
                             distribution = "multinomial",
                             activation = "RectifierWithDropout",
                             hidden = c(200,200,200),
                             input_dropout_ratio = 0.2,
                             l1 = 1e-5,
                             validation_frame = test,
                             epochs = 10,
                             variable_importances = TRUE) #added

# Retrieve the variable importance
h2o.varimp(model_vi)


#GRID Search for model comaprison - tweak certain parameters and
#observe changes in model behavior.
hidden_opt <- list(c(200,200), c(100,300,100), c(500,500,500))
l1_opt <- c(1e-5,1e-7)
hyper_params <- list(hidden = hidden_opt, l1 = l1_opt)

model_grid <- h2o.grid("deeplearning",
                       hyper_params = hyper_params,
                       x = x,
                       y = y,
                       distribution = "multinomial",
                       training_frame = train,
                       validation_frame = test)



# print out all prediction errors and run times of the models
model_grid

# print out the Test MSE for all of the models
for (model_id in model_grid@model_ids) {
  model <- h2o.getModel(model_id)
  mse <- h2o.mse(model, valid = TRUE)
  print(sprintf("Test set MSE: %f", mse))
}