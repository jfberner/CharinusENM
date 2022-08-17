# --------------------------------------------------#
# Building ENM Models with sdm package
# Charinus ENM project
# In this script we will build the models for the present and save them as rda objects for later use in other scripts
# First version 2022 Aug 15
# Author: João Frederico Berner
#--------------------------------------------------#

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
occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp') # only presence data, dropping absences
occ_test <- rgdal::readOGR('data/processed/shapefiles/test.shp')

# Model Build #####

d_occ <- sdmData(formula = charinus~., 
                 train=occ_train, test = occ_test, predictors = envpres,
                 bg = 18, method = 'eRandom') # Create sdmData object

m_occ <- sdm(formula = charinus~.,data = d_occ,
             methods = c('svm', 'maxent', 'brt', 'bioclim', 'domain'),
             replication = c('bootstrapping'), n=5) # Create model

if (!dir.exists("data/processed/model-build/model-object/")) dir.create("data/processed/model-build/model-object/", recursive = TRUE) # Create this folder

sdm::write.sdm(m_occ, "data/processed/model-build/model-object/model", overwrite = T) # Save the model object into RDS

# gui(m_occ) # if you want to see model results

if (!dir.exists("data/processed/model-build/predictions/")) dir.create("data/processed/model-build/predictions/", recursive = TRUE) # Create this folder

p_occ <- predict(m_occ, newdata = envpres, # new data is the environment in which we want to predict
                 filename = 'data/processed/model-build/predictions/predictions.present-nonames.tif',
                 mean = T, prj = T, overwrite = T, nc = 4) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_occ_stack <- raster::stack(p_occ) #convert rasterBrick to rasterStack
p_occ_spatraster <- terra::rast(p_occ_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_occ_spatraster, 
                    filename = 'data/processed/model-build/predictions/predictions.present-all-algorithms.tif',
                    overwrite = TRUE) # Using terra package because it retains layer names


# when you read it, make sure to so as:
# pocc <- terra::rast(x = 'data/processed/model-build/predictions/predictions.present-all-algorithms.tif')
# pocc %>% raster::brick()