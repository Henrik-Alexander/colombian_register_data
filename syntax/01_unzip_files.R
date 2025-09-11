########################################
# Project: Subnational birth squeezes #
# Purpose: Unzip the birth files      #
# Author: Henrik-Alexander Schubert   #
# E-mail: schubert@demogr.mgp.de      #
# Date: 05.06.2024                    #
#######################################

# Get the zip file names
zips <- list.files("births/original", pattern = ".zip$")

# Unzip
for (zip in zips) {
  cat("File:", zip, "\n")
  unzip(zipfile = paste0("births/original/", zip), exdir = "births")
}

# Unzip the double zipped files
zips <- list.files("births", pattern = ".zip$")
for (zip in zips) {
  cat("File:", zip, "\n")
  unzip(zipfile = paste0("births/", zip), exdir = "births")
}


# Remove all the files that are not in SPSS format
lapply(list.files("births", pattern = ".dta", full.names = T), file.remove)
lapply(list.files("births", pattern = ".csv", full.names = T), file.remove)
lapply(list.files("births", pattern = ".zip", full.names = T), file.remove)
lapply(list.files("births", pattern = ".txt", full.names = T), file.remove)


## Unzip deaths -----------------------------

# Get the zip file names
zips <- list.files("deaths", pattern = ".zip$")

# Unzip
for (zip in zips) {
  cat("File:", zip, "\n")
  unzip(zipfile = paste0("deaths/original", zip), exdir = "deaths")
}

# Unzip the double zipped files
zips <- list.files("deaths", pattern = ".zip$")
for (zip in zips) {
  cat("File:", zip, "\n")
  unzip(zipfile = paste0("deaths/", zip), exdir = "deaths")
}


# Remove all the files that are not in SPSS format
lapply(list.files("deaths", pattern = ".dta", full.names = T), file.remove)
lapply(list.files("deaths", pattern = ".csv", full.names = T), file.remove)
lapply(list.files("deaths", pattern = ".zip", full.names = T), file.remove)
lapply(list.files("deaths", pattern = ".txt", full.names = T), file.remove)

### END ########################################