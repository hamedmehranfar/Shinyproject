library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  # Application title
  titlePanel("CO2 Emissions Projection by 2050"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("R",
                  "No. of trees per month",
                  min = 0,
                  max = 150,
                  value = 1),
      sliderInput("f",
                  "Amount of food waste avoided",
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
    removal <- read.csv(paste(getwd(),"Data/removal.csv", sep = "/"))
    xValue <- removal$Year
    yValue <- removal$IndividualYear
    cdioxide <- removal$Emissions
    s<- 1:28
    X<- 1:400
    population <- 0.007880000000
    V = cdioxide/(population*input$R*25*12*s*input$f*2.5*12*s)
    
    # draw the plot with the specified number of bins
    plot(xValue,V, col = 'darkgray',
         xlab = 'Year',
         main = 'Plot to see the net-Zero', bty="n",type="l")
    lines(xValue,cdioxide)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
