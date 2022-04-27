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

## Script Title:
##    06 Additional Analysis

## Last update: 27 Apr 22

# This script analyzes the data to supplement principal component methods.

## Script TOC:
##    6.1 Load Packages and Data
##    6.2 CPUE




##### 6.1 Load Packages and Data #####

# Load packages
library(ggplot2)
library(readr)
library(moments)

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")



#### 6.2 CPUE #####

# Subset TripData for only uniform trips
TripData.sub.traptype <- subset(TripData, TripData$TrapType != "Multiple")

# Plot CPUE
ggplot(data = TripData.sub.traptype, aes(CPUE_kgPerTrap, fill = factor(TrapType))) +
  geom_density(alpha = 0.4) +
  #coord_cartesian(xlim = c(0, 50)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  ylab("Density") +
  xlab("Catch Per Unit Effort (kg / trap)") +
  labs(fill = "Trap Type") +
  scale_fill_brewer(palette = "Set3", direction = -1)

# Save Plot
ggsave(filename = "06_AdditionalAnalysis_Out/CPUEDensity_FishTrapsFoodSec.jpeg", device = "jpeg")

## Save kurtosis and skewness

# Create vectors to prepare a data frame to save results
TrapType <- c("Gated", "Traditional")
Kurtosis <- c()
Skewness <- c()

# Subset data for this analysis (one for each trap type)
TripData.sub.gated <- subset(TripData, TripData$TrapType == "Gated")
TripData.sub.trad <- subset(TripData, TripData$TrapType == "Traditional")

# Calculate Kurtosis and skewness for all three trap types
Kurtosis[1] <- kurtosis(TripData.sub.gated$CPUE_kgPerTrap, na.rm = TRUE)
Skewness[1] <- skewness(TripData.sub.gated$CPUE_kgPerTrap, na.rm = TRUE)
Kurtosis[2] <- kurtosis(TripData.sub.trad$CPUE_kgPerTrap, na.rm = TRUE)
Skewness[2] <- skewness(TripData.sub.trad$CPUE_kgPerTrap, na.rm = TRUE)

# Create a data frame with results
CatchStability <- data.frame(Skewness, Kurtosis, row.names = TrapType)

# Save kurtosis and skewness
write.csv(CatchStability, file = "06_AdditionalAnalysis_Out/CatchStability.csv")

# Transform CPUE data
cpue.sqrt.gated <- sqrt(TripData.sub.gated$CPUE_kgPerTrap)
cpue.sqrt.trad <- sqrt(TripData.sub.trad$CPUE_kgPerTrap)

# Plot transformed CPUE data
ggplot(data = TripData.sub.traptype, aes(sqrt(CPUE_kgPerTrap), fill = factor(TrapType))) +
  geom_density(alpha = 0.4) +
  #coord_cartesian(xlim = c(0, 50)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  ylab("Density") +
  xlab("Square Root Transformed Catch Per Unit Effort (kg / trap)") +
  labs(fill = "Trap Type") +
  scale_fill_brewer(palette = "Set3", direction = -1)

# Save plot
ggsave(filename = "06_AdditionalAnalysis_Out/CPUETransformedDensity_FishTrapsFoodSec.jpeg",
  device = "jpeg")

## Save kurtosis and skewness of transformed CPUE

# Create vectors to prepare a data frame to save results
TrapType <- c("Gated", "Traditional")
Kurtosis <- c()
Skewness <- c()

# Calculate kurtosis and skewness of sqrt transformed CPUE
Kurtosis[1] <- kurtosis(cpue.sqrt.gated, na.rm = TRUE)
Skewness[1] <- skewness(cpue.sqrt.gated, na.rm = TRUE)
Kurtosis[2] <- kurtosis(cpue.sqrt.trad, na.rm = TRUE)
Skewness[2] <- skewness(cpue.sqrt.trad, na.rm = TRUE)

# Create a data frame with results
CatchStabilityTransformed <- data.frame(Skewness, Kurtosis, row.names = TrapType)

# Save transformed kurtosis and skewness
write.csv(CatchStabilityTransformed, file = "06_AdditionalAnalysis_Out/CatchStability_SqrtTransformed.csv")

