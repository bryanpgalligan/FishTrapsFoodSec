

# Add FR, FE, and FD to TripData

# Load packages
library(mFD)

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


# Make a species assemblage (by trip) dataframe

# First column (TripID)
TripAssemblages <- as.data.frame(TripData$TripID)
colnames(TripAssemblages) <- "TripID"

# Add a column for each species in FishTraits
for (i in 1:nrow(FishTraits)){
  
  # Add column to FishTraits
  TripAssemblages[, rownames(FishTraits)[i]] <- NA
  
}

# Add biomass by species to assemblages data frame
for (i in 1:nrow(TripAssemblages)){
  
  # Get TripID
  a <- TripAssemblages$TripID[i]
  
  # Subset this trip's catch data
  x <- subset(CatchData, TripID == a)
  
  # Vector of species caught on this trip
  b <- unique(x$Species)
  
  # Sum the biomass by species
  for (j in 1:length(b)){
    
    # Subset catch data for this species
    y <- subset(x, Species == b[j])
    
    # Sum biomass
    c <- sum(y$Weight_g)
    
    # Save biomass to TripAssemblages
    TripAssemblages[i, b[j]] <- c
    
  }
  
}

# Replace NAs with 0
TripAssemblages[is.na(TripAssemblages)] <- 0

# Convert first column of TripAssemblages to row names
rownames(TripAssemblages) <- TripAssemblages[, 1]

# Delete now-redundant first column
TripAssemblages <- TripAssemblages[, -1]

# Make TripAssemblages a matrix
TripAssemblages <- as.matrix(TripAssemblages)

# Make TripAssemblages numeric
class(TripAssemblages) <- "numeric"


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
AssemblageSummary <- asb.sp.summary(TripAssemblages)

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
FE_Species <- FunctionalEntities$sp_fe

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
  sp_faxes_coord = FunSpacesQuality$"details_fspaces"$"sp_pc_coord"[, c("PC2", "PC3", "PC4", "PC5", "PC6")],
  plot = TRUE
)

# Return plots:
TraitAxisCorrelations$"tr_faxes_plot"



##### 3.5 Plot functional space #####

funct.space.plot(
  sp_faxes_coord = FunSpacesQuality$details_fspaces$sp_pc_coord[, c("PC1", "PC2", "PC3", "PC4")]
)




##### 3.6 Compute and plot functional diversity indices #####




