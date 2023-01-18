
####################################################################
### Calculation of working hours, concrete use and CO2 emissions ###
####################################################################




### packages ###

library(readxl)
library(dplyr)
library(data.table)
library(ggplot2)

### Data_Input ### 


location <- dirname(rstudioapi::getActiveDocumentContext()$path)

setwd("C:/Users/schmitt_j/Desktop/Shinyproject/Shinyproject")


bridge_data <- read_excel(paste(location, "Data", "ZolBgg-xmp.xlsx", sep = "/"), sheet = "CsEvo")


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


bridge_data <- bridge_data %>% mutate(across(year1:year15,~ .x*CS)) 


### number of observations per bridge ###


obs_per_bridge <- bridge_data %>% count(MixName)

bridge_data <- merge(bridge_data, obs_per_bridge)


### Calculation of annual status of each bridge ###

bridge_status <- bridge_data %>% 
  group_by(MixName) %>% 
  summarise(across(year1:year15, sum))

bridge_status <- merge(bridge_status, obs_per_bridge)


### Overall percentage value of bridge status ###

bridge_status_new <- bridge_status[,2:16]/bridge_status[,17]  


bridge_status <- cbind(bridge_status[,c(1,17)], bridge_status_new )


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


#######################
### save data frame ###
#######################

save(bridge_status,file="C:/Users/schmitt_j/Desktop/Shinyproject/Shinyproject/bridge_status.Rda")


### plot annual construction ###

bridge_status_sum_plot <- bridge_status[1,c(1,32:45)]


bridge_status_plot_long <- melt(setDT(bridge_status_sum_plot), id.vars = c("MixName"))


bridge_status_plot_long$year <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)


construction_time <- ggplot(bridge_status_plot_long, aes(x=year, y=value)) + geom_point()



##################################
##################################


### Construction scenario ###

### Overall sum of construction implementation ###


overall_construction <- sum(bridge_status_plot_long$value)



### Each "construction unit" requires the following imaginary inputs ###

working_hours <- 1000 # hours

concrete_use <- 5000  # tonnes

CO2_emissions <- 2000 # tonnes


### ### Each imaginary input has the following prices ###

working_hour_price <- 30   # CHF/hour

concrete_price <- 20       # CHF/tonne

CO2_emissions <- 50        # CHF/tonne




### Overall input use across all bridges and years ###

overall_working_hours <- overall_construction * working_hours

overall_concrete_use <- overall_construction * concrete_use

overall_CO2_emissions <- overall_construction * CO2_emissions



### Overall costs across all bridges and years ###

working_hours_costs <- overall_working_hours * 30

concrete_use_costs <- overall_concrete_use * 20

CO2_emissions_costs <- overall_CO2_emissions * 50



### Using dataset "bridge_status" to start with the worst bridge and go step by step 
### That would be a realistic scenario, because not all bridges can simultaneously be repaired in years 10 and 11 






