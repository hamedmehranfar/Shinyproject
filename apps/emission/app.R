library(shiny)
library(ggplot2)

ui <- fluidPage(
  
  # Application title
  titlePanel("CO2 Emissions Projection by 2050 and How each individual can contribute in achieving net-zero"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      sliderInput("R",
                  "No. of trees planted per Year",
                  min = 0,
                  max = 100,
                  value = 10),
      sliderInput("f",
                  "Amount of food waste avoided in a Year",
                  min = 0,
                  max = 500,
                  value = 25)
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
    V = cdioxide-(population*(input$R+(s-1)*input$R)*25*s+population*input$f*2.5*s)
    P = population*input$R*25*s+population*input$f*2.5
    # draw the plot with the specified number of bins
    plot(xValue,cdioxide, col = 'darkgray',
         xlab = 'Year',
         main = 'Plot to compare the combination of trees planted and food wastage avoided in order to achieve net zero', bty="n",type="l")
    lines(xValue,P)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
