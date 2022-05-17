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
##    06 Additional Analysis

## Last update: 9 May 22

# This script analyzes the data to supplement principal component methods.

## Script TOC:
##    6.1 Load Packages and Data
##    6.2 CPUE
##    6.3 TrapType and Food 1
##    6.4 TrapType and Food 2
##    6.5 TrapType and Conservation 1
##    6.6 TrapType and Conservation 2
##    6.7 TrapType and Scrapers
##    6.8 Food and Conservation 1
##    6.9 Food and Conservation 2
##    6.10 Lmat and calcium concentration




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

# Load species data
SpeciesData <- read_csv("02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv")

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




##### 6.3 TrapType and Food 1 #####

# Linear model
trap.food1.model <- lm(FoodDim1 ~ TrapType,
  data = PCAData)

# Model output
summary(trap.food1.model)

# Simulate residuals
simulateResiduals(trap.food1.model, plot = TRUE)

# There seem to be some problems in the residuals

# Density plot of FoodDim1
ggplot(data = PCAData, mapping = aes(FoodDim1)) +
  geom_density()

# This is not too far from normal...

# Get model predictions
prediction <- ggpredict(trap.food1.model, terms = c("TrapType"))

# Plot the prediction
plot.1a <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(x = "", y = "", title = "") +
  # labs(x = "", title = "",
  #   y = paste("Value and Catch per Trap ", sprintf("\u2192"),
  #     "\n", sprintf("\u2190"), " Calcium Concentration", sep = "")) +
  scale_y_continuous(breaks = c(-0.34, -0.2, 0, 0.2, 0.3, 0.34),
    labels = c("Calcium", -0.2, 0.0, 0.2, "Value", "CPUE")) +
  annotate(geom = "text", x = "Traditional", y = 0.25,
    label = expression("p = 4.92 x 10"^-5)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks.y = element_blank()) +
  coord_cartesian(ylim = c(-0.35, 0.35), xlim = c(1, 2))

# Gated traps have higher CPUE and value PUE, but lower Ca concentrations




##### 6.4 TrapType and Food 2 #####

# Linear model
trap.food2.model <- lm(FoodDim2 ~ TrapType,
  data = PCAData)

# Model output
summary(trap.food2.model)

# Simulate residuals
simulateResiduals(trap.food2.model, plot = TRUE)

# There seem to be some problems in the residuals

# Density plot of FoodDim2
ggplot(data = PCAData, mapping = aes(FoodDim2)) +
  geom_density()

# This is not too far from normal...

# Get model predictions
prediction <- ggpredict(trap.food2.model, terms = c("TrapType"))

# Plot the prediction
plot.1b <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(title = "", x = "", y = "") +
  scale_y_continuous(breaks = c(-0.2, 0, 0.2, 0.3, 0.34),
    labels = c(-0.2, 0.0, 0.2, "Maturity", "Vitamin A")) +
  annotate(geom = "text", x = "Traditional", y = 0.25,
    label = expression("p = 1.01 x 10"^-7)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_blank()) +
  coord_cartesian(ylim = c(-0.35, 0.35))

# Gated traps have higher vitamin A and mean L/Lmat

# Save food security plots
ggarrange(plot.1a, plot.1b)
ggsave("06_AdditionalAnalysis_Out/Fig4_FoodSecModels.jpeg", device = "jpeg")




##### 6.5 TrapType and Conservation 1 #####

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
plot.2a <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(title = "", x = "", y = "") +
  scale_y_continuous(breaks = c(-0.5, -0.46, -0.4, -0.2, 0, 0.2, 0.4, 0.46, 0.5, 0.54),
    labels = c("Browsers", "Fun. Divergence",
      -0.4, -0.2, 0.0, 0.2, 0.4,
      "Vulnerability", "Temperature", "Trophic Level")) +
  annotate(geom = "text", x = "Gated", y = 0.3,
    label = expression("   p < 2.0 x 10"^-16)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks = element_blank()) +
  coord_cartesian(ylim = c(-0.5, 0.5))

# Traditional traps have higher mean trophic level and lower browser mass ratio

# Save the plot
# ggsave(filename = "06_AdditionalAnalysis_Out/TrapCons1Prediction.jpeg", device = "jpeg")




##### 6.6 TrapType and Conservation 2 #####

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
plot.2b <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(title = "", x = "", y = "") +
  scale_y_continuous(breaks = c(-0.5, -0.46, -0.4, -0.2, 0, 0.2, 0.4, 0.46, 0.5, 0.54),
    labels = c("Fun. Richness", "",
      -0.4, -0.2, 0.0, 0.2, 0.4,
      "", "Fun. Evenness", "Maturity")) +
  annotate(geom = "text", x = "Traditional", y = 0.3,
    label = "p = 0.08") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks.y = element_blank()) +
  coord_cartesian(ylim = c(-0.5, 0.5))

# Gated traps have a higher mean L / Lmat and FEve but lower FRic




##### 6.7 TrapType and Scrapers #####

# Subset trip data to exclude traptype = multiple
df <- subset(TripData, TripData$TrapType != "Multiple")


##### WIP - switch to bayesian modeling approach with zoib on this particular model #####


# Linear Model with beta distribution because response variable is a proportion
trap.scrapers.model <- glmmTMB(ScraperMassRatio ~ TrapType + (1|Site),
  data = df,
  family = beta_family())

# Model summary
summary(trap.scrapers.model)

# Simulate residuals
simulateResiduals(trap.cons2.model, plot = TRUE)

# The residuals look okay

# Density plot of ConsDim2
ggplot(data = df, mapping = aes(ScraperMassRatio)) +
  geom_density()

# This looks like a normal distribution...

# Get model predictions
prediction <- ggpredict(trap.scrapers.model, terms = c("TrapType"))

# Plot the prediction
plot.2c <- ggplot(prediction, aes(y = predicted, x = x)) +
  geom_point() +
  geom_errorbar(aes(ymin = conf.low, ymax = conf.high, width = 0.1)) +
  labs(title = "", x = "", y = "") +
  scale_y_continuous(breaks = c(0, 0.02, 0.04, 0.06, 0.08, 0.1),
    labels = c("", 0.02, 0.04, 0.06, 0.08, "Scrapers")) +
  annotate(geom = "text", x = "Traditional", y = 0.08,
    label = "p = 0.22") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    axis.ticks.y = element_blank()) +
  coord_cartesian(ylim = c(0, 0.1))

# Proportion of scrapers in the catch is consistently low, with little variation
# between trap types

# Save conservation predictions plot
ggarrange(plot.2a, plot.2b, plot.2c, nrow = 1)
ggsave("06_AdditionalAnalysis_Out/Fig6_ConsModels.jpeg", device = "jpeg",
  height = 5, width = 12, units = "in")




##### 6.8 Food and Conservation 1 #####

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




##### 6.9 Food and Conservation 2 #####

# Linear model
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




##### 6.10 Lmat and calcium concentration #####

# Linear model
lmat.calc.model <- lm(Calcium_mgPer100g ~ Lmat_cm, data = SpeciesData)

# Model summary
summary(lmat.calc.model)

# Simulate residuals
simulateResiduals(lmat.calc.model, plot = TRUE)

# The residuals don't look great...

# Plot distribution of calcium
ggplot(data = SpeciesData, mapping = aes(x = Calcium_mgPer100g)) +
  geom_density()

# Plot distribution of Lmat
ggplot(data = SpeciesData, mapping = aes(x = Lmat_cm)) +
  geom_density()

# Get model prediction
prediction <- ggpredict(lmat.calc.model, terms = c("Lmat_cm"))

# Plot the prediction
ggplot(prediction, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lmat_cm, y = Calcium_mgPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 75), ylim = c(0, 210)) +
  labs(title = "",
    x = expression(paste("Length at First Maturity (", L[mat], ") (cm)", sep = "")),
    y = expression(paste("Calcium Concentration ", bgroup("(", frac('mg', '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 60, y = 140,
    label = expression("p = 6.49 x 10"^-8)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"))

# Save plot
ggsave("06_AdditionalAnalysis_Out/LmatCalcium.jpeg", device = "jpeg")





