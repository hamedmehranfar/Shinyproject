

# Define UI for random distribution app ----



ui <- fluidPage(
  
  # App title ----
  titlePanel("Overview of evolution of conditon states over time"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for the years ----
    sidebarPanel(
      
      
      # Input: Select the component ----
      selectInput(
        inputId = 'component_id',
        label = 'Please specify the component',
        choices = unique(bridge_data$MixName)
      ),
      
      
      
      br(),
      
      
      
      
      # Input: Select the random distribution type ----
      sliderInput(inputId = "date_year", label = "Selected year:",
                  min = year(today()), max = year(today())+14, value = year(today()), step = 1,
                  animate = animationOptions(interval = 500, loop = TRUE), sep = ""),
      
      # br() element to introduce extra vertical spacing ----
      br(),
      
      # Input: Slider for the number of observations to generate ----
      #sliderInput("n",
      #            "Number of observations:",
      #            value = 500,
      #            min = 1,
      #            max = 1000)
      
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      
      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotlyOutput("plot")),
                  #tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Table", dataTableOutput("table"))
      )
      
    )
  )
  
)

# Define server logic for the app ----
server <- function(input, output) {
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  d <- reactive({
    
      brg_component = input$component_id
      time_vec = as.character(c((year(today())):input$date_year))
      
    
    
  })
  
  #brg_component <- input$component_id
  #time_vec <- as.character(c((year(today())):input$date_year))

  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  
  output$plot <- renderPlotly({
    # Prepare the data for plotting
    
    plt_data <- bridge_data %>% filter(MixName == input$component_id) %>% select(all_of(as.character(c((year(today())):input$date_year))))
    plt_data <- as.data.frame (t(plt_data))
    plt_data <- `colnames<-`(plt_data,c(1:5))
    
    
    fig_2<- plot_ly(plt_data, y =~`1` , x =rownames(plt_data), name = 'CS1' ,
                    type = 'scatter', mode = 'none', stackgroup = 'one', groupnorm = 'percent')
    fig_2 <- fig_2 %>% add_trace(y = ~`2`, name = 'CS2')
    fig_2 <- fig_2 %>% add_trace(y = ~`3`, name = 'CS3')
    fig_2 <- fig_2 %>% add_trace(y = ~`4`, name = 'CS4')
    fig_2 <- fig_2 %>% add_trace(y = ~`5`, name = 'CS5')
    fig_2 <- fig_2 %>% layout( #title = 'Evolution of condition states over time', 
                                    xaxis = list(title = 'Year'), yaxis = list(title = 'Percentage') )

  })
  
  # Generate a summary of the data ----
  #output$summary <- renderPrint({
  #  summary(bridge_data %>% filter(MixName == input$component_id))
  #})
  
  # Generate an HTML table view of the data ----
  output$table <- renderDataTable({
    bridge_data %>% filter(MixName == input$component_id)
    
  })
  
}


# Create Shiny app ----
shinyApp(ui, server)
