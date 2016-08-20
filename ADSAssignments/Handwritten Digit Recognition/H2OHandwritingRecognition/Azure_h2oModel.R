library(h2o)
h2o.init(nthreads = -1) # This means nthreads = num available cores

# Map 1-based optional input ports to variables
train <- maml.mapInputPort(1) # class: data.frame

y <- "C785"
x <- setdiff(names(train), y)

train[,y] <- as.factor(train[,y])

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

path <- h2o.saveModel(model, 
                      path="./deeplearning_ImageProcessing_model", force=TRUE)

# Select data.frame to be sent to the output Dataset port
maml.mapOutputPort("path");