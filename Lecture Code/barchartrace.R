#https://michaeltoth.me/how-to-create-a-bar-chart-race-in-r-mapping-united-states-city-population-1790-2010.html

library(gganimate)
library(tidyverse)


library(gapminder)

gapminderFull = read.csv2("Lecture Code/gapminder.csv", sep = ";", dec=".", header =T)

gapminderFull %>%
  rename(country = ï..Total.population) %>%
  gather(year, pop, -country) %>%
  mutate(year = as.numeric(sub("X","",year))) %>%
  mutate(pop = as.numeric(str_remove_all(pop,","))) -> gapminderFull

all_data <- data.frame()

all_years <- data.frame(year = seq(1800, 2015, 1))

for(yearCurrent in all_years$year) {
  data = data.frame(country = unique(gapminder$country))
  data = left_join(data, unique(select(gapminder, country, continent)))
  data$year = yearCurrent 
  data = data %>% left_join(gapminderFull %>% filter(year==yearCurrent) %>% select(year, country, pop))
  all_data <- bind_rows(all_data, data)
}


gapminder %>%
  group_by(year) %>%
  mutate(top_10_pop = dense_rank(-pop)) %>%
  filter(top_10_pop <= 10) %>%
  ungroup() %>%
  select(country, continent) %>% distinct() -> top_countries


# Create all combinations of city and year we'll need for our final dataset
all_combos <- merge(top_countries, all_years, all = T)

# This accomplishes 2 things:
# 1. Filters out cities that are not ever in the top 10
# 2. Adds rows for all years (currently blank) to our existing dataset for each city
all_data_interp <- merge(all_data, all_combos, all.y = T)

all_data_interp <- all_data_interp %>%
  group_by(country) %>%
  mutate(pop=approx(year,pop,year)$y)

data <- all_data_interp %>%
  na.omit() %>%
  group_by(year) %>%
  arrange(-pop) %>%
  mutate(rank=row_number()) %>%
  filter(rank<=10)


p <- data %>%
  ggplot(aes(x = -rank,y = pop, group = country)) +
  geom_tile(aes(y = pop / 2, height = pop, fill = continent), width = 0.9) +
  geom_text(aes(label = country), hjust = "right", colour = "black", fontface = "bold", nudge_y = -100000) +
  geom_text(aes(label = scales::comma(pop)), hjust = "left", nudge_y = 100000, colour = "grey30") +
  coord_flip(clip="off") +
  scale_fill_manual(name = 'Region', values = c("#66c2a5", "#fc8d62", "#8da0cb", "#e78ac3")) +
  scale_x_discrete("") +
  scale_y_continuous("",labels=scales::comma) +
  theme(panel.grid.major.y=element_blank(),
        panel.grid.minor.x=element_blank(),
        legend.position = c(0.4, 0.2),
        plot.margin = margin(1,1,1,2,"cm"),
        axis.text.y=element_blank()) +
  # gganimate code to transition by year:
  transition_time(year) +
  ease_aes('cubic-in-out') +
  labs(title='Largest Countries in the World',
       subtitle='Population in {round(frame_time,0)}',
       caption='Source: gapminder')

anim = animate(p, nframes = 400, fps = 25, end_pause = 50, width = 600, height = 450)

anim
