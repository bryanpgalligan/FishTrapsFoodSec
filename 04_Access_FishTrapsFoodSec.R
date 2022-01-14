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
##    04 Access

## Last update: 13 Jan 22




## Table of Contents
#     4.1 Load Packages and Data
#     4.2 Clean Data
#     4.3 Total Catch (Mass)
#     4.3.1 CPUE
#     4.3.2 CPUE By Site




# First, clean the environment
rm(list = ls())




##### 4.1 Load Packages and Data #####

# Load packages
library(readr)

# Load TrapData
TrapData <- read_csv("01_CleanData_Out/TrapData_Cleaned.csv", 
  col_types = cols(Date = col_date(format = "%Y-%m-%d")))




##### 4.2 Clean Data #####

## Remove all fishing trips with multiple trap types used

# List of unique fishing trips
unique.trips <- unique(TrapData$TripID)

# Empty vector to make list of useable trips
trips.sametrap <- c()

# Make list of useable trips
for(i in 1:length(unique.trips)){
  
  # Temporary data frame of just this trip
  a <- subset(TrapData, TrapData$TripID == unique.trips[i])
  
  # Find how many trap types there are (1 or 2)
  b <- length(unique(a$TrapType))
  
  # If there is only one trap type, add this Trip ID to our list of useable trips
  if(b == 1){
    
    trips.sametrap <- append(trips.sametrap, unique.trips[i], after = length(trips.sametrap))
    
  }
  
}




##### 4.3 Total Catch (Mass) #####

## Does trap type influence CPUE (kg/trap)?

##### 4.3.1 CPUE #####

# Create data frame for this question
CPUE_Data <- data.frame(trips.sametrap)
colnames(CPUE_Data) <- "TripID"
CPUE_Data$TrapType <- NA
CPUE_Data$GateCode <- NA
CPUE_Data$Site <- NA
CPUE_Data$Catch_g <- NA
CPUE_Data$Catch_kg <- NA
CPUE_Data$Effort_traps <- NA
CPUE_Data$CPUE <- NA

# Fill in CPUE_Data
for(i in 1:length(CPUE_Data$TripID)){
  
  # Subset this trip from TrapData
  a <- subset(TrapData, TrapData$TripID == CPUE_Data$TripID[i])
  
  # Trap Type
  CPUE_Data$TrapType[i] <- a$TrapType[1]
  
  # Gate Code
  CPUE_Data$GateCode[i] <- a$GateCode[1]
  
  # Site
  CPUE_Data$Site[i] <- a$Site[1]
  
  # Catch (g)
  CPUE_Data$Catch_g[i] <- sum(a$Weight_g)
  
  # Effort (traps)
  CPUE_Data$Effort_traps[i] <- a$TrapsFished[1]
  
}

# Fill in Catch_kg column of CPUE_Data
CPUE_Data$Catch_kg <- CPUE_Data$Catch_g / 1000

# Fill in CPUE column of CPUE_Data
CPUE_Data$CPUE <- CPUE_Data$Catch_kg / CPUE_Data$Effort_traps

# Remove rows where NA occurs
CPUE_Data <- CPUE_Data[!is.na(CPUE_Data$Effort_traps),]
CPUE_Data <- CPUE_Data[!is.na(CPUE_Data$Catch_kg),]

# Save CPUE_Data
write.csv(CPUE_Data, file = "04_Access_Out/CPUE_Data.csv")

## Create and test four ANOVA's

# Variables interacting, blocking variable included
CPUE_IntBlock <- aov(CPUE ~ TrapType * Site + GateCode, data = CPUE_Data)

# Variables interacting, no blocking variable
CPUE_Int <- aov(CPUE ~ TrapType * Site, data = CPUE_Data)

# Variables not interacting, no blocking variable
CPUE_NoInt <- aov(CPUE ~ TrapType + Site, data = CPUE_Data)

# GateCode instead of TrapType
CPUE_GateCode <- aov(CPUE ~ GateCode + Site, data = CPUE_Data)

## Compare four ANOVA's using AIC

# List of models
model.list <- list(CPUE_IntBlock, CPUE_Int, CPUE_NoInt, CPUE_GateCode)

# Model names
model.names <- c("IntBlock", "Int", "NonInt", "GateCode")

# Compare using AIC
CPUE_ModelComparison <- aictab(model.list, modnames = model.names)

# The favored model is Interacting and Blocking!

# Save model comparison results
write.csv(CPUE_ModelComparison, file = "04_Access_Out/CPUE_ModelComparison.csv")

# Save model results
CPUE_Results <- summary(CPUE_IntBlock)
CPUE_Results
write.csv(CPUE_Results[[1]], file = "04_Access_Out/CPUE_Results.csv")

# We got super small p-values for all independent variables!

# Test the normality of residuals (qq plot)
ggqqplot(residuals(CPUE_IntBlock))

# The residuals DO NOT look okay

# Test homogeneity of variance
CPUE_Data %>%
  levene_test(CPUE ~ TrapType * Site)

# We DO NOT have homogeneity of variance




##### 4.3.2 CPUE By Site #####

# Test CPUE at each site

# Vector of each unique site for gated traps
a <- subset(CPUE_Data, CPUE_Data$TrapType == "Gated")
b <- unique(a$Site)

# Vector of each unique site for traditional traps
a <- subset(CPUE_Data, CPUE_Data$TrapType == "Traditional")
c <- unique(a$Site)

# Vector of sites with both trap types
SitesToTest <- intersect(b,c)

# Empty vectors to fill in with the loop
Site <- NA
p.value <- NA

# Test the preferred ANOVA structure for each site (removing site for obvious reasons)
for(i in 1:length(SitesToTest)){
  
  # Save the site name in question
  a <- SitesToTest[i]
  
  # Subset the data for only this site
  b <- subset(CPUE_Data, CPUE_Data$Site == a)
  
  # Run the ANOVA
  c <- aov(CPUE ~ TrapType + GateCode, data = b)
  
  # Save the p-value for the trap type variable
  p <- summary(c)[[1]]$`Pr(>F)`[1]
  
  # Save the site name
  Site <- append(Site, a, after = length(Site))
  
  # Save the p-value
  p.value <- append(p.value, p, after = length(p.value))
  
}

# Combine vectors into a data frame
Site_CPUE_p <- data.frame(Site, p.value)

# Delete rows with NA for site
Site_CPUE_p <- Site_CPUE_p[!is.na(Site_CPUE_p$Site),]

# Save results
write.csv(Site_CPUE_p, file = "04_Access_Out/CPUEBySite_pvalues.csv")



