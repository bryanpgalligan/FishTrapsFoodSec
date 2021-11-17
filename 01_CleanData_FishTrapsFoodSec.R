##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning

## Script Title:
##    01 Data Cleaning

## Last update: 17 Nov 21




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
library(taxize)
  library(dplyr)
  library(magrittr)
library(rfishbase)

# Load WCS combined gated trap data for 2010-2019
TrapData <- read_excel("00_RawData/CombinedTrapData_2010_2019.xlsx")

# Load Condy's key for diet based functional groups
FunGrKey_Condy <- read_excel("00_RawData/FunctionalGroupKey_DietBased_Condy2015.xlsx")




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

# Clean the "SPECIES" Column of the TrapData data frame

# Fix formatting

  # Remove excess white space
  TrapData$SPECIES <- str_squish(TrapData$SPECIES)
  
  # Set capitalization to Genus species
  TrapData$SPECIES <- str_to_sentence(TrapData$SPECIES)

# Check for typos
  
  # Make a unique list of species names, sorted alphabetically
  Unique_Species <- unique(TrapData$SPECIES)
  Unique_Species <- sort(Unique_Species)
  
  # Save Unique_Species as a *.csv file
  write.csv(Unique_Species, file = "01_CleanData_Temp/Unique_Species.csv",
    row.names = FALSE)
  
  # After reviewing the list manually, I found the following errors:
    # Monotaxinae grandoculus was listed as a species name. Genus should be Monotaxis.
    # Parapeneus cyclostomus was listed. Genus should be Parupeneus.
    # Parupeneaus indicus was listed. Genus should be Parupeneus.
    # Plectohinchus cryterinus was listed. It should be Plectorhinchus gaterinus.
  
  # The Parupeneas spp. are fixed by taxize::gnr_resolve() so do not need to be done manually.
  
  # Replace Monotaxinae grandoculus with Monotaxis grandoculus.
  TrapData$SPECIES <- gsub("Monotaxinae", "Monotaxis", TrapData$SPECIES)
  
  # Replace P. cryterinus with P. gaterinus.
  TrapData$SPECIES <- gsub("Plectohinchus cryterinus", "Plectorhinchus gaterinus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Update Unique_Species to reflect the removal of Monotaxinae
  Unique_Species <- unique(TrapData$SPECIES)
  
  # Obtain accurate scientific names using the taxize package
  CanonicalTaxa <- gnr_resolve(Unique_Species, best_match_only = TRUE, canonical = TRUE)
  
  # CanonicalTaxa successfully identified 224 of 225 species names. The last one is NA.
  
# Replace misspelled scientific names with the accurate ones.
  
  # Delete all rows of CanonicalTaxa that did not find misspellings.
  CanonicalTaxa <- subset(CanonicalTaxa,
    CanonicalTaxa$user_supplied_name != CanonicalTaxa$matched_name2)
  
  # We found 30 misspellings!
  
  # Replace misspelled species names in TrapData with the correct names from species_names
  for (i in 1:length(CanonicalTaxa$user_supplied_name)){
    
    TrapData$SPECIES <- gsub(CanonicalTaxa$user_supplied_name[i], CanonicalTaxa$matched_name2[i],
      TrapData$SPECIES, fixed = TRUE)
    
  }

    
 

##### 1.5 Add a column for FunGr_Diet #####

# Delete the empty first row from Condy's functional group key
FunGrKey_Condy <- FunGrKey_Condy[-1,]

# Create an empty column in TrapData for FunGr_Diet
TrapData$FunGr_Diet <- NA

# Fill in FunGr_Diet column to the extent possible with Condy's key
for(i in 1:length(TrapData$FunGr_Diet)){
  
  # Test whether this observation in TrapData corresponds to one of the species included
  #   in Condy's table.
  if(TrapData$SPECIES[i] %in% FunGrKey_Condy$Species){
    
    # Find the index of the species match
    a <- str_which(FunGrKey_Condy$Species, TrapData$SPECIES[i])
    
    # Fill in the FunGr_Diet column at i
    TrapData$FunGr_Diet[i] <- FunGrKey_Condy$`Functional Group`[a]
    
  }
  
}

# Create a list of species included in TrapData but not in Condy's key
Species_NewFunGrKey <- unique(
  subset(TrapData$SPECIES, !(TrapData$SPECIES %in% FunGrKey_Condy$Species)))

# Query FishBase for the first species' food items
diet_items(Species_NewFunGrKey[1])

# Possible next step: write a script that will automatically query FishBase and classify species
#   into the diet based functional groups, which are:

#   Browser
#   Detritivore
#   Grazer
#   Invert-Macro
#   Invert-Micro
#   Pisc-Macro-Invert
#   Piscivore
#   Planktivore
#   Scrapers/Excavators





