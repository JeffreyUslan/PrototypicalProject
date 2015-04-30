

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Ecotope Seattle Office"),
  
  sidebarLayout(
    sidebarPanel(
      actionButton("goButton", "Go"),
      htmlOutput("selectEnduses"),
      dateRangeInput("dates", label = h3("Date Range"),start="2015-04-24"),
      selectInput("smooth", label = h3("Smoother Range"), 
                  choices = list("None" = 1, "Day" = 288, "Week" = 2016, "4 weeks" = 8064), 
                  selected = 1)
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Plot", plotOutput("plot_gui")),
        tabPanel("Table", tableOutput("table_gui")),
        tabPanel("Compare", plotOutput("compare_gui")),
        tabPanel("Data Dictionary", tableOutput("dictionary_gui"))
      )
    )
  )
)
)





