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

# This script analyzes the data using principal components methods.

## Script TOC:



##### 5.1 Packages and data #####

# Load packages
library(ggplot2)
library(FactoMineR)
library(factoextra)
library(readr)
library(missMDA)

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

# Subset only active and supplementary variables (columns) for the FAMD
df.famd <- TripData[, c("Site", "TrapType",
  "B.undulatus", "LowNoCatch",
  "ScraperMassRatio", "BrowserMassRatio", "GrazerMassRatio", "PredatorMassRatio",
  "CPUE_kgPerTrap", "CPUE_DistFromMean", "ValuePUE",
  "MeanLLmat", "MeanTrophLevel", "MeanVulnerability", "MTC_degC",
  "FRic", "FEve", "FDiv",
  "CaConc_mgPer100g", "CaPrice_KSHPermg",
  "FeConc_mgPer100g", "FePrice_KSHPermg",
  "Omega3Conc_gPer100g", "Omega3Price_KSHPerg",
  "ProteinConc_gPer100g", "ProteinPrice_KSHPerg",
  "VAConc_ugPer100g", "VAPrice_KSHPerug",
  "SeConc_ugPer100g", "SePrice_KSHPerug",
  "ZnConc_ugPer100g", "ZnPrice_KSHPerug")]

# Empty list of rows containing infinite values in df.famd
inf <- as.numeric(c())

# Fill in list of rows containing infinite values in df.famd
for(i in 1:ncol(df.famd)){
  
  # Vector of infinite values' indices (if any)
  a <- which(is.infinite(df.famd[,i]) == TRUE)
  
  # Add indices to the list
  if(length(a) >= 1){
    inf <- append(inf, a, after = length(inf))
  }
  
}

# Remove duplicate indices from inf
inf <- unique(inf)

# Remove infinite values from df.famd
df.famd <- df.famd[-inf,]

# # As of 4/22/22, many of these columns have only one or three missing values. That can be an issue
# # for the mice() function, which underlies the imputation functions in the missMDA package. Here,
# # I'll remove rows to eliminate those cases. This will leave us in a situation where the only missing
# # values are in the three multifunctional diversity columns.
# 
# # Empty vector to contain row indices of missing values where one column has <10 missing values
# miss <- as.numeric(c())
# 
# # List of rows corresponding to missing values where one column has <10 missing values.
# for(i in 1:ncol(df.famd)){
#   
#   # Vector of indices with missing values
#   a <- which(is.na(df.famd[,i]))
#   
#   # Append values to miss only if missing values are >0 and <10
#   if(length(a) > 0 && length(a) < 10){
#     miss <- append(miss, a, after = length(miss))
#   }
#   
# }
# 
# # Unique row indices in miss
# miss <- unique(miss)
# 
# # Delete the offending rows
# df.famd <- df.famd[-miss,]
# 
# # Unfortunately, this does not seem to resolve the error message.
# 
# # Impute missing data by the mean of the variable using imputePCA function of missMDA package
# df.famd <- imputeFAMD(df.famd, sup.var = 1:2)

# Subset df.famd for complete cases only
df.famd <- df.famd[complete.cases(df.famd),]




##### 5.3 FAMD #####

# Run the factor analysis of mixed data (FAMD)
res.famd <- FAMD(df.famd, sup.var = 1:2, graph = FALSE)

















