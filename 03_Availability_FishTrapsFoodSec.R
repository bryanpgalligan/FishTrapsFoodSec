##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning
##    02 Stability
##    03 Availability

## Script Title:
##    03 Availability

## Last update: 23 Dec 21




## Table of Contents
#     3.1 Load Packages and Data
#     3.2 Life History Parameters




# First, clean the environment
rm(list = ls())



##### 3.1 Load Packages and Data #####

# Load packages
library(readr)
library(rfishbase)

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



