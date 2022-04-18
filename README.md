---
output:
  html_document: default
  pdf_document: default
---

# FishTrapsFoodSec

## Escape gaps contribute to ecosystem health and food security in an artisanal coral reef trap fishery.

**Authors:**

-   Bryan P. Galligan, S.J. ([bgalligan\@jesuits.org](mailto:bgalligan@jesuits.org))

-   Austin Humphries ([humphries\@uri.edu](mailto:humphries@uri.edu))

-   Maxwell Kodia Azali ([mkodia\@wcs.org](mailto:mkodia@wcs.org))

-   Tim McClanahan ([tmcclanahan\@wcs.org](mailto:tmcclanahan@wcs.org))

## Overview

This repository is the data management and analysis workflow of a research project investigating the ecosystem and food security benefits and tradeoffs of adding escape gaps to traditional African fish traps. It includes 10 years of landings data from artisanal fishers operating in the inshore waters of Kenya and Tanzania.

## Instructions

R scripts should be run in numeric order, beginning with `01_CleanData_FishTrapsFoodSec.R`. Each script has two corresponding folders in the repository, one called `temp` and one called `out`. The `temp` folder contains temporary output files that are not needed for further analysis or reference. The `out` folder contains output files that will be used by subsequent scripts, kept for future reference, or formatted as data tables for publication.

The R script `02_FishLife_FishTrapsFoodSec.R` retrieves estimated life history parameters for all species in the catch using Jim Thorson's `FishLife` [package](https://github.com/James-Thorson-NOAA/FishLife) (Thorson, 2020; Thorson et al., 2017). **You must restart R twice while running this script**, once after running the first line, which installs an older version of `rfishbase`, and once at the end of the script, which re-installs the newest version of `rfishbase`. This is necessary because `FishLife`is only compatible with earlier versions of `rfishbase`. These instructions are commented in the script itself.

## Repository Files

| File/Folder                                                                                                                                           | Enclosed File                                                                                                                                                        | Type            | Notes                                                                                                                                       |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| [00_RawData](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/00_RawData)                                                               |                                                                                                                                                                      | Folder          | Contains raw data                                                                                                                           |
|                                                                                                                                                       | [CombinedTrapData_2010_2019_Anonymized.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/CombinedTrapData_2010_2019_Anonymized.csv)     | Spreadsheet     | WCS landings data                                                                                                                           |
|                                                                                                                                                       | [FunctionalGroupKey_DietBased_Condy2015.xlsx](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/FunctionalGroupKey_DietBased_Condy2015.xlsx) | Spreadsheet     | A key developed for previous WCS studies assigning select species to diet-based functional groups                                           |
|                                                                                                                                                       | [Traits_MbaruEtAl2020.xls](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/Traits_MbaruEtAl2020.xls)                                       | Spreadsheet     | A list of species with categorizations by functional trait, developed by Mbaru et al. (2020).                                               |
|                                                                                                                                                       | [ValueByFamily.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/ValueByFamily.csv)                                                     | Spreadsheet     | A list of fish families and their corresponding values in Kenya Shillings developed for previous WCS studies.                               |
| [01_CleanData_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_FishTrapsFoodSec.R)                     |                                                                                                                                                                      | R Script        | Cleans the data and saves an edited and more compact version. Produces three normalized output spreadsheets as found in `01_CleanData_Out`. |
| [01_CleanData_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/01_CleanData_Out)                                                   |                                                                                                                                                                      | Folder          | Contains output files from eponymous R script                                                                                               |
|                                                                                                                                                       | [CatchData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Out/CatchData_GatedTraps_Galligan.csv)               | Spreadsheet     | Contains landings data; each row is an individual fish                                                                                      |
|                                                                                                                                                       | [SpeciesData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Out/SpeciesData_GatedTraps_Galligan.csv)           | Spreadsheet     | Data for each species in the catch                                                                                                          |
|                                                                                                                                                       | [TripData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Out/TripData_GatedTraps_Galligan.csv)                 | Spreadsheet     | Contains landings data; each row is one fishing trip                                                                                        |
| [01_CleanData_Temp](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/01_CleanData_Temp)                                                 |                                                                                                                                                                      | Folder          | Contains temporary output files from eponymous R script                                                                                     |
|                                                                                                                                                       | [SuspiciousPrices.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Temp/SuspiciousPrices.csv)                                        | Spreadsheet     | A list of price data from the original WCS spreadsheet that seemed suspicious. These prices have all been replaced.                         |
|                                                                                                                                                       | [TrapData_Cleaned.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Temp/TrapData_Cleaned.csv)                                        | Spreadsheet     | A cleaned copy of the original WCS data sheet.                                                                                              |
|                                                                                                                                                       | [Unique_Species.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Temp/Unique_Species.csv)                                            | Spreadsheet     | A list of species found in the WCS landings data                                                                                            |
| [02_FishLife_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_FishTrapsFoodSec.R)                       |                                                                                                                                                                      | R Script        | Obtains estimates of life history parameters for all species using Jim Thorson's `FishLife` package.                                        |
| [02_FishLife_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/02_FishLife_Out)                                                     |                                                                                                                                                                      | Folder          | Contains output files from eponymous R script                                                                                               |
|                                                                                                                                                       | [CatchData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/CatchData_GatedTraps_Galligan.csv)                | Spreadsheet     | Updates catch data to include life history parameters                                                                                       |
|                                                                                                                                                       | [SpeciesData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv)            | Spreadsheet     | Updates species data to include life history parameters                                                                                     |
|                                                                                                                                                       | [TripData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/TripData_GatedTraps_Galligan.csv)                  | Spreadsheet     | Updates trip data to include life history parameters                                                                                        |
| 02_FishLife_Temp                                                                                                                                      |                                                                                                                                                                      | Folder          | Empty                                                                                                                                       |
| [03_FunctionalDiversity_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_FishTrapsFoodSec.R) |                                                                                                                                                                      | R Script        | Workflow for the `mFD` package, which computes multidimensional functional diversity indices                                                |
| [03_FunctionalDiversity_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/03_FunctionalDiversity_Out)                               |                                                                                                                                                                      | Folder          | Contains output files from eponymous R script                                                                                               |
|                                                                                                                                                       | [FunctionalSpacesQuality.png](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/FunctionalSpacesQuality.png)                 | Figure          | Results of PCoA analysis determining the quality of functional spaces                                                                       |
|                                                                                                                                                       | [PositionSpeciesFunctionalAxes.png](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/PositionSpeciesFunctionalAxes.png)     | Figure          | Plots functional entities along pairs of functional axes                                                                                    |
|                                                                                                                                                       | [TraitsAndPCoAAxes.png](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/TraitsAndPCoAAxes.png)                             | Figure          | Plots relationships between traits and PCoA axes                                                                                            |
|                                                                                                                                                       | [TripData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/TripData_GatedTraps_Galligan.csv)       | Spreadsheet     | Updates trip data with functional diversity measures                                                                                        |
| 03_FunctionalDiversity_Temp                                                                                                                           |                                                                                                                                                                      | Folder          | Empty                                                                                                                                       |
| [04_DataExploration_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/04_DataExploration_FishTrapsFoodSec.R)         |                                                                                                                                                                      | R Script        | Explores data following procedures of Zuur et al. (2010)                                                                                    |
| 04_DataExploration_Out                                                                                                                                |                                                                                                                                                                      | Folder          | Empty                                                                                                                                       |
| 04_DataExploration_Temp                                                                                                                               |                                                                                                                                                                      | Folder          | Empty                                                                                                                                       |
| [Archive](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive)                                                                     |                                                                                                                                                                      | Folder          | See below                                                                                                                                   |
| [README.md](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/README.md)                                                                 |                                                                                                                                                                      | Markdown        | This document                                                                                                                               |
| [RWorkflow_FishTrapsFoodSec.Rproj](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/RWorkflow_FishTrapsFoodSec.Rproj)                   |                                                                                                                                                                      | RStudio Project | Sets working directory, source documents, etc. in RStudio                                                                                   |

## Archived Files

These files have been kept for posterity, but are not used in the current analysis. They are located in the `Archive` folder.

|                                                                                                                                                 |                                                                                                                                                                                        |             |                                                                                                                                                         |
|-------------------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| **File/Folder**                                                                                                                                 | **Enclosed File**                                                                                                                                                                      | **Type**    | **Notes**                                                                                                                                               |
| [02_Stability_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_FishTrapsFoodSec.R)       |                                                                                                                                                                                        | R Script    | Analysis of the stability pillar of the food security framework                                                                                         |
| [02_Stability_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/02_Stability_Out)                                     |                                                                                                                                                                                        | Folder      | Contains output files from the eponymous R script                                                                                                       |
|                                                                                                                                                 | [CatchComposition_DietCt_ModelComparison.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Out/CatchComposition_DietCt_ModelComparison.csv)     | Spreadsheet | Results of model comparisons for an ANOVA testing effect of trap type on catch composition (no. of fish, categorized by diet-based functional groups)   |
|                                                                                                                                                 | [CatchComposition_DietCt_Results.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Out/CatchComposition_DietCt_Results.csv)                     | Spreadsheet | Results of ANOVA testing effect of trap type on catch composition (no. of fish, categorized by diet-based functional groups)                            |
|                                                                                                                                                 | [CatchComposition_DietMass_ModelComparison.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Out/CatchComposition_DietMass_ModelComparison.csv) | Spreadsheet | Results of model comparisons for an ANOVA testing effect of trap type on catch composition (biomass ratio, categorized by diet-based functional groups) |
|                                                                                                                                                 | [CatchComposition_DietMass_Results.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Out/CatchComposition_DietMass_Results.csv)                 | Spreadsheet | Results of ANOVA testing the effect of trap type on catch composition (biomass ratio, categorized by diet-based functional groups)                      |
|                                                                                                                                                 | [CatchComposition_FunGrDiet_Data.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Out/CatchComposition_FunGrDiet_Data.csv)                     | Spreadsheet | Datasheet used to analyze catch composition by diet-based functional group                                                                              |
| [02_Stability_Temp](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/02_Stability_Temp)                                   |                                                                                                                                                                                        | Folder      | Contains temporary output files from the eponymous R script                                                                                             |
|                                                                                                                                                 | [BrowserMassQQ.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Temp/BrowserMassQQ.jpeg)                                                      | Image       | QQ plot of residuals for catch composition of browsers by mass                                                                                          |
|                                                                                                                                                 | [GrazerMassQQ.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Temp/GrazerMassQQ.jpeg)                                                        | Image       | QQ plot of residuals for catch composition of grazers by mass                                                                                           |
|                                                                                                                                                 | [ScraperMassQQ.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/02_Stability_Temp/ScraperMassQQ.jpeg)                                                      | Image       | QQ plot of residuals for catch composition of scrapers by mass                                                                                          |
| [03_Availability_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/03_Availability_FishTrapsFoodSec.R) |                                                                                                                                                                                        | R Script    | Analysis of the availability pillar of the food security framework                                                                                      |
| [03_Availability_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/03_Availability_Out)                               |                                                                                                                                                                                        | Folder      | Contains output files from the eponymous R script                                                                                                       |
|                                                                                                                                                 | [LengthAOV_ModelComparison.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/03_Availability_Out/LengthAOV_ModelComparison.csv)                              | Spreadsheet | Comparison of four ANOVAs for finding effect of trap type on length                                                                                     |
|                                                                                                                                                 | [LengthAOV_Results.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/03_Availability_Out/LengthAOV_Results.csv)                                              | Spreadsheet | Effect of trap type on length ANOVA results                                                                                                             |
|                                                                                                                                                 | [LengthData.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/03_Availability_Out/LengthData.csv)                                                            | Spreadsheet | A subset of the Trap Data spreadsheet that only includes entries with length data                                                                       |
| [03_Availability_Temp](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/03_Availability_Temp)                             |                                                                                                                                                                                        | Folder      | Contains temporary output files from the eponymous R script                                                                                             |
|                                                                                                                                                 | [LengthQQ.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/03_Availability_Temp/LengthQQ.jpeg)                                                             | Image       | QQ plot of residuals for length distribution by trap type                                                                                               |
| [04_Access_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/04_Access_FishTrapsFoodSec.R)             |                                                                                                                                                                                        | R Script    | Analysis of the access pillar of the food security framework                                                                                            |
| [04_Access_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/04_Access_Out)                                           |                                                                                                                                                                                        | Folder      | Contains output files from the eponymous R script                                                                                                       |
|                                                                                                                                                 | [CPUEBySite_pvalues.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/04_Access_Out/CPUEBySite_pvalues.csv)                                                  | Spreadsheet | Contains p-values for ANOVAs of effect of trap type on CPUE at each site                                                                                |
|                                                                                                                                                 | [CPUE_Data.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/04_Access_Out/CPUE_Data.csv)                                                                    | Spreadsheet | Data for CPUE by trip for trips that only used one trap type (gated or traditional)                                                                     |
|                                                                                                                                                 | [CPUE_ModelComparison.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/04_Access_Out/CPUE_ModelComparison.csv)                                              | Spreadsheet | Comparison of four ANOVAs for finding effect of trap type on CPUE                                                                                       |
|                                                                                                                                                 | [CPUE_Results.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/04_Access_Out/CPUE_Results.csv)                                                              | Spreadsheet | Effect of trap type on CPUE (ANOVA results)                                                                                                             |
| [04_Access_Temp](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/04_Access_Temp)                                         |                                                                                                                                                                                        | Folder      | Contains temporary output files from the eponymous R script                                                                                             |
|                                                                                                                                                 | [CPUEQQ.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/04_Access_Temp/CPUEQQ.jpeg)                                                                       | Image       | QQ plot of residuals for ANOVA of CPUE by trap type                                                                                                     |
| [06_TabsFigs_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/06_TabsFigs_FishTrapsFoodSec.R)         |                                                                                                                                                                                        | R Script    | Assembles tables and figures                                                                                                                            |
| [06_TabsFigs_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/06_TabsFigs_Out)                                       |                                                                                                                                                                                        | Folder      | Contains figures assembled so far                                                                                                                       |
|                                                                                                                                                 | [BrowsersScrapersGrazers.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/06_TabsFigs_Out/BrowsersScrapersGrazers.jpeg)                                    | Image       | Effect of trap type on catch composition (ratio of browsers, scrapers, and grazers by mass)                                                             |
|                                                                                                                                                 | [CPUE.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/06_TabsFigs_Out/CPUE.jpeg)                                                                          | Image       | Effect of trap type on CPUE                                                                                                                             |
|                                                                                                                                                 | [KeyHerbivores.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/06_TabsFigs_Out/KeyHerbivores.jpeg)                                                        | Image       | Effect of trap type on catch composition (ratio of key herbivores by mass)                                                                              |
|                                                                                                                                                 | [Length.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/06_TabsFigs_Out/Length.jpeg)                                                                      | Image       | Effect of trap type on length                                                                                                                           |
| 06_TabsFigs_Temp                                                                                                                                |                                                                                                                                                                                        | Folder      | Empty                                                                                                                                                   |
| [ExploratoryPlots.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/ExploratoryPlots.R)                                 |                                                                                                                                                                                        | R Script    | Contains code to generate some exploratory plots of the data                                                                                            |
| [ExploratoryPlots](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/Archive/ExploratoryPlots)                                     |                                                                                                                                                                                        | Folder      | Contains exploratory plots of the data                                                                                                                  |
|                                                                                                                                                 | [BrowserMassRatio.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/ExploratoryPlots/BrowserMassRatio.jpeg)                                                 | Figure      | Density plots of catch composition of browsers (ratio by mass) across sites and trap types                                                              |
|                                                                                                                                                 | [CPUE.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/ExploratoryPlots/CPUE.jpeg)                                                                         | Figure      | Density plots of CPUE across sites and trap types                                                                                                       |
|                                                                                                                                                 | [GrazerMassRatio.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/ExploratoryPlots/GrazerMassRatio.jpeg)                                                   | Figure      | Density plots of catch composition of grazers (ratio by mass) across sites and trap types                                                               |
|                                                                                                                                                 | [KeyHerbivoreMassRatio.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/ExploratoryPlots/KeyHerbivoreMassRatio.jpeg)                                       | Figure      | Density plots of catch composition of key herbivores (ratio by mass) across sites and trap types                                                        |
|                                                                                                                                                 | [LengthDistributions.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/ExploratoryPlots/LengthDistributions.jpeg)                                           | Figure      | Density plots of fish lengths across sites and trap types                                                                                               |
|                                                                                                                                                 | [ScraperMassRatio.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/Archive/ExploratoryPlots/ScraperMassRatio.jpeg)                                                 | Figure      | Density plots of catch composition of scrapers (ratio by mass) across sites and trap types                                                              |

## Processed Data

**Date** of data collection: 2010-2019

Geographic **location** of data collection: southern coast of Kenya, northern coast of Tanzania

Information about **funding** sources that supported the collection of the data: data were collected by Wildlife Conservation Society, Mombasa, Kenya

**Restrictions** placed on the data: Please contact Tim McClanahan before using data.

Portions of this data have been **used by** Condy et al. (2015), Gomes et al. (2014), Mbaru et al. (2020), and Mbaru and McClanahan (2013).

### Trip Data

**Filepath**: `03_FunctionalDiversity_Out/TripData_GatedTraps_Galligan.csv`

Number of **variables**: 67

Number of **observations**: 2734

**Missing data** code: `NA`

#### Variable List

| Variable             | Notes                                                                                                 |
|----------------------|-------------------------------------------------------------------------------------------------------|
| TripID               | Alphanumeric identifier for each fishing trip                                                         |
| Date                 | Sampling date                                                                                         |
| Country              | Sampling location (country)                                                                           |
| Site                 | Sampling location (landing site)                                                                      |
| Latitude             | Sampling location (decimal degrees)                                                                   |
| Longitude            | Sampling location (decimal degrees)                                                                   |
| Observer             | Researcher responsible for data                                                                       |
| Fisher               | Alphanumeric identifier for each fisher or crew (combination of fishers)                              |
| TotalCrew            | Size of fishing crew                                                                                  |
| TrapsOwned           | Number of traps owned by this fisher/crew                                                             |
| TrapsFished          | Number of traps fished on this trip                                                                   |
| TrapLocation         | Fishing location                                                                                      |
| Depth_m              | Depth of trap deployment (meters)                                                                     |
| SoakTime_Days        | Duration of trap deployment (days)                                                                    |
| TrapType             | Type of trap used on this fishing trip (traditional, gated, or multiple)                              |
| GapSize_cm           | Size of escape gap on traps used (centimeters or multiple)                                            |
| B.undulatus          | Was *Balistapus undulatus* present in the catch? (yes/no)                                             |
| BrowserMass_g        | Mass of browsing herbivores in the catch (grams)                                                      |
| BrowserMassRatio     | Proportion of browsers in the catch by mass                                                           |
| ScraperMass_g        | Mass of scraping herbivores in the catch (grams)                                                      |
| ScraperMassRatio     | Proportion of scrapers in the catch by mass                                                           |
| GrazerMass_g         | Mass of grazers in the catch (grams)                                                                  |
| GrazerMassRatio      | Proportion of grazers in the catch by mass                                                            |
| PredatorMass_g       | Mass of piscivorous predators in the catch (grams)                                                    |
| PredatorMassRatio    | Proportion of piscivorous predators in the catch by mass                                              |
| TotalCatch_g         | Total catch (grams)                                                                                   |
| LowNoCatch           | Was the catch \< 1 kg? (LowNoCatch / Catch)                                                           |
| CPUE_kgPerTrap       | Catch per unit effort (kilograms per trap)                                                            |
| CPUE_DistFromMean    | Catch stability (relative distance of CPUE from mean CPUE for each combination of site and trap type) |
| TotalValue_KSH       | Value of the catch (Kenya Shillings)                                                                  |
| ValuePUE             | Value per unit effort (Kenya Shillings per trap)                                                      |
| MeanLLmat            | Mean ratio of length to length at first maturity                                                      |
| MeanTrophLevel       | Mean trophic level                                                                                    |
| MeanVulnerability    | Mean species vulnerability (0-100)                                                                    |
| MTC_degC             | Mean temperature of the catch (degrees Celsius)                                                       |
| FECount              | Functional richness (count of unique functional entities in the catch)                                |
| FRic                 | Functional richness (proportion of hull volume)                                                       |
| FEve                 | Functional evenness                                                                                   |
| FDiv                 | Functional diversity                                                                                  |
| TotalCa_mg           | Total calcium (milligrams)                                                                            |
| CaPUE                | Calcium per unit effort (milligrams per trap)                                                         |
| CaConc_mgPer100g     | Calcium concentration (milligrams per 100 grams)                                                      |
| CaPrice_KSHPermg     | Value of calcium (Kenya Shillings per milligram)                                                      |
| TotalFe_mg           | Total iron (milligrams)                                                                               |
| FePUE                | Iron per unit effort (milligrams per trap)                                                            |
| FeConc_mgPer100g     | Iron concentration (milligrams per 100 grams)                                                         |
| FePrice_KSHPermg     | Value of iron (Kenya Shillings per milligram)                                                         |
| TotalOmega3_g        | Total Omega-3 polyunsaturated fatty acids (grams)                                                     |
| Omega3PUE            | Omega-3 per unit effort (grams per trap)                                                              |
| Omega3Conc_gPer100g  | Omega-3 concentration (grams per 100 grams)                                                           |
| Omega3Price_KSHPerg  | Value of omega-3 (Kenya Shillings per gram)                                                           |
| TotalProtein_g       | Total protein (grams)                                                                                 |
| ProteinPUE           | Protein per unit effort (grams per trap)                                                              |
| ProteinConc_gPer100g | Protein concentration (grams per 100 grams)                                                           |
| ProteinPrice_KSHPerg | Value of protein (Kenya Shillings per gram)                                                           |
| TotalVA_ug           | Total vitamin A (micrograms)                                                                          |
| VAPUE                | Vitamin A per unit effort (micrograms per trap)                                                       |
| VAConc_ugPer100g     | Vitamin A concentration (micrograms per 100 grams)                                                    |
| VAPrice_KSHPerug     | Value of vitamin A (Kenya Shillings per microgram)                                                    |
| TotalSe_ug           | Total selenium (micrograms)                                                                           |
| SePUE                | Selenium per unit effort (micrograms per trap)                                                        |
| SeConc_ugPer100g     | Selenium concentration (micrograms per 100 grams)                                                     |
| SePrice_KSHPerug     | Value of selenium (Kenya Shillings per microgram)                                                     |
| TotalZn_ug           | Total zinc (micrograms)                                                                               |
| ZnPUE                | Zinc per unit effort (micrograms per trap)                                                            |
| ZnConc_ugPer100g     | Zinc concentration (micrograms per 100 grams)                                                         |
| ZnPrice_KSHPerug     | Value of zinc (Kenya Shillings per microgram)                                                         |

### Catch Data

**Filepath**: `02_FishLife_Out/CatchData_GatedTraps_Galligan.csv`

Number of **variables**: 11

Number of **observations**: 25789

**Missing data** code: `NA`

#### Variable List

| Variable      | Notes                                                                       |
|---------------|-----------------------------------------------------------------------------|
| TripID        | Alphanumeric identifier for each fishing trip                               |
| TrapType      | Type of fish trap (gated / traditional)                                     |
| TrapLocation  | Fishing location                                                            |
| SoakTime_Days | Duration of trap deployment (days)                                          |
| GapSize_cm    | Size of escape gap on traps used (centimeters)                              |
| Species       | Species of fish caught (scientific name)                                    |
| FD_HC         | Is this fish destined for a fish dealer (FD) or household consumption (HC)? |
| Length_cm     | Standard length of fish, from tip of snout to last vertebrae (centimeters)  |
| Depth_m       | Depth of trap deployment (meters)                                           |
| Weight_g      | Weight (grams)                                                              |
| LLmat         | Ratio of length to length at first maturity (Lmat)                          |

### Species Data

**Filepath**: `02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv`

Number of **variables**: 44

Number of **observations**: 215

**Missing data** code: `NA`

#### Variable List

| Variable           | Notes                                                                             |
|--------------------|-----------------------------------------------------------------------------------|
| Species            | Species (scientific name)                                                         |
| Family             | Taxonomic family                                                                  |
| FishGroups         | Coarse fish groupings                                                             |
| EnglishName        | Species (common name in English)                                                  |
| KiswahiliName      | Species (common name in Kiswahili)                                                |
| Bycatch            | Is this species considered bycatch? (yes/no)                                      |
| Price_KSHPerkg     | Price (Kenya Shillings per kilogram)                                              |
| FunGr_Diet         | Coarse diet-based functional groups (Condy et al., 2015; FishBase)                |
| TrophLevel         | Trophic level based on food items (FishBase)                                      |
| SE_TrophLevel      | Standard error of trophic level estimate (FishBase)                               |
| Vulnerability      | Vulnerability (0-100) (FishBase)                                                  |
| Lmat_cm            | Length at first maturity (centimeters) (FishLife)                                 |
| Lopt_cm            | Optimum length (centimeters) (FishLife)                                           |
| Linf_cm            | Asymptotic length (centimeters) (FishLife)                                        |
| SizeCategory       | Functional trait: size (Mbaru et al., 2020)                                       |
| Diet               | Functional trait: diet (Mbaru et al., 2020)                                       |
| Mobility           | Functional trait: mobility (Mbaru et al., 2020)                                   |
| Active             | Functional trait: period of activity (Mbaru et al., 2020)                         |
| Schooling          | Functional trait: schooling behavior (Mbaru et al., 2020)                         |
| Position           | Functional trait: position in water column (Mbaru et al., 2020)                   |
| TempPrefMin_degC   | Minimum temperature preference (degrees Celsius) (FishBase)                       |
| TempPrefMean_degC  | Mean temperature preference (degrees Celsius) (FishBase)                          |
| TempPrefMax_degC   | Maximum temperature preference (degrees Celsius) (FishBase)                       |
| Calcium_mgPer100g  | Calcium concentration (milligrams per 100 grams) (FishBase)                       |
| Calcium_L95        | Lower 95% confidence interval for calcium estimate (FishBase)                     |
| Calcium_U95        | Upper 95% confidence interval for calcium estimate (FishBase)                     |
| Iron_mgPer100g     | Iron concentration (milligrams per 100 grams) (FishBase)                          |
| Iron_L95           | Lower 95% confidence interval for iron estimate (FishBase)                        |
| Iron_U95           | Upper 95% confidence interval for iron estimate (FishBase)                        |
| Omega3_gPer100g    | Omega-3 polyunsaturated fatty acid concentration (grams per 100 grams) (FishBase) |
| Omega3_L95         | Lower 95% confidence interval for omega-3 estimate (FishBase)                     |
| Omega3_U95         | Upper 95% confidence interval for omega-3 estimate (FishBase)                     |
| Protein_gPer100g   | Protein concentration (grams per 100 grams) (FishBase)                            |
| Protein_L95        | Lower 95% confidence interval for protein estimate (FishBase)                     |
| Protein_U95        | Upper 95% confidence interval for protein estimate (FishBase)                     |
| VitamA_ugPer100g   | Vitamin A concentration (micrograms per 100 grams) (FishBase)                     |
| VitaminA_L95       | Lower 95% confidence interval for vitamin A estimate (FishBase)                   |
| VitaminA_U95       | Upper 95% confidence interval for vitamin A estimate (FishBase)                   |
| Selenium_ugPer100g | Selenium concentration (micrograms per 100 grams) (FishBase)                      |
| Selenium_L95       | Lower 95% confidence interval for selenium estimate (FishBase)                    |
| Selenium_U95       | Upper 95% confidence interval for selenium estimate (FishBase)                    |
| Zinc_ugPer100g     | Zinc concentration (micrograms per 100 grams) (FishBase)                          |
| Zinc_L95           | Lower 95% confidence interval for zinc estimate (FishBase)                        |
| Zinc_U95           | Upper 95% confidence interval for zinc estimate (FishBase)                        |

## Built With

-   R version 4.1.2 (2021-11-01) -- "Bird Hippie"

-   RStudio 2021.09.1+372 "Ghost Orchid" Release (8b9ced188245155642d024aa3630363df611088a, 2021-11-08) for macOS

-   The following R packages:

    -   `AICcmodavg`

    -   `data.table`

    -   `dplyr`

    -   `FishLife`

    -   `ggplot2`

    -   `ggpubr`

    -   `magrittr`

    -   `mFD`

    -   `rcurl`

    -   `readr`

    -   `readxl`

    -   `rfishbase`

    -   `rstatix`

    -   `strex`

    -   `stringr`

    -   `taxize`

    -   `tidyr`

## Links

-   The GitHub [repository](https://github.com/bryanpgalligan/FishTrapsFoodSec) for this project

## References

Condy, M., Cinner, J. E., McClanahan, T. R., & Bellwood, D. R. (2015). Projections of the impacts of gear-modification on the recovery of fish catches and ecosystem function in an impoverished fishery. *Aquatic Conservation: Marine and Freshwater Ecosystems*, *25*(3), 396–410. <https://doi.org/10.1002/aqc.2482>

FAO, IFAD, UNICEF, WFP, & WHO. (2021). *The state of food security and nutrition in the world 2021: Transforming food systems for food security, improved nutrition, and affordable healthy diets for all*. FAO. <https://doi.org/10.4060/cb4474en>

Gomes, I., Erzini, K., & McClanahan, T. R. (2014). Trap modification opens new gates to achieve sustainable coral reef fisheries: Escape gaps in African traditional trap fisheries. *Aquatic Conservation: Marine and Freshwater Ecosystems*, *24*(5), 680–695. <https://doi.org/10.1002/aqc.2389>

Mbaru, E. K., Graham, N. A. J., McClanahan, T. R., & Cinner, J. E. (2020). Functional traits illuminate the selective impacts of different fishing gears on coral reefs. *Journal of Applied Ecology*, *57*(2), 241–252. <https://doi.org/10.1111/1365-2664.13547>

Mbaru, E. K., & McClanahan, T. R. (2013). Escape gaps in African basket traps reduce bycatch while increasing body sizes and incomes in a heavily fished reef lagoon. *Fisheries Research*, *148*, 90–99. <https://doi.org/10.1016/j.fishres.2013.08.011>

Thorson, J. T. (2020). Predicting recruitment density dependence and intrinsic growth rate for all fishes worldwide using a data-integrated life-history model. *Fish and Fisheries*, *21*(2), 237–251. <https://doi.org/10.1111/faf.12427>

Thorson, J. T., Munch, S. B., Cope, J. M., & Gao, J. (2017). Predicting life history parameters for all fishes worldwide. *Ecological Applications*, *27*(8), 2262–2276. <https://doi.org/10.1002/eap.1606>

Zuur, A. F., Ieno, E. N., & Elphick, C. S. (2010). A protocol for data exploration to avoid common statistical problems. *Methods in Ecology and Evolution*, *1*, 3–14. <https://doi.org/10.1111/j.2041-210X.2009.00001.x>
