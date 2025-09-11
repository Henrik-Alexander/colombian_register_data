########################################
# Project: Subnational birth squeezes #
# Purpose: Clean columbia data        #
# Author: Henrik-Alexander Schubert   #
# E-mail: schubert@demogr.mgp.de      #
# Date: 05.06.2024                    #
#######################################

# Load the packages
library(xlsx)
library(tidyverse)
library(data.table)

# Functions ----------------------------------------------

clean_labels <- function(col_names) {
  gsub(" ", "_", str_to_lower(col_names))
}

# Reset the department of birth
reset_code_dpto <- function (dpto) {
  dpto <- make_2digit(dpto)
  dpto[dpto == "05" | dpto == "0 5"] <- "Antioquia"
  dpto[dpto == "08" | dpto == "0 8"] <- "Atlántico"
  dpto[dpto == "08"] <- "Atlántico"
  dpto[dpto == "11"] <- "Bogotá"
  dpto[dpto == "13"] <- "Bolivar"
  dpto[dpto == "15"] <- "Boyaca"
  dpto[dpto == "17"] <- "Caldas"
  dpto[dpto == "18"] <- "Caqueta"
  dpto[dpto == "19"] <- "Cauca"
  dpto[dpto == "20"] <- "Cesar"
  dpto[dpto == "23"] <- "Cordoba"
  dpto[dpto == "25"] <- "Cundinamarca"
  dpto[dpto == "27"] <- "Choco"
  dpto[dpto == "41"] <- "Huila"
  dpto[dpto == "44"] <- "La guajira"
  dpto[dpto == "47"] <- "Magdalena"
  dpto[dpto == "50"] <- "Meta"
  dpto[dpto == "52"] <- "Nariño"
  dpto[dpto == "54"] <- "Norte de Santander"
  dpto[dpto == "63"] <- "Quindio"
  dpto[dpto == "66"] <- "Risaralda"
  dpto[dpto == "68"] <- "Santander"
  dpto[dpto == "70"] <- "Sucre"
  dpto[dpto == "73"] <- "Tolima"
  dpto[dpto == "76"] <- "Valle del Cauca"
  dpto[dpto == "81"] <- "Arauca"
  dpto[dpto == "85"] <- "Casanare"
  dpto[dpto == "86"] <- "Putumayo"
  dpto[dpto == "88"] <- "Archipelago of San Andrés, Providencia and Santa Catalina"
  dpto[dpto == "91"] <- "Amazonas"
  dpto[dpto == "94"] <- "Guainía"
  dpto[dpto == "95"] <- "Guaviare"
  dpto[dpto == "97"] <- "Vaupés"
  dpto[dpto == "99"] <- "Vichada"
  return(dpto)
}

# Translate the header
translate_header <- function(header) {
  header[header == "hombres"] <- "males"
  header[header == "mujeres"] <- "female"
  header[header == "grupos_de_edad"] <- "age_group"
  return(header)
}

# Make to two digit
make_2digit <- function(variable) {
  ifelse(nchar(variable) == 1, paste("0", variable), as.character(variable))
}

# 1. Load the headers -------------------------------------

header <- clean_labels(as.character(read.xlsx(list.files("pop", pattern = ".xls", full.names = T), 
          sheetIndex = 1, header = FALSE, startRow = 11, endRow = 11)))
header <- translate_header(header)
header[3:length(header)] <- paste(header[3:length(header)], rep(1985:2020, each = 3), sep = "_")

# 2. Load the data ---------------------------------------

# Load the population data in buckets
length_bucket <- 16
start_index <- 14
start_indices <- start_index + (length_bucket + 3) * 0:33

# Get the containers
pop_col <- vector("list", length = length(start_indices))

# Load the data
for (i in seq_along(start_indices)) {
  
    cat("Iteration:", i, "\n")

  # Get the region
  region <- read.xlsx(list.files("pop", pattern = ".xls", full.names = T), 
                   sheetIndex = 1, header = FALSE, startRow = start_indices[i] - 2, endRow = start_indices[i] - 2)[[1]]
  region <- reset_code_dpto(region)
  
  # Load the data
  pop <- read.xlsx(list.files("pop", pattern = ".xls", full.names = T), 
                   sheetIndex = 1, header = FALSE, startRow = start_indices[i], endRow = start_indices[i] + (length_bucket + 3))
  
  # Attach the region
  names(pop) <- header
  pop$region <- region
  
  # Pivot longer
  pop <- pivot_longer(pop, cols = matches("_[0-9]+$"), names_pattern = "(.*)_(.*)", names_to = c("sex", "year"), values_to = "pop")
  
  # Remove the first column
  pop <- pop[, !(names(pop) == "codigo")]
  
  # Attach the result
  pop_col[[i]] <- pop

}

# Combine the population data
pop_col <- rbindlist(pop_col)

# Remove missings
pop_col <- pop_col[!is.na(pop)]

# Make year numeric
pop_col[, year := as.numeric(year)]

# Save the data
save(pop_col, file = "pop/population_columbia.Rda")

### END ####################################