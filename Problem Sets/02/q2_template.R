# Problem Set 2
# Question 2

# Name: Louis Graf
# Matrikelnummer: 2389931

require(tidyverse)
require(rvest)

#a) -------------------------------------------------------------
url ="https://www.mydealz.de/?page="

map_df(1:20, function(i) {
  
  # simple but effective progress indicator
  cat(".")
  
  pg <- read_html(sprintf(url, i))
  
  data.frame(title = html_text(html_nodes(pg, ".thread--deal .thread-title--list")),
             temperature = html_text(html_nodes(pg, ".space--h-2.text--b , .thread--deal .vote-temp--burn")),
             author = html_text(html_nodes(pg, ".thread--deal .thread-username")),
             deepLink = html_attr(html_nodes(pg, ".thread--deal .thread-title--list"),"href"),
             comments = html_text(html_nodes(pg, ".thread--deal .cept-comment-link"))
             )
  
}) -> deals
#b) --------------------------------------------------------------

#Keine "falsche COdierung" in den Spalten Title & Temperature 
deals2 <- deals
deals2$title <- iconv(deals2$title, "latin1", "ASCII")
deals2$temperature <- iconv(deals2$temperature, "latin1", "ASCII")
Encoding(deals2$title)
#Beim Versuch die Kodierung zu wechseln entstehen NA Werte

#Bereinigte Deals
deals_clean = deals
deals_clean$title = trimws(deals$title, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
deals_clean$temperature = str_replace_all(trimws(deals$temperature, which = c("both", "left", "right"), whitespace = "[ \t\r\n]"),"°","")
deals_clean$author = trimws(deals$author, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
deals_clean$comments = trimws(deals$comments, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")

#c)-------------------------------------------------------------------
#i)
deals_clean  %>%
  mutate(freq = sum(str_detect(deals$temperature, "-"),na.rm = FALSE) / length(deals$title)) %>%
  summarise(freq = mean(freq))

deals_clean%>%
  summarise(avg = mean(as.numeric(deals_clean$temperature)))


#ii)
deals_clean %>%
  select(temperature, comments) %>%
  filter(is.numeric(temperature) > 0) %>%
  summarise(avg = mean(is.numeric(comments)))

deals_clean %>%
  select(temperature, comments) %>%
  filter(is.numeric(temperature) < 0 ) %>%
  summarise(avg = mean(is.numeric(comments)))

#iii)

deals_clean %>%
  mutate(count = 1) %>%
  group_by(author) %>%
  summarise(DealsByAuthor = sum(count)) %>%
  arrange(-DealsByAuthor) -> DealsByAuthor

DealsByAuthor

DealsByAuthor %>%
  summarise(Avg = mean(DealsByAuthor))


#iv)
deals_clean %>%
  mutate(freq = sum(str_detect(deals$title, "Xiaomi"),na.rm = TRUE) / length(deals$title)) %>%
  summarise(freq = mean(freq))
