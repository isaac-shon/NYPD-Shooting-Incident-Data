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
                                      on the 'Raw Data' tab on this page. Some of the features that this app includes are:"),
                                    tags$ul(
                                      tags$li("Data visualizations detailing incident circumstances and victim characteristics"),
                                      tags$li("Examination of overall activity over time and time of day"),
                                      tags$li("Interactive maps showing the precise location of each shooting")
                                    )
                                  )
                                ),
                                column(
                                  width = 6,
                                  # Card-like div #2
                                  div(
                                    class = "card",
                                    style = "border: 1px solid #ddd; padding: 15px; margin: 10px; display: flex; flex-direction: column; align-items: center;",
                                    h4("About the Data"),
                                    p("This app makes use of incident-level data collected by the New York Police Department, 
                                       retrieved from NYC OpenData's online API. Each record in the data set represents a 
                                       specific shooting incident that occured between 2006-2023 in one of the City's five boroughs. 
                                       "),
                                   tags$img(src="NYCOpenData_Logo.png", width = 250 , height = 75)
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
                              monthly incidents, there appears to be a sharp increase in shootings in 2020:"),
                              plotlyOutput("line_plot")),
                     tabPanel(title = "Time of Day for Each Incident", 
                              h5("Instead of looking at the overall time series trend in our data, let us now take
                                 a closer look at what time of day shooting incidents have tended to occur. From 
                                 our histogram below, we can see pretty strong evidence that there is a 'seasonal'
                                 trend in the sense that most incidents take place during the night, rather than
                                 in the middle of the day:"),
                              plotlyOutput("histogram")),
                     tabPanel(title = "Location Type of Incident",
                              h5("Here, we can see that the vast majority of incidents since 2006 took place on
                                 street (1,886 incidents between 2006-2023). Among indoor shooting incidents, most of them took place inside of
                                 housing or dwelling units:"),
                              plotlyOutput("bar1")),
                     tabPanel(title = "Victim Race", 
                              h5("We now take a deeper look at the victims of these incidents. One unfortunate fact that arises is that a 
                              majority of gun violence victims ub New York City were black and hispanic residents. In particular, a sizeable
                              majority of victims were either black or black hispanic residents:"),
                              plotlyOutput("bar2")),
                     tabPanel(title = "Victim Age Group",
                              h5("We can see that the majority of shooting victims (who either survived or were murdered)
                              were between the ages 18-44. However, more concerning is that outside of this age range,
                              the second largest set of victims of gun violence were minors. "),
                              selectInput("victim_race", "Select Race:", choices = unique(df$vic_race), selected = unique(df$vic_race)[1]),
                              plotlyOutput("ageGroupPlot", height = 400))
                    )
              ),
      tabItem(tabName = "map",
              tabBox(id = "t2", width = 12,
                     tabPanel(title = "Incident Heatmap", leafletOutput("incidentMap", height = 600))
              )
      )
    )
    
    
  )
  
  
)

