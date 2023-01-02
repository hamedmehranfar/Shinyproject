# This script is written to ensure all-
# prerequisite materials are loaded to the system.

#__________________________________
# Adjust the program according to the platform
library("parallel")
sys_pltform <- R.version$os
if (sys_pltform == "linux-gnu") {
  n_core <- (detectCores() - 1)
  cat("Perfect! You are running the code on Linux to get the best performance!")
} else {
  n_core <- 1
  cat("This program works the best on Linux machines\n")
}
#__________________________________
# Loading the required packages

# List the required packages in here

pkg_list <- c("plotly", "shiny","lubridate","dplyr","echarts4r","viridisLite"
              ,"jsonlite", "leaflet", "sp", "readxl"
              )

# Check and install the packages and free the storage afterwards
dum <- mclapply(pkg_list, library, character.only = TRUE, mc.cores = n_core)
rm(pkg_list)
cat("Required packages are succecfully loaded!\n")

#_____________________________________
# This functions enables running all "sapply()"  in a parallel mode

mcsapply <- function(X, FUN, ..., simplify = TRUE, USE.NAMES = TRUE,
                     mc.preschedule = TRUE,mc.set.seed = TRUE, mc.silent = FALSE,
                     mc.cores = n_core,mc.cleanup = TRUE,
                     mc.allow.recursive = TRUE, affinity.list = NULL)
{
  answer <- mclapply(X = X, FUN = FUN, ...,mc.preschedule = mc.preschedule, 
                     mc.set.seed = mc.set.seed, mc.silent = mc.silent,
                     mc.cores = mc.cores, mc.cleanup = mc.cleanup,
                     mc.allow.recursive = mc.allow.recursive,
                     affinity.list = affinity.list)
  
  if (USE.NAMES && is.character(X) && is.null(names(answer))) 
    names(answer) <- X
  if (!isFALSE(simplify) && length(answer)) 
    simplify2array(answer, higher = (simplify == "array"))
  else answer
}
cat("The initialisation was succeccful!\n")

