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

## Last update: 17 May 22

# This script creates a map of study sites

## Script TOC:
##    7.1 Packages and data
##    7.2 Make map




##### 7.1 Packages and data #####

# Load packages
library(readr)
library(ggplot2)
library(ggOceanMapsData)
library(ggOceanMaps)

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")




##### 7.2 Make map #####

# Data frame of site locations
sites <- as.data.frame(unique(TripData$Site))
colnames(sites) <- "site"

# Add columns for lat and lon
sites$lat <- c(-4.00604923, NA, -4.05215875, -4.660707, NA, NA, NA, -4.48622, -4.454932,
  -4.343498, -3.292405, -4.179676, -3.955419)
sites$lon <- c(39.72754486, NA, 39.70645155, 39.219428, NA, NA, NA, 39.478735, 39.498806,
  39.566646, 40.116701, 39.631405, 39.757086)

# Map
basemap(limits = c(39, 41, -5, -3), land.col = "gray80") +
  labs(x = "", y = "", title = "") +
  geom_spatial_point(data = sites, aes(x = lon, y = lat))

# Save map
ggsave("07_Mapping_Out/Fig2_FishTrapsMap.jpeg", device = "jpeg")

unique(RawData$Site)




unique(RawData$SPECIES)




