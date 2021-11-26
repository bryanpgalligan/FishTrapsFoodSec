# FishTrapsFoodSec

Escape gaps contribute to ecosystem health and food security in an artisanal coral reef trap fishery.

**Authors:**

-   Bryan P. Galligan, S.J. ([Jesuit Justice and Ecology Network Africa](https://www.jenaafrica.org))

-   Austin Humphries ([University of Rhode Island](http://ahumphrieslab.com))

-   Tim McClanahan ([Wildlife Conservation Society](https://www.wcs.org))

## Overview

This repository is the data management and analysis workflow of a research project investigating the ecosystem and food security benefits of adding escape gaps to traditional African fish traps. It includes 10 years of landings data from artisanal fishers operating in the inshore waters of Kenya and Tanzania. Our hypotheses correspond to the FAO's food security framework (Stability, Availability, Access, and Utilization) and include the following:

1.   Modified fish traps contribute to the **stability** of coastal East African food systems, enhancing coral reef resilience...

    -   ...by generating less functionally diverse catches.

    -   ...by catching fewer herbivorous reef fish.

2.  Modified fish traps contribute to the **availability** of food, enhancing stock status...

    -   ...by catching lower proportions of immature individuals and individuals below optimum length.

    -   ...but selectively target larger individuals and thus do not help maintain a population of mega-spawners.

3.  Modified fish traps increase **access** to food...

    -   ...by catching as much or more fish and key micronutrients by mass as traditional traps.

    -   ...by maintaining or increasing catch value in comparison to traditional traps.

4.  Modified traps could influence **utilization** of food...

    -   ...by making it more expensive to retain enough catch to satisfy the micronutrient needs of a child under five.

    -   ...by increasing or maintaining catch value after fishers retain enough catch to satisfy the micronutrient needs of a child under five.

## Instructions

R scripts should be run in numeric order, beginning with `01_CleanData_FishTrapsFoodSec.R`. Each script has two corresponding folders in the repository, one called "temp" and one called "out." The "temp" folder contains temporary output files that are not needed for further analysis or reference. The "out" folder contains output files that will be used by subsequent scripts, kept for future reference, or formatted as data tables for publication.

## Repository Files

| File/Folder                                                                                                                         | Enclosed File                                                                                                                                                        | Type            | Notes                                                                                             |
|-------------------------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------|---------------------------------------------------------------------------------------------------|
| [00_RawData](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/00_RawData)                                             |                                                                                                                                                                      | Folder          | Contains raw data                                                                                 |
|                                                                                                                                     | [CombinedTrapData_2010_2019_Anonymized.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/CombinedTrapData_2010_2019_Anonymized.csv)     | Spreadsheet     | WCS landings data                                                                                 |
|                                                                                                                                     | [FunctionalGroupKey_DietBased_Condy2015.xlsx](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/00_RawData/FunctionalGroupKey_DietBased_Condy2015.xlsx) | Spreadsheet     | A key developed for previous WCS studies assigning select species to diet-based functional groups |
| [01_CleanData_FishTrapsFoodSec.R](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_FishTrapsFoodSec.R)   |                                                                                                                                                                      | R Script        | Cleans the data from WCS and saves an edited and more compact version                             |
| [01_CleanData_Out](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/01_CleanData_Out)                                 |                                                                                                                                                                      | Folder          | Contains output files from eponymous R script                                                     |
|                                                                                                                                     | [TrapData_Cleaned.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Out/TrapData_Cleaned.csv)                                         | Spreadsheet     | Cleaned version of landings data                                                                  |
| [01_CleanData_Temp](https://github.com/bryanpgalligan/FishTrapsFoodSec/tree/master/01_CleanData_Temp)                               |                                                                                                                                                                      | Folder          | Contains temporary output files from eponymous R script                                           |
|                                                                                                                                     | [Unique_Species.csv](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/01_CleanData_Temp/Unique_Species.csv)                                            | Spreadsheet     | A list of species found in the WCS landings data                                                  |
| [README.md](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/README.md)                                               |                                                                                                                                                                      | Markdown        | This document                                                                                     |
| [RWorkflow_FishTrapsFoodSec.Rproj](https://github.com/bryanpgalligan/FishTrapsFoodSec/blob/master/RWorkflow_FishTrapsFoodSec.Rproj) |                                                                                                                                                                      | RStudio Project | Sets working directory, source documents, etc. in RStudio                                         |

## Data

### Trap Data

Filepath: `01_CleanData_Out/TrapData_Cleaned.csv`

Date of data collection: 2010-2019

Geographic location of data collection: southern coast of Kenya, northern coast of Tanzania

Information about funding sources that supported the collection of the data: data were collected by Wildlife Conservation Society, Mombasa, Kenya

Restrictions placed on the data: Please contact Tim McClanahan before using data.

Portions of this data have been used by:

-   Condy, M., Cinner, J. E., McClanahan, T. R., & Bellwood, D. R. (2015). Projections of the impacts of gear-modification on the recovery of fish catches and ecosystem function in an impoverished fishery. *Aquatic Conservation: Marine and Freshwater Ecosystems*, *25*(3), 396–410. <https://doi.org/10.1002/aqc.2482>

-   Gomes, I., Erzini, K., & McClanahan, T. R. (2014). Trap modification opens new gates to achieve sustainable coral reef fisheries: Escape gaps in African traditional trap fisheries. *Aquatic Conservation: Marine and Freshwater Ecosystems*, *24*(5), 680–695. <https://doi.org/10.1002/aqc.2389>

-   Mbaru, E. K., Graham, N. A. J., McClanahan, T. R., & Cinner, J. E. (2020). Functional traits illuminate the selective impacts of different fishing gears on coral reefs. *Journal of Applied Ecology*, *57*(2), 241–252. <https://doi.org/10.1111/1365-2664.13547>

-   Mbaru, E. K., & McClanahan, T. R. (2013). Escape gaps in African basket traps reduce bycatch while increasing body sizes and incomes in a heavily fished reef lagoon. *Fisheries Research*, *148*, 90–99. <https://doi.org/10.1016/j.fishres.2013.08.011>

## System Requirements
