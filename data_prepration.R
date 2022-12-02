# This script is made to make the data ready to use in the report
# This block is dedicated to processing the deterioration data
#______________________________________________________________

# Data_Input 

library(readxl)
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