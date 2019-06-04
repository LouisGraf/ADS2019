# Problem Set 1
# Question 1

library(tidyverse)
carData = mtcars
carData$car = row.names(carData)


#a)
createAd <- function(vehicleData){
  vehicleData %>%
    sample_n(1) -> df
  paste(df$car, 
        "Horsepower:",df$hp, 
        "Cylinders:", df$cyl, 
        "Fuel Efficiency:", df$mpg, 
        "1/4 mile time:", df$qsec, 
        sep=" ")
}

createAd(carData)


#b)
createFormattedAd <- function(vehicleData){
  lines = c()
  lines = rbind(lines, paste0("* ", vehicleData$car))
  lines = rbind(lines, paste0('* Horsepower: ', vehicleData$hp))
  lines = rbind(lines, paste0('* Cylinders: ', vehicleData$cyl))
  lines = rbind(lines, paste0('* Fuel Efficiency: ', vehicleData$mpg, 'mpg'))
  lines = rbind(lines, paste0('* 1/4 mile time: ', round(vehicleData$qsec, 0), 'sec'))
  maxChars = max(nchar(lines))
  
  output = c()
  output = rbind(output, paste0(rep('*', 3 + maxChars), collapse=''))
  for (line in lines){
    output = rbind(output, paste0(line, paste0(rep(' ', 2 + maxChars - nchar(line)), collapse = ''), '*'))
  }
  output = rbind(output, paste(rep('*', 3 + maxChars), collapse=''))
  
  output = paste(output, collapse = '\n')
  cat(output)
}

carData %>%
  sample_n(1) %>%
  createFormattedAd()


#c)
createFormattedAdWithComparison <- function(vehicleData){
  lines = c()
  lines = rbind(lines, paste0("* ", vehicleData$car))
  if (vehicleData$hp >= quantile(mtcars$hp, 0.9)){
    lines = rbind(lines, paste0('* Horsepower: ', vehicleData$hp, " (top 10%)"))
  } else {
    lines = rbind(lines, paste0('* Horsepower: ', vehicleData$hp))
  }
  lines = rbind(lines, paste0('* Cylinders: ', vehicleData$cyl))
  if (vehicleData$mpg >= quantile(mtcars$mpg, 0.9)){
    lines = rbind(lines, paste0('* Fuel Efficiency: ', vehicleData$mpg, " (top 10%)"))
  } else {
    lines = rbind(lines, paste0('* Fuel Efficiency: ', vehicleData$mpg))
  }
  if (vehicleData$qsec <= quantile(mtcars$qsec, 0.1)){
    lines = rbind(lines, paste0('* 1/4 mile time: ', vehicleData$qsec, " (top 10%)"))
  } else {
    lines = rbind(lines, paste0('* 1/4 mile time: ', vehicleData$qsec))
  }
  maxChars = max(nchar(lines))
  
  output = c()
  output = rbind(output, paste0(rep('*', 3 + maxChars), collapse=''))
  for (line in lines){
    output = rbind(output, paste0(line, paste0(rep(' ', 2 + maxChars - nchar(line)), collapse = ''), '*'))
  }
  output = rbind(output, paste(rep('*', 3 + maxChars), collapse=''))
  
  output = paste(output, collapse = '\n')
  cat(output)
}

carData %>%
  sample_n(1) %>%
  createFormattedAdWithComparison()

#d)
createFormattedAdsWithComparisons <- function(vehicleData, n){
  vehicleData %>%
    sample_n(n) -> df
  
  for (i in 1:n){
    createFormattedAdWithComparison(df[i,])
    cat('\n')
  }
}
createFormattedAdsWithComparisons(carData, 20)

#e)
prices = read_csv("Data/carPrices.csv")
mileage = read_csv('Data/carMileage.csv')

carData %>%
  left_join(prices, by=c('car' = 'Type')) %>%
  left_join(mileage, by = c('car' = 'Type'))

#...