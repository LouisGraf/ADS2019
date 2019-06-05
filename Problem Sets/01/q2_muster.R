# Problem Set 1
# Question 2

# Name: Your Name
# Matrikelnummer: Your matriculation number
library(tidyverse)
library(RCurl)
library(RJSONIO)
URL = "https://www.googleapis.com/books/v1/volumes?q=george+r+r+martin&maxResults=40"
response_parsed <- fromJSON(getURL(URL,ssl.verifyhost = 0L, ssl.verifypeer = 0L))


#a)
# Verschachtelte Listen...
# Your code

response_parsed$items[[1]]$volumeInfo$title
paste(response_parsed$items[[1]]$volumeInfo$authors, collapse = ', ')

getTitle = function(item) {
  title = item$volumeInfo$title
  return(title)
}

map_chr(response_parsed$items, getTitle)



#b)
map_chr(response_parsed$items, function(x) x$volumeInfo$title)
map_chr(response_parsed$items, function(x) x$volumeInfo$publishedDate)
map_chr(response_parsed$items, function(x) x$volumeInfo$maturityRating)
map_chr(response_parsed$items, function(x) paste(x$volumeInfo$authors, collapse ='; '))

#or


getBookData = function(item){
  title = item$volumeInfo$title
  authors = paste(item$volumeInfo$authors, collapse = '; ')
  published = item$volumeInfo$publishedDate
  rating = item$volumeInfo$maturityRating
  book = data.frame(title, published, rating, authors)
}

test = getBookData(response_parsed$items[[3]])

books = map_df(response_parsed$items, getBookData)


#c) 
getBookList = function(numberOfItems) {
  URL = paste0("https://www.googleapis.com/books/v1/volumes?q=george+r+r+martin&maxResults=",numberOfItems)
  response_parsed <- fromJSON(getURL(URL,ssl.verifyhost = 0L, ssl.verifypeer = 0L))
  books = map_df(response_parsed$items, getBookData)
  books %>%
    arrange(published, title) -> books
  }

books = getBookList(10)


#d)
getBookSalesInfo = function(response) {
  url <- paste0("https://www.googleapis.com/books/v1/volumes/", response)
  response_parsed <- fromJSON(getURL(url, ssl.verifyhost = 0L, ssl.verifypeer = 0L))
  
  title   <- response_parsed$volumeInfo$title
  country <- response_parsed$saleInfo$country
  price   <- paste(response_parsed$saleInfo$retailPrice, collapse = "")
  link    <- response_parsed$saleInfo$buyLink
  
  c(title, country, price, link)
}

getBookSalesInfo("a4toDwAAQBAJ")
