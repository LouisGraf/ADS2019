# Problem Set 2
# Question 1

# Name: Louis Graf
# Matrikelnummer: Your matriculation number

require(tidyverse)
require(rvest)
require(lubridate)

url = "http://quotes.toscrape.com"
aurl = "http://quotes.toscrape.com/author/J-K-Rowling/" #Test Url für Autoren
links = list()
#a) 
getQuotes <- function(link){
  
  read_html(link) -> nodes
  
  nodes %>%
    html_nodes(".quote") -> nodes
  
  nodes %>%
    html_nodes(".author") %>%
    html_text() -> author
  
  nodes %>%
    html_nodes(".tags") %>%
    html_text() -> tags
  
  nodes %>%
    html_nodes(".text") %>%
    html_text() -> quotes
  
  frame = data.frame(author, tags, quotes)
  return(frame)
}

getQuotes(url)


#b)

getAllPages <- function(link){
  links <<- c(links, link)
  
  read_html(link) %>%
    html_nodes('.next a') %>%
    html_attr('href') -> linknext
  
  if(length(linknext) > 0){
    getAllPages(paste(url,linknext,sep=""))
    }else{
      return(links)
  }
}




getAllQuotes <- function(links){
  allQuotes = data.frame()
  allLinks = list()
  allLinks = getAllPages(url)

  allQuotes <- map_df(allLinks,getQuotes)
  print(nrow(allQuotes))
  return(allQuotes)
}

quotes <- getAllQuotes(allLinks)
quotes


#c) 

getAuthorUrls <- function(link){
  
  read_html(link) %>%
    html_nodes(".quote span a") %>%
    html_attr("href") -> urls
  
  urls = paste(url, urls,sep="")

  return(urls)
}

getAuthorUrls <- function(firstPage){
  allLinks = list()
  allLinks = getAllPages(firstPage)
  
  allAuthors = sapply(allLinks,getAuthors)
  
  allAuthors <- unique(as.list(allAuthors), incomparables = FALSE)
}

#test1 <- getAuthorUrls(url)

#d) 

getDetails <- function(authorUrl){
  
  read_html(authorUrl) -> nodes
  
  nodes %>%
    html_nodes(".author-title") %>%
    html_text() -> author
  
  nodes %>%
    html_nodes(".author-description") %>%
    html_text() -> description
  
  nodes %>%
    html_nodes(".author-born-date") %>%
    html_text() -> bornDate
  
  frame = data.frame(author, description, bornDate)
  return(frame)
}
test2 = getDetails(aurl)


#e)
#i)
authorDetails %>%
  select(bornDate) %>%
  mutate(year = lubridate::year(bornDate), 
         month = lubridate::month(bornDate), 
         day = lubridate::day(bornDate))

