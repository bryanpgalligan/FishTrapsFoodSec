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
##    01 Data Cleaning

## Last update: 4 Feb 22




## Table of Contents
##    1.1 Load Packages and Data
##    1.2 "TRAP NO." Column
##    1.3 "Trap Type" & "Gap Size (Cms)" Columns
##    1.4 "Site" Column
##    1.5 "SPECIES" Column
##    1.6 "FunGr_Diet" Column
##    1.7 Lat/Lon Columns
##    1.8 FD/HC Column
##    1.9 Price Column
##    1.10 Date Column
##    1.11 Trip ID Column
##    1.12 Trim and Rename Columns
##    1.13 Normalization


# First, clean the environment
rm(list = ls())




##### 1.1 Load Packages and Data #####

# Load packages
library(readxl)
library(readr)
library(data.table)
library(stringr)
library(taxize)
  library(dplyr)
  library(magrittr)
library(rfishbase)

# Load WCS combined gated trap data for 2010-2019
TrapData <- read_csv("00_RawData/CombinedTrapData_2010_2019_Anonymized.csv")

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
    if (is.na(TrapData$`TRAP TYPE`[i]) == FALSE){
    
      if (TrapData$`TRAP TYPE`[i] == "TM" || TrapData$`TRAP TYPE`[i] == "traditional" || TrapData$`TRAP TYPE`[i] == "Traditional"){
        
        # save T as b
        b <- "T"
        
      } else{
        
        # save G as b if it's a gated trap
        b <- "G"
        
      }
    
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

  
  
  
##### 1.3 "Trap Type" & "Gap Size (Cms)" Columns #####

# Make everything in "Trap Type" be either "Traditional" or "Gated"
for (i in 1:length(TrapData$`TRAP TYPE`)){
  
  # If trap type is either MM or Modern...
  if(TrapData$`TRAP TYPE`[i] == "MM" || TrapData$`TRAP TYPE`[i] == "Modern"){
    
    # Save as Gated
    TrapData$`TRAP TYPE`[i] <- "Gated"
    
  }
  
  # If trap type is TM or traditional...
  if(TrapData$`TRAP TYPE`[i] == "TM" || TrapData$`TRAP TYPE`[i] == "traditional"){
    
    # Save as Traditional
    TrapData$`TRAP TYPE`[i] <- "Traditional"
    
  }
  
}

# Fill in NA's in Gap Size column based on Trap No if possible
for (i in 1:length(TrapData$`Gap size (Cms)`)){
  
  # If Gap Size is NA and there is a value for Trap No...
  if (is.na(TrapData$`Gap size (Cms)`[i]) == TRUE && is.na(TrapData$`TRAP NO.`[i]) == FALSE){
    
    # Fill in Gap Size = 0
    if (TrapData$`TRAP TYPE`[i] == "Traditional"){
      
      # Save as 0
      TrapData$`Gap size (Cms)`[i] <- 0
      
    }
    
    # Fill in Gap Size = 2
    if (TrapData$`TRAP NO.`[i] == "G2"){
      
      # Save as 2
      TrapData$`Gap size (Cms)`[i] <- 2
      
    }
    
    # Fill in Gap Size for 2/3
    if (TrapData$`TRAP NO.`[i] == "G2/3"){
      
      # Save as 2.5
      TrapData$`Gap size (Cms)`[i] <- 2.5
      
    }
    
    # Fill in Gap Size = 3
    if (TrapData$`TRAP NO.`[i] == "G3"){
      
      # Save as 3
      TrapData$`Gap size (Cms)`[i] <- 3
      
    }
    
    # Fill in Gap Size = 4
    if (TrapData$`TRAP NO.`[i] == "G4"){
      
      # Save as 4
      TrapData$`Gap size (Cms)`[i] <- 4
      
    }
    
    # Fill in Gap Size = 6
    if (TrapData$`TRAP NO.`[i] == "G6"){
      
      # Save as 6
      TrapData$`Gap size (Cms)`[i] <- 6
      
    }
    
    # Fill in Gap Size = 8
    if (TrapData$`TRAP NO.`[i] == "G8"){
      
      # Save as 8
      TrapData$`Gap size (Cms)`[i] <- 8
      
    }
    
  }
  
}

  
  
  
##### 1.4 "Site" Column #####

# Put all elements in the "Site" column into title case
TrapData$Site <- str_to_title(TrapData$Site)

# Delete the site called "Reef"
TrapData <- subset(TrapData, TrapData$Site != "Reef")




##### 1.5 "SPECIES" Column #####

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

    
 

##### 1.6 FunGr_Diet Column #####

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
      a <- which(FunGrKey_Condy$Species == TrapData$SPECIES[i])
      
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
      a <- which(FunGrKey_New$Species == TrapData$SPECIES[i])
      
      # Save the feeding type from FunGrKey_New to TrapData
      TrapData$FunGr_Diet[i] <- FunGrKey_New$FeedingType[a]
      
    }
    
  }
  
}
 
# We just went from 3639 NA's in the TrapData$FunGr_Diet column to 1371!

  
  
  
##### 1.7 Lat/Lon Columns #####

# Add columns for latitude and longitude
TrapData$Latitude <- str_split_fixed(TrapData$`GPS (0)`, ", ", 2)[,1]
TrapData$Longitude <- str_split_fixed(TrapData$`GPS (0)`, ", ", 2)[,2]

# Remove S from latitude column
TrapData$Latitude <- as.numeric(gsub("S", "", TrapData$Latitude))

# Make all latitudes negative
TrapData$Latitude <- -1*TrapData$Latitude

# Remove E from longitude column
TrapData$Longitude <- as.numeric(gsub("E", "", TrapData$Longitude))



 
##### 1.8 FD/HC Column #####

# Make possible values for FD/HC be FD and HC
for(i in 1:length(TrapData$`FD/HC`)){
  
  # If there is a value and it is not HC...
  if(is.na(TrapData$`FD/HC`[i]) == FALSE && TrapData$`FD/HC`[i] != "HC"){
    
    # Replace "Discarded" with NA
    if (TrapData$`FD/HC`[i] == "Discarded"){
      TrapData$`FD/HC`[i] <- NA
    } else{
      
      # Replace everything else with FD
      TrapData$`FD/HC`[i] <- "FD"
      
    }

  }
  
}




##### 1.9 Price Column #####

# Some values in the Price column are still a little suspicious.

# First, subset these values to share with Austin. The table with fish values
#   only lists 200, 120, 160, 80, and 0 as possible prices in KES/kg. Subset
#   all rows that have other values.

FishPrice_Suspicious <- subset(TrapData,
  TrapData$`Fish price_final` != 200 &
    TrapData$`Fish price_final` != 120 &
    TrapData$`Fish price_final` != 160 &
    TrapData$`Fish price_final` != 80 &
    TrapData$`Fish price_final` != 0)

# Save data frame
write.csv(FishPrice_Suspicious, file = "01_CleanData_Temp/SuspiciousPrices.csv")




##### 1.10 Date Column #####

# Make date column include full dates
TrapData$DATE <- paste(TrapData$YEAR, TrapData$MONTH, TrapData$DATE, sep = "-")

# Make date column a date object (not character)
TrapData$DATE <- as.Date(TrapData$DATE, format = "%Y-%m-%d")

# Delete month and year columns
TrapData <- select(TrapData, -MONTH)
TrapData <- select(TrapData, -YEAR)




##### 1.11 Trip ID Column #####

# An ID code for each unique combination of fisher/crew and date

# Create empty column
TrapData$TripID <- NA

# Create a vector that combines dates and fisher ID's (temporary Trip ID)
a <- paste(as.character(TrapData$DATE), TrapData$Fisherman, sep = "")

# Add your temporary Trip ID to the data frame
TrapData$TripID <- a

# Create a list of unique combinations of dates and fishers
a <- unique(a)

# We have 2744 unique fishing trips!

# Make your list of trips a data frame
a <- as.data.frame(a)

# Add an empty column to the temporary data frame for the new ID numbers
a$TripID <- NA

# A function to generate random alphanumeric strings
myFun <- function(n = 5000) {
  b <- do.call(paste0, replicate(5, sample(LETTERS, n, TRUE), FALSE))
  paste0(b, sprintf("%04d", sample(9999, n, TRUE)), sample(LETTERS, n, TRUE))
}

# List of alphanumeric codes for each fisher
a$TripID <- myFun(length(a$a))

# Add Trip ID's to TrapData
for(i in 1:length(TrapData$TripID)){
  
  # Find index of temporary Trip ID in temporary data frame
  b <- which(a$a == TrapData$TripID[i])
  
  # Replace temporary Trip ID with the new one
  TrapData$TripID[i] <- a$TripID[b]
  
}




##### 1.12 Trim and Rename Columns #####

# Make column names usable and delete unnecessary or corrupted columns

# Make all column names Title Case
colnames(TrapData) <- str_to_title(colnames(TrapData))

# Remove all spaces from column names
colnames(TrapData) <- str_replace_all(colnames(TrapData), " ", "")

# Rename Trap No. to GateCode
colnames(TrapData)[6] <- "GateCode"

# Rename SoakTime(Days) to SoakTime_Days
colnames(TrapData)[8] <- "SoakTime_Days"

# Delete DaySet Column
TrapData <- select(TrapData, -DaySet)

# Delete MeshSize Column
TrapData <- select(TrapData, -MeshSize)

# Rename GapSize(Cms) to GapSize_cm
colnames(TrapData)[9] <- "GapSize_cm"

# Delete GapSize3/2(Cms) Column
TrapData <- select(TrapData, -`GapSize3/2(Cm)`)

# Rename Fisherman as Fisher
colnames(TrapData)[10] <- "Fisher"

# Rename NumberOfFishers to TotalCrew
colnames(TrapData)[11] <- "TotalCrew"

# Rename NoOfTraps to TrapsOwned
colnames(TrapData)[12] <- "TrapsOwned"

# Rename TrapFished to TrapsFished
colnames(TrapData)[13] <- "TrapsFished"

# Delete Gps(0) column
TrapData <- select(TrapData, -`Gps(0)`)

# Rename TotalCatchG to TotalCatch_g
colnames(TrapData)[14] <- "TotalCatch_g"

# Delete DistanceFromPark(M) column
TrapData <- select(TrapData, -`DistanceFromPark(M)`)

# Rename ByCatch to Bycatch
colnames(TrapData)[21] <- "Bycatch"

# Rename Fd/Hc to FD_HC
colnames(TrapData)[22] <- "FD_HC"

# Rename Length(Cm) to Length_cm
colnames(TrapData)[23] <- "Length_cm"

# Rename Depth(M) to Depth_m
colnames(TrapData)[24] <- "Depth_m"

# Delete Depth(Cm) column
TrapData <- select(TrapData, -`Depth(Cm)`)

# Delete Width(Cm) column
TrapData <- select(TrapData, -`Width(Cm)`)

# Delete Weight(Kg) column
TrapData <- select(TrapData, -`Weight(Kg)`)

# Rename Weight(G) to Weight_g
colnames(TrapData)[25] <- "Weight_g"

# Delete PricePerGrade column
TrapData <- select(TrapData, -PricePerGrade)

# Delete PriceOfFish(Ksh) column
TrapData <- select(TrapData, -`PriceOfFish(Ksh)`)

# Delete Survey, Sea State, Trophic Level, and ID columns
TrapData <- select(TrapData, -c(Survey, SeaState, TrophicLevel, Id))

# Rename FishPrice_final as Price_KSH/kg
colnames(TrapData)[26] <- "Price_KSH/kg"

# Rename Fungr_diet to FunGr_Diet
colnames(TrapData)[27] <- "FunGr_Diet"

# Rename Tripid to TripID
colnames(TrapData)[30] <- "TripID"

# Save TrapData
write.csv(TrapData, file = "01_CleanData_Out/TrapData_Cleaned.csv", row.names = FALSE)




##### 1.13 Normalization ####

# "Normalize" the database by creating separate tables for each level of observation.
#   This section will also add data that will be needed for later analyses.

# A table for catch data
CatchData <- TrapData[, c("TripID", "TrapType", "GateCode", "TrapLocation",
  "SoakTime_Days", "GapSize_cm", "Species",
  "FD_HC", "Length_cm", "Depth_m", "Weight_g")]

# Save the catch data table
write.csv(CatchData, file = "01_CleanData_Out/CatchData_FishTrapsFoodSec.R")

# Construct a table for species-level data
SpeciesData <- as.data.frame(unique(TrapData$Species))
colnames(SpeciesData) <- "Species"

# Add empty columns
SpeciesData$Family <- NA
SpeciesData$FishGroups <- NA
SpeciesData$EnglishName <- NA
SpeciesData$KiswahiliName <- NA
SpeciesData$Bycatch <- NA
SpeciesData$Price_KSH/kg <- NA
SpeciesData$FunGr_Diet <- NA
SpeciesData$Lmat <- NA
SpeciesData$Lopt <- NA
SpeciesData$Linf <- NA
SpeciesData$SizeCategory <- NA
SpeciesData$Diet <- NA
SpeciesData$Mobility <- NA
SpeciesData$Active <- NA
SpeciesData$Schooling <- NA
SpeciesData$Position <- NA
SpeciesData$Calcium <- NA
SpeciesData$Iron <- NA
SpeciesData$VitaminA <- NA

