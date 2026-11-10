# 01.
# LIBRARIES AND PATHS DEFINITION 
# -> loads libraries for all scripts 
# -> defines paths to locate input data and write output files 
# -> defines date variable for automatic dating of files 
# ------------------------------------------------------------------------------
# Path 
dir <- getwd()
p.raw.data <- file.path(paste0(dir, "/data/raw"))
p.proc.data <- file.path(paste0(dir, "/data/processed"))

# ------------------------------------------------------------------------------
# Libraries 
packages = c("tidyverse" # packages' collection for data manipulation 
             # ""
) 
# source(file = file.path(paste0(dir, "/03.functions.R")))

# ------------------------------------------------------------------------------
# Time stamps for files' name 
date <- today()

# ==============================================================================
# 02.
# DATA PROCESSING : 
# -> reads raw data and makes modifications to create processed data  
# -> saves processed data in /DATA/PROCESSED 
# ------------------------------------------------------------------------------

# Data Myocastor coypus  
data_coypus <- read.csv(file = file.path(paste0(p.raw.data, "/coypus_presence.csv")), # reading the data file 
                        sep = ";") # setting column separator 

data_coypus <- data_coypus %>% 
  # hamornizing the columns' names in between df 
  rename(human_disturbance = HD) %>% 
  # changing , to . to avoid NA and changing the columnn type 
  mutate(human_disturbance = as.numeric(gsub(",", ".", human_disturbance)))

data_coypus$specie <- "Myocastor coypus"

# Data Lutra lutra 
data_lutra <- read.csv(file = file.path(paste0(p.raw.data, "/lutra_presence.csv")), # reading the data file 
                       sep = "," # setting column separator 
                       , skip = 1 # skipping line one un-useful 
) 
data_lutra$specie <- "Lutra lutra"


# Saving data 
write.csv(data_lutra, file = file.path(paste0(p.proc.data, "/lutra_processed_", date,".csv")))
# saveRDS(data_lutra, file = file.path(paste0(p.proc.data, "/lutra_processed_", date,".RData")))

write.csv(data_coypus, file = file.path(paste0(p.proc.data, "/coypus_processed_", date,".csv")))
# save(data_coypus, file = file.path(paste0(p.proc.data, "/coypus_processed_", date,".RData")))

# ==============================================================================
# 03.
# FUNCTIONS 
# Package checking 
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)
