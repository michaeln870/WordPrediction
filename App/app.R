library(shiny)
source("functions.R")


ui <- fluidPage(
    titlePanel("Word Prediction Application"),
    h3(strong("**Work in Progress**")),
    textInput("string", "Write something:"),
    textOutput("prediction"),
    verbatimTextOutput("text"),
    hr(),
    HTML(
      paste(
        h5("This is only a prototype, the current algorithm is very simple and 
           doesn't do a very good job at predicting the next word."),
        h5("I still need to:"),
        h5("- Implement a proper scoring algorithm"),
        h5("- Build a system to display more suggestions"),
        h5("- Test and optimize"),
        h5("- Improve UI and add features")
      )
    )
)
server <- function(input, output) {
    word <- reactive({predict_word(input$string)})
    
        output$prediction <- renderText({
            paste("Suggested word:", word())
        })
        output$text <- renderText({
            paste(input$string, word())
        })   

}
shinyApp(ui, server)
