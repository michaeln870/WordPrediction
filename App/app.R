library(shiny)
library(DT)

source("functions.R")


ui <- fluidPage(
  tabsetPanel(
    tabPanel("Word Predictor",
      titlePanel("Next Word Prediction Application"),
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
             HTML("<h3>How it works:</h3>
                <ul>
                    <li>Use the text box to write something and look at the prediction under</li>
                    <li>Look at the table on the right to see more suggestions</li>
                    <li>A higher score means that the word is a better match according to the model, a score of 1 means a perfect match</li>
                </ul>
                <h3>Options:</h3>
                <ul>
                    <li><strong>Slider</strong>: Changes the number of suggestions displayed on the right (if number of suggestions doesn't change, it means that there are no more suggestions)</li>
                    <li><strong>Add recursion</strong>: Look into lower order n-grams to give more suggestions</li>
                    <li><strong>Add a searchable table</strong>: Adds a searchable table below with all available suggestions</li>
                </ul>
                <h3>About the model:</h3>
                <p>The model has been built using a large corpus of more than 4 million lines of text with a total word count of over 102 million. The corpus has been cleaned and transformed into n-grams up to the fifth order (5-grams). The resulting model is composed of a corpus of more than 15 million n-grams, not accounting for unigrams. The algorithm used to predict the next word is based on the &quot;Stupid Backoff&quot; method.</p>
                <h3>Potential improvements:</h3>
                <p>The goal of this project was simply to demonstrate the ability to build a next word prediction application, improving it further is beyond its scope. Nonetheless, it is still useful to recognized its flaws and what steps could be taken to improve the model. Here are a few ideas:</p>
                <ul>
                    <li><strong>Use a better prediction method</strong>: While stupid backoff does just as well with large language models than the most performant smoothing methods, its n-grams count is quite low compared to the billions of n-grams needed for the method to be accurate. Implementing a Kneser-Ney Smoothing or Katz Backoff instead, might improve the accuracy of the model, but would in turn make the application slower as these are more expensive.</li>
                    <li><strong>Add more text to the corpus</strong>: As mentioned in the previous point, the n-gram count is quite low compared to state-of-the-art models. Adding more data to train the model will always yield better results.</li>
                    <li><strong>Add sentence segmentation</strong>: I didn&apos;t use sentence tokenization methods as it is difficult to distinguish between a sentence-boundary marker and an abbreviation marker (e.g. Mr.). These require either an extensive dictionary of abbreviations or the use of machine learning. Instead, I segmented each sequences of words between each punctuation marker and built my model from there.</li>
                    <li><strong>Implement an open vocabulary system</strong>: I didn&apos;t implement a system to deal with words that don&apos;t appear in my model. This would require either the use of machine learning or to build a fixed vocabulary set, then find out the probabilities that those words appear in a certain context.</li>
                    <li><strong>Add more complexity</strong>: There is always more that we can add to a model to make it more accurate, but there is also a fine balance between accuracy and performance that we need to account for.</li>
                </ul>
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
