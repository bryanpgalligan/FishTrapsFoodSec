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

# Remove all trips with CPUE greater than 30 kg per trap
TripData_NoOutliers <- subset(TripData, TripData$CPUE_kgPerTrap <= 30)

# CPUE with outliers removed
ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = CPUE_kgPerTrap)) +
  geom_boxplot()

# MTC_degC
ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = MTC_degC)) +
  geom_boxplot()

# Additional variables
ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = B.undulatus)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = BrowserMassRatio)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ScraperMassRatio)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = GrazerMassRatio)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = PredatorMassRatio)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ValuePUE)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = MeanLLmat)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = MeanTrophLevel)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = MeanVulnerability)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FECount)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FDiv)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = CaPUE)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FePUE)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = Omega3PUE)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ProteinPUE)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = VAPUE)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = SePUE)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ZnPUE)) +
  geom_boxplot()




##### 4.3 Distributions #####

ggplot(data = TripData_NoOutliers, mapping = aes(x = B.undulatus, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = BrowserMassRatio, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = ScraperMassRatio, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = GrazerMassRatio, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = PredatorMassRatio, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = CPUE_kgPerTrap, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = CPUE_DistFromMean, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = ValuePUE, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = MeanLLmat, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = MeanTrophLevel, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = MeanVulnerability, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = MTC_degC, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = FECount, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = FDiv, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = CaConc_mgPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = FeConc_mgPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = Omega3Conc_gPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = ProteinConc_gPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = VAConc_ugPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = SeConc_ugPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = ZnConc_ugPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)


# Save a copy of TripData ready for analysis
write.csv(TripData_NoOutliers, "04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv",
  row.names = FALSE)




