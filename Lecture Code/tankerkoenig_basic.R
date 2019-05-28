getGasolinePricesByCity = function(city)
{

key = readChar("googleAPIkey.txt", file.info("googleAPIkey.txt")$size)

url = "https://maps.googleapis.com/maps/api/geocode/json?address="

address = city

geocode = fromJSON(paste0(url,address,"&key=",key))
geocode$results$geometry$location


fromJSON(paste0("https://creativecommons.tankerkoenig.de/json/list.php?lat=",geocode$results$geometry$location$lat,"&lng=",geocode$results$geometry$location$lng,"&rad=1.5&sort=price&type=diesel&apikey=e23dc02b-8d60-a1b2-0c83-be6e179ac545"))
}

getGasolinePricesByCity("Bamberg")
