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
##    07 Mapping

## Script Title:
##    05 PCA Analysis

## Last update: 3 May 22

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
##    5.11 Data for modeling




##### 5.1 Packages and data #####

# Load packages
library(ggplot2)
library(FactoMineR)
library(factoextra)
library(readr)
library(corrplot)
library(dplyr)
library(ggpubr)

# NB: This trip data file has been processed to remove outliers that are likely the result of measurement
# error.

# Load trip data
TripData <- read_csv("04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv")




##### 5.2 Data manipulation #####

# Convert TripData to a data frame so you can assign row names
TripData <- as.data.frame(TripData)

# Assign row names
rownames(TripData) <- TripData$TripID

# Make column names readable
colnames(TripData)[19] <- "Browsers" #Browser mass ratio
colnames(TripData)[21] <- "Scrapers" #Scraper mass ratio
colnames(TripData)[28] <- "CPUE"
colnames(TripData)[31] <- "Value"
colnames(TripData)[32] <- "Maturity"
colnames(TripData)[34] <- "Trophic Level"
colnames(TripData)[35] <- "Vulnerability"
colnames(TripData)[36] <- "Temperature"
colnames(TripData)[38] <- "Fun. Richness"
colnames(TripData)[39] <- "Fun. Evenness"
colnames(TripData)[40] <- "Fun. Divergence"
colnames(TripData)[42] <- "Calcium Yield"
colnames(TripData)[43] <- "Calcium Concentration"
colnames(TripData)[59] <- "Vitamin A Concentration"

# Delete now redundant TripID column
TripData <- TripData[,-1]

# Subset only active and supplementary variables (columns) for the FAMD
df.famd <- TripData[, c("Site", "TrapType",
  "B.undulatus", "LowNoCatch",
  "Scrapers", "Browsers", "GrazerMassRatio", "PredatorMassRatio",
  "CPUE", "CPUE_DistFromMean", "Value",
  "Maturity", "Trophic Level", "Vulnerability", "Temperature",
  "FRic", "FEve", "FDiv",
  "Calcium", "CaPrice_KSHPermg" #,
#  "FeConc_mgPer100g", "FePrice_KSHPermg",
#  "Omega3Conc_gPer100g", "Omega3Price_KSHPerg",
#  "ProteinConc_gPer100g", "ProteinPrice_KSHPerg",
#  "VAConc_ugPer100g", "VAPrice_KSHPerug",
#  "SeConc_ugPer100g", "SePrice_KSHPerug",
#  "ZnConc_mgPer100g", "ZnPrice_KSHPermg"
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
  "Scrapers", "Browsers", "GrazerMassRatio", "PredatorMassRatio",
  "CPUE", "CPUE_DistFromMean", "Value",
  "Maturity", "Trophic Level", "Vulnerability", "Temperature",
  "FRic", "FEve", "FDiv",
  "Calcium", "CaPrice_KSHPermg" #,
  # "FeConc_mgPer100g", "FePrice_KSHPermg",
  # "Omega3Conc_gPer100g", "Omega3Price_KSHPerg",
  # "ProteinConc_gPer100g", "ProteinPrice_KSHPerg",
  # "VAConc_ugPer100g", "VAPrice_KSHPerug",
  # "SeConc_ugPer100g", "SePrice_KSHPerug",
  # "ZnConc_mgPer100g", "ZnPrice_KSHPermg"
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

# Quality of representation
var <- get_pca_var(res.pca)
corrplot(var$cos2, is.corr = FALSE)

# Prepare lists of variables for each biplot
conservation <- list(name = c("Scrapers", "Maturity", "Trophic Level", "Vulnerability", "FRic", 
    "FEve", "FDiv"))
food <- list(name = c("CPUE", "CPUE_DistFromMean", "Value",
  "Calcium", "CaPrice_KSHPermg"))

# Conservation biplot
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  #select.var = conservation,
  title = "PCA Biplot - Conservation")

# Food security biplot
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = food,
  title = "PCA Biplot - Food Security")

# Now, create three more biplots, each with two dimensions, making sure each variable
# is plotted either once or twice. Variables will be included based on their cos2 values.

# We'll use 0.2 as the minimum cos2 value for inclusion

# Prepare lists of variables for each biplot
dims12.food <- list(name = c("CPUE", "Value", "Temperature", "CaPrice_KSHPermg"))
dims12.cons <- list(name = c("Browsers", "Trophic Level", "Vulnerability",
  "FEve", "FDiv"))
dims34 <- list(name = c("Scrapers", "CPUE", "CPUE_DistFromMean", "Maturity",
  "Temperature", "FRic", "FEve", "CaPrice_KSHPermg"))
dims56 <- list(name = c("Scrapers", "GrazerMassRatio", "Calcium"))

# Dims 1 and 2 biplot for food security
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = dims12.food,
  title = "PCA Biplot - Food Security")

# Dims 1 and 2 biplot for conservation
fviz_pca_biplot(res.pca,
  label= "var", repel = TRUE,
  ylim = c(-5, 10),
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = dims12.cons,
  title = "PCA Biplot - Conservation")

# Dims 3 and 4 biplot
fviz_pca_biplot(res.pca,
  axes = c(3, 4),
  label= "var", repel = TRUE,
  col.ind = df.pca$TrapType, palette = cbPalette[c(2,4,7)], alpha = 0.6,
  col.var = "black",
  addEllipses = TRUE,
  select.var = dims34,
  title = "PCA Biplot")

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




##### 5.8 Nutrients PCA #####

# Subset only active and supplementary variables (columns) for the PCA
df.nut.pca <- TripData[, c("Site", "TrapType",
  "Calcium Concentration", "Calcium Yield",
  "FeConc_mgPer100g", "FePUE",
  "Omega3Conc_gPer100g", "Omega3PUE",
  "ProteinConc_gPer100g", "ProteinPUE",
  "Vitamin A Concentration", "VAPUE",
  "SeConc_ugPer100g", "SePUE",
  "ZnConc_mgPer100g", "ZnPUE"
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

# Quality of representation
var <- get_pca_var(res.nut.pca)
corrplot(var$cos2, is.corr = FALSE)

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
  "CPUE", "CPUE_DistFromMean", "Value",
  "Maturity",
  "Calcium Yield", "Calcium Concentration",
  "Vitamin A Concentration"
  )]

# Subset df.food.pca to remove trips with mixed trap types
df.food.pca <- subset(df.food.pca, df.food.pca$TrapType != "Multiple")

# Subset df.food.pca for complete cases only
df.food.pca <- df.food.pca[complete.cases(df.food.pca),]

# Run the PCA
res.food.pca <- PCA(df.food.pca[, 3:9], ncp = 2, graph = TRUE, scale.unit = TRUE)

# Eigenvalues
eig.val <- get_eigenvalue(res.food.pca)

# Scree plot
fviz_eig(res.food.pca)

# Correlation circle
fviz_pca_var(res.food.pca, col.var = "black")

# Quality of representation
var <- get_pca_var(res.food.pca)
corrplot(var$cos2, is.corr = FALSE)

# Prepare lists of variables for each biplot
names <- list(name = c("CPUE", "Value", "Maturity", "Calcium Yield", "Calcium Concentration", "Vitamin A Concentration"))

# Prepare biplot
plot3 <- fviz_pca_biplot(res.food.pca,
  label= "var", repel = TRUE,
  col.ind = df.food.pca$TrapType, palette = cbPalette[c(2,4)], alpha.ind = 0.6,
  col.var = "black", alpha.var = 0.5,
  addEllipses = TRUE,
  select.var = names,
  title = "",
  ylim = c(-4, 7),
  legend.title = "Trap Type") +
  labs(x = "Food Security Dim. 1", y = "Food Security Dim. 2", title = "") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

plot3

# Save biplot
ggsave("05_PrincipalComponents_Out/Fig3_FoodSecBiplot.jpeg", device = "jpeg")




##### 5.10 Conservation PCA #####

# Subset only active and supplementary variables (columns) for the PCA
df.cons.pca <- TripData[, c("Site", "TrapType",
  "Scrapers", "Browsers",
  "Maturity",
  "Trophic Level", "Vulnerability", "Temperature",
  "Fun. Richness", "Fun. Evenness", "Fun. Divergence"
  )]

# Subset df.cons.pca to remove trips with mixed trap types
df.cons.pca <- subset(df.cons.pca, df.cons.pca$TrapType != "Multiple")

# Subset df.cons.pca for complete cases only
df.cons.pca <- df.cons.pca[complete.cases(df.cons.pca),]

# Run the PCA
res.cons.pca <- PCA(df.cons.pca[, 3:11], ncp = 3, graph = TRUE, scale.unit = TRUE)

# Eigenvalues
eig.val <- get_eigenvalue(res.cons.pca)

# Scree plot
fviz_eig(res.cons.pca)

# Correlation circle
fviz_pca_var(res.cons.pca, col.var = "black")

# Quality of representation
var <- get_pca_var(res.cons.pca)
corrplot(var$cos2, is.corr = FALSE)

# Prepare lists of variables for each biplot
vars.plot1 <- list(name = c("Browsers", "Trophic Level", "Temperature", "Vulnerability", "Fun. Divergence",
  "Maturity", "Fun. Evenness", "Fun. Richness"))
vars.plot2 <- list(name = c("Browsers", "Trophic Level", "Temperature", "Vulnerability", "Fun. Divergence",
  "Scrapers"))

# Prepare biplot for dims 1 and 2
plot1 <- fviz_pca_biplot(res.cons.pca,
  axes = c(1, 2),
  label= "var", repel = TRUE,
  col.ind = df.cons.pca$TrapType, palette = cbPalette[c(2,4)], alpha.ind = 0.6,
  col.var = "black", alpha.var = 0.5,
  ylim = c(-4, 5),
  select.var = vars.plot1,
  addEllipses = TRUE,
  title = "",
  legend.title = "Trap Type") +
  labs(x = "Conservation Dim. 1", y = "Conservation Dim. 2", title = "") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

# Prepare biplot for dims 1 and 3
plot2 <- fviz_pca_biplot(res.cons.pca,
  axes = c(1, 3),
  label= "var", repel = TRUE,
  col.ind = df.cons.pca$TrapType, palette = cbPalette[c(2,4)], alpha.ind = 0.6,
  col.var = "black", alpha.var = 0.5,
  ylim = c(-4, 5),
  select.var = vars.plot2,
  addEllipses = TRUE,
  title = "",
  legend.title = "Trap Type") +
  labs(x = "Conservation Dim. 1", y = "Conservation Dim. 3", title = "") +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank())

# Save plot
ggarrange(plot1, plot2, legend = "right", common.legend = TRUE)
ggsave(filename = "05_PrincipalComponents_Out/Fig5_ConservationBiplots.jpeg", device = "jpeg",
  height = 5, width = 14, units = "in")

# Make plot of all three biplots together
ggarrange(plot1, plot2, plot3, legend = "none")
ggsave(filename = "05_PrincipalComponents_Out/AllBiplots.jpeg", device = "jpeg")


##### 5.11 Data for modeling #####

# Save a data frame for linear modeling

# Make row names in df.cons.pca and df.food.pca a column
df.cons.pca$TripID <- rownames(df.cons.pca)
df.food.pca$TripID <- rownames(df.food.pca)

# Combine data frames
TripData_ForModeling <- inner_join(df.cons.pca, df.food.pca, by = "TripID",
  suffix = c("", ".y"), keep = TRUE)

# Remove non-modeled variables
TripData_ForModeling <- TripData_ForModeling[, c("TripID", "Site", "TrapType")]

# Extract food pca coordinates
food.dims <- data.frame(res.food.pca[["ind"]][["coord"]])

# Make Trip ID a column
food.dims$TripID <- rownames(food.dims)

# Add food dimensions to TripData_ForModeling
TripData_ForModeling <- inner_join(TripData_ForModeling, food.dims, by = "TripID",
  suffix = c("", ".y"), keep = TRUE)

# Rename food dim 1, representing CPUE, value PUE, and Ca yield
colnames(TripData_ForModeling)[4] <- "FoodDim1"

# Rename food dim 2, representing Vitamin A concentration, Ca concentration, and maturity
colnames(TripData_ForModeling)[5] <- "FoodDim2"

# Remove surplus variables
TripData_ForModeling <- TripData_ForModeling[, c("TripID", "Site", "TrapType", "FoodDim1", "FoodDim2")]

# Extract conservation pca coordinates
cons.dims <- data.frame(res.cons.pca[["ind"]][["coord"]])

# Make Trip ID a column
cons.dims$TripID <- rownames(cons.dims)

# Add conservation dimensions to TripData_ForModeling
TripData_ForModeling <- inner_join(TripData_ForModeling, cons.dims, by = "TripID",
  suffix = c("", ".y"), keep = TRUE)

# Rename conservation dim 1, representing browsers, trophic level, MTC, vulnerability, and Fun. divergence
colnames(TripData_ForModeling)[6] <- "ConsDim1"

# Rename conservation dim 2, representing L/Lopt, Fun. evenness, and fun. richness
colnames(TripData_ForModeling)[7] <- "ConsDim2"

# Remove surplus variables
TripData_ForModeling <- TripData_ForModeling[, c("TripID", "Site", "TrapType",
  "FoodDim1", "FoodDim2",
  "ConsDim1", "ConsDim2")]

# Save data
write.csv(TripData_ForModeling, file = "05_PrincipalComponents_Out/TripData_ForModeling.csv",
  row.names = FALSE)



