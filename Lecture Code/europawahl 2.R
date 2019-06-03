library(tidyverse)
library(rvest)

getRegions = function(site)
{
  baseURL = "https://www.bundeswahlleiter.de/europawahlen/2019/"
  
  read_html(site) %>%
    html_nodes("#main li+ li a") -> mainNodes
  
  region = mainNodes %>% html_text()
  regionURL = mainNodes %>% html_attr("href")
  
  tibble(region = region, url = paste0(baseURL,regionURL)) %>%
    distinct()
}

getRegions("https://www.bundeswahlleiter.de/europawahlen/2019/ergebnisse.html") -> data

getSubRegionsURL = function(region, url)
{
  baseURL = "https://www.bundeswahlleiter.de/europawahlen/2019/ergebnisse/bund-99/"
  
  read_html(url) %>%
    html_nodes(".linklist__item a") -> mainNodes
  
  subregion = mainNodes %>% html_text()
  subregionurl = mainNodes %>% html_attr("href")
  
  tibble(region = region, subregion = subregion, url = paste0(baseURL,subregionurl))
}

map2_df(data$region, data$url, getSubRegionsURL) -> data2

getSubRegionsURL("https://www.bundeswahlleiter.de/europawahlen/2019/ergebnisse/bund-99/land-8.html")

getSubRegionDetails = function(url, sub){
  read_html(url) %>%
    html_table(fill=TRUE) %>%
    data.frame() -> df
  df[-1:-5,c(1,2,4)] %>%
    mutate(Stimmen.2019 = str_replace_all(Stimmen.2019,"\\.",""),
           Stimmen.2014 = str_replace_all(Stimmen.2014,"\\.","")) %>%
    mutate(Stimmen.2019 = as.numeric(str_replace_all(Stimmen.2019,"-","0")),
           Stimmen.2014 = as.numeric(str_replace_all(Stimmen.2014,"-","0"))) -> df
  df %>%
    mutate(subregion = sub)
}

allDetails = map2_df(data2$url, data2$subregion, getSubRegionDetails)

allDetails %>%
  left_join(data2 %>% select(-url)) %>%
  group_by(subregion) %>%
  mutate(validVotes = sum(Stimmen.2019)) %>%
  group_by(Merkmal, subregion, region) %>%
  summarise(totalVotes = sum(Stimmen.2019),
            share = totalVotes / validVotes) %>%
  select(share, Merkmal, subregion, region) %>%
  spread(Merkmal, share) %>%
  filter(region=="Bayern") %>%
  ggplot(aes(x=CSU, y=GRÜNE)) + geom_point()

allDetails %>%
  left_join(data2 %>% select(-url)) %>%
  select(region, subregion, Stimmen.2019, Stimmen.2014, Merkmal) %>%
  gather(Jahr,Stimmen,-region,-subregion,-Merkmal) %>%
  mutate(Jahr = substring(Jahr, 9, 13)) %>%
  group_by(Merkmal, Jahr) %>%
  summarise(totalVotes = sum(Stimmen)) %>%
  group_by(Jahr) %>%
  mutate(share = totalVotes/sum(totalVotes)) %>%
  arrange(-share) %>%
  mutate(Merkmal = factor(Merkmal, levels = unique(Merkmal))) %>%
  filter(share >= 0.006) %>%
  ggplot(aes(x=Jahr, y=share, fill=Merkmal)) + geom_col(position="dodge") + facet_grid(.~Merkmal)
  
  
  