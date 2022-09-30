## Script Title:
##    04 Data Exploration

# This script explores the data to avoid common statistical errors, following the procedures
# outlined by Zuur et al. (2010).

## Script TOC:
##    4.1 Load packages and data
##    4.2 Outliers
##    4.3 Distributions
##    4.4 Summary statistics




##### 4.1 Load packages and data #####

# Load packages
library(readr)
library(ggplot2)
library(plotrix) # for standard error function

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
ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = CPUE_DistFromMean)) +
  geom_boxplot()

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

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FRic)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FEve)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FDiv)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = CaConc_mgPer100g)) +
  geom_boxplot()

# There are some clear outliers. After investigation, they seem to be the result of data
# entry errors. Remove all trips with Calcium concentration >= 250 mg per 100 g.
# This amounts to six trips.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$CaConc_mgPer100g < 250)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = CaPrice_KSHPermg)) +
  geom_boxplot()

# There are three obvious outliers here. These are probably the result of data entry errors.
# Remove all trips with Calcium prices >= 2 KSH per mg. This amounts to five trips (two of which
# have infinity as a value).
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$CaPrice_KSHPermg < 2)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FeConc_mgPer100g)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 3))

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = FePrice_KSHPermg)) +
  geom_boxplot()

# There are two obvious outliers here, probably the result of data entry errors. Remove all
# trips with Fe price >= 75 KSH per mg.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$FePrice_KSHPermg < 75)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = Omega3Conc_gPer100g)) +
  geom_boxplot() +
  coord_cartesian(ylim = c(0, 0.5))

# There are six obvious outliers here, probably the result of data entry errors. Remove all
# trips with Omega 3 concentrations >= 0.2 g per 100 g.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$Omega3Conc_gPer100g < 0.2)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = Omega3Price_KSHPerg)) +
  geom_boxplot()

# There are some obvious issues: a few zeros and some high outliers (above 175 KSH per g).
# Likely the result of data entry errors. Remove them all.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$Omega3Price_KSHPerg > 0)
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$Omega3Price_KSHPerg < 175)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ProteinConc_gPer100g)) +
  geom_boxplot()

# There are some outliers here, with the very obvious ones above 15 g per 100 g, likely ther result
# of data entry errors.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$ProteinConc_gPer100g < 15)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ProteinPrice_KSHPerg)) +
  geom_boxplot()

# There are three obvious outliers here, all above 1.5 KSH per g. Remove.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$ProteinPrice_KSHPerg < 1.5)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = VAConc_ugPer100g)) +
  geom_boxplot()

# There are some outliers, but no (super) obvious breaks. We'll leave this the way it is.

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = VAPrice_KSHPerug)) +
  geom_boxplot()

# There is one outlier, above 1.5 KSH per ug. Remove it.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$VAPrice_KSHPerug < 1.5)

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = SeConc_ugPer100g)) +
  geom_boxplot()

# Some outliers, but no obvious breaks.

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = SePrice_KSHPerug)) +
  geom_boxplot()

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ZnConc_mgPer100g)) +
  geom_boxplot()

# Some outliers, but no obvious breaks.

ggplot(data = TripData_NoOutliers, mapping = aes(x = TrapType, y = ZnPrice_KSHPermg)) +
  geom_boxplot()

# There is one obvious outlier, above 40 KSH per ug. Remove it.
TripData_NoOutliers <- subset(TripData_NoOutliers, TripData_NoOutliers$ZnPrice_KSHPermg < 40)



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

ggplot(data = TripData_NoOutliers, mapping = aes(x = FRic, color = TrapType)) +
  geom_density(alpha = 0.4)

ggplot(data = TripData_NoOutliers, mapping = aes(x = FEve, color = TrapType)) +
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

ggplot(data = TripData_NoOutliers, mapping = aes(x = ZnConc_mgPer100g, color = TrapType)) +
  geom_density(alpha = 0.4)


# Save a copy of TripData ready for analysis
write.csv(TripData_NoOutliers, "04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv",
  row.names = FALSE)




##### 4.4 Summary statistics #####

# Find mean effort (site-days per month) and SE of mean

# you have 105 months and 841 site days

# List of all site days in study
site.days <- unique(TripData_NoOutliers[c("Date", "Site")])

# Convert date column to only month and year
site.days$Date <- format(as.Date(site.days$Date), "%Y-%m")

# New data frame of all months Oct 2010 - June 2019
effort <- as.data.frame(seq(as.Date("2010-10-01"), by = "month", length.out = 105))
colnames(effort) <- "Month"

# Format effort month column to by YYYY-MM
effort$Month <- format(as.Date(effort$Month), "%Y-%m")

# Add empty column for number of site days
effort$Effort <- NA

# Fill in effort column
for (i in 1:nrow(effort)){
  
  # Extract month
  a <- effort$Month[i]
  
  # Count number of site days
  b <- nrow(subset(site.days, site.days$Date == a))
  
  # Save number of site days to effort
  if (b > 0){
    effort$Effort[i] <- b
  } else {
    effort$Effort[i] <- 0
  }
  
}

# Remove first and last months because they are partial months
effort <- effort[2:104, ]

# Find mean and SE
mean(effort$Effort)
std.error(effort$Effort)








