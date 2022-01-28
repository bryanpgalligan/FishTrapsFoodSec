##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning
##    02 Stability
##    03 Availability
##    04 Access
##    06 Tables and Figures

## Script Title:
##    03 Availability

## Last update: 28 Jan 22




## Table of Contents
#     3.1 Load Packages and Data
#     3.2 Life History Parameters
#
#     3.x Median length




# First, clean the environment
rm(list = ls())



##### 3.1 Load Packages and Data #####

# Load packages
library(readr)
library(rfishbase)
library(AICcmodavg)

# Load TrapData
TrapData <- read_csv("01_CleanData_Out/TrapData_Cleaned.csv", 
  col_types = cols(Date = col_date(format = "%Y-%m-%d")))




##### 3.2 Life History Parameters #####

# Add columns for Lmat and Lopt
TrapData$Lmat <- NA
TrapData$Lopt <- NA

# Create an empty data frame for unique species, Lmat, Lopt, and Linf
life.hx.params <- as.data.frame(unique(TrapData$Species))
colnames(life.hx.params)[1] <- "Species"
life.hx.params$Lmat <- NA
life.hx.params$Lopt <- NA
life.hx.params$Linf <- NA

# NB: these params are mentioned for three species in Hicks & McClanahan (2012). They recalculated them based
# on Linf (or L max if that's a different thing?).




##### 3.x Length #####

## Test the effect of trap type on median length

# Remove all rows with no length observation
LengthData <- TrapData[!is.na(TrapData$Length_cm),]

## Create four ANOVA models to compare

# Variables interacting, blocking variable included
Length_IntBlock <- aov(Length_cm ~ TrapType * Site + GateCode, data = LengthData)

# Variables interacting, no blocking variable
Length_Int <- aov(Length_cm ~ TrapType * Site, data = LengthData)

# Variables not interacting, no blocking variable
Length_NoInt <- aov(Length_cm ~ TrapType + Site, data = LengthData)

# GateCode instead of TrapType
Length_GateCode <- aov(Length_cm ~ GateCode + Site, data = LengthData)

## Compare four ANOVA's using AIC

# List of models
model.list <- list(Length_IntBlock, Length_Int, Length_NoInt, Length_GateCode)

# Model names
model.names <- c("IntBlock", "Int", "NonInt", "GateCode")

# Compare using AIC
Length_ModelComparison <- aictab(model.list, modnames = model.names)

# The favored model is Interacting and Blocking!

# Save model comparison results
write.csv(Length_ModelComparison, file = "03_Availability_Out/LengthAOV_ModelComparison.csv")

# Save model results
LengthAOV_Results <- summary(Length_IntBlock)
LengthAOV_Results
write.csv(LengthAOV_Results[[1]], file = "03_Availability_Out/LengthAOV_Results.csv")

# We got super small p-values for all independent variables!

# Test the normality of residuals (qq plot)
ggqqplot(residuals(Length_IntBlock))
ggsave("03_Availability_Temp/LengthQQ.jpeg", device = "jpeg")

# The residuals DO NOT look okay

# Test homogeneity of variance
LengthData %>%
  levene_test(Length_cm ~ TrapType * Site)

# We DO NOT have homogeneity of variance

# Save LengthData
write.csv(LengthData, "03_Availability_Out/LengthData.csv")

# AOV with length data log transformed
LogLength_AOV <- aov(log(Length_cm + 1) ~ TrapType * Site + GateCode, data = LengthData)

# Test normality of residuals
ggqqplot(residuals(LogLength_AOV))

# The residuals are problematic again.

# Let's try the Tweedie GLMM
LengthTweedie <- glmmTMB(Length_cm ~ TrapType + (1|Site),
  data = LengthData, family = "tweedie")
    
    # Check the model results.
    summary(LengthTweedie)
    
    # The results are similar - still significant.

    # Run model diagnostics
    simulateResiduals(LengthTweedie, n = 250, plot = TRUE)

    # The diagnostics are not ideal, but they are interpretable.
    
    # Present the model results as ANOVA and save
    LengthTweedie_AOV <- glmmTMB:::Anova.glmmTMB(LengthTweedie)
    write.csv(LengthTweedie_AOV, file = "03_Availability_Out/LengthTweedie_Results.csv")

    # Test group size ratio to see if you can ignore the significant Levene test
    #   (homogeneity of variance)
    a <- length(
      subset(LengthData$Length_cm, LengthData$TrapType == "Traditional")
    )
    b <- length(
      subset(LengthData$Length_cm, LengthData$TrapType == "Gated")
    )
    a/b
    
    # The ratio is 1.04, which means we are okay because it is less than 1.5.
