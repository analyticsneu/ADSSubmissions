# Map 1-based optional input ports to variables
path <- maml.mapInputPort(1) # class: data.frame
test <- maml.mapInputPort(2) # class: data.frame

m_loaded <- h2o.loadModel(path)
# summary(m_loaded)
# h2o.confusionMatrix(m_loaded)
# h2o.performance(model, train = TRUE)
pred <- h2o.predict(model, newdata = test)

#maml.mapOutputPort("pred");