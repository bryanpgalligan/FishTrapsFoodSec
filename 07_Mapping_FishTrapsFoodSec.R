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
##    05 PCA Analysis
##    06 Additional Analysis
##    07 Mapping

## Script Title:
##    07 Mapping

## Last update: 9 May 22

# This script creates a map of study sites

## Script TOC:
##    7.1 Packages and data




##### 7.1 Packages and data #####

# Load packages
library(readr)
library(ggplot2)
library(ggOceanMapsData)
library(ggOceanMaps)

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")




##### 7.2 Make basemap #####

# Basemap
basemap(limits = c(39, 42, -5, -1)) +
  labs(x = "", y = "", title = "")

# Save map
ggsave("07_Mapping_Out/Fig2_FishTrapsMap.jpeg", device = "jpeg")

unique(RawData$Site)




unique(RawData$SPECIES)




