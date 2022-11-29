# This script is made to make the data ready to use in the report
# This block is dedicated to processing the deterioration data
#______________________________________________________________

# Data_Input 

library(readxl)
bridge_data <- read_excel(paste(location, "Data", "ZolBgg-xmp.xlsx", sep = "/"), sheet = "CsEvo")

# Update the header with the corrected year

