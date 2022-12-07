
####################################################################
### Calculation of working hours, concrete use and CO2 emissions ###
####################################################################




### packages ###

library(readxl)
library(dplyr)
library(data.table)

### Data_Input ### 


location <- dirname(rstudioapi::getActiveDocumentContext()$path)

setwd("C:/Users/schmitt_j/Desktop/Shinyproject/Shinyproject")


bridge_data <- read_excel(paste(location, "Data", "ZolBgg-xmp.xlsx", sep = "/"), sheet = "CsEvo")


### Definition of input use per unit of bridge improvement ###

working_hours <- 1000

concrete_use <- 5000

CO2_emissions <- 7000


### rename year columns ###

colnames(bridge_data)[6]  <- "year1"
colnames(bridge_data)[7]  <- "year2"
colnames(bridge_data)[8]  <- "year3"
colnames(bridge_data)[9]  <- "year4"
colnames(bridge_data)[10] <- "year5"
colnames(bridge_data)[11] <- "year6"
colnames(bridge_data)[12] <- "year7"
colnames(bridge_data)[13] <- "year8"
colnames(bridge_data)[14] <- "year9"
colnames(bridge_data)[15] <- "year10"
colnames(bridge_data)[16] <- "year11"
colnames(bridge_data)[17] <- "year12"
colnames(bridge_data)[18] <- "year13"
colnames(bridge_data)[19] <- "year14"
colnames(bridge_data)[20] <- "year15"


### Pre-Step: Calculation of annual status --> value for different qualities each year ###

options(digits=3)

bridge_data$year1 <- bridge_data$year1 * bridge_data$CS
bridge_data$year2 <- bridge_data$year2 * bridge_data$CS
bridge_data$year3 <- bridge_data$year3 * bridge_data$CS
bridge_data$year4 <- bridge_data$year4 * bridge_data$CS
bridge_data$year5 <- bridge_data$year5 * bridge_data$CS
bridge_data$year6 <- bridge_data$year6 * bridge_data$CS
bridge_data$year7 <- bridge_data$year7 * bridge_data$CS
bridge_data$year8 <- bridge_data$year8 * bridge_data$CS
bridge_data$year9 <- bridge_data$year9 * bridge_data$CS
bridge_data$year10 <- bridge_data$year10 * bridge_data$CS
bridge_data$year11 <- bridge_data$year11 * bridge_data$CS
bridge_data$year12 <- bridge_data$year12 * bridge_data$CS
bridge_data$year13 <- bridge_data$year13 * bridge_data$CS
bridge_data$year14 <- bridge_data$year14 * bridge_data$CS
bridge_data$year15 <- bridge_data$year15 * bridge_data$CS



### Calculation of annual status of each bridge ###

bridge_status <- bridge_data %>% 
  group_by(MixName) %>% 
  summarise(across(year1:year15, sum))


### Diff of each year to detect construction work ###

bridge_status <- bridge_status %>% 
  mutate(constr_year1 = if_else(year2 < year1,
                              year1 - year2,0))

bridge_status <- bridge_status %>% 
  mutate(constr_year2 = if_else(year3 < year2,
                                year2 - year3,0))

bridge_status <- bridge_status %>% 
  mutate(constr_year3 = if_else(year4 < year3,
                                year3 - year4,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year4 = if_else(year5 < year4,
                                year4 - year5,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year5 = if_else(year6 < year5,
                                year5 - year6,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year6 = if_else(year7 < year6,
                                year6 - year7,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year7 = if_else(year8 < year7,
                                year7 - year8,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year8 = if_else(year9 < year8,
                                year8 - year9,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year9 = if_else(year10 < year9,
                                year9 - year10,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year10 = if_else(year11 < year10,
                                year10 - year11,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year11 = if_else(year12 < year11,
                                year11 - year12,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year12 = if_else(year13 < year12,
                                year12 - year13,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year13 = if_else(year14 < year13,
                                year13 - year14,0))


bridge_status <- bridge_status %>% 
  mutate(constr_year14 = if_else(year15 < year14,
                                year14 - year15,0))



### construction sum per year ###

bridge_status$year1_sum <- sum(bridge_status$constr_year1)
bridge_status$year2_sum <- sum(bridge_status$constr_year2)
bridge_status$year3_sum <- sum(bridge_status$constr_year3)
bridge_status$year4_sum <- sum(bridge_status$constr_year4)
bridge_status$year5_sum <- sum(bridge_status$constr_year5)
bridge_status$year6_sum <- sum(bridge_status$constr_year6)
bridge_status$year7_sum <- sum(bridge_status$constr_year7)
bridge_status$year8_sum <- sum(bridge_status$constr_year8)
bridge_status$year9_sum <- sum(bridge_status$constr_year9)
bridge_status$year10_sum <- sum(bridge_status$constr_year10)
bridge_status$year11_sum <- sum(bridge_status$constr_year11)
bridge_status$year12_sum <- sum(bridge_status$constr_year12)
bridge_status$year13_sum <- sum(bridge_status$constr_year13)
bridge_status$year14_sum <- sum(bridge_status$constr_year14)


### plot annual construction ###

bridge_status_plot <- bridge_status[1,c(1,31:44)]


bridge_status_plot_long <- melt(setDT(bridge_status_plot), id.vars = c("MixName"))


bridge_status_plot_long$year <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)

plot(bridge_status_plot_long$year, bridge_status_plot_long$value)













