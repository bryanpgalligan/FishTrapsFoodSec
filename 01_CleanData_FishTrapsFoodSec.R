##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning

## Script Title:
##    01 Data Cleaning

## Last update: 22 Nov 21




## Table of Contents
##    1.1 Load Packages and Data
##    1.2 "TRAP NO." Column
##    1.3 "Site" Column
##    1.4 "SPECIES" Column
##    1.5 "FunGr_Diet" Column


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

# Make the "TRAP NO." column uniform. Possible values will be:
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
  
  # Update Unique_Species to reflect the above changes
  Unique_Species <- unique(TrapData$SPECIES)
  
  # Obtain accurate scientific names using the taxize package
  CanonicalTaxa <- gnr_resolve(Unique_Species, best_match_only = TRUE, canonical = TRUE)
  
  # CanonicalTaxa successfully identified all species names (224 species plus NA).
  
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

    
 

##### 1.5 FunGr_Diet Column #####

# First, using the key from Condy et al. 2015  

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

# Second, query FishBase to fill in as much as possible  

  # Create a list of species included in TrapData but not in Condy's key
  FunGrKey_New <- as.data.frame(
    unique(
      subset(TrapData$SPECIES, 
        !(TrapData$SPECIES %in% FunGrKey_Condy$Species))))
  
  # Rename first column
  colnames(FunGrKey_New) <- c("Species")
  
  # Remove NA
  FunGrKey_New <- na.omit(FunGrKey_New)
  
  # Add feeding type by querying FishBase
  FunGrKey_New <- ecology(FunGrKey_New$Species, fields = c("Species", "FeedingType"))
  
  # FishBase includes the following feeding types:
  #   hunting macrofauna (predator)
  #   NA
  #   variable
  #   grazing on aquatic plants
  #   selective plankton feeding
  #   picking parasites off a host (cleaner)
  #   browsing on substrate
  #   other
  
  # Condy et al. include the following feeding types:
  #   Browser
  #   Detritivore
  #   Grazer
  #   Invert-Macro
  #   Invert-Micro
  #   Pisc-Macro-Invert
  #   Piscivore
  #   Planktivore
  #   Scrapers/Excavators

# Edit new functional group key

  # Change "hunting macrofauna (predator)" to "Predator"
  FunGrKey_New$FeedingType <- gsub("hunting macrofauna (predator)", "Predator",
    FunGrKey_New$FeedingType, fixed = TRUE)

  # Change "grazing on aquatic plants" to "Grazer"
  FunGrKey_New$FeedingType <- gsub("grazing on aquatic plants", "Grazer",
    FunGrKey_New$FeedingType, fixed = TRUE)

  # Change "selective plankton feeding" to "Planktivore"
  FunGrKey_New$FeedingType <- gsub("selective plankton feeding", "Planktivore",
    FunGrKey_New$FeedingType, fixed = TRUE)

  # Change "picking parasites off a host (cleaner)" to "Cleaner"
  FunGrKey_New$FeedingType <- gsub("picking parasites off a host (cleaner)", "Cleaner",
    FunGrKey_New$FeedingType, fixed = TRUE)

  # Change "browsing on substrate" to "Browser"
  FunGrKey_New$FeedingType <- gsub("browsing on substrate", "Browser",
    FunGrKey_New$FeedingType, fixed = TRUE)

  # Make every other entry Title Case to match Condy's key
  FunGrKey_New$FeedingType <- str_to_title(FunGrKey_New$FeedingType)
  
  # Delete rows with NA
  FunGrKey_New <- na.omit(FunGrKey_New)

# Add new functional groups from FishBase to TrapData
for(i in 1:length(TrapData$FunGr_Diet)){
  
  # If the row does not already have FunGr_Diet filled in,
  if(is.na(TrapData$FunGr_Diet[i]) == TRUE){
    
    # And if FunGrKey_New has information for this species,
    if(TrapData$SPECIES[i] %in% FunGrKey_New$Species){
      
      # Find the index of the species in FunGrKey_New
      a <- str_which(FunGrKey_New$Species, TrapData$SPECIES[i])
      
      # Save the feeding type from FunGrKey_New to TrapData
      TrapData$FunGr_Diet[i] <- FunGrKey_New$FeedingType[a]
      
    }
    
  }
  
}
 
# We just went from 3639 NA's in the TrapData$FunGr_Diet column to 1371!

  
