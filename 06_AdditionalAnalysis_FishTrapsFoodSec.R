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

## Last update: 3 May 22

# This script analyzes the data to supplement principal component methods.

## Script TOC:
##    6.1 Load Packages and Data
##    6.2 CPUE
##    6.3 TrapType and Food
##    6.4 TrapType and Conservation 1
##    6.5 TrapType and Conservation 2
##    6.6 Food and Conservation 1
##    6.7 Food and Conservation 2




##### 6.1 Load Packages and Data #####

# Load packages
library(ggplot2)
library(readr)
library(moments)
library(ggeffects)
library(DHARMa)
library(glmmTMB)
library(ggpubr)

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")

# Load PCA data for modeling
PCAData <- read_csv("05_PrincipalComponents_Out/TripData_ForModeling.csv")


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




##### 6.3 TrapType and Food #####

# Linear model
trap.food.model <- lm(FoodDim1 ~ TrapType,
  data = PCAData)

# Model output
summary(trap.food.model)

# Simulate residuals
simulateResiduals(trap.food.model, plot = TRUE)

# There seem to be some problems in the residuals

# Density plot of FoodDim1
ggplot(data = PCAData, mapping = aes(FoodDim1)) +
  geom_density()

# This is not too far from normal...

# Get model predictions
prediction <- ggpredict(trap.food.model, terms = c("TrapType"))

# Plot the prediction
plot.1a <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(title = "", x = "", y = "") +
  scale_y_continuous(breaks = c(-0.34, -0.2, 0, 0.2, 0.3, 0.34),
    labels = c("Calcium Concentration", -0.2, 0.0, 0.2, "Value Per Unit Effort", "Catch Per Unit Effort")) +
  annotate(geom = "text", x = "Traditional", y = 0.25,
    label = expression("p = 4.92 x 10"^-5)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_blank()) +
  coord_cartesian(ylim = c(-0.35, 0.35))

# Gated traps have higher CPUE and value PUE, but lower Ca concentrations

# Save the plot
# ggsave(filename = "06_AdditionalAnalysis_Out/TrapFoodPrediction.jpeg", device = "jpeg",
#   height = 5, width = 3, units = "in")


##### 6.4 TrapType and Conservation 1 #####

# Linear model
trap.cons1.model <- lm(ConsDim1 ~ TrapType,
  data = PCAData)

# Model summary
summary(trap.cons1.model)

# Simulate residuals
simulateResiduals(trap.cons1.model, plot = TRUE)

# There seem to be some problems in the residuals

# Density plot of ConsDim1
ggplot(data = PCAData, mapping = aes(ConsDim1)) +
  geom_density()

# This is not a normal distribution...

# Get model predictions
prediction <- ggpredict(trap.cons1.model, terms = c("TrapType"))

# Plot the prediction
plot.1b <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(title = "", x = "", y = "") +
  scale_y_continuous(breaks = c(-0.34, -0.2, 0, 0.2, 0.34),
    labels = c("Browsing Herbivores", -0.2, 0.0, 0.2, "Mean Trophic Level")) +
  annotate(geom = "text", x = "Gated", y = 0.25,
    label = expression("   p = 9.81 x 10"^-13)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_blank()) +
  coord_cartesian(ylim = c(-0.35, 0.35))

# Traditional traps have higher mean trophic level and lower browser mass ratio

# Save the plot
# ggsave(filename = "06_AdditionalAnalysis_Out/TrapCons1Prediction.jpeg", device = "jpeg")




##### 6.5 TrapType and Conservation 2 #####

# Linear Model
trap.cons2.model <- lm(ConsDim2 ~ TrapType,
  data = PCAData)

# Model summary
summary(trap.cons2.model)

# Simulate residuals
simulateResiduals(trap.cons2.model, plot = TRUE)

# There seem to be some problems in the residuals

# Density plot of ConsDim2
ggplot(data = PCAData, mapping = aes(ConsDim2)) +
  geom_density()

# This looks like a normal distribution...

# Get model predictions
prediction <- ggpredict(trap.cons2.model, terms = c("TrapType"))

# Plot the prediction
plot.1c <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(title = "", x = "", y = "") +
  scale_y_continuous(breaks = c(-0.34, -0.2, 0, 0.2, 0.27, 0.34),
    labels = c("", -0.2, 0.0, 0.2, "Scraping Herbivores", expression(paste("Mean ", frac(L,L[mat]), sep = "")))) +
  annotate(geom = "text", x = "Traditional", y = 0.25,
    label = expression("p = 2.92 x 10"^-4)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks.y = element_blank()) +
  coord_cartesian(ylim = c(-0.35, 0.35))

# Gated traps have a higher mean L / Lmat and higher Scraper Mass Ratio
  
# Save the plot
# ggsave(filename = "06_AdditionalAnalysis_Out/TrapCons2Prediction.jpeg", device = "jpeg")

# Plot 1
ggarrange(plot.1a, plot.1b, plot.1c, nrow = 1)

# Save Plot 1
ggsave(filename = "06_AdditionalAnalysis_Out/TrapModelPredictions.jpeg", device = "jpeg",
  height = 4, width = 12, units = "in")

##### 6.6 Food and Conservation 1 #####

# Linear Model
food.cons1.model <- glmmTMB(ConsDim1 ~ FoodDim1 * TrapType,
  data = PCAData,
  family = gaussian())

# Simulate residuals
simulateResiduals(food.cons1.model, plot = TRUE)

# There seem to be some problems in the residuals

# Get model predictions
prediction <- ggpredict(food.cons1.model, terms = c("FoodDim1"))

# Plot the prediction
ggplot(prediction, aes(y = predicted, x = x)) +
  geom_line() +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2) +
  geom_point(PCAData, mapping = aes(x = FoodDim1, y = ConsDim1,
    color = TrapType), alpha = 0.3) +
  coord_cartesian(ylim = c(-2, 2)) +
  labs(title = "", x = "Food Security", y = "Conservation Dim. 1") +
  annotate(geom = "text", x = -5, y = 1, label = "p = 0.418") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"))

# Save the plot
ggsave(filename = "06_AdditionalAnalysis_Out/FoodCons1Prediction.jpeg", device = "jpeg")




##### 6.7 Food and Conservation 2 #####

food.cons2.model <- glmmTMB(ConsDim2 ~ FoodDim1*TrapType,
  data = PCAData,
  family = gaussian())

# Simulate residuals
simulateResiduals(food.cons2.model, plot = TRUE)

# There seem to be some problems in the residuals

# Get model predictions
prediction <- ggpredict(food.cons2.model, terms = c("FoodDim1"))

# Plot the prediction
ggplot(prediction, aes(y = predicted, x = x)) +
  geom_line() +
  geom_point(mapping = aes(x = FoodDim1, y = ConsDim2,
    color = TrapType), data = PCAData, alpha = 0.3) +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2) +
  coord_cartesian(ylim = c(-2.5, 2.5)) +
  labs(title = "", x = "Food Security", y = "Conservation Dim. 2") +
  annotate(geom = "text", x = -5, y = 0.7, label = "p = 0.089") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"))

# Save the plot
ggsave(filename = "06_AdditionalAnalysis_Out/FoodCons1Prediction.jpeg", device = "jpeg")

