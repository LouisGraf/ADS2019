# Problem Set 2
# Question 2

# Name: Louis Graf
# Matrikelnummer: 2389931

require(tidyverse)
require(rvest)

#a) -------------------------------------------------------------
url ="https://www.mydealz.de/?page="

map_df(1:50, function(i) {
  
  # simple but effective progress indicator
  cat(".")
  
  pg <- read_html(sprintf(url, i))
  
  data.frame(title = html_text(html_nodes(pg, ".thread-title--list")),
             temperature = html_text(html_nodes(pg, ".space--h-2.text--b , .thread--deal .vote-temp--burn")),
             author = html_text(html_nodes(pg, ".linkPlain .thread-username")),
             deepLink = html_attr(html_nodes(pg, ".thread-title--list"),"href"),
             #comments = html_text(html_nodes(pg, "div.excerpt")),
             stringsAsFactors=FALSE)
  
}) -> deals

#b) --------------------------------------------------------------

#Keine "falsche COdierung" in den Spalten Title & Temperature 
deals2 <- deals
deals2$title <- iconv(deals2$title, "latin1", "ASCII")
Encoding(deals2$title)
#Beim Versuch die Kodierung zu wechseln entstehen NA Werte

#Bereinigte Deals
deals_clean = deals
deals_clean$title = trimws(deals$title, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
deals_clean$temperature = trimws(deals$temperature, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")
deals_clean$author = trimws(deals$author, which = c("both", "left", "right"), whitespace = "[ \t\r\n]")

#c)-------------------------------------------------------------------
