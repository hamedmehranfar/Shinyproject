ui <- fluidPage(
  
  # Application title
  titlePanel("CO2 Emissions Projection by 2050"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("R",
                  "Kgs per month",
                  min = 0,
                  max = 10,
                  value = 1),
      sliderInput("f",
                  "yo",
                  min = 0,
                  max = 10,
                  value = 1)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define server logic required to draw the plot
server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    s    <- 1:100
    V = input$R*exp(-1*input$f*s)
    
    # draw the plot with the specified number of bins
    plot(s,V, col = 'darkgray',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Plot of waiting times', bty="n",type="l")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)