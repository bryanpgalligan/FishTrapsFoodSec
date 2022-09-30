# FishTrapsFoodSec

## Nutrient capture and sustainable yield maximized by a gear modification in artisanal fishing traps

**Authors:**

-   Bryan P. Galligan, S.J. ([bgalligan\@jesuits.org](mailto:bgalligan@jesuits.org))

-   Tim R. McClanahan ([tmcclanahan\@wcs.org](mailto:tmcclanahan@wcs.org))

-   Austin T. Humphries ([humphries\@uri.edu](mailto:humphries@uri.edu))

**Data Collectors:**

-   Ahmed

-   Nancy Birgen ([nbirgen\@yahoo.com](mailto:nbirgen@yahoo.com))

-   Michelle Condy ([michelle.condy\@jcu.edu.au](mailto:michelle.condy@jcu.edu.au))

-   Mesaidi Fadhili

-   Nseme Ferrunzi

-   Ines Gomes ([istgomes\@gmail.com](mailto:istgomes@gmail.com))

-   Valentine Jepchumba ([vlntnjepchumba503\@gmail.com](mailto:vlntnjepchumba503@gmail.com))

-   Mwafitina Juma

-   Jesse Kosgei ([jkosgei\@wcs.org](mailto:jkosgei@wcs.org))

-   Harriet Makungu ([makunguharriet\@yahoo.com](mailto:makunguharriet@yahoo.com))

-   Emmanuel Mbaru ([embaru\@kmfri.co.ke](mailto:embaru@kmfri.co.ke))

-   Bakari Mchinga ([bmchinga\@yahoo.com](mailto:bmchinga@yahoo.com))

-   Ali Musa

-   Asenath Nyachiro ([anyachiro\@kmfri.co.ke](mailto:anyachiro@kmfri.co.ke))

-   Douglas Obanyi ([douglasmaina\@gmail.com](mailto:douglasmaina@gmail.com))

-   Cavin Omondi ([omondikev13\@gmail.com](mailto:omondikev13@gmail.com))

-   Evyoone Ongoro ([ongoroyvonne\@gmail.com](mailto:ongoroyvonne@gmail.com))

-   Maureen Otieno ([motieno\@wcs.org](mailto:motieno@wcs.org))

-   Amir Shekiondo ([amosheki\@gmail.com](mailto:amosheki@gmail.com))

-   Ali Shilingi

-   Ramadhan Tungu

-   Nina Wambiji ([nwambiji\@yahoo.com](mailto:nwambiji@yahoo.com))

-   John Wanyoike ([karungoj\@yahoo.com](mailto:karungoj@yahoo.com))

-   Janet Warui ([janetwarui\@gmail.com](mailto:janetwarui@gmail.com))

**Recommended Citation:**

Galligan, B. P., Birgen, N., Condy, M., Fadhili, M., Ferrunzi, N., Gomes, I., Jepchumba, V., Juma, M., Kosgei, J., Makungu, H., Mbaru, E., Mchinga, B., Musa, A., Nyachiro, A., Obanyi, D., Omondi, C., Ongoro, E., Otieno, M., Shekiondo, A., Shilingi, A., Tungu, R., Wambiji, N., Wanyoike, J., Warui, J., Humphries, A. T., & McClanahan, T. R. (2022). FishTrapsFoodSec: Nutrient capture and sustainable yield maximized by a gear modification in artisanal fishing traps. Zenodo.

## Overview

This repository is the data management and analysis workflow of a research project investigating the ecosystem and food security benefits and tradeoffs of adding escape gaps to traditional African fish traps. It includes 10 years of landings data from artisanal trap fishers operating in the inshore waters of Kenya and Tanzania.

## Instructions

### For data access only:

The processed data files are described later in this document. The same section contains file paths at which these data can be found. Please note that some parameters in these files are not original, but are drawn from other sources (refer to metadata). Where this is the case, please cite the original data source as well as this archived dataset.

### To reproduce the analysis:

R scripts should be run in numeric order, beginning with `01_CleanData_FishTrapsFoodSec.R`. Each script has two corresponding folders in the repository, one called `temp` and one called `out`. The `temp` folder contains temporary output files that are not needed for further analysis or reference. The `out` folder contains output files that will be used by subsequent scripts, kept for future reference, or formatted as data tables for publication.

The R script `02_FishLife_FishTrapsFoodSec.R` retrieves estimated life history parameters for all species in the catch using Jim Thorson's `FishLife` [package](https://github.com/James-Thorson-NOAA/FishLife) (Thorson, 2020; Thorson et al., 2017). **You must restart R twice while running this script**, once after running the first line, which installs an older version of `rfishbase`, and once at the end of the script, which re-installs the newest version of `rfishbase`. This is necessary because `FishLife`is only compatible with earlier versions of `rfishbase`. These instructions are commented in the script itself.

## Built With

-   R version 4.2.1 (2022-06-23) -- "Funny-Looking Kid"

-   RStudio "Spotted Wakerobin" Release (7872775e, 2022-07-22) for macOS

-   The following R packages:

    -   `AICcmodavg (v2.3-1)`

    -   `data.table (v1.14.2)`

    -   `dplyr (v1.0.9)`

    -   `FishLife (v2.0.1)`

    -   `ggplot2 (v3.3.6)`

    -   `ggpubr (v0.4.0)`

    -   `magrittr (v2.0.3)`

    -   `mFD (v1.0.1)`

    -   `readr (v2.1.2)`

    -   `readxl (v1.4.1)`

    -   `rfishbase (v4.0.0)`

    -   `rstatix (v0.7.0)`

    -   `strex (v1.4.3)`

    -   `stringr (v1.4.1)`

    -   `taxize (v0.9.100)`

    -   `tidyr (v1.2.0)`

## Repository Files

| File/Folder                                                                                                                                           | Enclosed File                                                                                                                                                                         | Type            | Notes                                                                                                                                       |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| [00_RawData](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/00_RawData)                                                               |                                                                                                                                                                                       | Folder          | Contains raw data                                                                                                                           |
|                                                                                                                                                       | [CombinedTrapData_2010_2019_Anonymized.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/CombinedTrapData_2010_2019_Anonymized.csv)                      | Spreadsheet     | WCS landings data                                                                                                                           |
|                                                                                                                                                       | [FunctionalGroupKey_DietBased_Condy2015.xlsx](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/FunctionalGroupKey_DietBased_Condy2015.xlsx)                  | Spreadsheet     | A key developed for previous WCS studies assigning select species to diet-based functional groups                                           |
|                                                                                                                                                       | [Traits_MbaruEtAl2020.xls](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/Traits_MbaruEtAl2020.xls)                                                        | Spreadsheet     | A list of species with categorizations by functional trait, developed by Mbaru et al. (2020).                                               |
|                                                                                                                                                       | [ValueByFamily.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/ValueByFamily.csv)                                                                      | Spreadsheet     | A list of fish families and their corresponding values in Kenya Shillings developed for previous WCS studies.                               |
| [01_CleanData_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_FishTrapsFoodSec.R)                     |                                                                                                                                                                                       | R Script        | Cleans the data and saves an edited and more compact version. Produces three normalized output spreadsheets as found in `01_CleanData_Out`. |
| [01_CleanData_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/01_CleanData_Out)                                                   |                                                                                                                                                                                       | Folder          | Contains output files from eponymous R script                                                                                               |
|                                                                                                                                                       | [CatchData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Out/CatchData_GatedTraps_Galligan.csv)                                | Spreadsheet     | Contains landings data; each row is an individual fish                                                                                      |
|                                                                                                                                                       | [SpeciesData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Out/SpeciesData_GatedTraps_Galligan.csv)                            | Spreadsheet     | Data for each species in the catch                                                                                                          |
|                                                                                                                                                       | [TripData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Out/TripData_GatedTraps_Galligan.csv)                                  | Spreadsheet     | Contains landings data; each row is one fishing trip                                                                                        |
| [01_CleanData_Temp](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/01_CleanData_Temp)                                                 |                                                                                                                                                                                       | Folder          | Contains temporary output files from eponymous R script                                                                                     |
|                                                                                                                                                       | [SuspiciousPrices.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Temp/SuspiciousPrices.csv)                                                         | Spreadsheet     | A list of price data from the original WCS spreadsheet that seemed suspicious. These prices have all been replaced.                         |
|                                                                                                                                                       | [TrapData_Cleaned.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Temp/TrapData_Cleaned.csv)                                                         | Spreadsheet     | A cleaned copy of the original WCS data sheet.                                                                                              |
|                                                                                                                                                       | [Unique_Species.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Temp/Unique_Species.csv)                                                             | Spreadsheet     | A list of species found in the WCS landings data                                                                                            |
| [02_FishLife_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_FishTrapsFoodSec.R)                       |                                                                                                                                                                                       | R Script        | Obtains estimates of life history parameters for all species using Jim Thorson's `FishLife` package.                                        |
| [02_FishLife_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/02_FishLife_Out)                                                     |                                                                                                                                                                                       | Folder          | Contains output files from eponymous R script                                                                                               |
|                                                                                                                                                       | [CatchData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/CatchData_GatedTraps_Galligan.csv)                                 | Spreadsheet     | Updates catch data to include life history parameters                                                                                       |
|                                                                                                                                                       | [SpeciesData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv)                             | Spreadsheet     | Updates species data to include life history parameters                                                                                     |
|                                                                                                                                                       | [TripData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/TripData_GatedTraps_Galligan.csv)                                   | Spreadsheet     | Updates trip data to include life history parameters                                                                                        |
| 02_FishLife_Temp                                                                                                                                      |                                                                                                                                                                                       | Folder          | Empty                                                                                                                                       |
| [03_FunctionalDiversity_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_FishTrapsFoodSec.R) |                                                                                                                                                                                       | R Script        | Workflow for the `mFD` package, which computes multidimensional functional diversity indices                                                |
| [03_FunctionalDiversity_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/03_FunctionalDiversity_Out)                               |                                                                                                                                                                                       | Folder          | Contains output files from eponymous R script                                                                                               |
|                                                                                                                                                       | [FunctionalSpacesQuality.png](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/FunctionalSpacesQuality.png)                                  | Figure          | Results of PCoA analysis determining the quality of functional spaces                                                                       |
|                                                                                                                                                       | [PositionSpeciesFunctionalAxes.png](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/PositionSpeciesFunctionalAxes.png)                      | Figure          | Plots functional entities along pairs of functional axes                                                                                    |
|                                                                                                                                                       | [TraitsAndPCoAAxes.png](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/TraitsAndPCoAAxes.png)                                              | Figure          | Plots relationships between traits and PCoA axes                                                                                            |
|                                                                                                                                                       | [TripData_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/TripData_GatedTraps_Galligan.csv)                        | Spreadsheet     | Updates trip data with functional diversity measures                                                                                        |
| 03_FunctionalDiversity_Temp                                                                                                                           |                                                                                                                                                                                       | Folder          | Empty                                                                                                                                       |
| [04_DataExploration_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/04_DataExploration_FishTrapsFoodSec.R)         |                                                                                                                                                                                       | R Script        | Explores data following procedures of Zuur et al. (2010)                                                                                    |
| [04_DataExploration_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/04_DataExploration_Out)                                       |                                                                                                                                                                                       | Folder          | Empty                                                                                                                                       |
|                                                                                                                                                       | [TripDataForAnalysis_GatedTraps_Galligan.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/04_DataExploration_Out/TripDataForAnalysis_GatedTraps_Galligan.csv)      | Spreadsheet     | TripData cleaned for analysis. Unreasonable values have been removed.                                                                       |
| 04_DataExploration_Temp                                                                                                                               |                                                                                                                                                                                       | Folder          | Empty                                                                                                                                       |
| [05_PrincipalComponents_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/05_PrincipalComponents_FishTrapsFoodSec.R) |                                                                                                                                                                                       | R Script        | Runs and reports on FAMD and PCA analyses.                                                                                                  |
| [05_PrincipalComponents_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/05_PrincipalComponents_Out)                               |                                                                                                                                                                                       | Folder          | Contains output files from eponymous R script.                                                                                              |
|                                                                                                                                                       | [AllBiplots.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/05_PrincipalComponents_Out/AllBiplots.jpeg)                                                          | Figure          | All important biplots - to be used in the article.                                                                                          |
|                                                                                                                                                       | [Fig3_FoodSecBiplot.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/05_PrincipalComponents_Out/Fig3_FoodSecBiplot.jpeg)                                          | Figure          | Biplot of food security PCA dimensions (not actually Fig. 3)                                                                                |
|                                                                                                                                                       | [Fig5_ConservationBiplots.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/05_PrincipalComponents_Out/Fig5_ConservationBiplots.jpeg)                              | Figure          | Biplots of conservation PCA dimensions (not actually Fig. 5)                                                                                |
|                                                                                                                                                       | [TripData_ForModeling.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/05_PrincipalComponents_Out/TripData_ForModeling.csv)                                        | Spreadsheet     | Estimates from PCA and food security dimensions to be modeled using linear regression in script 6.                                          |
| 05_PrincipalComponents_Temp                                                                                                                           |                                                                                                                                                                                       | Folder          | Empty                                                                                                                                       |
| [06_AdditionalAnalysis_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_FishTrapsFoodSec.R)   |                                                                                                                                                                                       | R Script        | Performs follow-up analyses after the PCA                                                                                                   |
| [06_AdditionalAnalysis_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/06_AdditionalAnalysis_Out)                                 |                                                                                                                                                                                       | Folder          | Contains output files from eponymous R script                                                                                               |
|                                                                                                                                                       | [CPUEDensity_FishTrapsFoodSec.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/CPUEDensity_FishTrapsFoodSec.jpeg)                       | Figure          | Density plot of CPUE for gated and traditional traps                                                                                        |
|                                                                                                                                                       | [CPUE_LLopt_GAMM.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/CPUELLopt_GAMM.jpeg)                                                  | Figure          | Linear regression and scatter plot of CPUE for both trap types as response to L/Lopt                                                        |
|                                                                                                                                                       | [CPUETransformedDensity_FishTrapsFoodSec.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/CPUETransformedDensity_FishTrapsFoodSec.jpeg) | Figure          | Density plot of square root transformed CPUE for gated and traditional traps                                                                |
|                                                                                                                                                       | [CatchStability.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/CatchStability.csv)                                                     | Spreadsheet     | Skewness and kurtosis for non-transformed CPUE for gated and traditional traps                                                              |
|                                                                                                                                                       | [CatchStability_SqrtTransformed.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/CatchStability_SqrtTransformed.csv)                     | Spreadsheet     | Skewness and kurtosis for square root transformed CPUE for gated and traditional traps                                                      |
|                                                                                                                                                       | [Fig4_FoodSecModels.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/Fig4_FoodSecModels.jpeg)                                           | Figure          | Food security linear regression results dot and whisker plot (not actually Fig. 4)                                                          |
|                                                                                                                                                       | [Fig6_ConsModels.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/Fig6_ConsModels.jpeg)                                                 | Figure          | Conservation linear regression results dot and whisker plot (not actually Fig. 6)                                                           |
|                                                                                                                                                       | [LengthTrapTypeDensity.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/LengthTrapTypeDensity.jpeg)                                     | Figure          | Density plots of length by trap type                                                                                                        |
|                                                                                                                                                       | [LmatCalcium.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/LmatCalcium.jpeg)                                                         | Figure          | Exploratory plot of calcium concentrations as response to Lmat - linear regression and scatter plot                                         |
|                                                                                                                                                       | [NutrientConcentrationLLoptGAMMs.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/NutrientConcentrationLLoptGAMMs.jpeg)                 | Figure          | GAMMs of nutrient concentrations by trap type as response to L/Lopt by fishing trip                                                         |
|                                                                                                                                                       | [NutrientConcentrationLoptLMs.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/NutrientConcentrationLoptLMs.jpeg)                       | Figure          | Linear regressions and scatter plots of nutrient concentrations as response to Lopt by species                                              |
|                                                                                                                                                       | [NutrientConcentrationsTable.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/NutrientConcentrationsTable.csv)                           | Spreadsheet     | Table of nutrient concentrations by trap type with GLMMs to test for significance                                                           |
|                                                                                                                                                       | [NutrientYieldLLoptGAMMs.jpeg](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/NutrientYieldLLoptGAMMs.jpeg)                                 | Figure          | Nutrient yields by trap type as response to L/Lopt for each trip (GAMMs)                                                                    |
|                                                                                                                                                       | [NutrientYieldsTable.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/06_AdditionalAnalysis_Out/NutrientYieldsTable.csv)                                           | Spreadsheet     | Comparison of nutrient yields by trap type with RDI and GLMMs to test for significance                                                      |
| 06_AdditionalAnalysis_Temp                                                                                                                            |                                                                                                                                                                                       | Folder          | Empty                                                                                                                                       |
| [README.md](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/README.md)                                                                 |                                                                                                                                                                                       | Markdown        | This document                                                                                                                               |
| [RWorkflow_FishTrapsFoodSec.Rproj](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/RWorkflow_FishTrapsFoodSec.Rproj)                   |                                                                                                                                                                                       | RStudio Project | Sets working directory, source documents, etc. in RStudio                                                                                   |

## Processed Data

**Date** of data collection: 2010-2019

Geographic **location** of data collection: southern coast of Kenya, northern coast of Tanzania

Information about **funding** sources that supported the collection of the data: data were collected by Wildlife Conservation Society, Mombasa, Kenya

Portions of this data have been **used by** Condy et al. (2015), Gomes et al. (2014), Mbaru et al. (2020), and Mbaru and McClanahan (2013).

### Trip Data

**Filepath**: [`03_FunctionalDiversity_Out/TripData_GatedTraps_Galligan.csv`](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/03_FunctionalDiversity_Out/TripData_GatedTraps_Galligan.csv)

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
| TotalZn_mg           | Total zinc (milligrams)                                                                               |
| ZnPUE                | Zinc per unit effort (milligrams per trap)                                                            |
| ZnConc_ugPer100g     | Zinc concentration (milligrams per 100 grams)                                                         |
| ZnPrice_KSHPerug     | Value of zinc (Kenya Shillings per milligram)                                                         |

### Catch Data

**Filepath**: [`02_FishLife_Out/CatchData_GatedTraps_Galligan.csv`](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/CatchData_GatedTraps_Galligan.csv)

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

**Filepath**: [`02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv`](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/02_FishLife_Out/SpeciesData_GatedTraps_Galligan.csv)

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
| Calcium_L95        | Lower 95% credible interval for calcium estimate (FishBase)                       |
| Calcium_U95        | Upper 95% credible interval for calcium estimate (FishBase)                       |
| Iron_mgPer100g     | Iron concentration (milligrams per 100 grams) (FishBase)                          |
| Iron_L95           | Lower 95% credible interval for iron estimate (FishBase)                          |
| Iron_U95           | Upper 95% credible interval for iron estimate (FishBase)                          |
| Omega3_gPer100g    | Omega-3 polyunsaturated fatty acid concentration (grams per 100 grams) (FishBase) |
| Omega3_L95         | Lower 95% credible interval for omega-3 estimate (FishBase)                       |
| Omega3_U95         | Upper 95% credible interval for omega-3 estimate (FishBase)                       |
| Protein_gPer100g   | Protein concentration (grams per 100 grams) (FishBase)                            |
| Protein_L95        | Lower 95% credible interval for protein estimate (FishBase)                       |
| Protein_U95        | Upper 95% credible interval for protein estimate (FishBase)                       |
| VitamA_ugPer100g   | Vitamin A concentration (micrograms per 100 grams) (FishBase)                     |
| VitaminA_L95       | Lower 95% credible interval for vitamin A estimate (FishBase)                     |
| VitaminA_U95       | Upper 95% credible interval for vitamin A estimate (FishBase)                     |
| Selenium_ugPer100g | Selenium concentration (micrograms per 100 grams) (FishBase)                      |
| Selenium_L95       | Lower 95% credible interval for selenium estimate (FishBase)                      |
| Selenium_U95       | Upper 95% credible interval for selenium estimate (FishBase)                      |
| Zinc_ugPer100g     | Zinc concentration (micrograms per 100 grams) (FishBase)                          |
| Zinc_L95           | Lower 95% credible interval for zinc estimate (FishBase)                          |
| Zinc_U95           | Upper 95% credible interval for zinc estimate (FishBase)                          |

## Links

-   The GitHub [repository](https://github.com/bryanpgalligan/FishTrapsFoodSec) for this project

## References

Bache, S., & Wickham, H. (2022). magrittr: A forward-pipe operator for R. R package version 2.0.3. <https://CRAN.R-project.org/package=magrittr>

Boettiger, C., Lang, D. T., & Wainwright, P. C. (2012). rfishbase: Exploring, manipulation, and visualizing FishBase data from R. *Journal of Fish Biology*, *81*(6): 2030-2039. <https://doi.org/10.1111/j.1095-8649.2012.03464.x>

Chamberlain, S., & Szocs, E. (2013). taxize: Taxonomic search and retrieval in R. *F1000Research*, *2*:191. <https://f1000research.com/articles/2-191/v2>

Chamberlain, S., Szoecs, E., Foster, Z., Arendsee, Z., Boettiger, C., Ram, K., Bartomeus, I., Baumgartner, J., O'Donnell, J., Oksanen, J., Tzovaras, B. G., Marchand, P., Tran, V., Salmon, M., Li, G., & Grenié, M. (2020). taxize: Taxonomic information from around the web. R package version 0.9.98. <https://github.com/ropensci/taxize>

Condy, M., Cinner, J. E., McClanahan, T. R., & Bellwood, D. R. (2015). Projections of the impacts of gear-modification on the recovery of fish catches and ecosystem function in an impoverished fishery. *Aquatic Conservation: Marine and Freshwater Ecosystems*, *25*(3), 396--410. <https://doi.org/10.1002/aqc.2482>

Dowle, M., & Srinivasan, A. (2021). data.table: Extension of "data.frame." R package version 1.14.2. <https://CRAN.R-project.org/package=data.table>

Froese, R., & Pauly, D. (Eds.). (2022). FishBase. Online Publication. <https://fishbase.org>

Gomes, I., Erzini, K., & McClanahan, T. R. (2014). Trap modification opens new gates to achieve sustainable coral reef fisheries: Escape gaps in African traditional trap fisheries. *Aquatic Conservation: Marine and Freshwater Ecosystems*, *24*(5), 680--695. <https://doi.org/10.1002/aqc.2389>

Kassambara, A. (2020). ggpubr: "ggplot2" based publication ready plots. R package version 0.4.0. <https://CRAN.R-project.org/package=ggpubr>

Kassambara, A. (2021). rstatix: Pipe-friendly framework for basic statistical tests. R package version 0.7.0. <https://CRAN.R-project.org/package=rstatix>

Magneville, C., Loiseau, N., Albouy, C., Casajus, N., Claverie, T., Escalas, A., Leprieur, F., Maire, E., Mouillot, D., & Villéger, S. (2021). mFD: A computation of functional spaces and functional indices. R package version 1.0.1. <https://github.com/CmlMagneville/mFD>

Magneville, C., Loiseau, N., Albouy, C., Casajus, N., Claverie, T., Escalas, A., Leprieur, F., Maire, E., Mouillot, D., & Villéger, S. (2022). mFD: An R package to compute and illustrate the multiple facets of functional diversity. *Ecography*, *2022*(1). <https://doi.org/10.1111/ecog.05904>

Mazerolle, M. J. (2020). AICcmodavg: Model selection and multimodel inference based on (Q)AIC(c). R package version 2.3-1. <https://cran.r-project.org/package=AICcmodavg>

Mbaru, E. K., Graham, N. A. J., McClanahan, T. R., & Cinner, J. E. (2020). Functional traits illuminate the selective impacts of different fishing gears on coral reefs. *Journal of Applied Ecology*, *57*(2), 241--252. <https://doi.org/10.1111/1365-2664.13547>

Mbaru, E. K., & McClanahan, T. R. (2013). Escape gaps in African basket traps reduce bycatch while increasing body sizes and incomes in a heavily fished reef lagoon. *Fisheries Research*, *148*, 90--99. <https://doi.org/10.1016/j.fishres.2013.08.011>

Nolan, R. (2022). strex: Extra string manipulation functions. R package version 1.4.3. <https://CRAN.R-project.org/package=strex>

R Core Team. (2022). R: A language and environment for statistical computing. R Foundation for Statistical Computing. [https://www.R-project.org/](https://www.R-project.org/https://www.R-project.org/)

RStudio Team. (2022). RStudio: Integrated development for R. RStudio. <https://www.rstudio.com>

Thorson, J. T. (2020). Predicting recruitment density dependence and intrinsic growth rate for all fishes worldwide using a data-integrated life-history model. *Fish and Fisheries*, *21*(2), 237--251. <https://doi.org/10.1111/faf.12427>

Thorson, J. T., Munch, S. B., Cope, J. M., & Gao, J. (2017). Predicting life history parameters for all fishes worldwide. *Ecological Applications*, *27*(8), 2262--2276. <https://doi.org/10.1002/eap.1606>

Thorson, J. T. (2022). FishLife: Predict life history parameters for any fish. R Package version 2.0.1. <http://github.com/James-Thorson-NOAA/FishLife>

Wickham, H. (2016). *ggplot2: Elegant graphics for data analysis*. Springer. <https://ggplot2.tidyverse.org>

Wickham, H. (2022). stringr: Simple, consistent wrappers for common string operations. R package version 1.4.1. <https://CRAN.R-project.org/package=stringr>

Wickham, H., & Bryan, J. (2022). readxl: Read Excel files. R package version 1.4.1. <https://CRAN.R-project.org/package=readxl>

Wickham, H., Francois, R., Henry, L., & Müller, K. (2022). dplyr: A grammar of data manipulation. R package version 1.0.9. <https://CRAN.R-project.org/package=dplyr>

Wickham, H., & Girlich, M. (2022). tidyr: Tidy messy data. R package version 1.2.0. <https://CRAN.R-project.org/package=tidyr>

Wickham, H., Hester, J., & Bryan, J. (2022). readr: Read rectangular text data. R package version 2.1.2. <https://CRAN.R-project.org/package=readr>

Zuur, A. F., Ieno, E. N., & Elphick, C. S. (2010). A protocol for data exploration to avoid common statistical problems. *Methods in Ecology and Evolution*, *1*, 3--14. <https://doi.org/10.1111/j.2041-210X.2009.00001.x>
