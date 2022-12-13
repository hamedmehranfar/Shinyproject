

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
                  tabPanel("Plot", plotOutput("plot")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Table", tableOutput("table"))
      )
      
    )
  )
)

# Define server logic for random distribution app ----
server <- function(input, output) {
  
  # Reactive expression to generate the requested distribution ----
  # This is called whenever the inputs change. The output functions
  # defined below then use the value computed from this expression
  d <- reactive({
    brg_component <- input$component_id
    time_vec <- as.character(c((year(today())):input$date_year))
  })
  
  # Prepare the data for plotting
  
  plt_data <- bridge_data %>% filter(MixName == brg_component) %>% select(time_vec)
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  
  output$plot <- renderPlotly({
    dist <- input$dist
    n <- input$n
    
    hist(d(),
         main = paste("r", dist, "(", n, ")", sep = ""),
         col = "#75AADB", border = "white")
  })
  
  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(d())
  })
  
  # Generate an HTML table view of the data ----
  output$table <- renderTable({
    d()
  })
  
}

# Create Shiny app ----
shinyApp(ui, server)
