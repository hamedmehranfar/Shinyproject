
###################################################################
### Estimation of working hours, concrete use and CO2 emissions ###
###################################################################

# We prepare the dataset for the estimation of input use demand and a more effective construction planing.

# First, we calculate the annual 'status' of each bridge in each year.
# Second, we create a shiny app for bridge constructors to enable them to distribute the working efforts over the whole observation period.

# Through our work, we offer a tool for construction managers that they can distribute the input demand during a certain time-frame.
# Right now, all construction is accumulated in the years 10 and 11, which is quite unrealistic.

# First, construction companies probably do not have the work force to construction more than 100 bridges in the same year.
# Second, it would be really problematic for the people who actually need to use the highway to go to work etc, because the highway would be one big construction side.

# Hence, distributing the construction effforts smoothly throughout the year would have both advantages for construction companies and highway users.


# First step: Data-Pretationen (R-File: Input_Use_Construction.R)

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






