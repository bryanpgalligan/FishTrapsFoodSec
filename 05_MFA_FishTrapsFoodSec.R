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

## Script Title:
##    05 PCA Analysis

## Last update: 22 Apr 22

# This script analyzes the data using multiple factor analysis.

## Script TOC:



##### 5.1 Packages and data #####

# Load packages
library(ggplot2)
library(FactoMineR)
library(factoextra)
library(readr)

# NB: This trip data file has been processed to remove outliers that are likely the result of measurement
# error.

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")




##### 5.2 Data manipulation #####

# Convert TripData to a data frame so you can assign row names
TripData <- as.data.frame(TripData)

# Assign row names
rownames(TripData) <- TripData$TripID

# Delete now redundant TripID column
TripData <- TripData[,-1]

# Subset 







