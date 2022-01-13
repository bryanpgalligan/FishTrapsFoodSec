## Exploratory plots ##

# Load packages
library(readr)
library(ggplot2)
library(ggpubr)
library(glmmTMB)

# Load TrapData
TrapData <- read_csv("01_CleanData_Out/TrapData_Cleaned.csv", 
  col_types = cols(Date = col_date(format = "%Y-%m-%d")))

# Load CatchComposition
CatchComposition <- read_csv("02_Stability_Out/CatchComposition_FunGrDiet_Data.csv",
  col_types = cols(...1 = col_skip()))

# Load CPUE_Data
CPUE_Data <- read_csv("04_Access_Out/CPUE_Data.csv", 
    col_types = cols(...1 = col_skip()))
CPUEBySite_p <- read_csv("04_Access_Out/CPUEBySite_pvalues.csv",
  col_types = cols(...1 = col_skip()))

## CPUE by trap type
ggplot(data = CPUE_Data, mapping = aes(x = TrapType, y = CPUE)) +
  geom_point(alpha = 0.1, aes(color = Site)) +
  geom_boxplot(outlier.shape = NA, aes(alpha = 0)) +
  theme(panel.background = element_blank(),
    axis.line = element_line())

ggplot(data = CPUE_Data, mapping = aes(x = GateCode, y = CPUE)) +
  geom_point(alpha = 0.1, aes(color = Site)) +
  geom_boxplot(outlier.shape = NA, aes(alpha = 0)) +
  theme(panel.background = element_blank(),
    axis.line = element_line())

## CPUE by trap type and site over time

# Add a column for date
CPUE_Data$Date <- as.Date("1950-01-01")

# Add date to CPUE data
for(i in 1:length(CPUE_Data$TripID)){
  
  # Save TripID
  a <- CPUE_Data$TripID[i]
  
  # Get index for first ocurrence of this TripID in TrapData
  b <- match(a, TrapData$TripID)
  
  # Save date to CPUE_Data
  CPUE_Data$Date[i] <- TrapData$Date[b]
  
}

# Plot CPUE by date for different sites
ggplot(data = CPUE_Data, mapping = aes(x = Date, y = CPUE, color = TrapType)) +
  geom_point(alpha = 0.25) +
  facet_wrap(facets = vars(Site), scales = "free")

# Plot CPUE by date for all sites
ggplot(data = CPUE_Data, mapping = aes(x = Date, y = CPUE, color = Site)) +
  geom_point(alpha = 0.5, aes(shape = TrapType))

# Plot CPUE by date for all sites, no site info
ggplot(data = CPUE_Data, mapping = aes(x = Date, y = CPUE, color = TrapType)) +
  geom_point(alpha = 0.25)

# Density plot for CPUE
ggplot(data = CPUE_Data, mapping = aes(CPUE, fill = TrapType)) +
  geom_density(alpha = 0.25)

# Test a GLMM for CPUE over time
model <- glmmTMB(CPUE ~ Date + (1|Site) + (1|TrapType),
  data = CPUE_Data, family = nbinom2())
summary(model)

# It does not look like there is a trend in CPUE over time

