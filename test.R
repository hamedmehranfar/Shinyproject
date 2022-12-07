bar_data <- components %>% filter(Type == "Steel")

bar_data_1 <- bar_data %>% count(Type, CS) %>% group_by(Type) %>% mutate(prob = (n/sum(n)*100))
bar_plot_1<- plot_ly(bar_data_1, x = ~Type, y = ~prob , color = ~CS ,type = "bar")  %>%
  layout( barmode = "stack")
bar_plot_1


bar_data_2 <- bar_data %>% count(Type, CS) %>% group_by(Type) %>% mutate(prob = (n/sum(n)*100))
bar_plot_2<- plot_ly(bar_data_2, x = ~Type, y = ~prob , color = ~CS ,type = "bar",
                     text = ~prob %>% round() ) %>% layout(yaxis = list(ticksuffix = "%") ) 
bar_data_2
# bar_data_2 <- components %>% count(Type, CS)
# bar_data_2 <- components %>% plot_ly( x = ~Type, y = ~n , color = ~CS ,type = "bar")
# bar_data_2
#_________________________________________________________________________________________________________




bridge_data %>% filter(MixName == input$component_id)
# Sample for the shiny app



# Define UI for random distribution app ----

ui <- fluidPage(
  
  # App title ----
  titlePanel("Overview of evolution of conditon states over time"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Select the random distribution type ----
      radioButtons("dist", "Distribution type:",
                   c("Normal" = "norm",
                     "Uniform" = "unif",
                     "Log-normal" = "lnorm",
                     "Exponential" = "exp")),
      
      # br() element to introduce extra vertical spacing ----
      br(),
      
      # Input: Slider for the number of observations to generate ----
      sliderInput("n",
                  "Number of observations:",
                  value = 500,
                  min = 1,
                  max = 1000)
      
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
    dist <- switch(input$dist,
                   norm = rnorm,
                   unif = runif,
                   lnorm = rlnorm,
                   exp = rexp,
                   rnorm)
    
    dist(input$n)
  })
  
  # Generate a plot of the data ----
  # Also uses the inputs to build the plot label. Note that the
  # dependencies on the inputs and the data reactive expression are
  # both tracked, and all expressions are called in the sequence
  # implied by the dependency graph.
  output$plot <- renderPlot({
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
