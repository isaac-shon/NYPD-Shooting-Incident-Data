#install.packages("plotly")
library(shiny)
library(shinydashboard)
library(plotly)

dashboardPage(
  skin = "black",
  dashboardHeader(title = "Shooting Incidents in New York City", titleWidth = 600,
            
                  tags$li(class="dropdown",tags$a(href="https://github.com/isaac-shon", icon("github"), "GitHub", target="_blank"))
                  
                  ),
  
  dashboardSidebar(
    sidebarMenu(
      id = "sidebar",
      menuItem("Dataset Overview", tabName = "data", icon = icon("database")),
      menuItem("Visualizations", tabName = "viz", icon = icon("chart-line")),
      menuItem("Mapping", tabName = "map", icon = icon("map"))
      
    )
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "data",
              tabBox(id = "t1", width = 12, 
                     tabPanel("About", icon = icon("address-card"),
                              fluidRow(
                                column(
                                  width = 6,
                                  # Card-like div #1
                                  div(
                                    class = "card",
                                    style = "border: 1px solid #ddd; padding: 15px; margin: 10px;",
                                    h4("Introduction"),
                                    p("This data visualization app is meant to serve as an interactive guide to understanding
                                      shooting incidents in New York City. To see the raw data used in this app, click
                                      on the 'Raw Data' tab on this page.")
                                  )
                                ),
                                column(
                                  width = 6,
                                  # Card-like div #2
                                  div(
                                    class = "card",
                                    style = "border: 1px solid #ddd; padding: 15px; margin: 10px;",
                                    h4("About the Data"),
                                    p("This app makes use of incident-level data collected by the New York Police Department, 
                                       retrieved from NYC OpenData's online API. Each record in the data set represents a 
                                       specific shooting incident that occured in one of the City's five boroughs. 
                                       ")
                                  )
                                )
                              )),
                     tabPanel(title = "Raw Data", icon = icon("address-card"), DT::dataTableOutput("data_table"))
                     )
              ),
      tabItem(tabName = "viz",
              tabBox(id = "t2", width = 12,
                     tabPanel(title = "Number of Incidents Over Time",
                              h5("In this series of line plots, we have monthly shooting incidents reported by 
                              the New York Police Department from 2006 to the end of 2023. The raw times series 
                              data (shown by the top panel) is broken down into seasonal, trend and irregular 
                              components using LOESS. In the second panel, we show the overall trend in shooting 
                              incidents. We can see that while there has been a gradual decrease over time in 
                              monthly incidents, there appears to be a sharp increase in shootings in 2020."),
                              plotlyOutput("line_plot")),
                     tabPanel(title = "Location Type of Incident", plotlyOutput("bar1")),
                     tabPanel(title = "Victim Age Group", plotlyOutput("bar2")),
                     tabPanel(title = "Time of Day for Each Incident", plotlyOutput("histogram")),
                     tabPanel(title = "Suspect Age Group", h4("tabpanel 5 placeholder"))
                    )
              ),
      tabItem(tabName = "map",
              tabBox(id = "t2", width = 12,
                     tabPanel(title = "Location of Incidents", h4("tabpanel 1 placeholder"))
              )
      )
    )
    
    
  )
  
  
)

