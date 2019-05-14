library(RCurl)
library(RJSONIO)

#define function
getNameAndRating <- function(result)
{
  data.frame(name = c(substring(result$name,1,20)),
             rating = c(ifelse(is.null(result$rating),-1,result$rating)))
}

#get API data
key = readChar("googleAPIkey.txt", file.info("googleAPIkey.txt")$size)
URL <- paste0("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=49.7881799,9.93524&radius=500&types=bar&key=",key)
response_parsed <- fromJSON(getURL(URL,ssl.verifyhost = 0L, ssl.verifypeer = 0L))

#run function on single line
getNameAndRating(response_parsed$results[[1]])

#map function to full results lists
map_df(response_parsed$results, getNameAndRating)

