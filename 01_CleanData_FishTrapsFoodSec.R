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

# Rename FishPrice_final as Price_KSHPerkg
colnames(TrapData)[26] <- "Price_KSHPerkg"

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
CatchData <- TrapData[, c("TripID", "TrapType", "TrapLocation",
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
  
  # Linf, Lopt, and Lmat
  
  # Test to see if there was a match in the FishBase species table
  if(length(c) > 0){
  
    # Species ID
    spec.id <- SpeciesFishBase$SpecCode[c]
    
    # Genus Name
    gen.name <- SpeciesFishBase$Genus[c]
    
    # Species Name
    spec.name <- str_split(SpeciesFishBase$Species[c], pattern = " ", n = 2)[[1]][2]
    
    # URL
    url <- paste(
      "https://www.fishbase.de/popdyn/KeyfactsSummary_1.php?ID=",
      spec.id,
      "&GenusName=",
      gen.name,
      "&SpeciesName=",
      spec.name,
      sep = "")
    
    # Get the HTML code from the life history tool webpage
    try(life.hx.tool <- getURLContent(url), silent = FALSE)
    
    # Test whether you got new HTML code (i.e. if you found an actual life history tool for this species)
    if(life.hx.tool != life.hx.tool.previous){
      
      # Save current HTML code to compare with next iteration of loop
      life.hx.tool.previous <- life.hx.tool
      
      # Split right after L infinity
      x <- str_split(life.hx.tool, pattern = "L infinity")
      
      # Split before Linf value
      x <- str_split(x[[1]][2], pattern = "value=", n = 2)
      
      # Split after Linf value
      x <- str_split(x[[1]][2], pattern = "size", n = 2)
      
      # Save relatively isolated value for Linf
      x <- x[[1]][1]
      
      # Save Linf
      if(!is.na(x)){
        l.inf <- str_first_number(x, decimals = TRUE)
      } else{
        l.inf <- NA
      }
      
      # Make sure value is not zero
      if(!is.na(l.inf)){
        if(l.inf <= 0){
          l.inf <- NA
        }
      }
      
      # Split right after L maturity
      x <- str_split(life.hx.tool, pattern = "L maturity")
      
      # Split before Lmat value
      x <- str_split(x[[1]][2], pattern = "value=", n = 2)
      
      # Split after Lmat value
      x <- str_split(x[[1]][2], pattern = "\r\nsize", n = 2)
      
      # Save relatively isolated value for Lmat
      x <- x[[1]][1]
      
      # Save Lmat
      if(!is.na(x)){
        l.mat <- str_first_number(x, decimals = TRUE)
      } else{
        l.mat <- NA
      }
      
      # Make sure value is not zero
      if(!is.na(l.mat)){
        if(l.mat <= 0){
          l.mat <- NA
        }
      }
      
      # Split right after L max. yeild (Lopt)
      x <- str_split(life.hx.tool, pattern = "L max. yield")
      
      # Split before Lopt value
      x <- str_split(x[[1]][2], pattern = "value=", n = 2)
      
      # Split after Lopt value
      x <- str_split(x[[1]][2], pattern = "align", n = 2)
      
      # Save relatively isolated value for Lopt
      x <- x[[1]][1]
      
      # Save Lopt
      if(!is.na(x)){
        l.opt <- str_first_number(x, decimals = TRUE)
      } else{
        l.opt <- NA
      }
      
      # Make sure value is not zero
      if(!is.na(l.opt)){
        if(l.opt <= 0){
          l.opt <- NA
        }
      }
      
      # Save life hx info to SpeciesData
      if(length(l.inf) > 0){
        SpeciesData$Linf_cm[i] <- l.inf
      }  
      
      if(length(l.mat) > 0){
        SpeciesData$Lmat_cm[i] <- l.mat
      }  
      
      if(length(l.opt) > 0){
        SpeciesData$Lopt_cm[i] <- l.opt
      }
    }
  }
}

# Capitalize Common names and Families
SpeciesData$KiswahiliName <- str_to_sentence(SpeciesData$KiswahiliName)
SpeciesData$EnglishName <- str_to_sentence(SpeciesData$EnglishName)
SpeciesData$Family <- str_to_sentence(SpeciesData$Family)

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

beep()

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

