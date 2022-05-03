##  Escape gaps contribute to ecosystem health and food security in an artisanal coral
##    reef trap fishery.

##  Bryan P. Galligan, S.J. (JENA)
##  Austin Humphries (URI)
##  Maxwell Kodia Azali (WCS)
##  Tim McClanahan (WCS)

## Project TOC:
##    01 Data Cleaning
##    02 Adding Life History Values Using FishLife
##    03 Calculating Functional Diversity Indices
##    04 Data Exploration
##    05 PCA Analysis
##    06 Additional Analysis

## Script Title:
##    05 PCA Analysis

## Last update: 26 Apr 22

# This script analyzes the data using principal components methods.

## Script TOC:
##    5.1 Packages and data
##    5.2 Data manipulation
##    5.3 Factor analysis of mixed data (FAMD)
##    5.4 Graph variables (FAMD)
##    5.5 Graph trips (FAMD)
##    5.6 Run PCA (Principal Components Analysis)
##    5.7 Graph PCA
##    5.8 Nutrients PCA
##    5.9 Food security PCA
##    5.10 Conservation PCA




##### 5.1 Packages and data #####

# Load packages
library(ggplot2)
library(FactoMineR)
library(factoextra)
library(readr)
library(missMDA)
library(corrplot)

# NB: This trip data file has been processed to remove outliers that are likely the result of measurement
# error.

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")




##### 5.2 Data manipulation #####

# Convert TripData to a data frame so you can assign row names
TripData <- as.data.frame(TripData)

# Assign row names
rownames(TripData) <- TripData$TripID

# Delete now redundant TripID column
TripData <- TripData[,-1]

# Subset only active and supplementary variables (columns) for the FAMD
df.famd <- TripData[, c("Site", "TrapType",
  "B.undulatus", "LowNoCatch",
  "ScraperMassRatio", "BrowserMassRatio", "GrazerMassRatio", "PredatorMassRatio",
  "CPUE_kgPerTrap", "CPUE_DistFromMean", "ValuePUE",
  "MeanLLmat", "MeanTrophLevel", "MeanVulnerability", "MTC_degC",
  "FRic", "FEve", "FDiv",
  "CaConc_mgPer100g", "CaPrice_KSHPermg" #,
#  "FeConc_mgPer100g", "FePrice_KSHPermg",
#  "Omega3Conc_gPer100g", "Omega3Price_KSHPerg",
#  "ProteinConc_gPer100g", "ProteinPrice_KSHPerg",
#  "VAConc_ugPer100g", "VAPrice_KSHPerug",
#  "SeConc_ugPer100g", "SePrice_KSHPerug",
#  "ZnConc_ugPer100g", "ZnPrice_KSHPerug"
  )]

# # Empty list of rows containing infinite values in df.famd
# inf <- as.numeric(c())
# 
# # Fill in list of rows containing infinite values in df.famd
# for(i in 1:ncol(df.famd)){
#   
#   # Vector of infinite values' indices (if any)
#   a <- which(is.infinite(df.famd[,i]) == TRUE)
#   
#   # Add indices to the list
#   if(length(a) >= 1){
#     inf <- append(inf, a, after = length(inf))
#   }
#   
# }
# 
# # Remove duplicate indices from inf
# inf <- unique(inf)
# 
# # Remove infinite values from df.famd
# df.famd <- df.famd[-inf,]

# # As of 4/22/22, many of these columns have only one or three missing values. That can be an issue
# # for the mice() function, which underlies the imputation functions in the missMDA package. Here,
# # I'll remove rows to eliminate those cases. This will leave us in a situation where the only missing
# # values are in the three multifunctional diversity columns.
# 
# # Empty vector to contain row indices of missing values where one column has <10 missing values
# miss <- as.numeric(c())
# 
# # List of rows corresponding to missing values where one column has <10 missing values.
# for(i in 1:ncol(df.famd)){
#   
#   # Vector of indices with missing values
#   a <- which(is.na(df.famd[,i]))
#   
#   # Append values to miss only if missing values are >0 and <10
#   if(length(a) > 0 && length(a) < 10){
#     miss <- append(miss, a, after = length(miss))
#   }
#   
# }
# 
# # Unique row indices in miss
# miss <- unique(miss)
# 
# # Delete the offending rows
# df.famd <- df.famd[-miss,]
# 
# # Unfortunately, this does not seem to resolve the error message.
# 
# # Impute missing data by the mean of the variable using imputePCA function of missMDA package
# df.famd <- imputeFAMD(df.famd, sup.var = 1:2)

# Subset df.famd for complete cases only
df.famd <- df.famd[complete.cases(df.famd),]




##### 5.3 FAMD #####

# Run the factor analysis of mixed data (FAMD) with site and trap type as supplementary variables
res.famd <- FAMD(df.famd, ncp = 10, sup.var = 1:2, graph = FALSE)

# Eigenvalues/variances

# Get eigenvalues
eig.val <- get_eigenvalue(res.famd)
eig.val

# Draw the scree plot
fviz_screeplot(res.famd)

# Save the scree plot
ggsave("05_PrincipalComponents_Out/FAMDScreePlot_FishTrapsFoodSec.jpeg", device = "jpeg")




##### 5.4 Graph variables (FAMD) #####

# Extract variables
var <- get_famd_var(res.famd)


## All variables

# Plot variables
fviz_famd_var(res.famd,	repel	=	TRUE)

#	Contribution	of variables to	the	first	dimension
fviz_contrib(res.famd, "var",	axes =	1)

#	Contribution of variables to the	second	dimension
fviz_contrib(res.famd, "var",	axes =	2)

# Contribution of variables to the third dimension
fviz_contrib(res.famd, "var", axes = 3)

# Contribution of variables to the fourth dimension
fviz_contrib(res.famd, "var", axes = 4)


## Quantitative variables

# Get quantitative variables
quanti.var <- get_famd_var(res.famd, "quanti.var")

# Colorblind friendly palette
cbPalette <- c("#000000", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

# Plot quantitative variables
fviz_famd_var(res.famd, "quanti.var", axes = c(3, 4),
  repel = TRUE,
  col.var = "contrib", gradient.cols = cbPalette[c(1,3,5,7)])


## Qualitative variables

# Get qualitative variables
quali.var <- get_famd_var(res.famd, "quali.var")

# Plot qualitative variables
fviz_famd_var(res.famd, "quali.var",
  color.var = "contrib", gradient.cols = cbPalette[c(1,3,5,7)])




##### 5.5 Graph trips (FAMD) #####

# Get results for individual trips
trips <- get_famd_ind(res.famd)

# Plot individual trips
fviz_famd_ind(res.famd, axes = c(1,2),
  habillage = "TrapType", palette = cbPalette[c(3,5)],
  label = "none",
  mean.point = FALSE # remove mean point for group
  )



##### 5.6 Run PCA #####

# Subset only active and supplementary variables (columns) for the PCA
df.pca <- TripData[, c("Site", "TrapType",
  "ScraperMassRatio", "BrowserMassRatio", "GrazerMassRatio", "PredatorMassRatio",
  "CPUE_kgPerTrap", "CPUE_DistFromMean", "ValuePUE",
  "MeanLLmat", "MeanTrophLevel", "MeanVulnerability", "MTC_degC",
  "FRic", "FEve", "FDiv",
  "CaConc_mgPer100g", "CaPrice_KSHPermg" #,
  # "FeConc_mgPer100g", "FePrice_KSHPermg",
  # "Omega3Conc_gPer100g", "Omega3Price_KSHPerg",
  # "ProteinConc_gPer100g", "ProteinPrice_KSHPerg",
  # "VAConc_ugPer100g", "VAPrice_KSHPerug",
  # "SeConc_ugPer100g", "SePrice_KSHPerug",
  # "ZnConc_ugPer100g", "ZnPrice_KSHPerug"
  )]

# # Empty list of rows containing infinite values in df.famd
# inf <- as.numeric(c())
# 
# # Fill in list of rows containing infinite values in df.famd
# for(i in 1:ncol(df.pca)){
#   
#   # Vector of infinite values' indices (if any)
#   a <- which(is.infinite(df.pca[,i]) == TRUE)
#   
#   # Add indices to the list
#   if(length(a) >= 1){
#     inf <- append(inf, a, after = length(inf))
#   }
#   
# }
# 
# # Remove duplicate indices from inf
# inf <- unique(inf)
# 
# # Remove infinite values from df.famd
# df.pca <- df.pca[-inf,]

# Subset df.pca for complete cases only
df.pca <- df.pca[complete.cases(df.pca),]

# Run the PCA
res.pca <- PCA(df.pca[, 3:18], ncp = 6, graph = TRUE, scale.unit = TRUE)




##### 5.7 Graph PCA #####

# Eigenvalues
eig.val <- get_eigenvalue(res.pca)

# Scree plot
fviz_eig(res.pca)

# Correlation circle
fviz_pca_var(res.pca, col.var = "black")

# Save plot
ggsave(filename = "05_PrincipalComponents_Out/PCACorrelationCircle.jpeg", device = "jpeg")

# Quality of representation
var <- get_pca_var(res.pca)
corrplot(var$cos2, is.corr = FALSE)

# Prepare lists of variables for each biplot
conservation <- list(name = c("ScraperMassRatio", "MeanLLmat", "MeanTrophLevel", "MeanVulnerability", "FRic", 
    "FEve", "FDiv"))
food <- list(name = c("CPUE_kgPerTrap", "CPUE_DistFromMean", "ValuePUE",
  "CaConc_mgPer100g", "CaPrice_KSHPermg"))

# Conservation biplot
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  #select.var = conservation,
  title = "PCA Biplot - Conservation")

# Save plot
ggsave("05_PrincipalComponents_Out/ConservationBiplot_FishTrapsFoodSec.jpeg", device = "jpeg")

# Food security biplot
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = food,
  title = "PCA Biplot - Food Security")

# Save plot
ggsave("05_PrincipalComponents_Out/FoodBiplot_FishTrapsFoodSec.jpeg", device = "jpeg")

# Now, create three more biplots, each with two dimensions, making sure each variable
# is plotted either once or twice. Variables will be included based on their cos2 values.

# We'll use 0.2 as the minimum cos2 value for inclusion

# Prepare lists of variables for each biplot
dims12.food <- list(name = c("CPUE_kgPerTrap", "ValuePUE", "MTC_degC", "CaPrice_KSHPermg"))
dims12.cons <- list(name = c("BrowserMassRatio", "MeanTrophLevel", "MeanVulnerability",
  "FEve", "FDiv"))
dims34 <- list(name = c("ScraperMassRatio", "CPUE_kgPerTrap", "CPUE_DistFromMean", "MeanLLmat",
  "MTC_degC", "FRic", "FEve", "CaPrice_KSHPermg"))
dims56 <- list(name = c("ScraperMassRatio", "GrazerMassRatio", "CaConc_mgPer100g"))

# Dims 1 and 2 biplot for food security
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = dims12.food,
  title = "PCA Biplot - Food Security")

# Save plot
ggsave("05_PrincipalComponents_Out/Biplot1Food_FishTrapsFoodSec.jpeg", device = "jpeg")

# Dims 1 and 2 biplot for conservation
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = dims12.cons,
  title = "PCA Biplot - Conservation")

# Save plot
ggsave("05_PrincipalComponents_Out/Biplot1Conservation_FishTrapsFoodSec.jpeg", device = "jpeg")

# Dims 3 and 4 biplot
fviz_pca_biplot(res.pca,
  axes = c(3, 4),
  label= "var", repel = TRUE,
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = dims34,
  title = "PCA Biplot")

# Save plot
ggsave("05_PrincipalComponents_Out/Biplot2_FishTrapsFoodSec.jpeg", device = "jpeg")

# Dims 5 and 6 biplot
fviz_pca_biplot(res.pca,
  axes = c(5, 6),
  ylim = c(-5, 10),
  label= "var", repel = TRUE,
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = dims56,
  title = "PCA Biplot")

# Save plot
ggsave("05_PrincipalComponents_Out/Biplot3_FishTrapsFoodSec.jpeg", device = "jpeg")




##### 5.8 Nutrients PCA #####

# Subset only active and supplementary variables (columns) for the PCA
df.nut.pca <- TripData[, c("Site", "TrapType",
  "CaConc_mgPer100g", "CaPrice_KSHPermg",
  "FeConc_mgPer100g", "FePrice_KSHPermg",
  "Omega3Conc_gPer100g", "Omega3Price_KSHPerg",
  "ProteinConc_gPer100g", "ProteinPrice_KSHPerg",
  "VAConc_ugPer100g", "VAPrice_KSHPerug",
  "SeConc_ugPer100g", "SePrice_KSHPerug",
  "ZnConc_ugPer100g", "ZnPrice_KSHPerug"
  )]

# # Empty list of rows containing infinite values in df.famd
# inf <- as.numeric(c())
# 
# # Fill in list of rows containing infinite values in df.famd
# for(i in 1:ncol(df.nut.pca)){
#   
#   # Vector of infinite values' indices (if any)
#   a <- which(is.infinite(df.nut.pca[,i]) == TRUE)
#   
#   # Add indices to the list
#   if(length(a) >= 1){
#     inf <- append(inf, a, after = length(inf))
#   }
#   
# }
# 
# # Remove duplicate indices from inf
# inf <- unique(inf)
# 
# # Remove infinite values from df.famd
# df.nut.pca <- df.nut.pca[-inf,]

# Subset df.famd for complete cases only
df.nut.pca <- df.nut.pca[complete.cases(df.nut.pca),]

# Subset only gated and traditional traps
df.nut.pca <- subset(df.nut.pca, df.nut.pca$TrapType != "Multiple")

# Run the PCA
res.nut.pca <- PCA(df.nut.pca[, 3:16], ncp = 5, graph = TRUE, scale.unit = TRUE)

# Scree plot
fviz_eig(res.nut.pca)

# Nutrients biplot
fviz_pca_biplot(res.nut.pca,
  label= "var", repel = TRUE,
  #ylim = c(-5, 10),
  col.ind = df.nut.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  title = "PCA Biplot - Nutrients")




##### 5.9 Food security PCA #####

# Subset only active and supplementary variables (columns) for the PCA
df.food.pca <- TripData[, c("Site", "TrapType",
  #"ScraperMassRatio", "BrowserMassRatio", "GrazerMassRatio", "PredatorMassRatio",
  "CPUE_kgPerTrap", "CPUE_DistFromMean", "ValuePUE",
  "MeanLLmat",
  #"MeanTrophLevel", "MeanVulnerability", "MTC_degC",
  #"FRic", "FEve", "FDiv",
  "CaConc_mgPer100g", #"CaPrice_KSHPermg",
  # "FeConc_mgPer100g", #"FePrice_KSHPermg",
  # "Omega3Conc_gPer100g", #"Omega3Price_KSHPerg",
  # "ProteinConc_gPer100g", #"ProteinPrice_KSHPerg",
  "VAConc_ugPer100g" #, "VAPrice_KSHPerug",
  # "SeConc_ugPer100g", #"SePrice_KSHPerug",
  # "ZnConc_ugPer100g", #"ZnPrice_KSHPerug"
  )]

# Subset df.food.pca to remove trips with mixed trap types
df.food.pca <- subset(df.food.pca, df.food.pca$TrapType != "Multiple")

# Subset df.food.pca for complete cases only
df.food.pca <- df.food.pca[complete.cases(df.food.pca),]

# Run the PCA
res.food.pca <- PCA(df.food.pca[, 3:8], ncp = 2, graph = TRUE, scale.unit = TRUE)

# Eigenvalues
eig.val <- get_eigenvalue(res.food.pca)

# Scree plot
fviz_eig(res.food.pca)

# Correlation circle
fviz_pca_var(res.food.pca, col.var = "black")

# Save plot
ggsave(filename = "05_PrincipalComponents_Out/Food_PCACorrelationCircle.jpeg", device = "jpeg")

# Quality of representation
var <- get_pca_var(res.food.pca)
corrplot(var$cos2, is.corr = FALSE)

# Prepare biplot
fviz_pca_biplot(res.food.pca,
  label= "var", repel = TRUE,
  col.ind = df.food.pca$TrapType, palette = cbPalette[c(2,4)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  title = "PCA Biplot - Food Security")

# Save plot
ggsave("05_PrincipalComponents_Out/FoodOnly_Biplot_FishTrapsFoodSec.jpeg", device = "jpeg")





##### 5.10 Conservation PCA #####

# Subset only active and supplementary variables (columns) for the PCA
df.cons.pca <- TripData[, c("Site", "TrapType",
  "ScraperMassRatio", "BrowserMassRatio", "GrazerMassRatio", "PredatorMassRatio",
  #"CPUE_kgPerTrap", "CPUE_DistFromMean", "ValuePUE",
  "MeanLLmat",
  "MeanTrophLevel", "MeanVulnerability", "MTC_degC",
  "FRic", "FEve", "FDiv" #,
  # "CaConc_mgPer100g", #"CaPrice_KSHPermg",
  # # "FeConc_mgPer100g", #"FePrice_KSHPermg",
  # # "Omega3Conc_gPer100g", #"Omega3Price_KSHPerg",
  # # "ProteinConc_gPer100g", #"ProteinPrice_KSHPerg",
  # "VAConc_ugPer100g" #, "VAPrice_KSHPerug",
  # # "SeConc_ugPer100g", #"SePrice_KSHPerug",
  # # "ZnConc_ugPer100g", #"ZnPrice_KSHPerug"
  )]

# Subset df.cons.pca to remove trips with mixed trap types
df.cons.pca <- subset(df.cons.pca, df.cons.pca$TrapType != "Multiple")

# Subset df.cons.pca for complete cases only
df.cons.pca <- df.cons.pca[complete.cases(df.cons.pca),]

# Run the PCA
res.cons.pca <- PCA(df.cons.pca[, 3:8], ncp = 3, graph = TRUE, scale.unit = TRUE)

# Eigenvalues
eig.val <- get_eigenvalue(res.cons.pca)

# Scree plot
fviz_eig(res.cons.pca)

# Correlation circle
fviz_pca_var(res.cons.pca, col.var = "black")

# Save plot
ggsave(filename = "05_PrincipalComponents_Out/Conservation_PCACorrelationCircle.jpeg", device = "jpeg")

# Quality of representation
var <- get_pca_var(res.cons.pca)
corrplot(var$cos2, is.corr = FALSE)

# Prepare biplot
fviz_pca_biplot(res.cons.pca,
  label= "var", repel = TRUE,
  col.ind = df.cons.pca$TrapType, palette = cbPalette[c(2,4)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  title = "PCA Biplot - Conservation")

# Save plot
ggsave("05_PrincipalComponents_Out/ConservationOnly_Biplot_FishTrapsFoodSec.jpeg", device = "jpeg")


