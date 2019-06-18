# Problem Set 2
# Question 2

# Name: Louis Graf
# Matrikelnummer: 2389931

require(tidyverse)
require(rvest)

#a) -------------------------------------------------------------
url ="https://www.mydealz.de/new?page=" #Baseurl

map_df(1:50, function(i) { 
  
  cat(".") # simple but effective progress indicator

  pg <- read_html(paste0(url, i))

  data.frame(title = html_text(html_nodes(pg, ".thread--deal .thread-title--list, .thread--mode-default .thread-title--list")),
             temperature = html_text(html_nodes(pg, ".thread--type-list .vote-temp, .space--h-2.text--b")),
             author = html_text(html_nodes(pg, ".linkPlain .thread-username")),
             deepLink = html_attr(html_nodes(pg, ".thread--deal .thread-title--list, .thread--mode-default .thread-title--list"),"href"),
             comments = html_text(html_nodes(pg, ".cept-comment-link"))
  )

}) -> deals #Creates a dataframe with all deals from the pages 1:50 == 1000 Deals
#b) --------------------------------------------------------------

#Keine "falsche COdierung" in den Spalten Title & Temperature 
deals2 <- deals
deals2$title <- iconv(deals2$title, "latin1", "ASCII")
deals2$temperature <- iconv(deals2$temperature, "latin1", "ASCII")
Encoding(deals2$title)
#Beim Versuch die Kodierung zu wechseln entstehen wie zu erwarten NA Werte => Aufgabe nicht lösbar? 

#Bereinigte Deals
deals_clean = deals
deals_clean$title = trimws(deals$title, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
deals_clean$temperature[deals_clean$temperature=="Neu"] <- NA
deals_clean$temperature = as.integer(str_replace_all(trimws(deals$temperature, which = c("both", "left", "right"), whitespace = "[ \t\r\n]"),"°",""))
deals_clean$author = trimws(deals$author, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
deals_clean$comments = as.integer(trimws(deals$comments, which = c("both", "left", "right"), whitespace = "[ \t\r\n]"))

#c)-------------------------------------------------------------------
#i)
deals_clean  %>%
  mutate(freq = sum(str_detect(deals$temperature, "-"),na.rm = FALSE) / length(deals$title)) %>% #na.rm == sum doesnt count "Na"-values
  summarise(freq = mean(freq)) #Counts the amou and divides it by the length of the deals-dataframe

deals_clean%>%
  summarise(avg = mean(na.exclude(deals_clean$temperature))) #Calculates avg temp of deals


#ii)
deals_clean %>%
  select(temperature, comments) %>%
  filter(temperature > 0) %>%
  summarise(avg_hot = mean(comments)) #filters by temps greater than 0 and takes average of the comments

  
deals_clean %>%
  select(temperature, comments) %>%
  filter(temperature < 0) %>%
  summarise(avg_cold = mean(comments)) #filters by temps smaller than 0 and takes average of the comments

#iii)

deals_clean %>%
  mutate(count = 1) %>%
  group_by(author) %>%
  summarise(DealsByAuthor = sum(count)) %>%
  arrange(-DealsByAuthor) -> DealsByAuthor

head(DealsByAuthor, 1) #Author with most deals

DealsByAuthor %>%
  summarise(Avg = mean(DealsByAuthor)) #Average of all authors


#iv)
deals_clean %>%
  mutate(freq = sum(str_detect(deals$title, "Xiaomi"),na.rm = TRUE) / length(deals$title)) %>%
  summarise(freq = mean(freq)) #Same as i) but for Xiaomi
