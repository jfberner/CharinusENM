# Charinus ENM Repository
# Author: João Frederico Berner
# Date 2022-Aug-8th

## Project structure

```
project/
*    ├── data/
*    │   ├── raw
*    │   │   ├── occ
*    │   │   └── env
*    │   └── processed
     ├── docs/
*    ├── figs/
     ├── R/
*    ├── output/
*    └── README.md
```
In the `R` directory you will find the scripts.

The occurrence data in the `/data/raw/occ` directory has been acquired from Gustavo Silva de Miranda's personal database, and has been omitted with intention, while I don't get his authorization to release it.

Environmental data (in `/data/raw/raster`) was obtained from the PaleoClim project (http://www.paleoclim.org), and was mannualy downloaded on January 8th, 2022. We decided to use the finest possible resolution as all occurrence records come from GPS points collected by GSM himself. After considering the species' biology, variables retained are Bio1, Bio4, Bio12 and Bio15.

