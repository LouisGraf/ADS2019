# Problem Set 1
# Question 2

# Name: Your Name
# Matrikelnummer: Your matriculation number

library(RCurl)
library(RJSONIO)
URL = "https://www.googleapis.com/books/v1/volumes?q=george+r+r+martin&maxResults=40"
response_parsed <- fromJSON(getURL(URL,ssl.verifyhost = 0L, ssl.verifypeer = 0L))



#a)
# Your code

#b)
# Your code

#c) 
getBookList = function(numberOfItems) {
  # Your code
}

#d)
getBookSalesInfo = function(response) {
  # Your code
}