library(raster)
library(tidyverse)
library(rvest)

url = "https://www.kba.de/DE/Statistik/Fahrzeuge/Neuzulassungen/Umwelt/2016/2016_n_umwelt_dusl.html?nn=1978302"

url %>%
  read_html() %>%
  html_nodes(".data , .stub , .head") %>%
  html_text() -> x

m = matrix(x, ncol=8, byrow = T)

df = data.frame(m[2:17,1:7])
headers = m[1,1:7]
names(df) = substring(headers,1,6)
df

df %>%
  gather(key = Antrieb, value = Anzahl, -Land) %>%
  mutate(Anzahl = as.numeric(sub("\\.", "",Anzahl)))  -> df.complete

df.complete %>%
  group_by(Land) %>%
  mutate(Gesamt = sum(Anzahl)) %>%
  mutate(Anteil = Anzahl / Gesamt) -> df.complete

gadm36_DEU_1_sp = readRDS(gzcon(url("https://biogeo.ucdavis.edu/data/gadm3.6/Rsp/gadm36_DEU_1_sp.rds")))
mapdata = fortify(gadm36_DEU_1_sp, "NAME_1")

#THIS IS IMPORTANT FOR JOINING
#https://stackoverflow.com/questions/22096787/how-keep-information-from-shapefile-after-fortify
laender = data.frame(Land=unique(gadm36_DEU_1_sp$NAME_1))
laender$id = rownames(gadm36_DEU_1_sp@data)

mapdata %>% 
  left_join(laender) %>%
  left_join(df.complete) %>%
  filter(Antrieb == "Elektr") %>%
  ggplot() +
  geom_polygon(aes(x=long, y=lat, fill = Anteil, group=group)) +
  coord_fixed() + 
  labs(title = "Nuezulassungs-Anteil Dieselfahrzeuge",
       subtitle = "2016",
       caption = "Quelle: https://www.kba.de/DE/Statistik/Fahrzeuge/Neuzulassungen/Umwelt/2016/2016_n_umwelt_dusl.html?nn=1978302")



# WITH LEAFLET

library(leaflet)

#get GADM data
germany <- getData("GADM", country="DEU", level=1)

germany$NAME_1
germany$dieselanteil = df.complete %>% filter(Antrieb == "Diesel") %>% ungroup() %>% dplyr::select(Anteil) %>% unlist()


#create a color palette to fill the polygons
pal <- colorQuantile("Reds", NULL, n = 5)

#create a pop up (onClick)
polygon_popup <- paste0("<strong>Name: </strong>", germany$NAME_1, "<br>",
                        "<strong>Anteil: </strong>", paste(100*round(germany$dieselanteil,3),"%"))

#create leaflet map
leaflet() %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  addPolygons(data = germany, 
              fillOpacity = 0.4, 
              fillColor= ~pal(dieselanteil),
              weight = 2, 
              color = "white",
              popup = polygon_popup)
