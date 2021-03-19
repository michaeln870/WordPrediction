## Main functions for predicting word
library(tidyverse)

load("./ngrams.RData")
bigrams <- dict[[1]]
trigrams <- dict[[2]]
fourgrams <- dict[[3]]
fivegrams <- dict[[4]]

## Clean String, return vector of 4 or less words
clean_string <- function(string){
  string <- string %>%
    str_trim() %>%
    str_to_lower() %>%
    str_replace_all("[^a-z' ]","") %>%
    str_split(" ")
  string <- string[[1]] %>%
    tail(4)
  return(string)
}

## Reduce string to existing ngram size
find_ngram <- function(string, n){
  ngram_found <- FALSE
  
  while(ngram_found == FALSE){
    if (n==0){
      message("word not found (find_ngram)")
      string <- ""
      break
    }else if (string %in% dict[[n]][[1]]){
      message("found ngram")
      ngram_found <- TRUE
      break
    }else{
      string <- strsplit(string," ")[[1]][-1] %>%
        paste(collapse = " ")
      n <- n-1
    }
  }
  return(string)
}

## Get word
get_words <- function(string){
  n <- length(string)
  string <- paste(string, collapse=" ")

  string <- find_ngram(string, n)
  n <- length(strsplit(string," ")[[1]])
  
  if (n == 4){
    word <- fivegrams %>%
      filter(word1_4==string) %>%
      select(word5)
  } else if (n == 3){
    word <- fourgrams %>%
      filter(word1_3==string) %>%
      select(word4)
  } else if (n == 2){
    word <- trigrams %>%
      filter(word1_2==string) %>%
      select(word3)
  } else if (n == 1){
    word <- bigrams %>%
      filter(word1==string) %>%
      select(word2)
  } else {
    word <- list("")
  }
  return(word[[1]])
}

## main function
predict_word <- function(input){
  cleaned_input <- clean_string(input)
  words <- get_words(cleaned_input)
  return(words[1])
}