# Problem Set 4
# Question 2

# Name: Your Name
# Matrikelnummer: Your matriculation number

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
book_data = data.frame(document=1:2225, text=map_chr(files, getDocument), category = map_chr(files, getCategory))
book_data$category = as.character(book_data$category)
book_data$text = as.character(book_data$text)



List <- strsplit(book_data$text, " ")
book_data<- data.frame(document = rep(book_data$document,sapply(List, length)),category = rep(book_data$category,sapply(List, length)), word = unlist(List))
book_data$word <- tolower(book_data$word)
book_data$word <- gsub("[[:punct:]]", "", book_data$word)

#b) --------------------------------
data("stop_words")

book_data %>%
  anti_join(stop_words) %>%
  group_by(category) %>%
  count(word, sort = TRUE) %>% 
  filter(word != "") -> book_freq

book_freq %>%
  bind_tf_idf(word, category, n) -> idf_freq

#

#c -----------------------
#LDA
category_dm <- book_freq %>%
  cast_dtm(category, word, n)

category_lda <- LDA(category_dm, k = n_distinct(book_freq$category), control = list(seed = 1234))
category_lda_td <- tidy(category_lda)

#Top Terms per Category
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

#per-document classification
book_split <- initial_split(book_freq, strata = "category", p = 0.80)
book_train <- training(book_split)
book_test <- testing(book_split)

text_rec <- recipe(category ~ ., data = book_train) %>%
  prep(training = book_train)

book_train_data <- juice(text_rec)
book_test_data  <- bake(text_rec, book_test)

str(book_train_data, list.len = 10)



#Random Forest
# rf_model <- rand_forest(trees = 20,mode = "classification") %>%
#   set_engine("randomForest")
# rf_model
# 
# 
# text_model <- rf_model %>%  #Error: cannot allocate vector of size 10.7 Gb LOL
#   fit(category ~ ., data = book_train_data)

train_preprocessed <- bake(text_rec, book_train_data)
test_preprocessed <- bake(text_rec, book_test_data)


text_model <- rand_forest(
  mode = "classification",
  trees = 250) %>%
  set_engine("ranger") %>%
  fit(category ~ ., data = book_train_data)

predictions_rf <- text_model %>%
  predict(new_data = test_preprocessed) %>%
  bind_cols(test_preprocessed %>% dplyr::select(category))



# eval_tibble = predict(text_model, book_test_data, type = "class")
# eval_tibble$category = book_test_data$category
# 
# 
# eval_tibble %>%
#   accuracy(truth = category, estimate =  .pred_class )
# 
# 
# eval_tibble %>%
#   mutate(combined = paste(substr(label,1,10), substr(.pred_class,1,5), sep =" | ")) %>%
#   group_by(combined) %>%
#   tally() %>%
#   arrange(-n) %>% 
#   print(n=20)
