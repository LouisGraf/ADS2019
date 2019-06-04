require(tidyverse)
require(rvest)

url = 'https://coinmarketcap.com/all/views/all/'

read_html(url) -> rawData

rawData %>%
  html_nodes('.currency-name') %>%
  html_text() -> name

rawData %>%
  html_nodes('.price') %>%
  html_text() -> price


name %>%
  str_match_all('[A,B].')

coins = data.frame(name, price)


url = 'https://www.n-tv.de/'

read_html(url) -> rawData

rawData %>%
  html_nodes('.group .teaser__headline') %>%
  html_text() -> headlines

rawData %>%
  html_nodes('.teaser__text') %>%
  html_text() -> teaser

rawData %>%
  html_nodes('.teaser__content') -> nodes

getNews = function(node){
  node %>%
    html_nodes('.teaser__headline') %>%
    html_text() -> title
  node %>%
    html_nodes('.teaser__text') %>%
    html_text() -> teaser
  node %>%
    html_nodes('em') %>%
    html_text() -> author
  
  title = ifelse(length(title) == 0, NA, title)
  teaser = ifelse(length(teaser) == 0, NA, teaser)
  author = ifelse(length(author) == 0, NA, author)

  article = data.frame(title, teaser, author)
}

test = getNews(nodes[50])

news = map_df(nodes, getNews)