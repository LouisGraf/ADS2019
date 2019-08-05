library(tidyverse)

#Data Wrangling!!!!!!

#joining dataframes
carData %>%
  left_join(prices, by=c('car' = 'Type')) %>%
  left_join(mileage, by = c('car' = 'Type'))


#Percentage / relative Freqeuency
diamonds %>%
  group_by(cut) %>%
  summarise(n = n()) %>%
  mutate(sumn = sum(n),
         freq = n / sum(n))


#Values zwischen x und y
authorDetails %>%
  filter(year %in% 1800:1899) %>%
  summarise(count = n())


# Author with Most quotes
quotes %>%
  group_by(authors) %>%
  summarise(nQuotes = n()) %>%
  arrange(desc(nQuotes))


#Average quotes-count
quotes %>%
  group_by(authors) %>%
  summarise(count = n()) %>%
  summarise(averageQuotes = mean(nQuotes))


#Share with name "xiaomi"
dealz %>%
  mutate(xiaomi = str_detect(tolower(title), 'xiaomi')) %>%
  summarise(mean(xiaomi))


#Share of posted deals higher than 0°
dealz %>%
  mutate(hot = temperature > 0) %>%
  group_by(hot) %>%
  summarise(count = n(), share = n()/nrow(dealz))


#More comments hot or cold
dealz %>%
  mutate(numberOfComments = as.numeric(numberOfComments)) %>%
  mutate(hot = temperature > 0) %>%
  group_by(hot) %>%
  summarise(mean(numberOfComments))


#All quotes with tag
quotes %>%
  filter(str_detect(tags, 'life'))