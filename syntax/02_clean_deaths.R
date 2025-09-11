########################################
# Project: Subnational birth squeezes #
# Purpose: Clean columbia data        #
# Author: Henrik-Alexander Schubert   #
# E-mail: schubert@demogr.mgp.de      #
# Date: 05.06.2024                    #
#######################################

# Load the packages
library(tidyverse)
library(data.table)
library(haven)

# Graphics
theme_set(theme_bw(base_size = 16, base_family = "serif"))

# Functions --------------------------------

#
# Make to two digit
make_2digit <- function(variable) {
  ifelse(nchar(variable) == 1, paste("0", variable), as.character(variable))
}

#
clean_age_variable <- function(age){
  age[age == "00"] = "Less than one hour"
  age[age == "01"] = "Less than one day"
  age[age == "02"] = "From 1 to 6 days"
  age[age == "03"] = "From 7 to 27 days"
  age[age == "04"] = "From 28 to 29 days"
  age[age == "05"] = "From 1 to 5 months"
  age[age == "06"] = "From 6 to 11 months"
  age[age == "07"] = "From 1 year"
  age[age == "08"] = "From 2 to 4 years"
  age[age == "09"] = "From 5 to 9 years"
  age[age == "10"] = "From 10 to 14 years"
  age[age == "11"] = "From 15 to 19 years"
  age[age == "12"] = "From 20 to 24 years"
  age[age == "13"] = "From 25 to 29 years"
  age[age == "14"] = "From 30 to 34 years"
  age[age == "15"] = "From 35 to 39 years"
  age[age == "16"] = "From 40 to 44 years"
  age[age == "17"] = "From 45 to 49 years"
  age[age == "18"] = "From 50 to 54 years"
  age[age == "19"] = "From 55 to 59 years"
  age[age == "20"] = "From 60 to 64 years"
  age[age == "21"] = "From 65 to 69 years"
  age[age == "22"] = "From 70 to 74 years"
  age[age == "23"] = "From 75 to 79 years"
  age[age == "24"] = "From 80 to 84 years" 
  age[age == "25"] = "From 85 to 89 years"
  age[age == "26"] = "From 90 to 94 years"
  age[age == "27"] = "From 95 to 99 years"
  age[age == "28"] = "100 years and older"
  age[age == "29"] = NA
  return(factor(age))
}

# Reproductive ages
repro_ages <- c("From 15 to 19 years", "From 20 to 24 years", "From 25 to 29 years", 
                "From 30 to 34 years",  "From 35 to 39 years",  "From 40 to 44 years", 
                "From 45 to 49 years", "From 50 to 54 years",  "From 55 to 59 years")

# Clean the manner of death
manner_of_deaths <- c("p_pman_iris", "man_muer")

# Reset the department of birth
reset_code_dpto <- function (dpto) {
  dpto <- make_2digit(dpto)
  dpto[dpto == "05" | dpto == "0 5"] <- "Antioquia"
  dpto[dpto == "08" | dpto == "0 8"] <- "Atlántico"
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


# Clean names function
clean_names <- function(string){
  gsub(" ", "_", tolower(string))
}

# Clean the data ---------------------------

# List the death files
files <- list.files("deaths", pattern = ".sav", full.names = T)

# Create a container
deaths <- vector("list", length = length(files))

# Clean the data sets
for (i in seq_along(files)) {
  
    cat("Iteration:", i, "\n")
  
  # Load the data
  df <- read_sav(files[i])
  
  # Clean the names
  names(df) <- clean_names(names(df))
  
  # Select the names
  old_names <- c("cod_dpto", "ano", "sexo", "gru_ed1")
  
  # Year
  if (i < 20){
    df <- df[, c(old_names, manner_of_deaths[2])]
    df$homicide <- ifelse(as.numeric(df$man_muer) %in% 2, 1, 0)
  } else {
    df <- df[, c(old_names, manner_of_deaths[1])]
    df$homicide <- ifelse(as.numeric(df$p_pman_iris) %in% c(8, 9), 1, 0)
  }
  
  
  # Rename the columns
  df <- rename(df, region = cod_dpto, year = ano, 
               sex = sexo, age_group = gru_ed1)
  
  # Clean the region variable
  df$region <- reset_code_dpto(df$region)
  
  # Clean the age variable
  df$age_group <- clean_age_variable(df$age_group)
  df$death <- 1
  
  # Clean year variable 
  df$year <- as.numeric(df$year)
  
  # Filter men and women
  df <- df[df$sex != "3", ]
  df$sex <- ifelse(df$sex == "1", "male", "female")
  
  # Aggregate the data
  df <- aggregate(death ~ sex + age_group + region + homicide + year, data = df, FUN = sum)
  
  # Assign the results
  deaths[[i]] <- df

}


# Combine the data
deaths <- rbindlist(deaths)

# Estimate the total counts -> accounting for late registration
deaths[, death := sum(death), by = .(sex, age_group, year, region, homicide)]

# Select only individuals at reproductive age
deaths <- deaths[age_group %in% repro_ages,]

# Estimate the age-specific homicide rate
hom_rate <- deaths[, .(homicide_rate = sum(homicide * death) / sum(death)), by = .(sex, region, year)]
hom_rate[, expected_rate := mean(homicide_rate) +  sd(homicide_rate), by = .(sex, year)]

# Select men
hom_rate <- hom_rate[sex == "male", ]
hom_rate[, weight := ifelse(expected_rate > homicide_rate, 1, homicide_rate / expected_rate)]
hom_rate <- hom_rate[, .(region, year, expected_rate, weight)]

# Plot the trend of homicide rates
ggplot(hom_rate, aes(x = year, y = weight)) +
  geom_hline(yintercept = 1, linewidth = 0.3) +
  geom_line(linewidth = 1.4) +
  facet_wrap(~ region) +
  theme(
    strip.background = element_blank(),
    strip.text = element_text(face = "bold", size = 15)
  )
ggsave(last_plot(), filename = "U:/projects/3 Regional birth squeezes/subnational_birth_squeezes/figures/col_war_conflict_weight.pdf")

# Save the war rates
save(hom_rate, file = "war_weights.Rda")

### END #################################