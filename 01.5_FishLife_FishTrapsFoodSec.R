# This code uses Jim Thorsen's FishLife package to provide the most accurate estimates available
#   for life history parameters. Unfortunately, it relies on an old version of rfishbase. First,
#   restart R. Then install the old version of fishbase as below. You can then run this code. Once
#   you've run the code, detach rfishbase, update the package back to v. 4 or higher, and restart
#   R again.

# Install old version of fishbase
remotes::install_github( 'ropensci/rfishbase@fb-21.06', force=TRUE )

library(rfishbase)
library(FishLife)
library(readr)
library(stringr)

# Import species data
SpeciesData <- read_csv("01_CleanData_Out/SpeciesData_GatedTraps_Galligan.csv")

# Delete existing life history values
SpeciesData$Linf_cm <- NA
SpeciesData$Lmat_cm <- NA
SpeciesData$Lopt_cm <- NA

# Fill in Lopt, Lmat, and Linf for all species
for(i in 1:nrow(SpeciesData)){
  
  # Genus name
  Genus <- str_split_fixed(SpeciesData$Species[i], pattern = " ", n = 2)[1]
  
  # Species name
  Species <- str_split_fixed(SpeciesData$Species[i], pattern = " ", n = 2)[2]
  
  # Predictions of life history parameters for this species (in log space)
  try({ # skip to next iteration of loop if no match
  Predict <- Plot_taxa(Search_species(Genus = Genus, Species = Species)$match_taxonomy, mfrow=c(2,2))
  })
    
  # Predictive median of Linf for this species
  Linf <- exp(Predict[[1]]$Mean_pred[[1]])
  
  # Predictive median of Lmat for this species
  Lmat <- exp(Predict[[1]]$Mean_pred[[7]])
  
  # Predictive median of M for this species
  M <- exp(Predict[[1]]$Mean_pred[[6]])

  # Predictive median of K for this species
  K <- exp(Predict[[1]]$Mean_pred[[2]])
  
  # Calculate Lopt (Beverton 1992)
  Lopt <- Linf * (3 / (3 + M / K))
  
  # Save life history values to SpeciesData
  SpeciesData$Linf_cm[i] <- Linf
  SpeciesData$Lmat_cm[i] <- Lmat
  SpeciesData$Lopt_cm[i] <- Lopt
  
}

# Save SpeciesData
write.csv(SpeciesData, file = "01_CleanData_Out/SpeciesData_GatedTraps_Galligan.csv",
  row.names = FALSE)

# Detach rfishbase
detach(package:rfishbase, unload = TRUE)

# Update rfishbase to the current version
install.packages("rfishbase")



