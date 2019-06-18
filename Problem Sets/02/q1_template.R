# Problem Set 2
# Question 1

# Name: Louis Graf
# Matrikelnummer: 2389931

require(tidyverse)
require(rvest)
require(lubridate)

url = "http://quotes.toscrape.com" #Baseurl
aurl = "http://quotes.toscrape.com/author/J-K-Rowling/" #Test Url für Autoren

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

test_a <- getQuotes(url)


#b) ----------------------------------------------------------------------

getAllQuotes <- function(link){
  allQuotes = data.frame()
  allLinks = list()
  links = list()
  
  getAllPages <- function(link){
    links <<- c(links, link)
    
    read_html(link) %>%
      html_nodes('.next a') %>%
      html_attr('href') -> linknext
    
    if(length(linknext) > 0){
      getAllPages(paste0(url,linknext,sep=""))
    }else{
      return(links)
    }
  }
  
  allLinks = getAllPages(link)
  
  allQuotes <- map_df(allLinks,getQuotes)
  return(allQuotes)
}

test_b <- getAllQuotes(url)



#c) ------------------------------------------------------------------------------- 


getAuthorUrls <- function(link){
  allLinks = list()
  links = list()
  
    getAllPages <- function(link){
      links <<- c(links, link)
      
      read_html(link) %>%
        html_nodes('.next a') %>%
        html_attr('href') -> linknext
      
      if(length(linknext) > 0){
        getAllPages(paste0(url,linknext,sep=""))
      }else{
        return(links)
      }
    }
    
    allLinks = getAllPages(link)
    
    getAuthors <- function(alink){
      
      read_html(alink) %>%
        html_nodes(".quote span a") %>%
        html_attr("href") -> urls
      
      urls = paste(url, urls,sep="")
      
      return(urls)
    }
  
  allAuthors = sapply(allLinks,getAuthors)
  
  allAuthors <- unique(as.list(allAuthors), incomparables = FALSE)
  allAuthors <- unlist(allAuthors)
}

test_c <- getAuthorUrls(url)

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
test_d_getAuthorDetails = getDetails(aurl)

allAuthorDetails = map_df(getAuthorUrls(url),getDetails)



#e) ------------------------------------------------------
#i)  Transform the data frame to store the information on the day, month and year in distinct columns

allAuthorDetails$bornDate <- parse_date_time(allAuthorDetails$bornDate, orders = "mdy")
allQuotes = getAllQuotes(url)

allAuthorDetails %>%
  mutate(day = day(bornDate),
         month = month(bornDate),
         year = year(bornDate)) -> newAuthorDetails

#How many authors where born in the 19th century (1800-1899)?

newAuthorDetails %>%
  select(year) %>%
  filter(year < 1900 && year > 1799) %>%
  summarise(n = n()) 
#Lösung: 50


#ii) Transform and summarize the quotes data 
#1) -------- Which author has the most quotes on the website?
allQuotes %>% 
  select(author,quotes)%>%
  group_by(author) %>%
  count(author) %>%
  arrange(desc(n))%>%
  head(1) #Albert Einstein

#2) -------- How many quotes does an author have on average?
allQuotes %>%
  mutate(count = 1) %>%
  group_by(author) %>%
  summarise(QuotesByAuthor = sum(count)) %>%
  arrange(-QuotesByAuthor) -> QuotesByAuthor

QuotesByAuthor %>%
  summarise(Avg = mean(QuotesByAuthor))

#3) --------- Find all quotes that use the tag “life"

allQuotes %>%
  filter(str_detect(tags,'life')) %>%
  select(author, quotes)

#iii) -------- Join both data frames (you may need to transform keys first) 

newAuthorDetails = allAuthorDetails
newAuthorDetails$author = trimws(newAuthorDetails$author, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
CombinedDataFrames = merge(x=newAuthorDetails, y=allQuotes, by="author")
