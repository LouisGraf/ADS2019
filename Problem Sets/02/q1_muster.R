require(rvest)
require(tidyverse)

#a)
getQuotes <- function(url){
  read_html(url) -> rawPage
  
  rawPage %>%
    html_nodes('.text') %>%
    html_text() -> quotes
  
  rawPage %>%
    html_nodes('.author') %>%
    html_text() -> authors
  
  rawPage %>%
    html_nodes('.tags') %>%
    html_text() -> tags
  
  
  quoteDF = data.frame(authors, tags, quotes)
  quoteDF %>%
    mutate(quotes = iconv(quotes, "latin1", "ASCII", sub=""),
           authors = iconv(authors, "latin1", "ASCII", sub=""))
}

url = 'http://quotes.toscrape.com/'
dfQuotes = getQuotes(url)


#b)
base_url = 'http://quotes.toscrape.com/page/'

urls = paste0(base_url, 1:10, '/')

quotes = map_df(urls, getQuotes)

quotes %>%
  mutate(quotes = iconv(quotes, "latin1", "ASCII", sub=""),
         authors = iconv(authors, "latin1", "ASCII", sub="")) -> dfQuotes

#c)
url = urls[1]

getAuthorUrls = function(url){
  read_html(url) -> rawPage
  
  rawPage %>%
    html_nodes(".quote span a") %>%
    html_attr('href') -> authorUrls
}

allAuthors = unlist(map(urls, getAuthorUrls))

#d)
getAboutPage = function(url){
  url = paste0('http://quotes.toscrape.com', url)
  read_html(url) -> rawPage
  
  rawPage %>%
    html_nodes(".author-title") %>%
    html_text() -> authorName

  rawPage %>%
    html_nodes(".author-description") %>%
    html_text() -> description
  
  rawPage %>%
    html_nodes(".author-born-date") %>%
    html_text() -> bornDate  
  
  
  authorDF = data.frame(authorName, description, bornDate)
}

authorDetails = map_df(unique(allAuthors), getAboutPage)


#e)
authorDetails %>%
  mutate(year = str_extract(bornDate, '[0-9]{4}'),
         month = str_extract(bornDate, '[:alpha:]*'),
         day = str_extract(bornDate, '[0-9]{2}')) %>%
  arrange(year) -> authorDetails


authorDetails %>%
  filter(year %in% 1800:1899) %>%
  summarise(count = n())

quotes %>%
  group_by(authors) %>%
  summarise(nQuotes = n()) %>%
  arrange(desc(nQuotes))

quotes %>%
  group_by(authors) %>%
  summarise(nQuotes = n()) %>%
  summarise(averageQuotes = mean(nQuotes))

quotes %>%
  mutate(hasTag = str_detect(tags, 'life')) %>%
  filter(hasTag == TRUE) %>%
  select(-hasTag)


authorDetails %>%
  mutate(authorName = str_remove_all(authorName, '\\n[:space:]+')) -> authorDetails

quotes %>%
  left_join(authorDetails, by = c('authors'='authorName')) -> quotes
