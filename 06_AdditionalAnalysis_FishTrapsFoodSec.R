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
##    6.11 LLopt and nutrient yields
##    6.12 LLopt and nutrient concentrations




##### 6.1 Load Packages and Data #####

# Load packages
library(ggplot2)
library(readr)
library(moments)
library(ggeffects)
library(DHARMa)
library(glmmTMB)
library(ggpubr)
library(mgcv)
library(tidymv)

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")

# Load species data
SpeciesData <- read_csv("02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv")

# Load catch data
CatchData <- read_csv("02_FishLife_Out/CatchData_GatedTraps_Galligan.csv")

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




##### 6.11 LLopt and nutrient yields #####

# Colorblind friendly palette
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


## Calcium

# GAMM for calcium yield - traditional traps
ca.gamm.trad <- gamm(CaPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for calcium yield - gated traps
ca.gamm.gated <- gamm(CaPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
ca.predict.trad <- predict_gam(ca.gamm.trad$gam)
ca.predict.gated <- predict_gam(ca.gamm.gated$gam)

# Plot data and model predictions with daily value (RDA for children 1-3 years)
a <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = CaPUE)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = ca.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = ca.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = ca.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = ca.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_hline(yintercept = 700, linetype = 2) +
  xlab("") +
  #xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Calcium Yield ", bgroup("(", frac(mg, trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 1000)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# LM for LLopt and calcium
ca.lm <- lm(Calcium_mgPer100g ~ Lopt_cm, data = SpeciesData)
summary(ca.lm)

# LM prediction
ca.predict <- ggpredict(ca.lm, "Lopt_cm")

# Plot prediction and data
b <- ggplot(ca.predict, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lopt_cm, y = Calcium_mgPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 250)) +
  labs(title = "",
    x = "",
    #x = expression(paste("Optimum Length (", L[opt], ") (cm)", sep = "")),
    y = expression(paste("Calcium Concentration ", bgroup("(", frac('mg', '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 80, y = 212.5,
    label = expression("p = 6.39 x 10"^-9)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Iron

# GAMM for iron yield - traditional traps
fe.gamm.trad <- gamm(FePUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for iron yield - gated traps
fe.gamm.gated <- gamm(FePUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
fe.predict.trad <- predict_gam(fe.gamm.trad$gam)
fe.predict.gated <- predict_gam(fe.gamm.gated$gam)

# Plot data and model predictions with daily value (RDA for children 1-3 years)
c <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = FePUE)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = fe.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = fe.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = fe.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = fe.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_hline(yintercept = 7, linetype = 2) +
  xlab("") +
  #xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Iron Yield ", bgroup("(", frac(mg, trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 20)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# LM for LLopt and iron
fe.lm <- lm(Iron_mgPer100g ~ Lopt_cm, data = SpeciesData)
summary(fe.lm)

# LM prediction
fe.predict <- ggpredict(fe.lm, "Lopt_cm")

# Plot prediction and data
d <- ggplot(fe.predict, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lopt_cm, y = Iron_mgPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 2)) +
  labs(title = "",
    x = "",
    #x = expression(paste("Optimum Length (", L[opt], ") (cm)", sep = "")),
    y = expression(paste("Iron Concentration ", bgroup("(", frac('mg', '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 80, y = 1.7,
    label = "p = 0.155") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Omega-3 Polyunsaturated Fatty Acids (PUFA)

# GAMM for Omega-3 yield - traditional traps
pufa.gamm.trad <- gamm(Omega3PUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for calcium yield - gated traps
pufa.gamm.gated <- gamm(Omega3PUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
pufa.predict.trad <- predict_gam(pufa.gamm.trad$gam)
pufa.predict.gated <- predict_gam(pufa.gamm.gated$gam)

# Plot data and model predictions with daily value (adequate intake for children 1-3 years)
e <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = Omega3PUE)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = pufa.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = pufa.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = pufa.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = pufa.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_hline(yintercept = 0.7, linetype = 2) +
  xlab("") +
  #xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Omega-3 Yield ", bgroup("(", frac(g, trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 5)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# LM for LLopt and omega-3
pufa.lm <- lm(Omega3_gPer100g ~ Lopt_cm, data = SpeciesData)
summary(pufa.lm)

# LM prediction
pufa.predict <- ggpredict(pufa.lm, "Lopt_cm")

# Plot prediction and data
f <- ggplot(pufa.predict, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lopt_cm, y = Omega3_gPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 1)) +
  labs(title = "",
    x = "",
    #x = expression(paste("Optimum Length (", L[opt], ") (cm)", sep = "")),
    y = expression(paste("Omega-3 Concentration ", bgroup("(", frac('g', '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 80, y = 0.85,
    label = "p = 0.282") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Protein

# GAMM for protein yield - traditional traps
protein.gamm.trad <- gamm(ProteinPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for protein yield - gated traps
protein.gamm.gated <- gamm(ProteinPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
protein.predict.trad <- predict_gam(protein.gamm.trad$gam)
protein.predict.gated <- predict_gam(protein.gamm.gated$gam)

# Plot data and model predictions with daily value (RDA for children 1-3 years for a reference weight)
g <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = CaPUE)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = ca.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = ca.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = ca.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = ca.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_hline(yintercept = 13, linetype = 2) +
  xlab("") +
  #xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Protein Yield ", bgroup("(", frac(g, trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 1000)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# LM for LLopt and protein
protein.lm <- lm(Protein_gPer100g ~ Lopt_cm, data = SpeciesData)
summary(protein.lm)

# LM prediction
protein.predict <- ggpredict(protein.lm, "Lopt_cm")

# Plot prediction and data
h <- ggplot(protein.predict, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lopt_cm, y = Protein_gPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 100), ylim = c(15, 25)) +
  labs(title = "",
    x = "",
    #x = expression(paste("Optimum Length (", L[opt], ") (cm)", sep = "")),
    y = expression(paste("Protein Concentration ", bgroup("(", frac('g', '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 80, y = 23,
    label = "p = 0.0122") +
  scale_x_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Vitamin A

# GAMM for vitamin A yield - traditional traps
va.gamm.trad <- gamm(VAPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for vitamin A yield - gated traps
va.gamm.gated <- gamm(VAPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
va.predict.trad <- predict_gam(va.gamm.trad$gam)
va.predict.gated <- predict_gam(va.gamm.gated$gam)

# Plot data and model predictions with daily value (RDA for children 1-3 years)
i <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = VAPUE)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = va.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = va.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = va.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = va.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_hline(yintercept = 300, linetype = 2) +
  #xlab("") +
  xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Vitamin A Yield ", bgroup("(", frac(paste("\u00b5", g, sep = ""), trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 2500)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# LM for LLopt and vitamin A
va.lm <- lm(VitaminA_ugPer100g ~ Lopt_cm, data = SpeciesData)
summary(va.lm)

# LM prediction
va.predict <- ggpredict(va.lm, "Lopt_cm")

# Plot prediction and data
j <- ggplot(va.predict, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lopt_cm, y = VitaminA_ugPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 400)) +
  labs(title = "",
    x = expression(paste("Optimum Length (", L[opt], ") (cm)", sep = "")),
    y = expression(paste("Vitamin A Concentration ", bgroup("(", frac(paste("\u00b5" , 'g', sep = ""), '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 80, y = 340,
    label = "p = 0.754") +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Selenium

# GAMM for slenium yield - traditional traps
se.gamm.trad <- gamm(SePUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for calcium yield - gated traps
se.gamm.gated <- gamm(SePUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
se.predict.trad <- predict_gam(se.gamm.trad$gam)
se.predict.gated <- predict_gam(se.gamm.gated$gam)

# Plot data and model predictions with daily value (RDA for children 1-3 years)
k <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = SePUE)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = se.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = se.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = se.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = se.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_hline(yintercept = 20, linetype = 2) +
  #xlab("") +
  xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Selenium Yield ", bgroup("(", frac(paste("\u00b5", g, sep = ""), trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 1000)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# LM for LLopt and selenium
se.lm <- lm(Selenium_ugPer100g ~ Lopt_cm, data = SpeciesData)
summary(se.lm)

# LM prediction
se.predict <- ggpredict(se.lm, "Lopt_cm")

# Plot prediction and data
l <- ggplot(se.predict, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lopt_cm, y = Selenium_ugPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 100)) +
  labs(title = "",
    x = expression(paste("Optimum Length (", L[opt], ") (cm)", sep = "")),
    y = expression(paste("Selenium Concentration ", bgroup("(", frac(paste("\u00b5", g, sep = ""), '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 80, y = 85,
    label = expression("p = 5.09 x 10"^-4)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Zinc

# GAMM for zinc yield - traditional traps
zn.gamm.trad <- gamm(ZnPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for zinc yield - gated traps
zn.gamm.gated <- gamm(ZnPUE ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
zn.predict.trad <- predict_gam(zn.gamm.trad$gam)
zn.predict.gated <- predict_gam(zn.gamm.gated$gam)

# Plot data and model predictions with daily value (RDA for children 1-3 years)
m <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = ZnPUE)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = zn.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = zn.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = zn.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = zn.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_hline(yintercept = 3, linetype = 2) +
  #xlab("") +
  xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Zinc Yield ", bgroup("(", frac(mg, trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 60)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

# LM for LLopt and zinc
zn.lm <- lm(Zinc_ugPer100g ~ Lopt_cm, data = SpeciesData)
summary(zn.lm)

# LM prediction
zn.predict <- ggpredict(zn.lm, "Lopt_cm")

# Plot prediction and data
n <- ggplot(zn.predict, aes(x = x, y = predicted)) +
  geom_smooth(method = "lm") +
  geom_ribbon(aes(ymin = conf.low, ymax = conf.high), alpha = 0.2)+
  geom_point(mapping = aes(x = Lopt_cm, y = Zinc_ugPer100g),
    data = SpeciesData, alpha = 0.3) +
  coord_cartesian(xlim = c(0, 100), ylim = c(0, 5)) +
  labs(title = "",
    x = expression(paste("Optimum Length (", L[opt], ") (cm)", sep = "")),
    y = expression(paste("Zinc Concentration ", bgroup("(", frac('mg', '100g'), ")"), sep = ""))) +
  annotate(geom = "text", x = 80, y = 4.25,
    label = expression("p = 8.23 x 10"^-4)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Combine plots

# Combine yield plots (except protein)
ggarrange(a, c, e, i, k, m,
  common.legend = TRUE, legend = "right")
# annotate_figure(figure,
#   bottom = text_grob(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")"))),
#     vjust = -0.2))

# Save plot
ggsave(filename = "06_AdditionalAnalysis_Out/NutrientYieldLLoptGAMMs.jpeg", device = "jpeg",
  height = 9, width = 12, units = "in")

# Combine concentration plots (except protein)
ggarrange(b, d, f, j, l, n)

# Save plot
ggsave(filename = "06_AdditionalAnalysis_Out/NutrientConcentrationLoptLMs.jpeg", device = "jpeg",
  height = 9, width = 12, units = "in")


## Check LLopt and length

# Empty column for trip-level LLopt
CatchData$TripLLopt <- NA

# Add LLopt to CatchData
for (i in 1:nrow(CatchData)){
  
  # Extract TripID
  a <- CatchData$TripID[i]
  
  # Find trip-level LLopt
  b <- TripData$MeanLLopt[TripData$TripID == a]
  
  # Save to CatchData
  if (length(b) > 0){
    CatchData$TripLLopt[i] <- b
  }
  
}

# Plot the data
ggplot(data = CatchData, aes(x = TripLLopt, y = Length_cm, color = TrapType)) +
  geom_point(alpha = 0.2) +
  geom_smooth() +
  theme_minimal()


## Check relationship between CPUE and LLopt

# GAMM for CPUE - traditional traps
cpue.gamm.trad <- gamm(CPUE_kgPerTrap ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for CPUE - gated traps
cpue.gamm.gated <- gamm(CPUE_kgPerTrap ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
cpue.predict.trad <- predict_gam(cpue.gamm.trad$gam)
cpue.predict.gated <- predict_gam(cpue.gamm.gated$gam)

# Plot data and model predictions with daily value (RDA for children 1-3 years)
ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = CPUE_kgPerTrap)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = cpue.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = cpue.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = cpue.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = cpue.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  #xlab("") +
  xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Catch Per Unit Effort ", bgroup("(", frac(kg, trap), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 2), ylim = c(0, 30)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))

ggsave("06_AdditionalAnalysis_Out/CPUELLopt_GAMM.jpeg", device = "jpeg")




##### 6.12 LLopt and nutrient concentrations #####

## Calcium

# GAMM for calcium concentration - traditional traps
caconc.gamm.trad <- gamm(CaConc_mgPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for calcium concentration - gated traps
caconc.gamm.gated <- gamm(CaConc_mgPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
caconc.predict.trad <- predict_gam(caconc.gamm.trad$gam)
caconc.predict.gated <- predict_gam(caconc.gamm.gated$gam)

# Plot data and model predictions
a <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = CaConc_mgPer100g)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = caconc.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = caconc.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = caconc.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = caconc.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  xlab("") +
  #xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Calcium Concentration ", bgroup("(", frac(mg, '100 g'), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 35)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Iron

# GAMM for iron concentration - traditional traps
feconc.gamm.trad <- gamm(FeConc_mgPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for iron concentration - gated traps
feconc.gamm.gated <- gamm(FeConc_mgPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
feconc.predict.trad <- predict_gam(feconc.gamm.trad$gam)
feconc.predict.gated <- predict_gam(feconc.gamm.gated$gam)

# Plot data and model predictions
b <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = FeConc_mgPer100g)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = feconc.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = feconc.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = feconc.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = feconc.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  xlab("") +
  #xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Calcium Concentration ", bgroup("(", frac(mg, '100 g'), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 0.55)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Omega-3

# GAMM for omega-3 PUFA concentration - traditional traps
pufaconc.gamm.trad <- gamm(Omega3Conc_gPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for omega-3 PUFA concentration - gated traps
pufaconc.gamm.gated <- gamm(Omega3Conc_gPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
pufaconc.predict.trad <- predict_gam(pufaconc.gamm.trad$gam)
pufaconc.predict.gated <- predict_gam(pufaconc.gamm.gated$gam)

# Plot data and model predictions
c <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = Omega3Conc_gPer100g)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = pufaconc.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = pufaconc.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = pufaconc.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = pufaconc.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  xlab("") +
  #xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Omega-3 Concentration ", bgroup("(", frac(g, '100 g'), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 0.21)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Vitamin A

# GAMM for vitamin A concentration - traditional traps
vaconc.gamm.trad <- gamm(VAConc_ugPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for vitamin A concentration - gated traps
vaconc.gamm.gated <- gamm(VAConc_ugPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
vaconc.predict.trad <- predict_gam(vaconc.gamm.trad$gam)
vaconc.predict.gated <- predict_gam(vaconc.gamm.gated$gam)

# Plot data and model predictions
d <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = VAConc_ugPer100g)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = vaconc.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = vaconc.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = vaconc.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = vaconc.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  xlab("") +
  xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Vitamin A Concentration ", bgroup("(", frac(paste("\u00b5", g, sep = ""), '100g'), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 80)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Selenium

# GAMM for selenium concentration - traditional traps
seconc.gamm.trad <- gamm(SeConc_ugPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for selenium concentration - gated traps
seconc.gamm.gated <- gamm(SeConc_ugPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
seconc.predict.trad <- predict_gam(seconc.gamm.trad$gam)
seconc.predict.gated <- predict_gam(seconc.gamm.gated$gam)

# Plot data and model predictions
e <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = SeConc_ugPer100g)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = seconc.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = seconc.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = seconc.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = seconc.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  xlab("") +
  xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Selenium Concentration ", bgroup("(", frac(paste("\u00b5", g, sep = ""), '100g'), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 25)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Zinc

# GAMM for zinc concentration - traditional traps
znconc.gamm.trad <- gamm(ZnConc_ugPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.trad)

# GAMM for zinc concentration - gated traps
znconc.gamm.gated <- gamm(ZnConc_ugPer100g ~ s(MeanLLopt),
  random = list(Site = ~1),
  data = TripData.sub.gated)

# Generate model predictions
znconc.predict.trad <- predict_gam(znconc.gamm.trad$gam)
znconc.predict.gated <- predict_gam(znconc.gamm.gated$gam)

# Plot data and model predictions
f <- ggplot(data = TripData.sub.traptype, mapping = aes(x = MeanLLopt, y = ZnConc_ugPer100g)) +
  geom_point(alpha = 0.1, aes(color = TrapType)) +
  scale_color_manual(values = cbPalette[c(2,4)]) +
  geom_line(data = znconc.predict.trad,
    aes(x = MeanLLopt, y = fit), color = cbPalette[4]) +
  geom_ribbon(data = znconc.predict.trad,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  geom_line(data = znconc.predict.gated,
    aes(x = MeanLLopt, y = fit), color = cbPalette[2]) +
  geom_ribbon(data = znconc.predict.gated,
    aes(x = MeanLLopt, ymin = (fit - se.fit), ymax = (fit + se.fit)),
    alpha = 0.2, linetype = 0,
    inherit.aes = FALSE) +
  xlab("") +
  xlab(expression(paste("Length : Optimum Length ", bgroup("(", frac(L, L[opt]), ")")))) +
  ylab(expression(paste("Zinc Concentration ", bgroup("(", frac(mg, '100g'), ")")))) +
  labs(color = "Trap Type") +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) +
  coord_cartesian(xlim = c(0, 1.5), ylim = c(0, 1.3)) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
    panel.background = element_blank(),
    legend.key = element_rect(fill = "white"),
    axis.line = element_line(colour = "black"),
    plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"))


## Combine plots

# Combine plots
ggarrange(a, b, c, d, e, f,
  common.legend = TRUE, legend = "right")

# Save plot
ggsave(filename = "06_AdditionalAnalysis_Out/NutrientConcentrationLLoptGAMMs.jpeg", device = "jpeg",
  height = 9, width = 12, units = "in")





