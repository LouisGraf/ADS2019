#What is the mean / max / min mpg of the cars?

mean(mtcars$mpg)
max(mtcars$mpg)
min(mtcars$mpg)

order(mtcars$mpg)
mtcars[tail(order(mtcars$mpg),1),]

mtcars[mtcars$mpg==max(mtcars$mpg),]

#Create a new column which states the ratio of power vs. weight

mtcars$ratioPowerWeight = mtcars$hp / mtcars$wt


#Which is the best car according to this dimension?
mtcars[mtcars$ratioPowerWeight==max(mtcars$ratioPowerWeight),]

