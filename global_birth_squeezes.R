### 
# Project: Global bith squeezes
# Purpose:


library(data.table)

# Load the data =================================

load("pop/population_columbia.Rda")

# 0. Clean the TFR data =========================

# Load the TFR data
tfr_col_reg <- fread("tfr_regional.csv")
tfr_col_nat <- fread("tfr_national.csv")

# Clean the TFR data
tfr_col_nat <- tfr_col_nat[, .(region="00", year, tfr_male, tfr_female, tfr_ratio) ]
tfr_col_reg <- tfr_col_reg[, .(region, year, tfr_male, tfr_female, tfr_ratio) ]

# Bind the data
tfr_col <- rbindlist(list(tfr_col_nat, tfr_col_reg))

# 1. Estimate the sex ratio age 20-30 ===========

# Reshape the data into wide formal
pop_col <- dcast(pop_col, age_group + region + year ~ sex, value.var="pop", fun.aggregate=sum)

# Filter the age groups
pop_col_adult <- pop_col[age_group%in% c("20-24", "25-29"), ]

# Aggregate the data
pop_col_adult <- pop_col[, .(asr=sum(males)/sum(female), males=sum(males), females=sum(female)), by=.(region, year)]

# 2. Combine TFR and Sexratio data ==============

# Combine the data
fert_colombia <- merge(pop_col_adult, tfr_col, by=c("region", "year"))

# Save the data
save(fert_colombia, file="U:/projects/37_global_birth_squeezes/data/fertility_colombia.Rda")

## END ##########################################