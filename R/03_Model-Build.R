# --------------------------------------------------#
# Building ENM Models with sdm package
# Charinus ENM project
# In this script we will build the models for the present and save them as rda objects for later use in other scripts
# First version 2022 Aug 15
# Author: João Frederico Berner
# --------------------------------------------------#

path <- '~/Documents/CharinusENM' # I'm so sorry about this, I really can't figure out a better way to make this work.

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
setwd(path)
setwd('data/processed/envcropped/Present/')
envpres <- dir(pattern="tif$")
envpres <- raster::stack(envpres)
setwd(path)

## Occurrence Data #####
occ_raw <- read.csv('data/raw/occ/presence_absence.csv')
occ_pres <- occ_raw %>% filter(charinus == 1) # only presence data, dropping absences
occ_abs <- occ_raw %>% filter(charinus == 0)

# Turn the object into a SpatialPoints dataframe
coordinates(occ_pres) <- ~long + lat
proj4string(occ_pres) <- projection(raster())

# Model Build #####

d_occ <- sdmData(formula = charinus~., 
                 train=occ_pres, predictors = envpres,
                 bg = 18, method = 'eRandom')

m_occ <- sdm(formula = charinus~.,data = d_occ,
             methods = c('svm', 'maxent', 'brt', 'bioclim', 'domain'),
             replication = c('cv'), n=10) 

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
