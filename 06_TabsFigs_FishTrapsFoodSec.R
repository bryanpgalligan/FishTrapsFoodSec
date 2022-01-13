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

## Last update: 13 Jan 22




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
  coord_cartesian(ylim = c(0.4, 0.6)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  annotate(geom = "text", x = "Traditional", y = 0.58, label = "p = 0.012", size = 3) +
  ylab("") +
  xlab("")

# Scrapers
b <- ggplot(data = CatchComposition, mapping = aes(x = TrapType, y = ScraperMassRatio)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.5)) +
  coord_cartesian(ylim = c(0, 0.2)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  annotate(geom = "text", x = "Traditional", y = 0.18, label = "p = 0.659", size = 3) +
  ylab("") +
  xlab("")

# Grazers
c <- ggplot(data = CatchComposition, mapping = aes(x = TrapType, y = GrazerMassRatio)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.5)) +
  coord_cartesian(ylim = c(0, 0.2)) +
  theme(panel.background = element_blank(),
    axis.line = element_line()) +
  annotate(geom = "text", x = "Traditional", y = 0.18, label = "p = 0.020", size = 3) +
  ylab("") +
  xlab("")

# Combine the plots
ggarrange(a, b, c, labels = "AUTO")

# Save the plots
ggsave(filename = "06_TabsFigs_Out/BrowsersScrapersGrazers.jpeg", device = "jpeg")




##### 6.x Length by Trap Type #####
a <- ggplot(data = TrapData, mapping = aes(x = TrapType, y = Length_cm)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.02)) +
  theme(panel.background = element_blank(),
        axis.line = element_line())

b <- ggplot(data = TrapData, aes(Length_cm, group = TrapType)) +
  geom_histogram(binwidth = 2) +
  coord_cartesian(xlim = c(0, 50)) +
  facet_wrap(facets = vars(TrapType)) +
  theme_bw()

ggarrange(a, b, nrow = 1, widths = c(0.5, 1))

ggsave(filename = "06_TabsFigs_Out/Length.jpeg", device = "jpeg")




##### 6.x CPUE by Trap Type #####

a <- ggplot(data = CPUE_Data, aes(x = TrapType, y = CPUE)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.02)) +
  theme(panel.background = element_blank(),
    axis.line = element_line())

b <- ggplot(data = CPUE_Data, aes(x = TrapType, y = CPUE, group = Site)) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun.data = mean_se, geom = "errorbar", aes(width = 0.02)) +
  facet_wrap(facets = vars(Site)) +
  theme_bw()

ggarrange(a, b, nrow = 1, widths = c(0.5, 1))

ggsave(filename = "06_TabsFigs_Out/CPUE.jpeg", device = "jpeg",
  width = 500, height = 200, units = "mm")



