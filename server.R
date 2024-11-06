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
  output$bar1 <- renderPlotly({
    ggplot(location_type, aes(x = reorder(loc_classfctn_desc, -incidents), y = incidents)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Incident Count by Location Classification",
           x = "Location Classification",
           y = "Number of Incidents") +
      theme_minimal()
  })
  
  output$bar2 <- renderPlotly({
    ggplot(victim_age_group, aes(x = vic_age_group, y = incidents)) +
      geom_bar(stat = "identity", fill = "steelblue") +
      labs(title = "Incident Count by Victim Age Group",
           x = "Victim Age Group",
           y = "Number of Incidents") +
      theme_minimal()
  })
    
  # Histogram of Data:
  output$histogram <- renderPlotly({
    ggplot(df, aes(x = occur_time)) + 
      geom_histogram(binwidth = 3600, color = "black", fill = "steelblue") + 
      labs(title = "Distribution of Incident Times", x = "Time of Day", y = "Frequency") + 
      theme_minimal()
  })
}