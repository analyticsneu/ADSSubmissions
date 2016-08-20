install.packages("imager")

if(!require("devtools"))
  install.packages("devtools")
devtools::install_github("rstudio/rsconnect")

#connect to shiny account
rsconnect::setAccountInfo(name='dmdatascience', token='C6618436F567213FC8732AD229EAFFD7', 
                          secret='t4EiImv9ye9qEAVuwrN2lJpkWjkPilzPs3rvLoX0')