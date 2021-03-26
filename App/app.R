library(shiny)
library(DT)

source("functions.R")


ui <- fluidPage(
  tabsetPanel(
    tabPanel("Word Predictor",
      titlePanel("Next Word Predictor"),
      sidebarLayout(
        sidebarPanel(
          textInput("string", "Please write something:"),
          h5("Prediction:"),
          htmlOutput("prediction"),
          hr(),
          sliderInput("slider", "Number of suggestions to be displayed",
                      min=0, max= 30, value = 10),
          checkboxInput("recursion", "Add recursion", value = FALSE),
          checkboxInput("DT", "Add a searchable table", value = FALSE),
          width = 6
        ),
        mainPanel(
          h3("More Suggestions"),
          tags$style(type="text/css",
                     ".shiny-output-error { visibility: hidden; }",
                     ".shiny-output-error:before { visibility: hidden; }"),
          column(width=2, tableOutput('scores')),
          column(width=2, tableOutput('scores2'), offset = 1),
          column(width=2, tableOutput('scores3'), offset = 1),
          width = 6
        )
      ),
      conditionalPanel(
        condition = "input.DT == true",
        DTOutput("table"))
    ),
    tabPanel("About",
             HTML("
              <h3>About the project</h3>
              <p>This project was completed as part of the final deliverable of the Coursera Data Science Specialization from Johns Hopkins University. The goal of which was to demonstrates one&apos;s ability to work with new data types and problems by building a Shiny web application that is able to take a sequence of words and predict what the next word is most likely to be.</p>
              <h3>About the model</h3>
              <p>The model was built using a large corpus of more than 4 million lines of text in English with a total count of over 100 million words. The corpus has been cleaned and transformed into up to the fifth order (5-grams) and Stupid Backoff was used to predict and rank the next word. The resulting model contains more than 5 million unique n-grams and has an accuracy of 13.96 % for top-1 precision and 21.53 % for top-3 precision.</p>
              <h3>How the application works</h3>
              <ul>
                  <li>Use the text box to write something and look at the prediction under.</li>
                  <li>More suggestions ordered by scores will appear to the right.</li>
                  <li>Scores range from 0 to 1, a higher score basically means a higher probability that the prediction is right.</li>
              </ul>
              <p>Options:</p>
              <ul>
                  <li><strong>Slider</strong>: Changes the number of suggestions displayed on the right (if the number of suggestions doesn&apos;t change, it means that there are no more suggestions).</li>
                  <li><strong>Add recursion</strong>: Looks into lower order n-grams to give more suggestions.</li>
                  <li><strong>Add a searchable table</strong>: Adds a searchable table below with all available suggestions.</li>
              </ul>
              <h3>More details</h3>
              <p>For more details about this app, please visit my GitHub page:&nbsp;<a href=\"https://github.com/michaeln870/WordPrediction\">https://github.com/michaeln870/WordPrediction</a></p>
             ")
    )
  )
)

server <- function(input, output) {

  words <- reactive({
    if(input$string != ""){
      predict_word(input$string, recursion = input$recursion)
    } else{list(data.frame(Term="",Score=""))}
  })
    
        output$prediction <- renderText({
            paste(str_trim(input$string), "<strong>", words()[[1]][1,1],"</strong>")
        })
        output$scores <- renderTable({head(words()[[1]],
                                           min(input$slider,10))},
                                     digits=4)

        output$scores2 <- renderTable({
          if(input$slider > 10 & words()[[2]] > 10){
            words()[[1]][11:min(input$slider,20,words()[[2]]),]
            }
          }, digits=4)
        
        output$scores3 <- renderTable({
          if(input$slider > 20 & words()[[2]] > 20){
            words()[[1]][21:min(input$slider,30,words()[[2]]),]
          }
        }, digits=4)
        output$table <- renderDT(
            words()[[1]] %>%
            datatable() %>%
            formatRound(columns = "Score",digits=4))

}
shinyApp(ui, server)
