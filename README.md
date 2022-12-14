# Charinus ENM Repository
#### Author: João Frederico Berner
#### Date 2022-Aug-13th

## Project structure

```
project/
*    ├── data/
*    │   ├── raw
*    │   │   ├── occ/
*    │   │   └── env/
*    │   └── processed
*    │       ├── envcropped/
*    │       ├── final-model-build/
*    │       ├── model-build/
*    │       └── shapefiles/
*    ├── docs/
*    │    ├── REPORT.html
*    │    └── REPORT.md
*    ├── figs/
*    ├── citation/
*    ├── R/
*    ├── output/
*    └── README.md
```
In the `R/` directory you will find the scripts.

The occurrence data in the `/data/raw/occ` directory has been acquired from Gustavo Silva de Miranda's personal database, and has been omitted intentionally, while I don't get his authorization to release it.

Present environmental data was obtained from [BioClim v2.1](https://www.worldclim.org). Past environmental data (in `/data/raw/raster`) was obtained from the [PaleoClim project ](http://www.paleoclim.org). Both datasets were manually downloaded, PaleoClim on January 8th, 2022 and BioClim on August 13th, 2022. We decided to use the finest available resolution (2.5min) as all occurrence records come from GPS points collected by GSM himself. After considering the species' biology and var correlation, variables retained are Bio1, Bio4, Bio12 and Bio15. These data are all in the `data/raw/env` folder and is not uploaded because of its size.

Models are built using the sdm package (https://www.github.com/babaknaimi/sdm). Models are trained with pseudoabsences generated by eRandom method, and evaluated using absence records (collected by GSM as well) by MAE and AUC metrics. We ensemble the best performing algorithms, and project the models to past climate scenarios.

If I have enough time, I'd like to make the Uncertainty Maps presented by Morales-Barbero & Vega-Álvarez’s (2018) using the two best algorithms instead of ensembling.

