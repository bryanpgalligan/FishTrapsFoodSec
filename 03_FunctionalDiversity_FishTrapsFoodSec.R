

# Add FR, FE, and FD to TripData

# Load packages
library(mFD)
library(readr)
library(dplyr)
library(stringr)
library(ggplot2)

# Load data
TripData <- read_csv("01_CleanData_Out/TripData_GatedTraps_Galligan.csv")
CatchData <- read_csv("01_CleanData_Out/CatchData_GatedTraps_Galligan.csv")
SpeciesData <- read_csv("01_CleanData_Out/SpeciesData_GatedTraps_Galligan.csv")


##### 3.1 Enter data #####

# Make a traits dataframe
FishTraits <- select(SpeciesData, c("Species", "SizeCategory", "Diet", "Mobility", "Active", "Schooling", "Position"))

# Remove uncategorized species and save as data frame
FishTraits <- as.data.frame(FishTraits[complete.cases(FishTraits), ])

# Make species names row names
rownames(FishTraits) <- FishTraits[, "Species"]

# Delete species column
FishTraits <- FishTraits[, -1]

# Make all columns factor variables
FishTraits$SizeCategory <- factor(FishTraits$SizeCategory,
  levels = c("S1", "S2", "S3", "S4", "S5", "S6"),
  ordered = TRUE)
FishTraits$Diet <- factor(FishTraits$Diet,
  ordered = FALSE)
FishTraits$Mobility <- factor(FishTraits$Mobility,
  levels = c("Sed", "Mob", "VMob"),
  ordered = TRUE)
FishTraits$Active <- factor(FishTraits$Active,
  ordered = FALSE)
FishTraits$Schooling <- factor(FishTraits$Schooling,
  levels = c("Sol", "Pair", "SmallG", "MedG", "LargeG"),
  ordered = TRUE)
FishTraits$Position <- factor(FishTraits$Position,
  levels = c("Bottom", "Low", "High"),
  ordered = TRUE)


# Trip assemblage codes are commented because the assemblages are to small if binned
# by trip. If you have fewer FEs/species than traits in any assemblage, that assemblage
# can't be used to calculate Functional Richness. Instead, we'll bin assemblages by site
# and trap type.

# # Make a species assemblage (by trip) dataframe
# 
# # First column (TripID)
# TripAssemblages <- as.data.frame(TripData$TripID)
# colnames(TripAssemblages) <- "TripID"
# 
# # Add a column for each species in FishTraits
# for (i in 1:nrow(FishTraits)){
#   
#   # Add column to TripAssemblages
#   TripAssemblages[, rownames(FishTraits)[i]] <- NA
#   
# }

# Make a species assemblage (by site) dataframe

# First column (Site.TrapType)
a <- unique(TripData$Site)
a.trad <- paste(a, "Traditional", sep = ".")
a.gat <- paste(a, "Gated", sep = ".")
SiteAssemblages <- as.data.frame(c(a.trad, a.gat))
colnames(SiteAssemblages) <- "Site.TrapType"

# Add a column for each species in FishTraits
for (i in 1:nrow(FishTraits)){
  
  # Add column to SiteAssemblages
  SiteAssemblages[, rownames(FishTraits)[i]] <- NA
  
}

# Replace NAs with 0
SiteAssemblages[is.na(SiteAssemblages)] <- 0

# Convert first column of SiteAssemblages to row names
rownames(SiteAssemblages) <- SiteAssemblages[, 1]

# Delete now-redundant first column
SiteAssemblages <- SiteAssemblages[, -1]

# A vector of species not categorized with traits
UncategorizedSpecies <- SpeciesData$Species[!(SpeciesData$Species %in% rownames(FishTraits))]

# A version of CatchData that excludes uncategorized species
CatchData2 <- subset(CatchData, !(CatchData$Species %in% UncategorizedSpecies))

# # Add biomass by species to assemblages data frame
# for (i in 1:nrow(TripAssemblages)){
#   
#   # Get TripID
#   a <- TripAssemblages$TripID[i]
#   
#   # Subset this trip's catch data
#   x <- subset(CatchData, TripID == a)
#   
#   # Vector of species caught on this trip
#   b <- unique(x$Species)
#   
#   # Sum the biomass by species
#   for (j in 1:length(b)){
#     
#     # Subset catch data for this species
#     y <- subset(x, Species == b[j])
#     
#     # Sum biomass
#     c <- sum(y$Weight_g)
#     
#     # Save biomass to TripAssemblages
#     TripAssemblages[i, b[j]] <- c
#     
#   }
#   
# }
# 
# # Replace NAs with 0
# TripAssemblages[is.na(TripAssemblages)] <- 0
# 
# # Convert first column of TripAssemblages to row names
# rownames(TripAssemblages) <- TripAssemblages[, 1]
# 
# # Delete now-redundant first column
# TripAssemblages <- TripAssemblages[, -1]
# 
# # Make TripAssemblages a matrix
# TripAssemblages <- as.matrix(TripAssemblages)
# 
# # Make TripAssemblages numeric
# class(TripAssemblages) <- "numeric"

# Add biomass by species to assemblages data frame
for (i in 1:nrow(CatchData2)){
  
  # Extract Site
  a <- as.character(TripData[TripData$TripID == CatchData2$TripID[i], "Site"])
  
  # Extract TrapType
  b <- CatchData2$TrapType[i]
  
  # Extract Species
  c <- CatchData2$Species[i]
  
  # Reproduce target rowname
  d <- paste(a, b, sep = ".")
  
  # Add to appropriate cell in SiteAssemblages data frame
  SiteAssemblages[d, c] <- SiteAssemblages[d, c] + CatchData2$Weight_g[i]
  
}

# Replace NAs with 0
SiteAssemblages[is.na(SiteAssemblages)] <- 0

# Make SiteAssemblages a matrix
SiteAssemblages <- as.matrix(SiteAssemblages)

# Make SiteAssemblages numeric
class(SiteAssemblages) <- "numeric"

# # Convert first column of TripAssemblages to row names
# rownames(TripAssemblages) <- TripAssemblages[, 1]
# 
# # Delete now-redundant first column
# TripAssemblages <- TripAssemblages[, -1]
# 
# # Make TripAssemblages a matrix
# TripAssemblages <- as.matrix(TripAssemblages)
# 
# # Make TripAssemblages numeric
# class(TripAssemblages) <- "numeric"


# Make a TraitKey dataframe
TraitKey <- data.frame(colnames(FishTraits), c("O", "N", "O", "N", "O", "O"))
colnames(TraitKey) <- c("trait_name", "trait_type")


# Summaries

# Summary of fish traits
FishTraitsSummary <- sp.tr.summary(
  tr_cat = TraitKey,
  sp_tr = FishTraits,
  stop_if_NA = TRUE
)

# Summary of species assemblages
AssemblageSummary <- asb.sp.summary(SiteAssemblages)

AssemblageSummary$"sp_tot_w"       # Species total biomass in all assemblages
AssemblageSummary$"asb_tot_w"      # Total biomass per assemblage
AssemblageSummary$"asb_sp_richn"   # Species richness per assemblage



##### 3.2 Computing distances between species #####

# Gather species into functional entities (FEs)
FunctionalEntities <- sp.to.fe(
  sp_tr = FishTraits,
  tr_cat = TraitKey,
  fe_nm_type = "fe_rank")

# Data frame of FE Traits, to be used instead of FishTraits
FETraits <- FunctionalEntities$fe_tr

# Key to convert species to FEs
FE_Species <- as.data.frame(FunctionalEntities[["sp_fe"]])
colnames(FE_Species) <- "FE"

# # Matrix of FE assemblages, to be used instead of TripAssemblages
# 
# # First column (TripID)
# FEAssemblages <- as.data.frame(TripData$TripID)
# colnames(FEAssemblages) <- "TripID"
# 
# # Add a column for each species in FETraits
# for (i in 1:nrow(FETraits)){
#   
#   # Add column to FETraits
#   FEAssemblages[, rownames(FETraits)[i]] <- NA
#   
# }
# 
# # Replace NAs with 0
# FEAssemblages[is.na(FEAssemblages)] <- 0
# 
# # Add biomass by FE to assemblages data frame
# for (i in 1:nrow(FEAssemblages)){
#   
#   # Get TripID
#   a <- FEAssemblages$TripID[i]
#   
#   # Subset this trip's catch data
#   x <- subset(CatchData, TripID == a)
#   
#   # Vector of species caught on this trip
#   b <- unique(x$Species)
#   
#   # Empty vector of FEs caught on this trip
#   #c <- vector(mode = "character", length = 0)
#   
#   # FEs caught on this trip and add biomasses to FEAssemblages
#   for (j in 1:length(b)){
#     
#     # Find the FE to which species b[j] is assigned
#     d <- FE_Species[b[j],]
#     
#     if (is.na(d) == TRUE) next
#     
#     # Append FE to vector listing all FEs from trip
#     #c <- append(c, d, after = length(c))
#     
#     # Sum the biomass by species
#     
#     # Subset catch data for this species
#     y <- subset(x, Species == b[j])
#     
#     # Sum biomass
#     e <- sum(y$Weight_g)
#     
#     # Save biomass to FEAssemblages
#     FEAssemblages[i, d] <- e + FEAssemblages[i, d]
#     
#   }
#   
# }

# Matrix of FE assemblages, to be used instead of SiteAssemblages

# First column (Site.TrapType)
FEAssemblages <- as.data.frame(rownames(SiteAssemblages))
colnames(FEAssemblages) <- "Site.TrapType"

# Add a column for each FE in FETraits
for (i in 1:nrow(FETraits)){
  
  # Add column to FETraits
  FEAssemblages[, rownames(FETraits)[i]] <- NA
  
}

# Replace NAs with 0
FEAssemblages[is.na(FEAssemblages)] <- 0

# # Add biomass of each functional entity to FEAssemblages data frame (based on TRIPS)
# for (i in 1:nrow(FEAssemblages)){
#   
#   # Get TripID
#   a <- FEAssemblages$TripID[i]
#   
#   # Subset this trip's catch data
#   x <- subset(CatchData, TripID == a)
#   
#   # Vector of species caught on this trip
#   b <- unique(x$Species)
#   
#   # Empty vector of FEs caught on this trip
#   #c <- vector(mode = "character", length = 0)
#   
#   # FEs caught on this trip and add biomasses to FEAssemblages
#   for (j in 1:length(b)){
#     
#     # Find the FE to which species b[j] is assigned
#     d <- FE_Species[b[j],]
#     
#     if (is.na(d) == TRUE) next
#     
#     # Append FE to vector listing all FEs from trip
#     #c <- append(c, d, after = length(c))
#     
#     # Sum the biomass by species
#     
#     # Subset catch data for this species
#     y <- subset(x, Species == b[j])
#     
#     # Sum biomass
#     e <- sum(y$Weight_g)
#     
#     # Save biomass to FEAssemblages
#     FEAssemblages[i, d] <- e + FEAssemblages[i, d]
#     
#   }
#   
# }

# Add biomass of each functional entity to FEAssemblages data frame (based on SITES)
for (i in 1:nrow(CatchData2)){
  
  # Extract Species
  a <- CatchData2$Species[i]
  
  # Extract TrapType
  b <- CatchData2$TrapType[i]
  
  # Extract Site
  c <- TripData$Site[TripData$TripID == CatchData2$TripID[i]]
  
  # Convert Species to FE
  d <- FE_Species[a, ]
  
  # Reproduce target row name in FEAssembalges
  e <- paste(c, b, sep = ".")
  
  # Add this fish's mass to the appropriate cell in FEAssemblages
  FEAssemblages[FEAssemblages$Site.TrapType == e, d] <-
    FEAssemblages[FEAssemblages$Site.TrapType == e, d] + CatchData2$Weight_g[i]
  
}

# Convert first column of FEAssemblages to row names
rownames(FEAssemblages) <- FEAssemblages[, 1]

# Delete now-redundant first column
FEAssemblages <- FEAssemblages[, -1]

# Make FEAssemblages a matrix
FEAssemblages <- as.matrix(FEAssemblages)

# Make FEAssemblages numeric
class(FEAssemblages) <- "numeric"

# Replace NAs with 0
FEAssemblages[is.na(FEAssemblages)] <- 0

# Calculate traits-based distances
FunDist <- funct.dist(
  sp_tr = FETraits,
  tr_cat = TraitKey,
  metric = "gower",
  ordinal_var = "podani",
  weight_type = "equal",
  stop_if_NA = TRUE
)




##### 3.3 Compute multidimensional functional spaces and assess quality #####

# Compute quality of functional spaces
FunSpacesQuality <- quality.fspaces(
  sp_dist = FunDist,
  maxdim_pcoa = 10,
  deviation_weighting = "absolute",
  fdist_scaling = FALSE,
  fdendro = "average"
)

# Review results
FunSpacesQuality     # pcoa_4d has the lowest mad, which is best

# Plot quality of functional spaces
quality.fspaces.plot(
  fspaces_quality = FunSpacesQuality,
  quality_metric = "mad",
  fspaces_plot = c("tree_average", "pcoa_2d", "pcoa_3d", "pcoa_4d", "pcoa_5d", "pcoa_6d"),
  name_file = "03_FunctionalDiversity_Out/FunctionalSpacesQuality",
  x_lab = "Trait-based distance"
)




##### 3.4 Test correlations between functional axes and traits #####

# Test for correlations
TraitAxisCorrelations <- traits.faxes.cor(
  sp_tr = FETraits,
  sp_faxes_coord = FunSpacesQuality$"details_fspaces"$"sp_pc_coord"[, c("PC1", "PC2", "PC3", "PC4")],
  plot = TRUE
)

# Return plots:
TraitAxisCorrelations$"tr_faxes_plot"

# Save plot
ggsave(filename = "03_FunctionalDiversity_Out/TraitsAndPCoAAxes.png", device = "png",
  width = 15, height = 10, units = "in")




##### 3.5 Plot functional space #####

funct.space.plot(
  sp_faxes_coord = FunSpacesQuality$details_fspaces$sp_pc_coord[, c("PC1", "PC2", "PC3", "PC4")]
)

# Save plot
ggsave(filename = "03_FunctionalDiversity_Out/PositionSpeciesFunctionalAxes.png", device = "png",
  width = 10, height = 8, units = "in")




##### 3.6 Compute and plot functional diversity indices #####

# Remove sites from FEAssemblages where the number of FEs is not greater than
# number of axes used to compute the convex hull, meaning FRic cannot be computed using those
# assemblages.
ProblemAssemblages <- c("Tiwi.Traditional", "Mtwapa.Traditional", "Chale.Gated", "Mtwapa.Gated")
FEAssemblages <- subset(FEAssemblages, !(rownames(FEAssemblages) %in% ProblemAssemblages))

# Compute multidimensional alpha diversity - F. Richness, Divergence, and Evenness (Villéger et al. 2008)
FDIndices <- alpha.fd.multidim(
  sp_faxes_coord = FunSpacesQuality$details_fspaces$sp_pc_coord[, c("PC1", "PC2", "PC3", "PC4")],
  asb_sp_w = FEAssemblages,
  ind_vect = c("fric", "fdiv", "feve"),
  scaling = TRUE,
  check_input = TRUE,
  details_returned = TRUE
)

# Save FD Indices by assemblage
FDIndices_Results <- FDIndices[["functional_diversity_indices"]]

# Save FD Indices to TripData
for (i in 1:nrow(TripData)){
  
  # Extract Site
  a <- TripData$Site[i]
  
  # Extract TrapType
  b <- TripData$TrapType[i]
  
  # Go to next iteration if TrapType is Multiple
  if (b == "Multiple") next
  
  # Target row name in FDIndices_Results
  c <- paste(a, b, sep = ".")
  
  # Index of target row
  d <- which(c %in% rownames(FDIndices_Results))
  
  # Go to next iteration if there is no match
  if (length(d) < 1) next
  
  # Save all four values to TripData
  TripData$FECount[i] <- FDIndices_Results$sp_richn[d]
  TripData$FRic[i] <- FDIndices_Results$fric[d]
  TripData$FEve[i] <- FDIndices_Results$feve[d]
  TripData$FDiv[i] <- FDIndices_Results$fdiv[d]
  
}

# Save new TripData
write.csv(TripData, file = "03_FunctionalDiversity_Out/TripData_GatedTraps_Galligan.csv",
  row.names = FALSE)




