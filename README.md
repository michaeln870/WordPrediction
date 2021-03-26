# Capstone Project: Next Word Predictor

### The Final Product

https://michaeln870.shinyapps.io/WordPrediction/

### About the project

This project was completed as part of the final deliverable of the [Coursera Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) from Johns Hopkins University. The goal of which was to demonstrates one's ability to work with new data types and problems by building a Shiny web application that is able to take a sequence of words and predict what the next word is most likely to be.

### About the model

The model was built using a large corpus of more than 4 million lines of text in English with a total count of over 100 million words. The corpus has been cleaned and transformed into up to the fifth order (5-grams) and Stupid Backoff was used to predict and rank the next word. The resulting model contains more than 5 million unique n-grams and has an accuracy of 13.96 % for top-1 precision and 21.53 % for top-3 precision.

### For more detailed information about the project
- `Report.md`: Full report on the project
- `generating ngrams.ipynb`: R Codes (using sparklyr) to clean and transform a large text corpus into n-grams. Ran on a Spark cluster.
- `App` folder: R codes to run the application
  - `functions.R`: algorithm used to predict next word
  - `App.R`: back-end of the web application 
