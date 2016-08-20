#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(imager)
#install.packages("h2o", type="source", repos=(c("http://h2o-release.s3.amazonaws.com/h2o/rel-turin/4/R")))
library(h2o)
localH2O = h2o.init()
h2o.removeAll()
model <<- h2o.loadModel("C:\\Users\\cr203945\\Documents\\NEU\\Shiny\\Model\\deeplearning_HW_Basic_model\\HW_dl_model_basic")

train <- h2o.importFile(path = "C:\\Users\\cr203945\\Documents\\NEU\\Shiny\\HWShiny\\train.csv")
y <- "C785"
x <- setdiff(names(train), y)

# resizeImage = function(im, w.out, h.out) {
#   # function to resize an image 
#   # im = input image, w.out = target width, h.out = target height
#   # Bonus: this works with non-square image scaling.
#   
#   # initial width/height
#   w.in = nrow(im)
#   h.in = ncol(im)
#   
#   # Create empty matrix
#   im.out = matrix(rep(0,w.out*h.out), nrow =w.out, ncol=h.out )
#   
#   # Compute ratios -- final number of indices is n.out, spaced over range of 1:n.in
#   w_ratio = w.in/w.out
#   h_ratio = h.in/h.out
#   
#   # Do resizing -- select appropriate indices
#   im.out <- im[ floor(w_ratio* 1:w.out), floor(h_ratio* 1:h.out)]
#   
#   return(im.out)
# }

shinyServer(function(input, output) {
  ntext <- eventReactive(input$goButton, {
    print(input$url)
    if (input$url == "http://") {
      NULL
    } else {
      tmp_file <- tempfile()
      download.file(input$url, destfile = tmp_file)
      tmp_file
    }
  })
  
  output$originImage = renderImage({
    list(src = if (input$tabs == "Upload Image") {
      if (is.null(input$file1)) {
        if (input$goButton == 0 || is.null(ntext())) {
          'cthd.jpg'
        } 
      } else {
        input$file1$datapath
      }
    } else {
      if (input$goButton == 0 || is.null(ntext())) {
        if (is.null(input$file1)) {
          'cthd.jpg'
        } else {
          input$file1$datapath
        }
      } 
    },
    title = "Original Image")
  }, deleteFile = FALSE)
  
  output$summary <- renderText({
    src = if (input$tabs == "Upload Image") {
      if (is.null(input$file1)) {
        if (input$goButton == 0 || is.null(ntext())) {
          '3.jpg'
        } 
      } else {
        input$file1$datapath
      }
    } else {
      if (input$goButton == 0 || is.null(ntext())) {
        if (is.null(input$file1)) {
          '3.jpg'
        } else {
          input$file1$datapath
        }
      } 
    }
    
    # src<-system.file("C:\\Users\\cr203945\\Documents\\NEU\\Shiny\\HWShiny\\HandWritingRecognitionApp1\\5.png")
     #im <- load.image("C:\\Users\\cr203945\\Downloads\\HW\\6.png")
    # im.gray <- grayscale(im)
    # dim(im.gray)
    # im.df<-as.data.frame(im.gray)
    # im.arr<-as.array(im.gray)
    # 
    # normed <- resizeImage(im,28,28)
    # test.h20<-as.h2o(normed)
    im <- load.image(src)
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
    prob<-as.data.frame(pred)
    as.character(prob[1,1])
    # max.idx <- order(prob[,1], decreasing = TRUE)[1:5]
    # result <- synsets[max.idx]
    # res_str <- ""
    # for (i in 1:5) {
    #   tmp <- strsplit(result[i], " ")[[1]]
    #   for (j in 2:length(tmp)) {
    #     res_str <- paste0(res_str, tmp[j])
    #   }
    #   res_str <- paste0(res_str, "\n")
    # }
    # res_str
    
  })
  
})