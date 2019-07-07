library(tidyverse)

dfSoccer = read.csv("https://github.com/vincentarelbundock/Rdatasets/raw/master/csv/vcd/Bundesliga.csv")

soccerTable = function(year){
  dfSoccer %>%
    filter(Year == year) %>%
    mutate(pointsHome = if_else(HomeGoals > AwayGoals, 3, if_else(HomeGoals == AwayGoals, 1, 0)),
           pointsAway = if_else(HomeGoals > AwayGoals, 0, if_else(HomeGoals == AwayGoals, 1, 3))) %>%
    select(-X, -Date, -Round) %>%
    gather(key, team, -HomeGoals, -AwayGoals, -Year, -pointsHome, -pointsAway) %>%
    group_by(team, Year) %>%
    summarise(Points = sum(pointsHome[key=="HomeTeam"]) + sum(pointsAway[key=="AwayTeam"]),
              Goals = sum(HomeGoals[key=="HomeTeam"]) - sum(AwayGoals[key=="HomeTeam"]) + 
                sum(AwayGoals[key=="AwayTeam"]) - sum(HomeGoals[key=="AwayTeam"])) %>%
    ungroup() -> df
  return(df)
}

years = unique(dfSoccer$Year)
bundesliga = map_df(years, soccerTable)


# Wie bestimmt man den Gewinner pro Saison? Welche Mannschaft hat die meisten Tore geschossen?
bundesliga %>%
  group_by(Year) %>%
  filter(Points == max(Points))


# Prozente in Labels?
bundesliga %>%
  group_by(Year) %>%
  arrange(desc(Points)) %>%
  mutate(rank = row_number()) %>%
  group_by(team) %>%
  summarise(shareWon = length(Year[rank==1]) / length(years)) %>%
  arrange(desc(shareWon)) %>%
  head(5) %>%
  ggplot(aes(x=team, y=shareWon)) + 
  geom_col() + scale_y_continuous(labels = scales::percent) +
  theme_bw() + ylab("Anteil Meister") + xlab("")