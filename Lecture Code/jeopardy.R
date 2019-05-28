library(rvest)
library(tidyverse)





getEpisode= function(episode)
{
  
  episode %>%
    read_html() %>%
    html_nodes(".clue_text") %>%
    html_attr("correct_response")
  
}

getEpisode("http://www.j-archive.com/showgame.php?game_id=6295")


getFinalQuestionsByEpisode = function(episode)
{
  
  episode %>%
    read_html() %>%
    html_node("#clue_FJ") %>%
    html_text()
  
}

getEpisodesFromSeason = function(season)
{
  season %>%
    read_html() %>%
    html_nodes("td:nth-child(1) a") %>%
    html_attr("href")
  
  
}

map(paste0("http://www.j-archive.com/showseason.php?season=",1:35),getEpisodesFromSeason) -> episodes
episodes.urls = unlist(episodes)
#very slow
#episodes.html = map(episodes.urls, getEpisode)


filenames = paste0("export/file",1:6279,".xml")
map(filenames, read_html) -> episodes.html

getDailyDoubleLocations = function(episode)
{
  episode %>%
    html_nodes(".clue") -> clueNodes
  
  clueNodes %>% 
    str_detect("clue_value_daily_double") -> ddfield
  
  clueNodes[ddfield] %>%
    str_match("J_[1-9]_[1-9]") %>%
    as.vector()

}

episodes.html %>%
  map(getDailyDoubleLocations) %>%
  unlist() -> ddLocationStatistic

data.frame(location = ddLocationStatistic) %>%
  mutate(location = substring(location,3,5)) %>%
  separate(col = "location",
           into = c("row", "column"),
           sep="_") %>%
  mutate(column = as.numeric(column),
         row = as.numeric(row)) %>%
  group_by(row, column) %>%
  tally() %>%
  ggplot(aes(x=row, y=-column, fill=n)) + geom_tile() + 
  scale_fill_gradient(low = "white", high = "blue") +
  geom_text(aes(label=n)) + theme_void()
