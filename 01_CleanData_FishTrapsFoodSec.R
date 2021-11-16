##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning

## Script Title:
##    01 Data Cleaning

## Last update: 11 Nov 21




## Table of Contents
##    1.1 Load Packages and Data
##    1.2 "TRAP NO." Column
##    1.3 "Site" Column
##    1.4 "SPECIES" Column
##    1.5 Add a column for FunGr_Diet


# First, clean the environment
rm(list = ls())




##### 1.1 Load Packages and Data #####

# Load packages
library(readxl)
library(data.table)
library(stringr)

# Load WCS combined gated trap data for 2010-2019
TrapData <- read_excel("00_RawData/CombinedTrapData_2010_2019.xlsx")




##### 1.2 "TRAP NO." Column #####

# Make the "TRAP NO." column uniform. Rows with mesh sizePossible values will be:
#     G2
#     G2/3
#     G3
#     G4
#     G6
#     G8
#     T

# A table of variables in the "TRAP NO." column
table(TrapData$`TRAP NO.`, useNA = "ifany")

# Delete observations of mesh size treatments
TrapData <- TrapData[!TrapData$`TRAP NO.` %like% "Mesh",]

# Coerce all values to the list of appropriate values above

  # Replace 2 with G2
  TrapData$`TRAP NO.` <- replace(TrapData$`TRAP NO.`, TrapData$`TRAP NO.`=="2", "G2")
  
  # Replace 3 with G3
  TrapData$`TRAP NO.` <- replace(TrapData$`TRAP NO.`, TrapData$`TRAP NO.` == "3", "G3")
  
  # Replace 4 with G4
  TrapData$`TRAP NO.` <- replace(TrapData$`TRAP NO.`, TrapData$`TRAP NO.` == "4", "G4")
  
  # Remove all spaces (G 2; G 2/3; G 3; G 4)
  TrapData$`TRAP NO.` <- gsub(" ", "", TrapData$`TRAP NO.`)

# Fill in NA's where possible
for (i in 1:length(TrapData$`TRAP NO.`)){
  
  # If the Trap No. is NA...
  if (is.na(TrapData$`TRAP NO.`[i]) == TRUE){
    
    # Save a as NA as a placeholder
    a <- NA
    
    # ...and there is a value in the Gap Size (cm) column,
    if (is.na(TrapData$`Gap size (Cms)`[i]) == FALSE){
      
      # save the Gap Size (cm) value as a
      a <- TrapData$`Gap size (Cms)`[i]
      
    }
    
    # ...and the Trap Type is TM, traditional, or Traditional,
    if (TrapData$`TRAP TYPE`[i] == "TM" || TrapData$`TRAP TYPE`[i] == "traditional" || TrapData$`TRAP TYPE`[i] == "Traditional"){
      
      # save T as b
      b <- "T"
      
    } else{
      
      # save G as b if it's a gated trap
      b <- "G"
      
    }
    
    # If b and a don't disagree and it's a traditional trap...
    if (b == "T"){
      if (a == 0 || is.na(TrapData$`Gap size (Cms)`[i]) == TRUE){
        
        # Change the Trap No. value to T
        TrapData$`TRAP NO.`[i] <- "T"
        
      }
      
    }
    
    # If b and a don't disagree and it's a gated trap...
    if (b == "G" && is.na(TrapData$`Gap size (Cms)`[i]) == FALSE && a != 0){
      
      # Save the correct trap number
      TrapData$`TRAP NO.`[i] <- paste(b, a, sep="")
      
    }
   
  }
  
}

# All the values in the "TRAP NO." column now use consistent labels. If there was no value and
#   information could be obtained from the "Gap Size (Cms)" or "Gap Size 3/2 (Cms)" columns, a value
#   has been added.
  
# NEXT STEP: Use the "TRAP TYPE" column to fill in the rest of the NA's if possible (there are 1735).




##### 1.3 "Site" Column #####

# Put all elements in the "Site" column into title case
TrapData$Site <- str_to_title(TrapData$Site)




##### 1.4 "SPECIES" Column #####

table(TrapData$SPECIES, useNA = "ifany")

# Clean the "SPECIES" Column of the TrapData data frame

# Remove excess whites space
TrapData$SPECIES <- str_squish(TrapData$SPECIES)

# Set capitalization to Genus species
TrapData$SPECIES <- str_to_sentence(TrapData$SPECIES)

# Make a separate data frame to proofread "SPECIES" column for typos
Unique_Species <- unique(TrapData$SPECIES)

# Sort alphabetically
Unique_Species <- sort(Unique_Species)

# Save list of species to a *.csv file
write.csv(Unique_Species, file = "01_CleanData_Temp/Species_List.csv")




##### 1.5 Add a column for FunGr_Diet #####

# Create an empty column in TrapData for Fun.Diet
TrapData$FunGr_Diet <- NA








