
####################################################################
### Calculation of working hours, concrete use and CO2 emissions ###
####################################################################

# Second Step: Illustration of the annual input demand through gg-plot

# Through our application, we offer a easy construction planning possibility to distribute the working efforts over an observation period.

### packages ###

library(readxl)
library(dplyr)
library(data.table)
library(ggplot2)
library(tidyr)
library(shiny)



### Data_Input ### 

setwd("C:/Users/schmitt_j/Desktop/Shinyproject/Shinyproject")


load("C:/Users/schmitt_j/Desktop/Shinyproject/Shinyproject/bridge_status.Rda")




# plot annual construction for all bridges in total throughout the observation period


bridge_status_sum_plot <- bridge_status[1,c(1,32:45)]


bridge_status_plot_long <- melt(setDT(bridge_status_sum_plot), id.vars = c("MixName"))


bridge_status_plot_long$year <- c(1,2,3,4,5,6,7,8,9,10,11,12,13,14)


construction_time <- ggplot(bridge_status_plot_long, aes(x=year, y=value)) + geom_point()


##################################
##################################

# Definition of input use for construction activities:

# Each "construction unit" requires the following imaginary inputs 

working_hours <- 1000 # hours

concrete_use <- 5000  # tonnes

CO2_emissions <- 2000 # tonnes



##################################
##################################


# Construction requirements and cots for each bridge 


bridge_construction_hours <- bridge_status[,c(1,18:31)]


# Calculation of input requirements of each bridge

# plot 1: working hours

bridge_construction_hours <- bridge_construction_hours %>% 
  mutate_at(vars(constr_year1:constr_year14),
            .funs = funs(. * 1000))


bridge_construction_hours <- setnames(bridge_construction_hours, 
         old = c('constr_year1','constr_year2','constr_year3','constr_year4','constr_year5','constr_year6',
                 'constr_year7','constr_year8','constr_year9','constr_year10','constr_year11','constr_year12',
                 'constr_year13','constr_year14'), 
         new = c('y1','y2','y3','y4','y5','y6',
                 'y7','y8','y9','y10','y11','y12',
                 'y13','y14'))


hours_long <- gather(bridge_construction_hours, year, Working_Hours, y1:y14, factor_key=TRUE)


hours_plot <- ggplot(data=hours_long, aes(x=year, y=Working_Hours, group=MixName)) +
  geom_line() + ggtitle("Annual construction working hours by bridge")  + theme(plot.title = element_text(hjust = 0.5))




# plot 2: concrete use 

bridge_construction_concrete <- bridge_status[,c(1,18:31)]

bridge_construction_concrete <- bridge_construction_concrete %>% 
  mutate_at(vars(constr_year1:constr_year14),
            .funs = funs(. * 1000))


setnames(bridge_construction_concrete, 
         old = c('constr_year1','constr_year2','constr_year3','constr_year4','constr_year5','constr_year6',
                 'constr_year7','constr_year8','constr_year9','constr_year10','constr_year11','constr_year12',
                 'constr_year13','constr_year14'), 
         new = c('y1','y2','y3','y4','y5','y6',
                 'y7','y8','y9','y10','y11','y12',
                 'y13','y14'))

concrete_long <- gather(bridge_construction_concrete, year, Concrete_Use, y1:y14, factor_key=TRUE)


concrete_plot <- ggplot(data=concrete_long, aes(x=year, y=Concrete_Use, group=MixName)) +
  geom_line() + ggtitle("Annual concrete use by bridge")  + theme(plot.title = element_text(hjust = 0.5))





# plot 3: CO2 

bridge_construction_co2 <- bridge_status[,c(1,18:31)]

bridge_construction_co2 <- bridge_construction_co2 %>% 
  mutate_at(vars(constr_year1:constr_year14),
            .funs = funs(. * 2000))


setnames(bridge_construction_co2, 
         old = c('constr_year1','constr_year2','constr_year3','constr_year4','constr_year5','constr_year6',
                 'constr_year7','constr_year8','constr_year9','constr_year10','constr_year11','constr_year12',
                 'constr_year13','constr_year14'), 
         new = c('y1','y2','y3','y4','y5','y6',
                 'y7','y8','y9','y10','y11','y12',
                 'y13','y14'))

co2_long <- gather(bridge_construction_co2, year, Concrete_Use, y1:y14, factor_key=TRUE)


co2_plot <- ggplot(data=co2_long, aes(x=year, y=Concrete_Use, group=MixName)) +
  geom_line() + ggtitle("Annual CO2 emissions during construction by bridge")  + theme(plot.title = element_text(hjust = 0.5))



