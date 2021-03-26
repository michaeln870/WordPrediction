## Script of functions for predicting word
library(tidyverse)

# Loading dictionary of ngrams (dict)
load("./ngrams.RData") 
# It consists of a list of 5 tibbles
  # [[1]] bigrams
  # [[2]] trigrams
  # [[3]] fougrams
  # [[4]] fivegrams
  # [[5]] unigrams (reduced to top 30)
# > names(dict[[1]])
# [1] "firstTerms" "lastTerm"   "n"  


## Clean String
  ## Takes a character string and returns a vector of 4 or less words
clean_string <- function(string){
  string <- string %>%
    str_trim() %>%
    str_to_lower() %>%
    str_replace_all("^['-]|['-]$|(?<![a-zA-Z])['-]|['-](?![a-zA-Z])","") %>%
    str_replace_all("[^-a-z' ]","") %>%
    str_replace_all("  +"," ") %>%
    str_split(" ")
  string <- string[[1]] %>%
    tail(4)
  return(string)
}

## Stupid BackOff
  ## Receives a vector of words
stupid_backoff <- function(words, alpha = 0.4, recursion = FALSE){ 
  
  n_words <- length(words)
  n_alpha = 0
  scores = NULL

  ## Scoring
  while(n_words>0){
    words_str <- paste(words, collapse = " ")
    ngrams <- dict[[n_words]] %>%
      filter(firstTerms == words_str) %>%
      mutate(Score = n/sum(n)*alpha^n_alpha) %>%
      select(lastTerm, Score) %>%
      rename(Term=lastTerm)
    
    scores <- bind_rows(scores, ngrams) %>%
      arrange(desc(Score)) %>%
      distinct(Term, .keep_all = TRUE)
          
    words <- words[-1]
    n_words <- n_words-1
    n_alpha <- n_alpha +1

    if(nrow(scores) != 0 & recursion == FALSE) {
      break
    } else if(n_words==0 & recursion == FALSE){
      scores <- dict[[5]] %>%
        mutate(Score = Score*alpha^n_alpha)
    } else if(n_words == 0 & nrow(scores) == 0){
      unigrams <- dict[[5]] %>%
        mutate(Score = Score*alpha^n_alpha)
      scores <- scores %>%
        bind_rows(unigrams) %>%
        arrange(desc(Score)) %>%
        distinct(Term, .keep_all = TRUE)
    }
  }
  
  return(scores)
}

## main function
  ## Takes a character string and returns a list containing
  ## [[1]] tibble of all suggestions with their score
  ## [[2]] the number of row of the tibble (only used for displaying fancy table in app)
predict_word <- function(inputString, recursion = FALSE){
  cleaned_input <- clean_string(inputString)
  scores <- stupid_backoff(cleaned_input, recursion=recursion)
  list(scores, nrow(scores))
}