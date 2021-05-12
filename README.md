# Capstone Project: Next Word Predictor

### The Word Predictor

https://michaeln870.shinyapps.io/WordPrediction/

### About the project

This project was completed as part of the final deliverable of the [Coursera Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science) from Johns Hopkins University. The goal of which was to build a Shiny web application that is able to take a sequence of words and predict what the next word is most likely to be.

**The model**

The prediction model used for the application was built using a large corpus of more than 4 million lines of text with a total count of over 100 million words. The corpus has been cleaned and transformed into n-grams up to the fifth order (5-grams) using a Spark cluster, then a Stupid Backoff algorithm was used to predict and rank the next word. The resulting model contains more than 5 million unique n-grams and has an accuracy of 13.96 % for top-1 precision and 21.53 % for top-3 precision.

### Files
- `Report.md`: Full report on the project
- `generating ngrams.ipynb`: R codes (using sparklyr) to clean and transform the corpus into n-grams
- `App folder`: R codes to run the application
  - `functions.R`: Algorithm used to predict words
  - `App.R`: Back-end of the web application 
