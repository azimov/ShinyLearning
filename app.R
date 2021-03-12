#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

#load darta e.g. load("myData.rds")
scores <- rbind(
  data.frame(
    database = "CCAE",
    t = rnorm(100),
    c = rnorm(100),
    category = c("0-365", "0-30")
  ),
  data.frame(
    database = "OPTUM",
    t = rnorm(100),
    c = rnorm(100),
    category = c("0-365", "0-30")
  ),
  data.frame(
    database = "MDCR",
    t = rnorm(100),
    c = rnorm(100),
    category = c("0-365", "0-30")
  )
)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Header"),

    # Sidebar with drop downs
    sidebarLayout(
        sidebarPanel(
            selectInput("database", "Datbase", c("CCAE", "OPTUM", "MDCR")),
            selectInput("conceptDomain", "Select concept domain:", c(1,2 ))
        ),

        # Show a plot of the generated distribution
        mainPanel(
            fluidRow(
                column(12,
            
                       fluidRow(
                           column(6,
                                  h2("Drugs 0-30"),
                                plotOutput("drug030")      
                            ),
                           column(width = 6,
                                  h2("Drugs 0-365"), plotOutput("drug0365"))
                       )
                )
            )
        )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output) {
  plotItems <- reactive({
      items <- scores[scores$database == input$database, ]
  })
  
  output$drug030 <- renderPlot({
      items <- plotItems()
      items <- items[items$category == "0-30", ]
      ggplot2::ggplot(items, aes(x=t, y=c)) + geom_point()
  })
  
  output$drug0365 <- renderPlot({
      items <- plotItems()
      items <- items[items$category == "0-365", ]
      ggplot2::ggplot(items, aes(x=t, y=c)) + geom_point()
  })
}   

# Run the application 
shinyApp(ui = ui, server = server)
