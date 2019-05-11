### Taken from Joan Claverol, mentor at Ubiqum Code Academy ###
###                       05/11/2019                        ###

#Load Libraries: p_load can install, load,  and update packages
if(require("pacman")=="FALSE"){
  install.packages("pacman")
}

pacman::p_load(shiny, shinydashboard, dplyr, ggplot2)

# SetWD and Load Data 
Data <-read.csv("Blackwell_Hist_Sample.csv")

#### 1. PREPROCESSING ####
# Rename and transform Buying
Data<-Data %>% rename(Buying="in.store")  %>% mutate(Buying=factor(Buying))
Data<-Data %>% mutate(Buying= recode(Buying, "0" = "Online", "1" = "InStore"))

# Rename and transform Region
Data<-Data %>% rename(Region="region")  %>% mutate(Region=factor(Region))
Data<-Data %>% mutate(Region= recode(Region, "1" = "East", "2" = "West","3" = "South", "4" = "Central"))

#### 2. SHINY ####

##### USER INTERFACE #####
ui <- dashboardPage(
  
  # Header
  dashboardHeader(
    title = "Blackwell Electronics",
    titleWidth=250
  ),
  
  # Sidebar
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dataset", tabName = "dataset", icon = icon("fas fa-address-book")), 
      menuItem("BarPlot", tabName = "barplot", icon = icon("bar-chart-o")),              
      menuItem("Histogram", tabName = "histogram", icon = icon("line-chart")),
      
      selectInput(inputId = "Region", label = "Select a region",choices=c("East", "West", "South", "Central")),
      sliderInput(inputId = "selectedAge","Select age:",min = 0,max = 100,value = c(18, 80))
      
    )
  ),
  
  # Body
  dashboardBody(
    tabItems(
      tabItem(tabName = "dataset", box(dataTableOutput("datasetTable"))),
      
      tabItem(tabName = "barplot", box(plotOutput("barplotOutput"))),
      
      tabItem(tabName = "histogram", box(plotOutput("histogOutput")))
      
    )
  )
)

##### SERVER #####
server <- function(input, output) {
  
  output$datasetTable <- renderDataTable ({
    Data
  })
  
  output$barplotOutput <- renderPlot ({
    ggplot(Data, aes(x=Region))+
      geom_bar()
  })  
  
  output$histogOutput <- renderPlot ({
    ggplot(Data, aes(x=age))+
      geom_histogram()
  })  
  
}

shinyApp(ui, server)

##### SERVER 2 (REACTIVE) #####
server <- function(input, output) {
  
  DataReactive <- reactive({
    Data %>% filter(Region == input$Region) %>%
      filter(age >= input$selectedAge[1] & age <= input$selectedAge[2])
  }) 
  
  output$datasetTable <- renderDataTable ({
    FinalData<-DataReactive()
  })
  
  output$barplotOutput <- renderPlot ({
    FinalData<-DataReactive()
    ggplot(FinalData, aes(x=Region))+
      geom_bar()
  })  
  
  output$histogOutput <- renderPlot ({
    FinalData<-DataReactive()
    ggplot(FinalData, aes(x=age))+
      geom_histogram()
  })  
  
}

shinyApp(ui, server)