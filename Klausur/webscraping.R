#Webscraping

#Basics
url = "url"

url %>%
  read_html(url) -> rawPage
  
  rawPage %>%
    html_nodes('.text') %>%
    htmt_attr('href') %>%
    html_text() -> quotes
  
#Fehlende Werte zu NA wandeln
  temperature = ifelse(length(temperature) == 0, NA, temperature) #Wenn length = 0, also nicht vorhanden, dann NA
  title = ifelse(length(title) == 0, NA, title)

  