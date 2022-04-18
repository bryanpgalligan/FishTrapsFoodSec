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


