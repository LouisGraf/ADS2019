require(rvest)
require(tidyverse)

#a)
url = 'https://www.mydealz.de/new?page=1'

getNodeDetails = function(node){
  node %>%
    html_nodes(".vote-temp") %>%
    html_text() -> temperature
  
  node %>%
    html_nodes(".thread-title--list") %>%
    html_text() -> title

  node %>%
    html_nodes(".thread-title--list") %>%
    html_attr('href') -> deepLink  
    
  node %>%
    html_nodes(".thread-username") %>%
    html_text() -> author
  
  node %>%
    html_nodes(".cept-comment-link") %>%
    html_text() -> numberOfComments
  
  temperature = ifelse(length(temperature) == 0, NA, temperature)
  title = ifelse(length(title) == 0, NA, title)
  deepLink = ifelse(length(deepLink) == 0, NA, deepLink)
  author = ifelse(length(author) == 0, NA, author)
  numberOfComments = ifelse(length(numberOfComments) == 0, NA, numberOfComments)
  
  deal = data.frame(title, temperature, author, deepLink, numberOfComments)
}

getDealz = function(url){
  read_html(url) -> raw_page
  
  raw_page %>%
    html_nodes('.threadGrid') -> nodes

  deals = map_df(nodes, getNodeDetails)
}


dealz = getDealz(url)

dealz = map_df(paste0('https://www.mydealz.de/new?page=', 1:50), getDealz)


#b
dealz %>%
  mutate(title = iconv(title, "latin1", "ASCII", sub=""),
         temperature = iconv(temperature, "latin1", "ASCII", sub="")) %>%
  mutate(temperature = str_remove_all(temperature, '[:space:]')) -> dealz

dealz = dealz[complete.cases(dealz),]


#c
dealz %>%
  mutate(hot = temperature > 0) %>%
  group_by(hot) %>%
  summarise(count = n(), share = n()/nrow(dealz))

dealz %>%
  mutate(numberOfComments = as.numeric(numberOfComments)) %>%
  mutate(hot = temperature > 0) %>%
  group_by(hot) %>%
  summarise(mean(numberOfComments))

dealz %>%
  group_by(author) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

dealz %>%
  group_by(author) %>%
  summarise(count = n()) %>%
  summarise(mean(count))

dealz %>%
  mutate(xiaomi = str_detect(tolower(title), 'xiaomi')) %>%
  summarise(mean(xiaomi))
