# Capstone Project: Next Word Prediction Application

The goal of this project was the demonstrate the ability to build a next word prediction web application. It is part of the Johns Hopkins University's Data Science Specialization on Coursera.

### The Application:

https://michaeln870.shinyapps.io/WordPrediction/

### About the model:

The model has been built using a large corpus of more than 4 million lines of text with a total word count of over 102 millions. The corpus has been cleaned and transformed into n-grams up to the fifth order (5-grams). The resulting model is composed of a corpus of more than 15 million n-grams, not accounting for unigrams. The algorithm used to predict the next word is based on the "Stupid Backoff" method.

### For more detailed information about the project:
- `Milestone-Report.md`: Report for the first part of the project. It describes the data used, steps for data preparation and some exploratory data analysis.
- `generating ngrams.ipynb`: R Codes (sparklyr package) to clean and transform a large text corpus into n-grams. Ran on a Spark cluster.
- `App` folder: R codes to run the application, includes algorithm used to predict next word in `functions.R`
