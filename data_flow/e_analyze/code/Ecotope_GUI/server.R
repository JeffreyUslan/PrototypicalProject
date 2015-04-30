
shinyServer(function(input, output) {
  
  
  searchVar<- reactive({  
    n_nums=sapply(file,is.numeric)    
    enduses=names(file)[n_nums]
    enduses=try(as.character(data_dictionary$Variable[order(data_dictionary$Units)][data_dictionary$Variable[order(data_dictionary$Units)]%in% enduses]),silent=TRUE)
    enduses=try(enduses[order(enduses)],silent=TRUE)
  })
  
  
  output$selectEnduses <- renderUI({ 
    try(checkboxGroupInput("enduses", label = h3("Select End Use"), searchVar(),selected=searchVar()[1] ),silent=TRUE)
  })
  
  
  
  
  output$plot_gui <- renderPlot({
    input$goButton
    enduses=isolate(input$enduses)
    dates=isolate(input$dates)
    smooth=isolate(input$smooth)
    plot_gui(enduses,dates,smooth)    
    
    
  })
  
#   vis <- reactive({
#     df %>% ggvis(~x, ~y) %>% layer_points() %>% 
#       add_tooltip(function(x) paste0(names(x), ": ", 
#                                      format(x), collapse = "<br />"), "hover") %>%
#       vis %>% bind_shiny("plot_gui")  
#   })
  
  output$table_gui<- renderTable({
    
    enduses=input$enduses
    dates=input$dates
    smooth=input$smooth
    cool_table=table_gui(enduses,dates,smooth)
    
  },include.rownames=FALSE,NA.string="")
  
  output$compare_gui<- renderPlot({
    input$goButton
    enduses=isolate(input$enduses)
    dates=isolate(input$dates)
    smooth=isolate(input$smooth)
    compare_gui(enduses,dates,smooth)
  })
  
  output$dictionary_gui<- renderTable({
    
    enduses=input$enduses
    dictionary=dictionary_gui(enduses)
    
  },include.rownames=FALSE)
  
})


