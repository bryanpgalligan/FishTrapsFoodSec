##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning
##    02 Stability

## Script Title:
##    02 Stability

## Last update: 22 Dec 21




## Table of Contents
#     2.1 Load Packages and Data
#     2.2 FunGr_Diet
#     2.2.1 Data Manipulation
#     2.2.2 Analysis




# First, clean the environment
rm(list = ls())




##### 2.1 Load Packages and Data #####

# Load packages
library(readr)
library(tidyr)
library(dplyr)
library(AICcmodavg)

# Load Trap Data
TrapData <- read_csv("01_CleanData_Out/TrapData_Cleaned.csv")




##### 2.2 FunGr_Diet #####

## Hypothesis: Experimental traps contribute to reef resilience by catching fewer browsers,
##  scrapers, and grazers.


## Independent variables:
##    TrapType (categorical, 2 levels)
##    GateCode (categorical, 7 levels) *blocking variable
##    Site (categorical, 20 levels)

## Dependent variable:
##    Catch composition

##### 2.2.1 Data Manipulation #####

# Delete all rows with NA for FunGr_Diet
TrapData_FunGrDiet <- TrapData[!is.na(TrapData$FunGr_Diet),]

# Delete all rows with NA for GateCode
TrapData_FunGrDiet <- TrapData_FunGrDiet[!is.na(TrapData_FunGrDiet$GateCode),]

# Bin all non-browsers/scrapers/grazers into one functional group ("Other")
for(i in 1:length(TrapData_FunGrDiet$FunGr_Diet)){
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Cleaner"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Detritivore"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Invert-Macro"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Invert-Micro"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Pisc-Macro-Invert"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Piscivore"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Planktivore"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Predator"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
  if(TrapData_FunGrDiet$FunGr_Diet[i] == "Variable"){
    TrapData_FunGrDiet$FunGr_Diet[i] <- "Other"
  }
  
}

# Preliminary data frame of unique variable combinations for ANOVA
GateCode <- unique(TrapData_FunGrDiet$GateCode)
Site <- unique(TrapData_FunGrDiet$Site)
AOV_FunGrDiet <- expand_grid(GateCode, Site)

# Add columns to data AOV Data Frame
AOV_FunGrDiet$TrapType <- NA
AOV_FunGrDiet$BrowserCt <- NA
AOV_FunGrDiet$BrowserMass_g <- NA
AOV_FunGrDiet$BrowserCtRatio <- NA
AOV_FunGrDiet$BrowserMassRatio <- NA
AOV_FunGrDiet$GrazerCt <- NA
AOV_FunGrDiet$GrazerMass_g <- NA
AOV_FunGrDiet$GrazerCtRatio <- NA
AOV_FunGrDiet$GrazerMassRatio <- NA
AOV_FunGrDiet$ScraperCt <- NA
AOV_FunGrDiet$ScraperMass_g <- NA
AOV_FunGrDiet$ScraperCtRatio <- NA
AOV_FunGrDiet$ScraperMassRatio <- NA
AOV_FunGrDiet$OtherCt <- NA
AOV_FunGrDiet$OtherMass_g <- NA
AOV_FunGrDiet$OtherCtRatio <- NA
AOV_FunGrDiet$OtherMassRatio <- NA
AOV_FunGrDiet$KeyHerbivoreCt <- NA
AOV_FunGrDiet$KeyHerbivoreMass_g <- NA
AOV_FunGrDiet$KeyHerbivoreCtRatio <- NA
AOV_FunGrDiet$KeyHerbivoreMassRatio <- NA
AOV_FunGrDiet$TotalCt <- NA
AOV_FunGrDiet$TotalMass_g <- NA

# Fill in TrapType column of AOV data frame
for (i in 1:length(AOV_FunGrDiet$TrapType)){
  
  if(AOV_FunGrDiet$GateCode[i] == "T"){
    AOV_FunGrDiet$TrapType[i] <- "Traditional"
  } else{
    AOV_FunGrDiet$TrapType[i] <- "Gated"
  }
  
}

# Fill in count and mass columns of AOV Data Frame
for (i in 1:length(AOV_FunGrDiet$GateCode)){
  
  # Subset data applicable to this row
  a <- subset(TrapData_FunGrDiet, 
    GateCode == AOV_FunGrDiet$GateCode[i] & Site == AOV_FunGrDiet$Site[i])
  
  # Calculate BrowserCt
  AOV_FunGrDiet$BrowserCt[i] <- sum(a$FunGr_Diet == "Browser")
  
  # Calculate GrazerCt
  AOV_FunGrDiet$GrazerCt[i] <- sum(a$FunGr_Diet == "Grazer")
  
  # Calculate ScraperCt
  AOV_FunGrDiet$ScraperCt[i] <- sum(a$FunGr_Diet == "Scrapers/Excavators")
  
  # Calculate OtherCt
  AOV_FunGrDiet$OtherCt[i] <- sum(a$FunGr_Diet == "Other")
  
  # Calculate TotalCt
  AOV_FunGrDiet$TotalCt[i] <- length(a$FunGr_Diet)
  
  # Calculate BrowserMass_g
  b <- subset(a, a$FunGr_Diet == "Browser")
  AOV_FunGrDiet$BrowserMass_g[i] <- sum(b$Weight_g, na.rm = TRUE)
  
  # Calculate GrazerMass_g
  b <- subset(a, a$FunGr_Diet == "Grazer")
  AOV_FunGrDiet$GrazerMass_g[i] <- sum(b$Weight_g, na.rm = TRUE)
  
  # Calculate ScraperMass_g
  b <- subset(a, a$FunGr_Diet == "Scrapers/Excavators")
  AOV_FunGrDiet$ScraperMass_g[i] <- sum(b$Weight_g, na.rm = TRUE)
  
  # Calculate OtherMass_g
  b <- subset(a, a$FunGr_Diet == "Other")
  AOV_FunGrDiet$OtherMass_g[i] <- sum(b$Weight_g, na.rm = TRUE)
  
  # Calculate TotalMass
  AOV_FunGrDiet$TotalMass_g[i] <- sum(a$Weight_g, na.rm = TRUE)
  
}

# Fill in ratio columns of AOV data frame
AOV_FunGrDiet$BrowserCtRatio <- AOV_FunGrDiet$BrowserCt / AOV_FunGrDiet$TotalCt
AOV_FunGrDiet$BrowserMassRatio <- AOV_FunGrDiet$BrowserMass_g / AOV_FunGrDiet$TotalMass_g
AOV_FunGrDiet$GrazerCtRatio <- AOV_FunGrDiet$GrazerCt / AOV_FunGrDiet$TotalCt
AOV_FunGrDiet$GrazerMassRatio <- AOV_FunGrDiet$GrazerMass_g / AOV_FunGrDiet$TotalMass_g
AOV_FunGrDiet$ScraperCtRatio <- AOV_FunGrDiet$ScraperCt / AOV_FunGrDiet$TotalCt
AOV_FunGrDiet$ScraperMassRatio <- AOV_FunGrDiet$ScraperMass_g / AOV_FunGrDiet$TotalMass_g
AOV_FunGrDiet$OtherCtRatio <- AOV_FunGrDiet$OtherCt / AOV_FunGrDiet$TotalCt
AOV_FunGrDiet$OtherMassRatio <- AOV_FunGrDiet$OtherMass_g / AOV_FunGrDiet$TotalMass_g

# Fill in Key Herbivore columns of AOV data frame
AOV_FunGrDiet$KeyHerbivoreCt <- AOV_FunGrDiet$BrowserCt + AOV_FunGrDiet$GrazerCt + AOV_FunGrDiet$ScraperCt
AOV_FunGrDiet$KeyHerbivoreMass_g <- AOV_FunGrDiet$BrowserMass_g + AOV_FunGrDiet$GrazerMass_g + AOV_FunGrDiet$ScraperMass_g
AOV_FunGrDiet$KeyHerbivoreCtRatio <- AOV_FunGrDiet$KeyHerbivoreCt / AOV_FunGrDiet$TotalCt
AOV_FunGrDiet$KeyHerbivoreMassRatio <- AOV_FunGrDiet$KeyHerbivoreMass_g / AOV_FunGrDiet$TotalMass_g

# Remove rows of AOV data frame where mass = 0 g
AOV_FunGrDiet <- subset(AOV_FunGrDiet, AOV_FunGrDiet$TotalMass_g > 0)





##### 2.2.2 Analysis #####

## Catch Composition using count ratio (no. of key herbivores)

# Variables interacting, blocking variable included
CatchComposition_DietCt_InteractingBlocking <- aov(KeyHerbivoreCtRatio ~ TrapType * Site + GateCode, data = AOV_FunGrDiet)

# Variables interacting, no blocking variable
CatchComposition_DietCt_Interacting <- aov(KeyHerbivoreCtRatio ~ TrapType * Site, data = AOV_FunGrDiet)

# Variables not interacting
CatchComposition_DietCt_NonInteracting <- aov(KeyHerbivoreCtRatio ~ TrapType + Site, data = AOV_FunGrDiet)

# GateCode instead of TrapType
CatchComposition_DietCt_GateCode <- aov(KeyHerbivoreCtRatio ~ GateCode + Site, data = AOV_FunGrDiet)

## Compare four ANOVA's using AIC

# List of models
model.list <- list(CatchComposition_DietCt_InteractingBlocking, CatchComposition_DietCt_Interacting,
  CatchComposition_DietCt_NonInteracting, CatchComposition_DietCt_GateCode)

# Model names
model.names <- c("IntBlock", "Int", "NonInt", "GateCode")

# Compare using AIC
CatchComposition_DietCt_ModelComparison <- aictab(model.list, modnames = model.names)

# The favored model uses TrapType (not GateCode), non-interacting and no blocking variable!

# Save model comparison results
write.csv(CatchComposition_DietCt_ModelComparison, file = "02_Stability_Out/CatchComposition_DietCt_ModelComparison.csv")

# Save model results
CatchComposition_DietCt_Results <- summary(CatchComposition_DietCt_NonInteracting)
CatchComposition_DietCt_Results
write.csv(CatchComposition_DietCt_Results[[1]], file = "02_Stability_Out/CatchComposition_DietCt_Results.csv")

# We find a significant relationship between site and catch composition but not between TrapType and composition!


## Catch composition using mass ratio (mass of key herbivores)

# Variables interacting, blocking variable included
CatchComposition_DietMass_InteractingBlocking <- aov(KeyHerbivoreMassRatio ~ TrapType * Site + GateCode, data = AOV_FunGrDiet)

# Variables interacting, no blocking variable
CatchComposition_DietMass_Interacting <- aov(KeyHerbivoreMassRatio ~ TrapType * Site, data = AOV_FunGrDiet)

# Variables not interacting
CatchComposition_DietMass_NonInteracting <- aov(KeyHerbivoreMassRatio ~ TrapType + Site, data = AOV_FunGrDiet)

# GateCode instead of TrapType
CatchComposition_DietMass_GateCode <- aov(KeyHerbivoreMassRatio ~ GateCode + Site, data = AOV_FunGrDiet)


## Compare four ANOVA's using AIC

# List of models
model.list <- list(CatchComposition_DietMass_InteractingBlocking, CatchComposition_DietMass_Interacting,
  CatchComposition_DietMass_NonInteracting, CatchComposition_DietMass_GateCode)

# Model names
model.names <- c("IntBlock", "Int", "NonInt", "GateCode")

# Compare using AIC
CatchComposition_DietMass_ModelComparison <- aictab(model.list, modnames = model.names)

# Again, the favored model uses TrapType (not GateCode), non-interacting and no blocking variable!

# Save model comparison results
write.csv(CatchComposition_DietMass_ModelComparison, file = "02_Stability_Out/CatchComposition_DietMass_ModelComparison.csv")

# Save model results
CatchComposition_DietMass_Results <- summary(CatchComposition_DietMass_NonInteracting)
CatchComposition_DietMass_Results
write.csv(CatchComposition_DietMass_Results[[1]], file = "02_Stability_Out/CatchComposition_DietMass_Results.csv")

# Again, we find a significant effect of site, but not of trap type!


## Now, test the catch composition : count ratio across all sites

# A list of sites
site.list <- unique(AOV_FunGrDiet$Site)



# A data frame to hold sites and p-values
site.anovas <- as.data.frame(site.list)
site.anovas$p.ctratio <- NA
site.anovas$p.massratio <- NA

# Run the favored model structure on each site
for (i in 1:length(site.list)){
  
  # Temporary data frame for this site's data
  a <- subset(AOV_FunGrDiet, AOV_FunGrDiet$Site == site.list[i])
    
  # Run the ct ratio ANOVA
  b <- t.test(KeyHerbivoreCtRatio ~ TrapType, data = a)
  
  # Run the mass ratio ANOVA
  c <- t.test(KeyHerbivoreMassRatio ~ TrapType, data = a)
  
  # Ct ANOVA results
  d <- summary(b)
  
  # Mass ANOVA results
  e <- summary(c)
  
  # Extract the p-values
  p.ct <- d[[1]]$`Pr(>F)`[1]
  p.mass <- e[[1]]$`Pr(>F)`[1]
  
  # Save p-values to dataframe
  site.anovas$p.ctratio[i] <- p.ct
  site.anovas$p.massratio[i] <- p.mass
  
}




