#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


require(imager)
library(shiny)
require(jpeg)
require(png)

shinyUI(pageWithSidebar(
  headerPanel(title = 'Image Classification using MXNetR',
              windowTitle = 'Image Classification using MXNetR'),
  
  sidebarPanel(
    includeCSS('boot.css'),
    tabsetPanel(
      id = "tabs",
      tabPanel("Upload Image",
               fileInput('file1', 'Upload a PNG / JPEG File:'))
      # tabPanel(
      #   "Use the URL",
      #   textInput("url", "Image URL:", "http://"),
      #   actionButton("goButton", "Go!")
      # )
    )
  ),
  
  mainPanel(
    h3("Image"),
    tags$hr(),
    imageOutput("originImage", height = "auto"),
    tags$hr(),
    h3("What is in it?"),
    tags$hr(),
    verbatimTextOutput("summary")
  )
))

