library(tidyverse)

str(ChickWeight)

#Add a column called weight_d_time that is weight divided by time

ChickWeight %>% 
  mutate(weight_d_time = weight / Time)

#Calculate the mean weight and time for each diet

ChickWeight %>%
  group_by(Diet) %>%
  summarize(meanWeight = mean(weight),
            meanTime = mean(Time))

#Add a column called weight_d_time that is weight divided by time AND time_d that is time in days

ChickWeight %>% 
  mutate(weight_d_time = weight / Time)

ChickWeight %>%
  select(Diet) %>%
  mutate(diet_qualitative = case_when(
    Diet == 4 ~ "Meat",
    Diet == 3 ~ "Grain",
    Diet == 2 ~ "Vegetable",
    Diet == 1 ~ "Fruit")
  )

#Create a new variable Diet_name which shows Diet in text format (1 is fruit, 2 is vegetables, 3 is meat, 4 is grain). The case_when() function is helpful for this task.


 %>
For each time period less than 10, calculate the mean weight
For each Diet, calculate the mean weight, maximum time, and the number of chicks on each diet
Give me a random sample of 10 rows from the ChickWeight dataframe, but only show me the values for Chick and weight (sample_n)