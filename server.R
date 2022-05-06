library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(DT)

#upload code from https://mastering-shiny.org/action-transfer.html
#data()$Date<-as.Date(data()$Date, "%y/%m/%d") --------- where and how?

shinyServer <- function(input, output, session) {
  
  #Upload file code
  data <- reactive({
    req(input$file)
    read.csv(input$file$datapath)
    #colnames("Date", "DOB", "Age at Interview", "Race", "Zip Code", "OffenseType", "County") - why doesn't this work
    #Error message if invalid file
 #   ext <- tools::file_ext(input$file$name)
  #  switch(ext,
   #        csv = vroom::vroom(input$file$datapath, delim = ","),
    #       validate("Invalid file; Please upload a .csv file")
    #)
  })
  
#File preview message
  output$preview <- renderText({
    req(input$file)
    paste("Here is a preview of", input$file$name)
  })
    
#file upload data display
  output$head <- renderTable(head(data()))

#data table date filter
#observe({
#  updateSelectInput(session, "dtdate", choices = data()$Date)
#})

#data table county filter  
#observe({
#  updateSelectInput(session, "dtcounty", choices = data()$County)
#})

#data table offense type filter
#observe({
#  updateSelectInput(session, "dtoffense", choices = data()$OffenseType)
#})


#tabledata <- reactive({
 # df <- data() %>% filter(Date %in% input$dtdate, County %in% input$dtcounty, OffenseType %in% input$dtoffense)
#})


#output$table <- renderDataTable(tabledata())

  #data must be 2-dimensional
 output$table <- DT::renderDataTable(DT::datatable({

if (input$dtdate != "All") {
  data() <- data()[data()$Date == input$dtdate,]
}
if (input$dtcounty != "All") {
  data() <- data()[data()$County == input$dtcounty,]
}
if (input$dtoffense != "All") {
  data() <- data()[data()$OffenseType == input$dtoffense,]
}
data()
}))

  #bar chart filter
  bardata <- reactive({
    df <- data() %>% filter(County %in% input$horizontalbar)
    })
 
  #Dynamic horizontal bar choices
  observe({
    updateSelectInput(session, "horizontalbar", choices = data()$County)
  })
  
  #horizontal bar chart
  output$bar <- renderPlot({
 #   stacked.bar <- ggplot(bardata(), aes(fill=OffenseType, x=Date, y=Count))
#    stacked.bar + geom_bar(stat='identity', position="stack") + coord_flip()
    stacked.bar <- ggplot(bardata(), aes(fill=OffenseType, x=Date))
    stacked.bar + geom_bar(stat='count', position="stack") + coord_flip()
  })
  
  #heat map
  output$heat <- renderPlot({
    heatmap(data(), Rowv = Count, Colv = County)
  })
}