########################################
# Project: Subnational birth squeezes #
# Purpose: Clean columbia data        #
# Author: Henrik-Alexander Schubert   #
# E-mail: schubert@demogr.mgp.de      #
# Date: 06.06.2024                    #
#######################################

# Data website: https://microdatos.dane.gov.co/index.php/catalog/central/about
# Data stored under: Estadísticas Vitales


### This file runs and estimates the rates ---------------

# Install.packages
packages <- c("data.table", "tidyverse", "haven", "xlsx", "sf")
# install.packages(packages)

# Do you need to unzip the files
unzip_files <- FALSE

# 1. Unzip files
if (unzip_files) source("syntax/01_Unzip_files.R")

# 2. Clean the birth data (including age imputations)
source("02_clean_births.R")

# 3. Clean the population data
source("03_clean_pop_data.R")

# 4. Estimate the fertility rates
source("04_estimate_rates.R")

### END ####################################################