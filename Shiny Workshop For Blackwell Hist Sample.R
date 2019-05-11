library(shiny)
library(shinydashboard)

df <- read.csv("Blackwell_Hist_Sample.csv")


# Shiny dashboard ----

ui <- dashboardPage(
  
  dashboardHeader(title = "First shiny dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      
      menuItem("1st option", tabName = "firstoption", icon = icon("bar-chart-o"), 
               menuSubItem("Histogram"),
               sliderInput("slider", "Number of bins:", 1, 100, 50)),
      
      
      menuItem("2nd option", tabName = "secondoption", icon = icon("dashboard")),
      menuItem("3rd option", tabName = "thirdoption", icon = icon("th"))
    )
  ),
  
  dashboardBody(
    
    fluidRow(
      box(plotOutput("plot1", height = 250))
    )
  )
)

server <- function(input, output) {
  histdata <- df$amount
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)
