#install.packages("readxl")
#install.packages("leaflet")
library(readxl)
library(sp)
library(dplyr)
library(leaflet)


bridges_coordinates <- read_excel(paste(location,"Data/bridges_coordinates.xlsx", sep = "/"))
ZolBgg <- read_excel(paste(location,"Data/ZolBgg-xmp.xlsx", sep = "/"))
#bridges_coordinates <- read_xlsx("bridges_coordinates.xlsx")
#ZolBgg <- read_xlsx("ZolBgg-xmp.xlsx")

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
#View(bridges) 
bridges <- subset(bridges, bridges$Name != "no data") # we now have a dataset containing only the observations for which we have data available regarding their deterioration
bridges.noNA <- na.omit(bridges)

#ensuring lat and long are numbers
bridges.noNA$longitude <- as.numeric(bridges.noNA$longitude)
bridges.noNA$latitude <- as.numeric(bridges.noNA$latitude)

#creating new spatial point dataframe
bridges.SP <- SpatialPointsDataFrame(bridges.noNA[,c(3,4)], bridges.noNA[,-c(3,4)])

bridge_map <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = bridges.noNA, lng= ~longitude, lat= ~latitude, popup= paste(bridges.noNA$Name))

# this can now be copied into the markdown file ,

write.csv(bridges.noNA, "bridges.file.csv") #out of this, I manually created a csv "bridges_conditions.csv" (details condition of abutments and bearings for bridges over the years)
bridges_conditions <- read.csv("bridges_conditions.csv", sep = ";")

# for the year 15, there seems to be no data for the majority of the bridges --> we only include years 1-14
bridges_conditions <- bridges_conditions[,1:22]
View(bridges_conditions)

# we now try to include the popups of the bridge conditions for a given year, starting with year 1
m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = bridges.noNA, lng= ~longitude, lat= ~latitude, popup= paste(bridges.noNA$Name, bridges_conditions$bridge_part, bridges_conditions$condition, bridges_conditions$year_1))
m

# this does not give us the desired result, so we add the possibility to plot the map for a specific bridge part and year
# we first create a table containing either the abutment or the bearings 
bridges_conditions.bearings <- subset(bridges_conditions, bridges_conditions$bridge_part == "bearings")
bridges_conditions.abutment <- subset(bridges_conditions, bridges_conditions$bridge_part == "abutment")

# first for the bearings
m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = bridges.noNA, lng= ~longitude, lat= ~latitude, popup= paste(bridges.noNA$Name, bridges_conditions.bearings$bridge_part, bridges_conditions.bearings$condition, bridges_conditions.abutment$year_1))
m

# now for the abutments
m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = bridges.noNA, lng= ~longitude, lat= ~latitude, popup= paste(bridges.noNA$Name, bridges_conditions.abutment$bridge_part, bridges_conditions.abutment$condition, bridges_conditions.abutment$year_1))
m

# it doesn't allow us to display all the condition states in the respective years. 
# we will instead plot the possibility for a condition 1 occurring, as it would indicate some degree of deterioation 
# this could then be used to gain information for potential repair work in the future
# as an example, doing it only for the abutments

bridges_conditions.abutment.1 <- subset(bridges_conditions.abutment, bridges_conditions.abutment$condition == 1)

# for year 1 
m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = bridges.noNA, lng= ~longitude, lat= ~latitude, popup= paste(bridges.noNA$Name, bridges_conditions.abutment.1$bridge_part, bridges_conditions.abutment.1$year_1))
m


# if we now want to see how this part would develop in 5 years, we can also plot this
# for year 6 
m <- leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = bridges.noNA, lng= ~longitude, lat= ~latitude, popup= paste(bridges.noNA$Name, bridges_conditions.abutment.1$bridge_part, bridges_conditions.abutment.1$year_6))
m

# this code for the map can be copied for the respective years we want to see the state of the abutments in 