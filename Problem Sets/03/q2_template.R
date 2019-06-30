# Problem Set 3
# Question 2

# Name: Louis Graf
# Matrikelnummer: 2389931

library(tidyverse) # tidy data analysis
library(tidygraph) # tidy graph analysis
library(ggraph) 
library(jsonlite)


if (!file.exists("clinton_emails.rda")) {
  clinton_emails <- fromJSON("http://graphics.wsj.com/hillary-clinton-email-documents/api/search.php?subject=&text=&to=&from=&start=&end=&sort=docDate&order=desc&docid=&limit=27159&offset=0")$rows
  save(clinton_emails, file="clinton_emails.rda")
}

load("clinton_emails.rda")

clinton_emails %>% 
  mutate(from=trimws(from),
         to=trimws(to)) %>% 
  filter(from != "") %>% 
  filter(to != "") %>% 
  filter(!grepl(";", from)) %>% 
  filter(!grepl(";", to)) -> clinton_emails

clinton_emails %>%
  select(to, from) %>%
  group_by(to, from) %>%
  summarise(weight = n())%>%
  arrange(desc(weight)) %>%
  ungroup() -> clinton_route




as_tbl_graph(clinton_route, directed = FALSE) %>%
mutate(neighbors = centrality_degree(),
       group = group_infomap(),
       keyplayer = node_is_keyplayer(k = 10)) %>%
  activate(edges) %>% 
  filter(!edge_is_multiple()) -> clinton_network


layout <- create_layout(clinton_network, 
                        layout = "fr")

ggraph(layout) + 
  geom_edge_density(aes(fill = weight)) +
  geom_edge_link(aes(width = weight), alpha = 0.1) + 
  geom_node_point(aes(color = factor(group)), size = 2) +
  geom_node_text(aes(label = name), size = 2, repel = TRUE) +
  theme_graph()

