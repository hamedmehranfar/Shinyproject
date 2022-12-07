# This script is made to make the data ready to use in the report
# This block is dedicated to processing the deterioration data
#______________________________________________________________

# Data_Input 

location <- dirname(rstudioapi::getActiveDocumentContext()$path)
bridge_data <- read_excel(paste(location, "Data", "ZolBgg-xmp.xlsx", sep = "/"), sheet = "CsEvo")

# Update the header with the corrected year
#_______________________________________________________
# Number of years we want to do the prediction for
n_years <- 15

# Prediction period
vec_year <- c((year(today())):(year(today())+n_years-1))

# Update the headers
colnames(bridge_data)[6:20] <- vec_year
rm (vec_year)
#______________________________________________________
#Preparing data for the bar plot

# Getting the current condition state of the components
current_condition <- t(bridge_data[,"CS"]) * bridge_data[,as.character(year(today()))]

# Making a subset of data to show the condition states in the first year 
components <- bridge_data[which(current_condition!=0), c(1:5)]