#Create two vectors which reflecting 100 throws of two standard dices by sampling from 1:6.

set.seed(11) # fix random seed for reproducibility
dice1 = sample(1:6, 100, T)
dice2 = sample(1:6, 100, T)

dice1
dice2

#How often did dice 1 show the higher number?
sum(dice1 > dice2)

#How often did dice 1 show a number which was at least 3 larger than dice 2?
sum(dice1 - 3 >= dice2)

#Compare the ten highest throws of the two dices
topTenDice1 = head(sort(dice1, decreasing = T), 10)
topTenDice2 = head(sort(dice2, decreasing = T), 10)

topTenDice1 - topTenDice2

#Create a third vector reflecting the sum of the two other throws
sumDices = dice1 + dice2

#Determine the five highest and the five lowest combined scores
head(sort(sumDices, decreasing = T), 5)
head(sort(sumDices, decreasing = F), 5)
