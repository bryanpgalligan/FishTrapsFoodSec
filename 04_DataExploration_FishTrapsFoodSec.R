##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Maxwell Kodia Azali (WCS)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning
##    02 Adding Life History Values Using FishLife
##    03 Calculating Functional Diversity Indices
##    04 Data Exploration

## Script Title:
##    04 Data Exploration

## Last update: 18 Apr 22

# This script explores the data to avoid common statistical errors, following the procedures
# outlined by Zuur et al. (2010).

## Script TOC:
##    4.1 Load packages and data




##### 4.1 Load packages and data #####

# Load packages
library(readr)
library(ggplot2)

# Load data
TripData <- read_csv("03_FunctionalDiversity_Out/TripData_GatedTraps_Galligan.csv",
  col_types = cols(...1 = col_skip()))
SpeciesData <- read_csv("02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv")
CatchData <- read_csv("02_FishLife_Out/CatchData_GatedTraps_Galligan.csv")




##### 4.2 Outliers #####

# CPUE_kgPerTrap
ggplot(data = TripData, mapping = aes(x = TrapType, y = CPUE_kgPerTrap)) +
  geom_boxplot()

# Remove all trips with CPUE greater than 50 kg per trap
TripData_NoOutliers <- subset(TripData, TripData$CPUE_kgPerTrap <= 50)

# CPUE with outliers removed
ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = CPUE_kgPerTrap)) +
  geom_boxplot()

# MTC_degC
ggplot(data = TripData, mapping = aes(x = TrapType, y = MTC_degC)) +
  geom_boxplot()

TripData_Cold <- subset(TripData, TripData$MTC_degC <= 20)








