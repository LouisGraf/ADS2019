# Problem Set 1
# Question 1

library(tidyverse)
carData = mtcars
carData$car = row.names(carData)

createAd(carData[1,])

#a)
createAd <- function(vehicleData){
  paste(vehicleData$car, 
        "Horsepower:",vehicleData$hp, 
        "Cylinders:", vehicleData$cyl, 
        "Fuel Efficiency:", vehicleData$mpg, 
        "1/4 mile time:", vehicleData$qsec, 
        sep=" ")
}


#b)
createFormattedAd <- function(vehicleData){
  firstRow = paste0(rep('*', 30), collapse = "")
  
  spaces = paste0(rep(" ", 15), collapse = "")
  secondRow = paste0("* ", vehicleData$car, spaces, '*')
  
  thirdRow = paste0('* Horsepower: ', vehicleData$hp)
  spaces = paste0(rep(" ", 12), collapse = "")
  thirdRow = paste0(thirdRow, spaces, '*')
  
  fourthRow = paste0('* Cylinders: ', vehicleData$cyl)  
  spaces = paste0(rep(" ", 15), collapse = "")
  fourthRow = paste0(fourthRow, spaces, '*')
  
  fifthRow = paste0('* Fuel Efficiency: ', vehicleData$mpg, 'mpg')
  spaces = paste0(rep(" ", 5), collapse = "")
  fifthRow = paste0(fifthRow, spaces, '*')
  
  sixthRow = paste0('* 1/4 mile time: ', round(vehicleData$qsec, 0), 'sec')
  spaces = paste0(rep(" ",7), collapse = "")
  sixthRow = paste0(sixthRow, spaces, '*')
  
  output = paste(firstRow, 
                 secondRow, 
                 thirdRow,
                 fourthRow,
                 fifthRow,
                 sixthRow,
                 firstRow,
                 sep='\n')
  cat(output)
}
createFormattedAd(carData[1,])



#c)
createFormattedAdWithComparison <- function(vehicleData){
  firstRow = paste0(rep('*', 30), collapse = "")
  
  spaces = paste0(rep(" ", 15), collapse = "")
  secondRow = paste0("* ", vehicleData$car, spaces, '*')
  
  thirdRow = paste0('* Horsepower: ', vehicleData$hp)
  if (vehicleData$hp > quantile(carData$hp, 0.9)){
    thirdRow = paste0(thirdRow, ' Top 10%')
    spaces = paste0(rep(" ", 4), collapse = "")
  } else {
    spaces = paste0(rep(" ", 12), collapse = "")
  }
  thirdRow = paste0(thirdRow, spaces, '*')
  
  fourthRow = paste0('* Cylinders: ', vehicleData$cyl)  
  spaces = paste0(rep(" ", 15), collapse = "")
  fourthRow = paste0(fourthRow, spaces, '*')
  
  fifthRow = paste0('* Fuel Efficiency: ', vehicleData$mpg, 'mpg')
  spaces = paste0(rep(" ", 5), collapse = "")
  fifthRow = paste0(fifthRow, spaces, '*')
  
  sixthRow = paste0('* 1/4 mile time: ', round(vehicleData$qsec, 0), 'sec')
  spaces = paste0(rep(" ",7), collapse = "")
  sixthRow = paste0(sixthRow, spaces, '*')
  
  output = paste(firstRow, 
                 secondRow, 
                 thirdRow,
                 fourthRow,
                 fifthRow,
                 sixthRow,
                 firstRow,
                 sep='\n')
  cat(output)
}



#d)
createFormattedAdsWithComparisons <- function(vehicleData, n){
  vehicleData %>%
    sample_n(5) -> df
  
  for (i in 1:n){
    createFormattedAdWithComparison(df[i,])
    cat('\n')
  }
}
createFormattedAdsWithComparisons(carData, 3)

#e)
prices = read_csv("Data/carPrices.csv")
mileage = read_csv('Data/carMileage.csv')

carData %>%
  left_join(prices, by=c('car' = 'Type')) %>%
  left_join(mileage, by = c('car' = 'Type'))
