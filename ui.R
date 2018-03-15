library(shiny)
library(plotly)
library(leaflet)
library(dplyr)
library(shinythemes)
setwd("F:/Work/Edited")

shinyUI(fluidPage(
  theme = shinytheme("lumen"),
  navbarPage(
    "EditedTrends",id = "nav",
    tabPanel("Description",
             h3("The page below helps you find the searches made based on general terms in the description field of the data"),
             h3("(You can search terms like \'gold\' or \'jumpsuit\' to see its distribution within the data)"),
             textInput("Search12",label = "Enter value to explore"),
             actionButton("search","Search"),
             plotlyOutput("plot2")
    ),
    
    tabPanel("Product",
             h3("The page below helps you identify trends in categories or Brands every day/week"),
            br(),
             fluidRow
             (column(3,
                    uiOutput("field")),
             column(4,
                    uiOutput("Fe")),
             column(4,
                    uiOutput("field1"))
             ),
             plotlyOutput("plot1")
    ),
    tabPanel("Filter",
             h3("The page below helps you find the Top10 most searched products in US and Uk within a custom time range"),
             fluidRow
             (column(3,
                     textInput("dt1",label = "Enter start date",placeholder = "mm/dd/yyyy")),
               column(4,
                      textInput("dt2",label = "Enter end date",placeholder = "mm/dd/yyyy"))),
                      actionButton("go","Go"),
             
    tableOutput("plot3")
  ))
  
)
)