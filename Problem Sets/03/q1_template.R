# Problem Set 3
# Question 1

library(tidyverse)
library(leaflet)
library(raster)
# Name: Louis Graf

# Matrikelnummer: 2389931


#1) 
#a) -------------------------------------------------------
data = read_csv2("https://www.bundeswahlleiter.de/dam/jcr/5441f564-1f29-4971-9ae2-b8860c1724d1/ew19_kerg2.csv",skip = 9)


data %>%
  filter(Gruppenart == "Partei", Gebietsart == "Land") -> data_filtered



#b) -------------------------------------------------------
data_filtered %>%
  dplyr::select(Gebietsname, Gruppenname, Prozent) %>%
  filter(Gruppenname %in% c("CDU", "CSU", "SPD", "AfD", "DIE LINKE", "GRÜNE", "FDP" )) %>%
  group_by(Gebietsname, Gruppenname)  -> bdata

#Grouped Barplot: x = Gebietsname, y = Prozent, Bar = Gruppennamen(Partei)
ggplot(data = bdata, mapping = aes(x = Gebietsname, y = Prozent, fill = Gruppenname)) + 
  geom_bar(stat = "identity")  + 
  theme(axis.text.x = element_text(angle = 90, vjust=0.2, hjust=0.5))

#Facet: x = Gruppennamen, y = Prozent, Facetten = Bundesland
ggplot(data = bdata, mapping = aes(x = Gruppenname, y = Prozent)) + 
  geom_bar(stat = "identity") + 
  facet_wrap( ~ Gebietsname) + 
  theme(axis.text.x = element_text(angle = 90, vjust=0.2, hjust=0.5))



#c) -------------------------------------------------------
#Stacked Barplot: x = Gebietsname, y = Prozent, Bar = Gruppennamen(Partei)
ggplot(data = bdata, mapping = aes(x = Gebietsname, y = Prozent, fill = Gruppenname)) + 
  geom_bar(stat = "identity", position = "fill")  + 
  theme(axis.text.x = element_text(angle = 90, vjust=0.2, hjust=0.5))



#d) -------------------------------------------------------
#i)
bdata %>%
  group_by(Gebietsname) %>%
  filter(Prozent == max(Prozent)) %>%
  arrange(Gebietsname, Gruppenname, Prozent) -> winner


#ii)
#get GADM data
#sp = readRDS("Problem Sets/03/gadm36_DEU_1_sp.rds")
sp <- getData("GADM", country="DEU", level=1)

#iii)
#Merge Dataframes
sp_data = merge(sp, winner, by.x = "NAME_1", by.y = "Gebietsname")

#iv)
#create a color palette to fill the polygons
pal <- colorFactor(c(
  'AfD'= 'blue',
  'CDU'= 'black',
  'CSU'='grey',
  'FDP'='yellow',
  'GRÜNE'='seagreen',
  'SPD'='red'), domain = c("AfD", "CDU", "CSU", "FDP", "GRÜNE", "SPD"), n = 6)

#Creating Pop-Ups
polygon_popup <- paste0("<strong>Name: </strong>", sp_data$NAME_1, "<br>",
                         "<strong>Wahlsieger: </strong>", sp_data$Gruppenname, "<br>",
                         "<strong>Prozent: </strong>", round(sp_data$Prozent,2))

#v)
#create leaflet map
leaflet() %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  setView(lat=10, lng=0 , zoom=2) %>% 
  addPolygons(data = sp_data, 
              fillColor= ~pal(Gruppenname),
              fillOpacity = 0.4, 
              weight = 2, 
              color = "Black",
              popup = polygon_popup)


#e) -------------------------------------------------------
#Landkreis-Daten
data %>%
  filter(Gruppenart == "Partei", Gebietsart == "Kreis") %>%
  dplyr::select(Gebietsname, Gruppenname, Prozent) %>%
  filter(Gruppenname %in% c("CDU", "CSU", "SPD", "AfD", "DIE LINKE", "GRÜNE", "FDP" )) %>%
  group_by(Gebietsname, Gruppenname) %>%
  group_by(Gebietsname) %>%
  filter(Prozent == max(Prozent)) %>%
  arrange(Gebietsname, Gruppenname, Prozent) -> winner2




#get GADM data
sp2 <- getData("GADM", country="DEU", level=2)


#Merge Dataframes
sp_data2 = merge(sp2, winner2, by.x = "NAME_2", by.y = "Gebietsname")


#Creating Pop-Ups
polygon_popup2 <- paste0("<strong>Name: </strong>", sp_data2$NAME_2, "<br>",
                        "<strong>Wahlsieger: </strong>", sp_data2$Gruppenname, "<br>",
                        "<strong>Prozent: </strong>", round(sp_data2$Prozent,2))

#create leaflet map
leaflet() %>% 
  addProviderTiles("CartoDB.Positron") %>% 
  setView(lat=10, lng=0 , zoom=2) %>% 
  addPolygons(data = sp_data2, 
              fillColor= ~pal(Gruppenname),
              fillOpacity = 0.4, 
              weight = 2, 
              color = "Black",
              popup = polygon_popup2)

