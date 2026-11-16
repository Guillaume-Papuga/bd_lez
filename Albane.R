



# 01. ------------------------------------------------------------------------------
# LIBRARIES AND PATHS DEFINITION  ------------------------------------------------------------------------------
# -> loads libraries for all scripts 
# -> defines paths to locate input data and write output files 
# -> defines date variable for automatic dating of files 
## Path ------------------------------------------------------------------------------
dir <- getwd()
p.raw.data <- file.path(paste0(dir, "/data/raw"))
p.proc.data <- file.path(paste0(dir, "/data/processed"))

## Libraries ------------------------------------------------------------------------------
packages = c("tidyverse" # packages' collection for data manipulation 
             # ""
) 
source(file = file.path(paste0(dir, "/03.functions.R")))

# 03   ------------------------------------------------------------------------------
# FUNCTIONS  ------------------------------------------------------------------------------
## Packages ------------------------------------------------------------------------------
#used in 01.R Package checking 
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE)
      library(x, character.only = TRUE)
    }
  }
)
# data loading -----------------------------------------------------------------
# used in 10.R: lastest version of processed data for lutra lutra  
get_latest_lutra <- function(path) {# creates the list of all files matching the pattern in path
  files <- list.files(
    path,
    pattern = "lutra_processed_\\d{4}-\\d{2}-\\d{2}\\.csv$",# date definition pattern
    full.names = TRUE
  )
  
  if (length(files) == 0) { # error message if the pattern does not match 
    stop("No file found.")
  }
  
  dates <- as.Date( # substracts the basename of the files to only keep the dates
    sub(".*lutra_processed_(\\d{4}-\\d{2}-\\d{2})\\.csv", "\\1", basename(files))
  ) 
  
  files[which.max(dates)] # keeps the latest date/version of the file 
}

# used in 10.R: lastest version of processed data for Myocastor coypus
get_latest_coypus <- function(path) {# creates the list of all files matching the pattern in path
  files <- list.files(
    path,
    pattern = "coypus_processed_\\d{4}-\\d{2}-\\d{2}\\.csv$",# date definition pattern
    full.names = TRUE
  )
  
  if (length(files) == 0) { # error message if the pattern does not match 
    stop("No file found.")
  }
  
  dates <- as.Date( # substracts the basename of the files to only keep the dates
    sub(".*coypus_processed_(\\d{4}-\\d{2}-\\d{2})\\.csv", "\\1", basename(files))
  ) 
  
  files[which.max(dates)] # keeps the latest date/version of the file 
}

# 01.(suite)------------------------------------------------------------------------------
## date ------------------------------------------------------------------------------
# Time stamps for files' name 
date <- today()

## Processed data loading -------------------------------------------------------
# Call to latest processed data function 
# -> maybe we do it here to not have to do it in every script 
latest.lutra <- get_latest_lutra(p.proc.data) 
data_lutra <- read.csv(file = file.path(latest.lutra))

latest.coypus <- get_latest_coypus(p.proc.data) 
data_coypus <- read.csv(file = file.path(latest.coypus))

# ==============================================================================
# 02.
# DATA PROCESSING : 
# -> reads raw data and makes modifications to create processed data  
# -> saves processed data in /DATA/PROCESSED 
# ------------------------------------------------------------------------------

if (exists("data_lutra") & exists("data_coypus") ==F) {
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
}
