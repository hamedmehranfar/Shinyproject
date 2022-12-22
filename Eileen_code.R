install.packages("readxl")
install.packages("leaflet")
library(readxl)
library(sp)
library(dplyr)
library(leaflet)

bridges_coordinates <- read_excel("bridges_coordinates.xlsx")
ZolBgg <- read_excel("ZolBgg-xmp.xlsx")

names <- na.omit(ZolBgg[,2]) # we create a vector with the bridge names that we can add the coordinates too 
# we use this vector to then match the coordinates with the bridges, in order to visualize them on a map 

bridges_coordinates$Name
names.bridges <- c("Aarebr. Bruegg", "Aareviad Busswil", "Du Chueelibach", "Du Lyssbach", "Jenskanal-Br.", "KDu Loeribach", 
                   "PDu Horbengasse", "Plle Bruegg", "PU Schuepfen", "PU Bruegg mitte 3", "PU Busswil", "PU Lyss", "PU mitte 1", 
                   "PU Muenchenbuchsee", "PU Oberfeldweg", "PU Studen Station", "PU Suberg", "SU Brueggstrasse Sued", "SU Fluehmatten", 
                   "SU Leueren Blaumatt", "SU Muehleplatz", "SU Murgeli", "SU Rosengasse", "SU Schwanden", "SU Studen", "SUe Bruegg",
                   "SUe Steinweg", "U Bielstr.", "U Bielstrase", "U Neubrueckstrasse", "Ue Brueggstrasse", "WU Friedhof", "WU Holen")

# we now rename the brige coordinates that we have
# we will then use this to match the coordinates with the bridge names (for which we have deteoriation data)

bridges_coordinates$Name <- c("Aarebr. Bruegg", "Aareviad Busswil", "Du Lyssbach", "Du Chueelibach", "Jenskanal-Br.", "KDu Loeribach", 
                              "PDu Horbengasse", "Plle Bruegg", "PU Bruegg mitte 3", "no data", "no data", "no data", "no data", "no data", 
                              "PU Busswil", "PU Lyss", "PU mitte 1", "no data", "no data", "no data", "no data", "no data", "PU Muenchenbuchsee", 
                              "PU Oberfeldweg", "no data", "PU Studen Station", "PU Suberg", "SU Brueggstrasse Sued", "SU Fluehmatte", 
                              "SU Leueren Blaumatt", "SU Muehleplatz", "SU Murgeli", "SU Rosengasse", "SU Schwanden", "SU Studen", "SUe Bruegg", 
                              "SUe Steinweg", "U Bielstr.", "U Bielstrasse", "U Neubrueckstrasse", "no data", "Ue Brueggstrasse", "WU Friedhof", "WU Holen")

names.bridges <- as.data.frame(names.bridges)
names.bridges$Name <- names.bridges$names.bridges

bridges <- merge(names.bridges, bridges_coordinates, by = "Name", all.y = TRUE)
View(bridges) 
bridges <- subset(bridges, bridges$Name != "no data") # we now have a dataset containing only the observations for which we have data available regarding their deterioration
bridges.noNA <- na.omit(bridges)

#ensuring lat and long are numbers
bridges.noNA$longitude <- as.numeric(bridges.noNA$longitude)
bridges.noNA$latitude <- as.numeric(bridges.noNA$latitude)

#creating new spatial point dataframe
bridges.SP <- SpatialPointsDataFrame(bridges.noNA[,c(3,4)], bridges.noNA[,-c(3,4)])

m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = bridges.noNA, lng= ~longitude, lat= ~latitude, popup= paste(bridges.noNA$Name))

# this can now be copied into the markdown file ,

m
