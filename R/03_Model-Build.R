# --------------------------------------------------#
# Building ENM Models with sdm package
# Charinus ENM project
# In this script we will build the models for the present and save them as rda objects for later use in other scripts
# First version 2022 Aug 15
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
# remotes::install_github(babaknaimi/sdm)
library(sdm)
# sdm::installAll()
library(raster)
library(terra)
library(tidyr)
library(dplyr)
library(TeachingDemos)
char2seed('Charinus')

# Load Data #####
## Environmental Data #####
envpres <- dir(path = 'data/processed/envcropped/Present/', pattern = ".tif$", full.names = T)
envpres <- raster::stack(envpres)

## Occurrence Data #####
occ_train <- readOGR('data/processed/shapefiles/train.shp') # only presence data, dropping absences
occ_test <- readOGR('data/processed/shapefiles/test.shp')

# Turn the object into a SpatialPoints dataframe
coordinates(occ_pres) <- ~long + lat
proj4string(occ_pres) <- projection(raster())

# Model Build #####

d_occ <- sdmData(formula = charinus~., 
                 train=occ_train, test = occ_test, predictors = envpres,
                 bg = 18, method = 'eRandom')

m_occ <- sdm(formula = charinus~.,data = d_occ,
             methods = c('svm', 'maxent', 'brt', 'bioclim', 'domain'),
             replication = c('cv'), n=5) 

# gui(m_occ)

if (!dir.exists("data/processed/model-build/predictions/")) dir.create("data/processed/model-build/predictions/", recursive = TRUE)

p_occ <- predict(m_occ, envpres,
                  'data/processed/model-build/predictions.present.img',
                  mean = T, overwrite = T)


# Visualization aid during script build #####
library(mapview)
library(leafem)
library(leaflet)
library(mapdeck)
list <- list(occ_pres, envpres)
menv <- mapview::mapview(envpres)
mocc <- mapview::mapview(occ_pres)
mapviewOptions(platform = "mapdeck")
menv + mocc
leaflet() %>% addFeatures(menv, occ_pres)
mapview(list, 
        col.regions = mapviewGetOption("raster.palette"),
        color = mapviewGetOption("vector.palette"))
