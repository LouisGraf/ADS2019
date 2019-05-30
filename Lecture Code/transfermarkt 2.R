url = "https://www.transfermarkt.de/wurzburger-kickers/startseite/verein/1557/saison_id/2018"

url %>%
  read_html() %>%
  html_nodes("td div span a") %>%
  html_attr("href") -> wuerzburgSpielerURL

unique(wuerzburgSpielerURL) -> wuerzburgSpielerURL

getPlayerDetails = function(playerURL)
{
  playerURL = paste0("https://www.transfermarkt.de",playerURL)
  
  playerURL %>%
    read_html() -> playerPage
  
  playerPage %>%
    html_nodes("h1") %>%
    html_text() -> name
  
  playerPage %>%
    html_nodes(".right-td a:nth-child(1)") %>%
    html_text() -> marktwert
  
  data.frame(name = name, marktwert = marktwert)
}

map_df(head(wuerzburgSpielerURL), getPlayerDetails)
