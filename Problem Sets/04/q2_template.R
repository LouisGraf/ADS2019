# Problem Set 4
# Question 2

# Name: Louis Graf
# Matrikelnummer: 2389931

require(tidyverse)
library(foreign)
library(tidytext)
library(topicmodels)
library(randomForest)

#Working Directory anpassen, um einfacher an Ordnerstruktur zu gelangen
setwd("Problem Sets/04/bbc")
files = list.files(recursive = TRUE, pattern = "*.txt")

getDocument = function(x){paste(unlist(scan(x, what="character",quiet = T)),collapse = " ")}
getCategory = function(x){paste(unlist(strsplit(x, split='/', fixed=TRUE))[1])}

#map Text & Category for each file
article_data = data.frame(document=1:2225, text=map_chr(files, getDocument), category = map_chr(files, getCategory))

#Turn text into char
article_data$category = as.character(article_data$category)
article_data$text = as.character(article_data$text)


#Split articles into word-vectors & clean data
wordList <- strsplit(article_data$text, " ")
article_data<- data.frame(document = rep(article_data$document,sapply(wordList, length)),category = rep(article_data$category,sapply(wordList, length)), word = unlist(wordList))
article_data$word <- tolower(article_data$word)
article_data$word <- gsub("[[:punct:]]", "", article_data$word)

#b) --------------------------------
#Remove Stopwords
data("stop_words")

article_data %>%
  anti_join(stop_words) %>%
  group_by(category) %>%
  count(word, sort = TRUE) %>% 
  filter(word != "") -> article_freq

article_freq %>%
  bind_tf_idf(word, category, n) -> idf_freq

idf_freq %>%
  group_by(category) %>%
  arrange(desc(tf_idf)) %>%
  top_n(15, tf_idf) %>%
  ungroup() %>%
  mutate(word = reorder(word, tf_idf)) %>%
  ggplot(aes(x=word, y=tf_idf))+
  geom_col() + 
  coord_flip() + 
  facet_wrap(~category, scales="free")

#c -----------------------

#LDA
category_dtm <- article_freq %>%
  cast_dtm(category, word, n)

category_lda <- LDA(category_dtm, k = n_distinct(article_freq$category), control = list(seed = 1234))


#Top Terms per Category
category_lda_td <- tidy(category_lda)

top_terms <- category_lda_td %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

      #Visuzalizing
      top_terms %>%
        mutate(term = reorder_within(term, beta, topic)) %>%
        ggplot(aes(term, beta)) +
        geom_bar(stat = "identity") +
        scale_x_reordered() +
        theme(axis.text.x = element_text(angle = 90, size = 10, vjust = - 0.01)) +
        facet_wrap(~ topic, scales = "free_x")

      
#By word assignment
category_topics <- tidy(category_lda, matrix = "beta")


      #Visuzalizing
          top_terms_category <- category_topics %>%
            group_by(topic) %>%
            top_n(5, beta) %>%
            ungroup() %>%
            arrange(topic, -beta)
          
          top_terms_category
      
          top_terms_category %>%
            mutate(term = reorder(term, beta)) %>%
            ggplot(aes(term, beta, fill = factor(topic))) +
            geom_col(show.legend = FALSE) +
            facet_wrap(~ topic, scales = "free") +
            coord_flip()




