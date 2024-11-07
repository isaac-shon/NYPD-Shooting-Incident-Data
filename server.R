function(input, output, session){
  # Table of Loaded Data:
  output$data_table <- DT::renderDataTable(df, options = list(scrollX = TRUE))
  
  # Line plot
  output$line_plot <- renderPlotly({
    autoplot(decomp) +
      theme_minimal() +
      labs(title = "Decomposition of Monthly Shooting Incidents", x = "Date")
  })
  
  # Barplots of Data:
  
  output$borough <- renderPlotly({
    ggplot(borough_incidents, aes(x = reorder(boro, -incidents), y = incidents)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Incident Count by Borough",
           x = "Borough",
           y = "Number of Incidents") +
      theme_minimal()
  })
  
  output$location <- renderPlotly({
    ggplot(location_type, aes(x = reorder(loc_classfctn_desc, -incidents), y = incidents)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Incident Count by Location Classification",
           x = "Location Classification",
           y = "Number of Incidents") +
      theme_minimal()
  })
  
  
  output$race <- renderPlotly({
    ggplot(victim_race, aes(x = reorder(vic_race, -incidents), y = incidents)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Incident Count by Victim Race",
           x = "Victim Race",
           y = "Number of Incidents") +
      theme_minimal()
  })
  
  filteredData <- reactive({ 
    df %>% mutate(vic_age_group = ifelse(vic_age_group == "(null)", "UNKNOWN", vic_age_group)) %>% 
      filter(vic_age_group != "1022") %>% 
      filter(vic_race == input$victim_race) %>% 
      group_by(vic_age_group) %>% 
      summarise(incidents = n())
    })
  
  output$ageGroupPlot <- renderPlotly({
    filteredData() %>% 
      ggplot(aes(x = vic_age_group, y = incidents)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Incident Count by Victim Age Group",
           x = "Victim Age Group",
           y = "Number of Incidents") +
      theme_minimal()
  })
    
  # Histogram of Data:
  output$histogram <- renderPlotly({
    ggplot(df, aes(x = occur_time)) + 
      geom_histogram(binwidth = 1800, color = "black", fill = "steelblue") + 
      labs(title = "Distribution of Incident Times", x = "Time of Day", y = "Frequency") + 
      theme_minimal()
  })
  
  # Map of Data:
  output$incidentMap <- renderLeaflet({
    df %>% filter(!is.na(latitude)) %>% 
      leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }") %>% 
      addProviderTiles(providers$CartoDB.Positron) %>%
      addHeatmap(lng = ~longitude, lat = ~latitude, blur = 5, max = 1, radius = 15) 
  })
  
  # Map of Murders:
  filteredMurderData <- reactive({ 
    df %>% 
      filter(year == as.numeric(input$Year_Incident)) %>% 
      filter(statistical_murder_flag == as.logical(input$Murder_Incident)) %>% 
      filter(!is.na(latitude))
  })
  
  
  output$MurderPlot <- renderLeaflet({
    marker_color <- if (input$Murder_Incident == TRUE) {
      "red"   
    } else {
      "green"
    }
    
    filteredMurderData()  %>%
      leaflet(options = leafletOptions(zoomControl = FALSE)) %>%
      htmlwidgets::onRender("function(el, x) {
        L.control.zoom({ position: 'topright' }).addTo(this)
    }") %>% 
      addProviderTiles(providers$CartoDB.Positron) %>%
      addCircleMarkers(lng = ~longitude, lat = ~latitude, 
                       radius = 2,
                       color = marker_color,
                       fillColor = marker_color,
                       fillOpacity = 0.3, 
                       stroke = FALSE)
  })

}