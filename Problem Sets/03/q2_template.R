# Problem Set 3
# Question 2

# Name: Louis Graf
# Matrikelnummer: 2389931

library(tidyverse) # tidy data analysis
library(tidygraph) # tidy graph analysis
library(jsonlite)
library(ggraph)

#a -------------------------------------------

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
  ungroup() -> clinton_emails

clinton_net <- as_tbl_graph(clinton_emails, directed = FALSE)

ggraph(clinton_net) + 
  geom_edge_link(width = 1) + 
  geom_node_point(size = 2) +
  geom_node_text(aes(label = "from"), size = 1, repel = TRUE) +
  theme_graph()

#b -------------------------------

clinton_emails %>% 
  mutate(from=trimws(from),
         to=trimws(to)) %>% 
  filter(from != "") %>% 
  filter(to != "") %>% 
  filter(!grepl(";", from)) %>% 
  filter(!grepl(";", to)) -> clinton_emails

clinton_emails %>%
  filter(to == "Hillary Clinton" | from == "Hillary Clinton") %>%
  select(to, from) %>%
  group_by(to, from) %>%
  summarise(weight = n())%>%
  arrange(desc(weight)) %>%
  ungroup() -> clinton_emails

clinton_net <- as_tbl_graph(clinton_emails, directed = FALSE)

ggraph(clinton_net) + 
  geom_edge_link(width = 1) + 
  geom_node_point(size = 2) +
  geom_node_text(aes(label = "from"), size = 1, repel = TRUE) +
  theme_graph()

#c ---------------------------------

clinton_net <- as_tbl_graph(clinton_emails, directed = FALSE) %>%
  mutate(centrality = centrality_degree() %>%
           activate(edges) %>% 
           filter(!edge_is_multiple()) %>%
           mutate(centrality_e = centrality_edge_betweenness())
         
         as.tibble(clinton_net)
         layout = create_layout(clinton_net, layout = "fr")
         
         ggraph(layout) + 
           geom_edge_link(width = 1) + 
           geom_node_point(size = log(centrality)) + # Findet weight nicht, aber auch kein centrality oder sonst irgendetwas ... // da bin ich mal auf die Übung/Musterlösung gespannt
           geom_node_text(aes(label = "from"), size = 1, repel = TRUE) +
           theme_graph()
         
         #d ---------------------------------------
         
         #Musterlösung:
         
         # i. Leverage your data wrangling skills to count the number of interactions between each pair of nodes 
         # ii. Join the new data frame to the email data frame  
         # iii. Remove duplicate edges 
         # iv. Plot the graph and remove all legends 
