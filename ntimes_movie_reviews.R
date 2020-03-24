# Load R packages
library(shiny)
library(shinythemes)
library(tidyverse)
library(jsonlite)
library(DT)
# library(promises)
# library(future)
# plan(multiprocess)

# Declarations
NYTIMES_KEY <- "*****"

# Functions
get_movies <- function(query) {
    url <- paste0("https://api.nytimes.com/svc/movies/v2/reviews/search.json?query=", query, "&api-key=", NYTIMES_KEY)
    
    fromJSON(url, flatten = T) %>% data.frame() %>%
        select(results.display_title,results.link.url)
}

# Define UI
ui <- fluidPage(theme = shinytheme("cosmo"),
                navbarPage(
                    "NY Times Movie Reviews",
                    tabPanel("Links",
                             sidebarPanel(
                                 tags$h3("Input:"),
                                 textInput("txt1", "Movie Name:", ""),
                                 actionButton("search", "Search")
                                 
                             ), # sidebarPanel
                             mainPanel(
                                 h1("Links for NY Times Movie Reviews"),
                                 
                                 h4("Results:"),
                                 verbatimTextOutput("txtout"),
                                 dataTableOutput("tblOutput")
                                 
                             ) # mainPanel
                             
                    )
                    
                ) # navbarPage
) # fluidPage


# Define server function  
server <- function(input, output) {
    movies <- reactive({
        input$search
        
        query <- isolate(input$txt1)
        
        get_movies(query)
    })
    
    output$tblOutput <- renderDT(movies())
}


# Create Shiny object
shinyApp(ui = ui, server = server)
