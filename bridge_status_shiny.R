
####################################################################
### Calculation of working hours, concrete use and CO2 emissions ###
####################################################################

### packages ###

library(readxl)
library(dplyr)
library(data.table)
library(ggplot2)

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


# Each imaginary input has the following prices 

working_hour_price <- 30   # CHF/hour

concrete_price <- 20       # CHF/tonne

CO2_emissions <- 50        # CHF/tonne



##################################
##################################


# Construction requirements and cots for each bridge 


bridge_construction <- bridge_status[,c(1,18:31)]


# Calculation of input requirements of each bridge

# plot 1: working hours

bridge_construction_hours <- bridge_construction %>% 
  mutate_at(vars(constr_year1:constr_year14),
            .funs = funs(. * 1000))


bridge_construction_hours <- setnames(bridge_construction_hours, 
         old = c('constr_year1','constr_year2','constr_year3','constr_year4','constr_year5','constr_year6',
                 'constr_year7','constr_year8','constr_year9','constr_year10','constr_year11','constr_year12',
                 'constr_year13','constr_year14'), 
         new = c('hours_y1','hours_y2','hours_y3','hours_y4','hours_y5','hours_y6',
                 'hours_y7','hours_y8','hours_y9','hours_y10','hours_y11','hours_y12',
                 'hours_y13','hours_y14'))


bridge_construction_hours1 <- melt(setDT(bridge_construction_hours), id.vars = c("MixName"))

 


# plot 2: costs for working hours

bridge_construction_hours_costs <- bridge_construction_hours %>% 
  mutate_at(vars(hours_y1:hours_y14),
            .funs = funs(. * 30))


setnames(bridge_construction_hours_costs, 
         old = c('hours_y1','hours_y2','hours_y3','hours_y4','hours_y5','hours_y6',
                 'hours_y7','hours_y8','hours_y9','hours_y10','hours_y11','hours_y12',
                 'hours_y13','hours_y14'), 
         new = c('costs_hours_y1','costs_hours_y2','costs_hours_y3','costs_hours_y4','costs_hours_y5','costs_hours_y6',
                 'costs_hours_y7','costs_hours_y8','costs_hours_y9','costs_hours_y10','costs_hours_y11','costs_hours_y12',
                 'costs_hours_y13','costs_hours_y14'))




# plot 3: concrete use 

bridge_construction <- bridge_status[,c(1,18:31)]

bridge_construction_concrete <- bridge_construction %>% 
  mutate_at(vars(constr_year1:constr_year14),
            .funs = funs(. * 1000))


setnames(bridge_construction_concrete, 
         old = c('constr_year1','constr_year2','constr_year3','constr_year4','constr_year5','constr_year6',
                 'constr_year7','constr_year8','constr_year9','constr_year10','constr_year11','constr_year12',
                 'constr_year13','constr_year14'), 
         new = c('concrete_y1','concrete_y2','concrete_y3','concrete_y4','concrete_y5','concrete_y6',
                 'concrete_y7','concrete_y8','concrete_y9','concrete_y10','concrete_y11','concrete_y12',
                 'concrete_y13','concrete_y14'))



# plot 4: costs for concrete use

bridge_construction_concrete_costs <- bridge_construction_concrete %>% 
  mutate_at(vars(concrete_y1:concrete_y14),
            .funs = funs(. * 20))


setnames(bridge_construction_concrete_costs, 
         old = c('concrete_y1','concrete_y2','concrete_y3','concrete_y4','concrete_y5','concrete_y6',
                 'concrete_y7','concrete_y8','concrete_y9','concrete_y10','concrete_y11','concrete_y12',
                 'concrete_y13','concrete_y14'), 
         new = c('costs_concrete_y1','costs_concrete_y2','costs_concrete_y3','costs_concrete_y4','costs_concrete_y5','costs_concrete_y6',
                 'costs_concrete_y7','costs_concrete_y8','costs_concrete_y9','costs_concrete_y10','costs_concrete_y11','costs_concrete_y12',
                 'costs_concrete_y13','costs_concrete_y14'))




