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
##    06 Tables and Figures

## Last update: 28 Jan 22




## Table of Contents
#     6.1 Load Packages and Data
#     6.x Key Herbivore Composition by Trap Type
#     6.x Size by Trap Type
#     6.x CPUE by Trap Type




# First, clean the environment
rm(list = ls())




##### 6.1 Load Packages and Data #####

# Load packages
library(readr)
library(ggplot2)
library(ggpubr)

# Load TrapData
TrapData <- read_csv("01_CleanData_Out/TrapData_Cleaned.csv", 
  col_types = cols(Date = col_date(format = "%Y-%m-%d")))

# Load CatchComposition
CatchComposition <- read_csv("02_Stability_Out/CatchComposition_FunGrDiet_Data.csv",
  col_types = cols(...1 = col_skip()))

# Load CPUE_Data
CPUE_Data <- read_csv("04_Access_Out/CPUE_Data.csv", 
    col_types = cols(...1 = col_skip()))
CPUE_ResultsBySite <- read_csv("04_Access_Out/CPUETweedie_ResultsBySite.csv",
  col_types = cols(...1 = col_skip()))




##### 6.x Key Herbivore Composition by Trap Type #####

# A simple figure of the proportion of key herbivores in catch
ggplot(data = CatchComposition, mapping = aes(x = TrapType, y = KeyHerbivoreMassRatio)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.02)) +
  #coord_cartesian(ylim = c(0, 1)) +
  theme(panel.background = element_blank(),
    axis.line = element_line())

ggsave(filename = "06_TabsFigs_Out/KeyHerbivores.jpeg", device = "jpeg")

# A figure containing three plots, one for proportion of each type of herbivore in catch

# Browsers
a <- ggplot(data = CatchComposition, mapping = aes(x = TrapType, y = BrowserMassRatio)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.5)) +
  #geom_boxplot(outlier.alpha = 0.1) +
  #coord_cartesian(ylim = c(0.4, 0.6)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  annotate(geom = "text", x = "Traditional", y = 0.56, label = "p = 0.012", size = 3) +
  ylab("") +
  xlab("")

# Scrapers
b <- ggplot(data = CatchComposition, mapping = aes(x = TrapType, y = ScraperMassRatio)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.5)) +
  #geom_boxplot(outlier.alpha = 0.1) +
  coord_cartesian(ylim = c(0.06, 0.12)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
<<<<<<< HEAD
  annotate(geom = "text", x = "Traditional", y = 0.18, label = "p = 0.855", size = 3) +
=======
  annotate(geom = "text", x = "Traditional", y = 0.12, label = "p = 0.855", size = 3) +
>>>>>>> 3585257 (Update figures to reflect new statistical tests.)
  ylab("") +
  xlab("")

# Grazers
c <- ggplot(data = CatchComposition, mapping = aes(x = TrapType, y = GrazerMassRatio)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.5)) +
  #geom_boxplot(outlier.alpha = 0.1) +
  coord_cartesian(ylim = c(0, 0.05)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
<<<<<<< HEAD
  annotate(geom = "text", x = "Traditional", y = 0.18, label = "p = 0.000", size = 3) +
=======
  annotate(geom = "text", x = "Traditional", y = 0.05, label = "p = 0.000", size = 3) +
>>>>>>> 3585257 (Update figures to reflect new statistical tests.)
  ylab("") +
  xlab("")

# Combine the plots
ggarrange(a, b, c, labels = "AUTO")

# Save the plots
ggsave(filename = "06_TabsFigs_Out/BrowsersScrapersGrazers.jpeg", device = "jpeg")




##### 6.x Length by Trap Type #####

a <- ggplot(data = TrapData, mapping = aes(x = TrapType, y = Length_cm)) +
  #stat_summary(fun = mean, geom = "point") +
  #stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.5)) +
  geom_boxplot(outlier.alpha = 0.25) +
  coord_cartesian(ylim = c(0, 60)) +
  theme(panel.background = element_blank(),
        axis.line = element_line()) +
  annotate(geom = "text", x = Inf, y = Inf, label = "p = 0.000",
    hjust = 1, vjust = 2) +
  ylab("Length (cm)") +
  xlab("Trap Type")

b <- ggplot(data = TrapData, aes(Length_cm, fill = TrapType)) +
  geom_density(alpha = 0.4) +
  coord_cartesian(xlim = c(0, 50)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  ylab("Density") +
  xlab("Length (cm)") +
  labs(fill = "Trap Type")

ggarrange(a, b, nrow = 1, widths = c(0.5, 1))

ggsave(filename = "06_TabsFigs_Out/Length.jpeg", device = "jpeg",
  width = 300, height = 150, units = "mm")




##### 6.x CPUE by Trap Type #####

# First, remove Bogowa because it only has gated traps
CPUE_Data <- subset(CPUE_Data, CPUE_Data$Site != "Bogowa")
CPUE_ResultsBySite <- subset(CPUE_ResultsBySite, CPUE_ResultsBySite$Site != "Bogowa")

# Set sites in order from least to greatest CPUE

# Data frame of median CPUE by site
CPUE_BySite <- as.data.frame(unique(CPUE_Data$Site))
colnames(CPUE_BySite) <- "Site"
CPUE_BySite$CPUE_median <- NA

# Fill in median CPUE for each site
for(i in 1:length(CPUE_BySite$Site)){
  
  # Save site
  a <- CPUE_BySite$Site[i]
  
  # Subset CPUE data for this site only
  b <- subset(CPUE_Data, CPUE_Data$Site == a)
  
  # Save the median
  CPUE_BySite$CPUE_median[i] <- median(b$CPUE)
  
}

# Sort data frame by CPUE in ascending order
CPUE_BySite <- CPUE_BySite[order(CPUE_BySite$CPUE_median),]

# Set CPUE_Data factors in the same order
CPUE_Data$Site <- factor(CPUE_Data$Site, levels = CPUE_BySite$Site)

# Round values in CPUEBySite_p

# A rounding function that always rounds .5 up to the nearest integer. (The normal
# round() function rounds .5 to the nearest even number.)
round2 <- function(x, digits = 0) {  # Function to always round 0.5 up
  posneg <- sign(x)
  z <- abs(x) * 10^digits
  z <- z + 0.5
  z <- trunc(z)
  z <- z / 10^digits
  z * posneg
}

# Round p-values
CPUE_ResultsBySite$`Pr(>|z|)` <- round2(CPUE_ResultsBySite$`Pr(>|z|)`, digits = 3)

# Put sites in order as a factor
CPUE_ResultsBySite$Site <- factor(CPUE_ResultsBySite$Site, levels = CPUE_BySite$Site)

# Prepare p-value annotations
p <- CPUE_ResultsBySite
p$`Pr(>|z|)` <- as.character(p$`Pr(>|z|)`)

for (i in 1:nrow(p)){
  p$`Pr(>|z|)`[i] <- paste("p = ", p$`Pr(>|z|)`[i], sep="")
}

# as.character rounds 0.000 to 0, so we have to fix that
for(i in 1:nrow(p)){
  
  if(p$`Pr(>|z|)`[i] == "p = 0"){
    
    p$`Pr(>|z|)`[i] <- "p = 0.000"
    
  }
  
}


# Main CPUE plot
a <- ggplot(data = CPUE_Data, aes(x = TrapType, y = CPUE)) +
  geom_boxplot(outlier.alpha = 0.1) +
  coord_cartesian(ylim = c(0,5)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  ylab("Catch per Unit Effort (kg / trap)") +
  xlab("") +
  annotate(geom = "text", x = Inf, y = Inf, label = "p = 0.000",
    hjust = 1, vjust = 2)

# CPUE by site
b <- ggplot(data = CPUE_Data, aes(x = TrapType, y = CPUE)) +
  geom_boxplot(outlier.alpha = 0.1) +
  facet_wrap(facets = vars(Site), scales = "free") +
  theme_bw() +
  ylab("") +
  xlab("") +
  geom_text(data = p,
    aes(x = Inf, y = Inf, label = `Pr(>|z|)`),
    hjust = 1.1, vjust = 1.5)

# Combine plots
ggarrange(a, b, nrow = 1, widths = c(0.5, 1))

# Save plots
ggsave(filename = "06_TabsFigs_Out/CPUE.jpeg", device = "jpeg",
  width = 500, height = 200, units = "mm")





