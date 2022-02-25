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
library(RCurl)
library(strex)

# Load WCS combined gated trap data for 2010-2019
TrapData <- read_csv("00_RawData/CombinedTrapData_2010_2019_Anonymized.csv")

# Load Condy's key for diet based functional groups
FunGrKey_Condy <- read_excel("00_RawData/FunctionalGroupKey_DietBased_Condy2015.xlsx")

# Load Mbaru's key for species functional traits
TraitData <- read_excel("00_RawData/Traits_MbaruEtAl2020.xls")
TraitData <- TraitData[-1,] # Remove first (empty) row


# Load price table used for previous studies
FamilyValues <- read_csv("00_RawData/ValueByFamily.csv")




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
    
  # Replace Monotaxinae grandoculus with Monotaxis grandoculus.
  TrapData$SPECIES <- gsub("Monotaxinae", "Monotaxis", TrapData$SPECIES)
  
  # Replace P. cryterinus with P. gaterinus.
  TrapData$SPECIES <- gsub("Plectohinchus cryterinus", "Plectorhinchus gaterinus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace P. macronema with P. macronemus
  TrapData$SPECIES <- gsub("Parupeneas macronema", "Parupeneus macronemus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Parupeneas macronema with Parupeneus macronemus
  TrapData$SPECIES <- gsub("Parupeneas macronema", "Parupeneus macronemus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace the other P. macronema with P. macronemus
  TrapData$SPECIES <- gsub("Parupeneus macronema", "Parupeneus macronemus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace O. cubicus with O. cubicum
  TrapData$SPECIES <- gsub("Ostracion cubicus", "Ostracion cubicum",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace S. ruselli with S. ruselii
  TrapData$SPECIES <- gsub("Scarus russelli", "Scarus russelii",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace N. branchycentron with N. brachycentron
  TrapData$SPECIES <- gsub("Naso branchycentron", "Naso brachycentron",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace S. tieroides with S. tiereoides
  TrapData$SPECIES <- gsub("Sargocentron tieroides", "Sargocentron tiereoides",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Parupenaeus indicus with Parupeneus indicus
  TrapData$SPECIES <- gsub("Parupenaeus indicus", "Parupeneus indicus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Lethrinus borbonicus valenciennes with L. borbonicus
  TrapData$SPECIES <- gsub("Lethrinus borbonicus valenciennes", "Lethrinus borbonicus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Scarus sordidus with Chlorurus sordidus
  TrapData$SPECIES <- gsub("Scarus sordidus", "Chlorurus sordidus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Scarus atrilunula with Chlorurus atrilunula
  TrapData$SPECIES <- gsub("Scarus atrilunula", "Chorurus atrilunula",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Monotaxis grandoculus with Monotaxis grandoculis
  TrapData$SPECIES <- gsub("Monotaxis grandoculus", "Monotaxis grandoculis",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Epinephelus caeruleopunctatus with Epinephelus coeruleopunctatus
  TrapData$SPECIES <- gsub("Epinephelus caeruleopunctatus", "Epinephelus coeruleopunctatus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Lethrinus sanguineus with Lethrinus mahsena
  TrapData$SPECIES <- gsub("Lethrinus sanguineus", "Lethrinus mahsena",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Lutjanus russelli with Lutjanus russellii
  TrapData$SPECIES <- gsub("Lutjanus russelli", "Lutjanus russellii",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Chlorurus strongycephalus with Chlorurus strongylocephalus
  TrapData$SPECIES <- gsub("Chlorurus strongycephalus", "Chlorurus strongylocephalus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Acanthurus tennenti with Acanthurus tennentii
  TrapData$SPECIES <- gsub("Acanthurus tennenti", "Acanthurus tennentii",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace G. grandoculus with G. grandoculis
  TrapData$SPECIES <- gsub("Gymnocranius grandoculus", "Gymnocranius grandoculis",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace C. merra with E. merra
  TrapData$SPECIES <- gsub("Cephalopholis merra", "Epinephelus merra",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Lutjanus carponatus with Lutjanus carponotatus
  TrapData$SPECIES <- gsub("Lutjanus carponatus", "Lutjanus carponotatus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Lethrinus genivitattus with Lethrinus genivittatus
  TrapData$SPECIES <- gsub("Lethrinus genivitattus", "Lethrinus genivittatus",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Scarus harid with Hipposcarus harid
  TrapData$SPECIES <- gsub("Scarus harid", "Hipposcarus harid",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Lethrinus elongatus with L. microdon
  TrapData$SPECIES <- gsub("Lethrinus elongatus", "Lethrinus microdon",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Myripristis melanosticta with M. botche
  TrapData$SPECIES <- gsub("Myripristis melanosticta", "Myripristis botche",
    TrapData$SPECIES, fixed = TRUE)
  
  # Replace Chorurus atrilunula with Chlorurus atrilunula
  TrapData$SPECIES <- gsub("Chorurus atrilunula", "Chlorurus atrilunula",
    TrapData$SPECIES, fixed = TRUE)
  
  # Remove rows of TrapData with NA for species
  TrapData <- TrapData[!is.na(TrapData$SPECIES) == TRUE,]


    
 

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

# Assign new values to entire price column

# This has been moved to the normalization section so as to only apply it to the
#   SpeciesData table.

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

# Delete FishPrice_final column
TrapData <- select(TrapData, -`FishPrice_final`)

# Rename Fungr_diet to FunGr_Diet
colnames(TrapData)[26] <- "FunGr_Diet"

# Rename Tripid to TripID
colnames(TrapData)[29] <- "TripID"

# Save TrapData
write.csv(TrapData, file = "01_CleanData_Out/TrapData_Cleaned.csv", row.names = FALSE)




##### 1.13 Normalization ####

# "Normalize" the database by creating separate tables for each level of observation.
#   This section will also add data that will be needed for later analyses.

# A table for catch data
CatchData <- TrapData[, c("TripID", "TrapType", "TrapLocation",
  "SoakTime_Days", "GapSize_cm", "Species",
  "FD_HC", "Length_cm", "Depth_m", "Weight_g")]

# Save the catch data table
write.csv(CatchData, file = "01_CleanData_Out/CatchData_GatedTraps_Galligan.csv",
  row.names = FALSE)

# Construct a table for species-level data
SpeciesData <- as.data.frame(unique(TrapData$Species))
colnames(SpeciesData) <- "Species"

# Add empty columns
SpeciesData$Family <- NA
SpeciesData$FishGroups <- NA
SpeciesData$EnglishName <- NA
SpeciesData$KiswahiliName <- NA
SpeciesData$Bycatch <- NA
SpeciesData$Price_KSHPerkg <- NA
SpeciesData$FunGr_Diet <- NA
SpeciesData$Lmat_cm <- NA
SpeciesData$Lopt_cm <- NA
SpeciesData$Linf_cm <- NA
SpeciesData$SizeCategory <- NA
SpeciesData$Diet <- NA
SpeciesData$Mobility <- NA
SpeciesData$Active <- NA
SpeciesData$Schooling <- NA
SpeciesData$Position <- NA
SpeciesData$Calcium_mgPer100g <- NA
SpeciesData$Calicum_L95 <- NA
SpeciesData$Calcium_U95 <- NA
SpeciesData$Iron_mgPer100g <- NA
SpeciesData$Iron_L95 <- NA
SpeciesData$Iron_U95 <- NA
SpeciesData$VitaminA_ugPer100g <- NA
SpeciesData$VitaminA_L95 <- NA
SpeciesData$VitaminA_U95 <- NA
SpeciesData$Selenium_ugPer100g <- NA
SpeciesData$Selenium_L95 <- NA
SpeciesData$Selenium_U95 <- NA
SpeciesData$Zinc_ugPer100g <- NA
SpeciesData$Zinc_L95 <- NA
SpeciesData$Zinc_U95 <- NA


# Extract data from FishBase
SpeciesFishBase <- species(SpeciesData$Species)

# Set up a placeholder value for life.history.tool.previous
life.hx.tool.previous <- "placeholder"

# Fill in SpeciesData columns
for(i in 1:nrow(SpeciesData)){
  
  # Vector of row numbers for occurrence of this species in original data
  a <- which(TrapData$Species == SpeciesData$Species[i])
  
  # Species occurrence in FishBase Species table
  c <- which(SpeciesFishBase$Species == SpeciesData$Species[i])
  
  # Family
  
  # Choose most frequent family assigned to this species in original data
  b <- tail(names(sort(table(TrapData$Family[a]))), 1)
  
  # Save family to SpeciesData if you have a value for b
  if(length(b) > 0){
    SpeciesData$Family[i] <- b
  }
  
  # FishGroups
  
  # Choose most frequent fish group assigned to this species in original data
  b <- tail(names(sort(table(TrapData$FishGroups[a]))), 1)
  
  # Save fish group to SpeciesData if you have a value
  if(length(b) > 0){
    SpeciesData$FishGroups[i] <- b
  }
  
  # English Name
  
  # Choose most frequent English name assigned to this species in original data
  b <- tail(names(sort(table(TrapData$EnglishName[a]))), 1)
  
  # Save English name to SpeciesData if you have a value
  if(length(b) > 0){
    SpeciesData$EnglishName[i] <- b
  }  
  
  # Kiswahili Name
  
  # Choose most frequent Kiswahili name assigned to this species in original data
  b <- tail(names(sort(table(TrapData$KiswahiliName[a]))), 1)
  
  # Save Kiswahili name to SpeciesData if you have a value
  if(length(b) > 0){
    SpeciesData$KiswahiliName[i] <- b
  }
  
  # Choose most frequent bycatch answer (y/n) from original data
  b <- tail(names(sort(table(TrapData$Bycatch[a]))), 1)

  # Save bycatch answer to SpeciesData if you have a value
  if(length(b) > 0){
    SpeciesData$Bycatch[i] <- b
  }  
  
  # Diet-based functional group
  
  # Choose most common diet-based functional group from original data
  b <- tail(names(sort(table(TrapData$FunGr_Diet[a]))), 1)

  # Save diet-based functional group to SpeciesData if you have a value
  if(length(b) > 0){
    SpeciesData$FunGr_Diet[i] <- b
  }  
  
}

# Capitalize Common names and Families
SpeciesData$KiswahiliName <- str_to_sentence(SpeciesData$KiswahiliName)
SpeciesData$EnglishName <- str_to_sentence(SpeciesData$EnglishName)
SpeciesData$Family <- str_to_sentence(SpeciesData$Family)

# Clean bycatch column
SpeciesData$Bycatch <- str_to_sentence(SpeciesData$Bycatch)

# Subset for values that are not "Yes" or "No"
bad.bycatch <- subset(SpeciesData, SpeciesData$Bycatch != "Yes" & SpeciesData$Bycatch != "No")

# Fix bad bycatch values
for(i in 1:nrow(bad.bycatch)){
  
  # Yes if price is NA
  if(is.na(bad.bycatch$Price_KSHPerkg[i])){
    bad.bycatch$Bycatch[i] <- "Yes"
  } else{
  
    # Yes if price is 0
    if(bad.bycatch$Price_KSHPerkg[i] == 0){
      bad.bycatch$Bycatch[i] <- "Yes"
    }
  
    # No if price is greater than 0
    if(bad.bycatch$Price_KSHPerkg[i] > 0){
      bad.bycatch$Bycatch[i] <- "No"
    }
  
  }
    
  # Row number for this species in SpeciesData
  a <- which(SpeciesData$Species == bad.bycatch$Species[i])
  
  # Save new bycatch value
  SpeciesData$Bycatch[a] <- bad.bycatch$Bycatch[i]
  
}


# Fill in price column
for(i in 1:nrow(SpeciesData)){
  
  # Test to make sure there is a match
  if(SpeciesData$Family[i] %in% FamilyValues$Family){
  
    # Row number where this family occurs in the FamilyValues table
    a <- which(FamilyValues$Family == SpeciesData$Family[i])
    
    # Fill in price column
    SpeciesData$Price_KSHPerkg[i] <- FamilyValues$Price_KSHPerkg[a]
  
  }
}

# Make TraitData table more readable

# Change diet codes to plain English
TraitData$Diets <- gsub("FC", "Carnivorous", TraitData$Diets, fixed = TRUE)
TraitData$Diets <- gsub("HD", "Herbivorous detritivorous", TraitData$Diets, fixed = TRUE)
TraitData$Diets <- gsub("HM", "Macroalgal herbivorous", TraitData$Diets, fixed = TRUE)
TraitData$Diets <- gsub("IM", "Mobile Inverts", TraitData$Diets, fixed = TRUE)
TraitData$Diets <- gsub("IS", "Sessile Inverts", TraitData$Diets, fixed = TRUE)
TraitData$Diets <- gsub("OM", "Omnivorous", TraitData$Diets, fixed = TRUE)
TraitData$Diets <- gsub("PK", "Planktivorous", TraitData$Diets, fixed = TRUE)

# Fill in the traits
for(i in 1:nrow(SpeciesData)){
  
  # Test to make sure there is a match with Mbaru's trait table
  if(SpeciesData$Species[i] %in% TraitData$Genus_and_species...2){
    
    # Row number of match in Mbaru's table
    a <- which(TraitData$Genus_and_species...2 == SpeciesData$Species[i])
    
    # Fill in Size Category
    SpeciesData$SizeCategory[i] <- TraitData$`Size-Class`[a]
    
    # Fill in Diet
    SpeciesData$Diet[i] <- TraitData$Diets[a]
    
    # Fill in Mobility
    SpeciesData$Mobility[i] <- TraitData$`Home-Range`[a]
    
    # Fill in Active
    SpeciesData$Active[i] <- TraitData$Activity[a]
    
    # Fill in Schooling
    SpeciesData$Schooling[i] <- TraitData$Schooling[a]
    
    # Fill in Position
    SpeciesData$Position[i] <- TraitData$`Level-water`[a]
    
  }
  
}

# Extract nutrient estimates from FishBase
NutrientBase <- estimate(SpeciesData$Species)

# Fill in nutrient estimates
for(i in 1:nrow(SpeciesData)){
  
  # Confirm that there is a match
  if(SpeciesData$Species[i] %in% NutrientBase$Species){
    
    # Find row number for this species in NutrientBase
    a <- which(NutrientBase$Species == SpeciesData$Species[i])
    
    # Save necessary values to SpeciesData
    SpeciesData$Calcium_mgPer100g[i] <- NutrientBase$Calcium[a]
    SpeciesData$Calcium_U95[i] <- NutrientBase$Calcium_u95[a]
    SpeciesData$Calicum_L95[i] <- NutrientBase$Calcium_l95[a]
    SpeciesData$Iron_mgPer100g[i] <- NutrientBase$Iron[a]
    SpeciesData$Iron_L95[i] <- NutrientBase$Iron_l95[a]
    SpeciesData$Iron_U95[i] <- NutrientBase$Iron_u95[a]
    SpeciesData$VitaminA_ugPer100g[i] <- NutrientBase$VitaminA[a]
    SpeciesData$VitaminA_L95[i] <- NutrientBase$VitaminA_l95[a]
    SpeciesData$VitaminA_U95[i] <- NutrientBase$VitaminA_u95[a]
    SpeciesData$Selenium_ugPer100g[i] <- NutrientBase$Selenium[a]
    SpeciesData$Selenium_L95[i] <- NutrientBase$Selenium_l95[a]
    SpeciesData$Selenium_U95[i] <- NutrientBase$Selenium_u95[a]
    SpeciesData$Zinc_ugPer100g[i] <- NutrientBase$Zinc[a]
    SpeciesData$Zinc_L95[i] <- NutrientBase$Zinc_l95[a]
    SpeciesData$Zinc_U95[i] <- NutrientBase$Zinc_u95[a]
    
  }
  
}

# Save SpeciesData
write.csv(SpeciesData, file = "01_CleanData_Out/SpeciesData_GatedTraps_Galligan.csv",
  row.names = FALSE)

# Prepare a TripData table
TripData <- as.data.frame(unique(TrapData$TripID))
colnames(TripData) <- "TripID"
TripData$Date <- NA
TripData$Country <- NA
TripData$Site <- NA
TripData$Latitude <- NA
TripData$Longitude <- NA
TripData$Observer <- NA
TripData$Fisher <- NA
TripData$TotalCrew <- NA
TripData$TrapsOwned <- NA
TripData$TrapsFished <- NA
TripData$TrapLocation <- NA
TripData$Depth_m <- NA
TripData$SoakTime_Days <- NA
TripData$TrapType <- NA
TripData$GapSize_cm <- NA
TripData$BrowserMass_g <- NA
TripData$BrowserMassRatio <- NA
TripData$ScraperMass_g <- NA
TripData$ScraperMassRatio <- NA
TripData$GrazerMass_g <- NA
TripData$GrazerMassRatio <- NA
TripData$TotalCatch_g <- NA
TripData$CPUE_kgPerTrap <- NA
TripData$TotalValue_KSH <- NA
TripData$ValuePUE <- NA
TripData$TotalCa_mg <- NA
TripData$CaPUE <- NA
TripData$TotalFe_mg <- NA
TripData$FePUE <- NA
TripData$TotalVA_ug <- NA
TripData$VAPUE <- NA
TripData$TotalSe_ug <- NA
TripData$SePUE <- NA
TripData$TotalZn_ug <- NA
TripData$ZnPUE <- NA

# Fill in TripData with the easy values
for(i in 1:nrow(TripData)){
  
  # Subset this trip's information from CatchData
  x <- subset(TrapData, TrapData$TripID == TripData$TripID[i])
  
  # Choose most frequent value for the easy values and save to temporary data frame x
  
  # Date
  a <- tail(names(sort(table(x$Date))), 1)
  if(length(a) > 0){
    TripData$Date[i] <- a
  }
  
  # Country
  a <- tail(names(sort(table(x$Country))), 1)
  if(length(a) > 0){
   TripData$Country[i] <- a
  }
  
  # Site
  a <- tail(names(sort(table(x$Site))), 1)
  if(length(a) > 0){
    TripData$Site[i] <- a
  }
  
  # Latitude
  a <- tail(names(sort(table(x$Latitude, useNA = "ifany"))), 1)
  if(!is.na(a)){
    TripData$Latitude[i] <- a
  }
    
  # Longitude
  a <- tail(names(sort(table(x$Longitude, useNA = "ifany"))), 1)
  if(!is.na(a)){
    TripData$Longitude[i] <- a
  }
  
  # Observer
  a <- tail(names(sort(table(x$DataCollector, useNA = "ifany"))), 1)
  if(!is.na(a)){
    TripData$Observer[i] <- a
  }
  
  # Fisher
  a <- tail(names(sort(table(x$Fisher, useNA = "ifany"))), 1)
  if(!is.na(a)){
    TripData$Fisher[i] <- a
  }
    
  # Total Crew
  a <- tail(names(sort(table(x$TotalCrew, useNA = "ifany"))), 1)
  if(!is.na(a)){
    TripData$TotalCrew[i] <- a
  }
  
  # Traps Owned
  a <- tail(names(sort(table(x$TrapsOwned, useNA = "ifany"))), 1)
  if(!is.na(a)){
    TripData$TrapsOwned[i] <- a
  }
    
  # Traps Fished
  a <- tail(names(sort(table(x$TrapsFished, useNA = "ifany"))), 1)
  if(!is.na(a)){
    TripData$TrapsFished[i] <- a
  }
    
  # Trap Location
  if(length(unique(x$TrapLocation)) > 1){
    TripData$TrapLocation[i] <- "Multiple"
  } else{
    if(!is.na(x$TrapLocation[1])){
      TripData$TrapLocation[i] <- x$TrapLocation[1]
    }
  }
  
  # Depth (m)
  if(length(unique(x$Depth_m)) > 1){
    TripData$Depth_m[i] <- "Multiple"
  } else{
    if(!is.na(x$Depth_m[1])){
      TripData$Depth_m[i] <- x$Depth_m[1]
    }
  }
  
  # SoakTime_Days
  if(length(unique(x$SoakTime_Days)) > 1){
    TripData$SoakTime_Days[i] <- "Multiple"
  } else{
    if(!is.na(x$SoakTime_Days[1])){
      TripData$SoakTime_Days[i] <- x$SoakTime_Days[1]
    }
  }
  
  # TrapType
  if(length(unique(x$TrapType)) > 1){
    TripData$TrapType[i] <- "Multiple"
  } else{
    if(!is.na(x$TrapType[1])){
      TripData$TrapType[i] <- x$TrapType[1]
    }
  }
  
  # GapSize_cm
  if(length(unique(x$GapSize_cm)) > 1){
    TripData$GapSize_cm[i] <- "Multiple"
  } else{
    if(!is.na(x$GapSize_cm[1])){
      TripData$GapSize_cm[i] <- x$GapSize_cm[1]
    }
  }
  
  # BrowserMass_g
  y <- subset(x, x$FunGr_Diet == "Browser")
  if(nrow(y) > 0){
    TripData$BrowserMass_g[i] <- sum(y$TotalCatch_g)
  } else{
    TripData$BrowserMass_g[i] <- 0
  }
  
  # ScraperMass_g
  y <- subset(x, x$FunGr_Diet == "Scraper")
  if(nrow(y) > 0){
    TripData$ScraperMass_g[i] <- sum(y$TotalCatch_g)
  } else{
    TripData$ScraperMass_g[i] <- 0
  }
  
  # GrazerMass_g
  y <- subset(x, x$FunGr_Diet == "Grazer")
  if(nrow(y) > 0){
    TripData$GrazerMass_g[i] <- sum(y$TotalCatch_g)
  } else{
    TripData$GrazerMass_g[i] <- 0
  }
  
  # TotalCatch_g
  TripData$TotalCatch_g[i] <- sum(x$TotalCatch_g)
  
  # Add species data columns to temporary data frame x
  x$Price_KSH <- NA
  x$Ca <- NA
  x$Fe <- NA
  x$VA <- NA
  x$Se <- NA
  x$Zn <- NA
  
  # Add species data to x
  for(j in 1:nrow(x)){
    
    # Row number in SpeciesData for this species
    a <- which(SpeciesData$Species == x$Species[j])
    
    # Price_KSH
    x$Price_KSH[j] <- SpeciesData$Price_KSHPerkg[a] * (x$Weight_g[j] / 1000)
    
    # Calcium
    x$Ca[j] <- SpeciesData$Calcium_mgPer100g[a] * (x$Weight_g[j] / 100)
    
    # Iron
    x$Fe[j] <- SpeciesData$Iron_mgPer100g[a] * (x$Weight_g[j] / 100)
    
    # Vitamin A
    x$VA[j] <- SpeciesData$VitaminA_ugPer100g[a] * (x$Weight_g[j] / 100)
    
    # Selenium
    x$Se[j] <- SpeciesData$Selenium_ugPer100g[a] * (x$Weight_g[j] / 100)
    
    # Zinc
    x$Zn[j] <- SpeciesData$Zinc_ugPer100g[a] * (x$Weight_g[j] / 100)
    
  }
  
  # Add additional values to TripData
  
  # Total Value
  TripData$TotalValue_KSH[i] <- sum(x$Price_KSH)
  
  # Total Calcium
  TripData$TotalCa_mg[i] <- sum(x$Ca)
  
  # Total Iron
  TripData$TotalFe_mg[i] <- sum(x$Fe)
  
  # Total Vitamin A
  TripData$TotalVA_ug[i] <- sum(x$VA)
  
  # Total Selenium
  TripData$TotalSe_ug[i] <- sum(x$Se)
  
  # Total Zinc
  TripData$TotalZn_ug[i] <- sum(x$Zn)
  
}

# Mass Ratios
TripData$BrowserMassRatio <- TripData$BrowserMass_g / TripData$TotalCatch_g
TripData$ScraperMassRatio <- TripData$ScraperMass_g / TripData$TotalCatch_g
TripData$GrazerMassRatio <- TripData$GrazerMass_g / TripData$TotalCatch_g

# Convert Trap and Crew stats to numeric
TripData$TotalCrew <- as.numeric(TripData$TotalCrew)
TripData$TrapsOwned <- as.numeric(TripData$TrapsOwned)
TripData$TrapsFished <- as.numeric(TripData$TrapsFished)

# xPUE
TripData$CPUE_kgPerTrap <- (TripData$TotalCatch_g / 1000) / TripData$TrapsFished
TripData$ValuePUE <- TripData$TotalValue_KSH / TripData$TrapsFished
TripData$CaPUE <- TripData$TotalCa_mg / TripData$TrapsFished
TripData$FePUE <- TripData$TotalFe_mg / TripData$TrapsFished
TripData$VAPUE <- TripData$TotalVA_ug / TripData$TrapsFished
TripData$SePUE <- TripData$TotalSe_ug / TripData$TrapsFished
TripData$ZnPUE <- TripData$TotalZn_ug / TripData$TrapsFished

# Change sig figs
TripData$BrowserMassRatio <- round(TripData$BrowserMassRatio, digits = 4)
TripData$GrazerMassRatio <- round(TripData$GrazerMassRatio, digits = 4)
TripData$ScraperMassRatio <- round(TripData$ScraperMassRatio, digits = 4)
TripData$CPUE_kgPerTrap <- round(TripData$CPUE_kgPerTrap, digits = 4)
TripData$TotalValue_KSH <- round(TripData$TotalValue_KSH, digits = 0)
TripData$ValuePUE <- round(TripData$ValuePUE, digits = 0)

# Save the data table
write.csv(TripData, file = "01_CleanData_Out/TripData_GatedTraps_Galligan.csv",
  row.names = FALSE)

