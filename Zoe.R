###################################
#           SCRIPT 01             #
#     Created the 10/11/2026      #
###################################

# SETTINGS ---------------------------------------------------------------------
## Set the path ----------------------------------------------------------------
dir <- getwd()
p.raw.data <- file.path(paste0(dir, "/data/raw"))
p.proc.data <- file.path(paste0(dir, "/data/processed"))

##Packages ---------------------------------------------------------------------
  # Packages to manipulate data
library("dplyr") #data manipulations
library("lubridate") #date manipulations
  
  # Packages to do beautiful figures
  ##Graphics
library("ggplot2") 


## Time stamps for files' name -------------------------------------------------
today <- today()


## Load data -------------------------------------------------------------------
lutra <- read.csv(file.path(paste0(dir, "/data/raw/lutra_presence.csv")), header = T, sep = ",", dec = ".") #raw data lutra
coypus <- read.csv(file.path(paste0(dir, "/data/raw/coypus_presence.csv")), header = T, sep = ";", dec = ".") #raw data coypus

# DATA EXPLORATION
lutra
coypus
