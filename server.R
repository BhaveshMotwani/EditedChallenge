library(plotly)
library(leaflet)
library(shiny)
library(dplyr)
library(zoo)
library(shinyjs)
library(leaflet)
setwd("F:/Work/Edited")


#Reading and summarizing data
products<-readRDS("products.rds")
product_info<-products[,c("product_id","product_name","description","brand","category",
                           "currency","date","max_discount","market","price","shop")]
categories <- c("brand","category")


shinyServer(function(input, output) {

observe({
    search12<-reactiveValues(data = NULL)
    xtra<-reactiveValues(data = NULL)
    
    output$field <- renderUI({
    selectInput(inputId="field",
                label = "Select Field to filter:",
                choices = categories,
                selected = 'brand')
    })

    output$Fe <- renderUI({
      selectInput(inputId = "Fe",
                  label = paste("Select",input$field,":"),
                  choices = unique(products[input$field]))
    })
    
    output$field1 <- renderUI({
      selectInput(inputId = "field1",
                  label = "Select duration:",
                  choices = c("Daily","Monthly"),
                  selected = "Monthly")
    })

    
    output$plot1 <- renderPlotly({
      if(is.null(input$field) | is.null(input$Fe))
        return()
      
     plot_data <- product_info[,c('date',input$field,'market')]
     plot_data <- plot_data[(plot_data[input$field]==input$Fe),]
     us <- plot_data[(plot_data['market']=='US'),]
     uk <- plot_data[(plot_data['market']=='UK'),]
     us['date']<- as.Date(us[['date']],format = "%Y-%m-%d %I:%M:%S")
     uk['date']<- as.Date(uk[['date']],fromat = "%Y-%m-%d %I:%M:%S")
     if(input$field1 == 'Daily')
      {
       us1 <- us %>% group_by(date) %>% tally()
       uk1 <- uk %>% group_by(date) %>% tally()
     }
     else
       if(input$field1 == 'Monthly')
       {
         us['date']<- format(us[['date']],format = "%Y-%m")
         uk['date']<- format(uk[['date']],format = "%Y-%m")
         us1 <- us %>% group_by(date) %>% tally()
         uk1 <- uk %>% group_by(date) %>% tally()
         us1['date'] <- as.yearmon(us1[['date']],format = "%Y-%m")
         uk1['date'] <- as.yearmon(uk1[['date']],format = "%Y-%m")
       }
      m <-ggplot()+
          geom_line(aes(date,n,color = 'US'),us1)+
          geom_line(aes(date,n,color = 'UK'),uk1)+
        labs(y = "Number of searches",x = "Date")+
        ggtitle(paste("Distribution of",input$field,"Searches over the period of Data"))
      
      print(m)
    })
    
    #randomVals <- eventReactive
    observeEvent(input$search, {
      search12$data <- dplyr::filter(product_info, grepl(input$Search12, description))
      plot_data <- search12$data[,c('date','description','market')]
      us <- plot_data[(plot_data['market']=='US'),]
      uk <- plot_data[(plot_data['market']=='UK'),]
      us['date']<- as.Date(us[['date']],format = "%Y-%m-%d %I:%M:%S")
      uk['date']<- as.Date(uk[['date']],fromat = "%Y-%m-%d %I:%M:%S")
      us['date']<- format(us[['date']],format = "%Y-%m")
      uk['date']<- format(uk[['date']],format = "%Y-%m")
      us1 <- us %>% group_by(date) %>% tally()
      uk1 <- uk %>% group_by(date) %>% tally()
      us1['date'] <- as.yearmon(us1[['date']],format = "%Y-%m")
      uk1['date'] <- as.yearmon(uk1[['date']],format = "%Y-%m")
    output$plot2 <- renderPlotly({
        m <-ggplot()+
          geom_line(aes(date,n,color = 'US'),us1)+
          geom_line(aes(date,n,color = 'UK'),uk1)+
          labs(y = "Number of searches",x = "Date")+
          ggtitle(paste("Distribution of the term (",input$Search12,") in description"))
        m
      })
      

      
    })
    
    observeEvent(input$go, {
    output$plot3 <- renderTable({
      #if(is.null(input$dt1)||is.null(input$dt2)) return
      date1 <- as.Date(input$dt1,format = "%m/%d/%Y")
      date2 <- as.Date(input$dt2,format = "%m/%d/%Y")
      plot_data <- product_info[,c('date','product_name','market')]
      us <- plot_data[(plot_data['market']=='US'),]
      uk <- plot_data[(plot_data['market']=='UK'),]
      us['date']<- as.Date(us[['date']],format = "%Y-%m-%d %I:%M:%S")
      uk['date']<- as.Date(uk[['date']],fromat = "%Y-%m-%d %I:%M:%S")
      xtradata1<-subset(us,(date > date1 & date < date2))
      xtradata2<-subset(uk,(date > date1 & date < date2))
      xtradata11<- head(xtradata1 %>% count(product_name, sort = TRUE),10)
      xtradata12<- head(xtradata2 %>% count(product_name, sort = TRUE),10)
      colnames(xtradata11) <- c('US','Frequency')
      colnames(xtradata12) <- c('UK','Frequency')
      xtra$data<-cbind(xtradata11,xtradata12) 
      xtra$data
      
      
    })    
    })
    
    })
})

