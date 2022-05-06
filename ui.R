library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(plotly)
library(DT)

#upload code from https://mastering-shiny.org/action-transfer.html

shinyUI <- dashboardPage(
  dashboardHeader(title = "Lakeshore Regional Child Advocacy Center", titleWidth = 425),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Upload", tabName = "uploads", icon = icon("upload")),
      menuItem("Data Table", tabName = "datatable", icon = icon("table")),
      menuItem("Visualizations", tabName = "visuals", icon = icon("chart-bar"), startExpanded = TRUE,
               menuSubItem("Bar Chart", tabName = "hbar"),
               menuSubItem("Heat Table", tabName = "htab")),
      menuItem("About", tabName = "about", icon = icon("code"))
    )
  ),

  dashboardBody(
    tabItems(
      tabItem(tabName = "uploads",
              fluidPage(
                titlePanel("File Upload"),
                helpText("Please upload a .csv file."),
                fileInput("file", NULL, buttonLabel = "Upload...", multiple = FALSE),
                textOutput("preview"),
                tableOutput("head")
              ) #end of upload file code
              ),#-fluid page
      
      tabItem(tabName = "datatable",
              fluidPage(
                titlePanel("Data Table"),
                fluidRow(
                  column(4,
                         selectInput("dtdate",
                                     "Date:",
                                     c("All",
                                       unique(as.character(data()$Date)))
                         ),
                         column(4,
                                selectInput("dtcounty",
                                            "County:",
                                            c("All",
                                              unique(as.character(data()$County)))
                                            )
                                ),
                         column(4,
                                selectInput("dtoffense",
                                            "Offense Type:",
                                            c("All",
                                              unique(as.character(data()$OffenseType)))
                                            )
                                )
                  ),
                  
                dataTableOutput("table")
              )
              )
              ),
      
      tabItem(tabName = "hbar",
              fluidPage(
                titlePanel("Horizontal Bar Chart"),
                selectInput("horizontalbar",
                            "County:",
                            "Counties"
                            #list("Washington", "Ozaukee", "Sheboygan")
                           #c("All",
                            # unique(as.character(data()$County)))
                  
                ),
                plotOutput("bar", height = "825px")
              )),
      
      tabItem(tabName = "htab",
              fluidPage(
              titlePanel("Heat Table"),
              plotOutput("heat")
              )),
      
      tabItem(tabName = "about",
              fluidPage(
                titlePanel("Developed by Dalton Espitia"),
                p("This dashboard will allow users to upload datasets and create visualizations."),
                p("Contact me at: daltonespitia56@gmail.com")
              ))
    ) #tab items end
  ) #dashboard body end
) #ui end
