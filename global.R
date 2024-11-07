# install.packages("httr")
# install.packages("jsonlite")
# install.packages("shiny")
# install.packages("DT")
# install.packages("forecast")
# install.packages("hms")
# install.packages("leaflet")
# install.packages("leaflet.extras")
# install.packages('rsconnect')
library(httr)
library(jsonlite)
library(shiny)
library(bslib)
library(DT)
library(ggplot2)
library(dplyr)
library(lubridate)
library(stringr)
library(forecast)
library(hms)
library(leaflet)
library(leaflet.extras)
library(rsconnect)
#-------------------------------------------------------------------------------#
# Retrieve Incident-Level Data from NYC Open Data API
url <- "https://data.cityofnewyork.us/resource/833y-fsy8.json?$limit=50000"
response <- GET(url)

# Check if the request was successful
if (status_code(response) == 200) {
  df <- fromJSON(content(response, "text"))
  print(paste("Successfully retrieved data."))  # Print or process the data as needed
} else {
  print(paste("Failed to retrieve data. Status code:", status_code(response)))
}
#-------------------------------------------------------------------------------#
# Some Data Cleaning:

df$occur_date <- str_sub(df$occur_date, 1, 10)
df$occur_date <- as.Date(df$occur_date, format = "%Y-%m-%d")

# Convert occur_time to HMS format:
df$occur_time <- as_hms(df$occur_time)

# Convert latitude and longitude to numeric:
df$latitude <- as.numeric(df$latitude)
df$longitude <- as.numeric(df$longitude)

# Create Year Variable
df$year <- year(df$occur_date)
  
#-------------------------------------------------------------------------------#
# Number of incidents over time:

incident_count <- df %>% mutate(month = floor_date(occur_date, "month")) %>% 
  group_by(month) %>% 
  summarise(incidents = n() )

# Convert to time series object
ts_data <- ts(incident_count$incidents, frequency = 12, start = c(2006, 1))

# Decompose the time series
decomp <- stl(ts_data, s.window = "periodic")

#-------------------------------------------------------------------------------#
# Breakdown of Incident Location Type:

location_type <- df %>% filter(loc_classfctn_desc != "(null)") %>% 
  group_by(loc_classfctn_desc) %>% 
  summarise(incidents = n())

# Breakdown by Borough:
borough_incidents <- df %>% 
  group_by(boro) %>% 
  summarise(incidents = n())

#-------------------------------------------------------------------------------#
# Breakdown of Victim Race:
victim_race <- df %>% 
  group_by(vic_race) %>% 
  summarise(incidents = n())

#-------------------------------------------------------------------------------#

