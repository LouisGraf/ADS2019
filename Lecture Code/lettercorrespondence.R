#https://www.jessesadler.com/post/network-analysis-with-r/
letters = read.csv2("https://raw.githubusercontent.com/jessesadler/intro-to-r/master/data/correspondence-data-1585.csv", sep=",")

head(letters)

sources <- letters %>%
  distinct(source) %>%
  rename(label = source)

destinations <- letters %>%
  distinct(destination) %>%
  rename(label = destination)

sources
destinations

nodes <- full_join(sources, destinations, by = "label")
nodes

nodes <- nodes %>% rowid_to_column("id")
nodes

per_route <- letters %>%  
  group_by(source, destination) %>%
  summarise(weight = n()) %>% 
  ungroup()
per_route

edges <- per_route %>% 
  left_join(nodes, by = c("source" = "label")) %>% 
  rename(from = id)

edges <- edges %>% 
  left_join(nodes, by = c("destination" = "label")) %>% 
  rename(to = id)

edges <- dplyr::select(edges, from, to, weight)
edges

library(tidygraph)
library(ggraph)
routes_tidy <- tbl_graph(nodes = nodes, edges = edges, directed = TRUE)
routes_tidy
routes_tidy %>% 
  activate(edges) %>% 
  arrange(desc(weight))

ggraph(routes_tidy) + geom_edge_link() + geom_node_point() + theme_graph()

ggraph(routes_tidy, layout = "graphopt") + 
  geom_edge_link(aes(width = log1p(weight)), alpha = 0.8) + 
  scale_edge_width(range = c(0.2, 2)) +
  geom_node_text(aes(label = label), repel = TRUE) +
  labs(edge_width = "Letters") +
  theme_graph()

ggraph(routes_tidy, layout = "linear") + 
  geom_edge_arc(aes(width = weight), alpha = 0.8) + 
  scale_edge_width(range = c(0.2, 2)) +
  geom_node_text(aes(label = label)) +
  labs(edge_width = "Letters") +
  theme_graph()

# As chord diagram
library(circlize)
edges %>%
  left_join(nodes, by = c("from" = "id")) %>%
  mutate(from = label) %>%
  select(-label) %>%
  left_join(nodes, by = c("to" = "id")) %>%
  mutate(to = label) %>%
  select(-label) %>%
  mutate(weight = log1p(weight)) %>%
  chordDiagram(transparency = 0.3)
