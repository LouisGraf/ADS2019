# Problem Set 2
# Question 1

# Name: Louis Graf
# Matrikelnummer: 2389931

require(tidyverse)
require(rvest)
require(lubridate)

url = "http://quotes.toscrape.com" #Baseurl
aurl = "http://quotes.toscrape.com/author/J-K-Rowling/" #Test Autoren-Url
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
  allQuotes = data.frame() #initiiert Dataframe
  allLinks = list() #initiiert Liste um Links zu sammeln
  links = list() # ^
  
  getAllPages <- function(link){ #Funktion nimmt eine Url und speichert die URL des "Next" Buttons in einer Liste
    links <<- c(links, link)
    
    read_html(link) %>%
      html_nodes('.next a') %>%
      html_attr('href') -> linknext
    
    if(length(linknext) > 0){ #Checkt ob es einen "Next"-Link gibt, falls nicht endet die Funktion
      getAllPages(paste0(url,linknext,sep="")) #Recursive function
    }else{
      return(links)
    }
  }
  
  allLinks = getAllPages(link) #Ruft die Funktion auf
  
  allQuotes <- map_df(allLinks,getQuotes) #Auf jede URL der Liste wird getQuotes angewendet und als df gespeichert
  return(allQuotes)
}

test_b <- getAllQuotes(url)



#c) ------------------------------------------------------------------------------- 


getAuthorUrls <- function(link){ #wie getAllQuotes, nur für Autoren-URLs einer(!) Seite
  allLinks = list()
  links = list()
  
    getAllPages <- function(link){ #Sammelt wieder alle Seiten
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
    
    getAuthors <- function(alink){ #Sammelt jeden Author einer Seite
      
      read_html(alink) %>%
        html_nodes(".quote span a") %>%
        html_attr("href") -> urls
      
      urls = paste(url, urls,sep="")
      
      return(urls)
    }
  
  allAuthors = sapply(allLinks,getAuthors) #Auf jede URL der Liste wird getAuthors angewendet und als Liste gespeichert
  
  allAuthors <- unique(as.list(allAuthors), incomparables = FALSE) #Filtert doppelte Werte heraus (benötigt Liste?)
  allAuthors <- unlist(allAuthors) #Löst liste wieder auf?
}

test_c <- getAuthorUrls(url)

#d) 

getDetails <- function(authorUrl){ #Funktion scrollt jede Autoren-URL und gibt Df mit Author, Beschreibung und Geburtsdatum zurück
  
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

allAuthorDetails = map_df(getAuthorUrls(url),getDetails) #Wie getAllQuotes nur mit Autor-Daten



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
