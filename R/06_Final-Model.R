# --------------------------------------------------#
# Final Model
# CharinusENM
# In this script, we'll generate models with the two best performing
# algorithms by AUC (absence-evaluated) and Accumulation of Occurrences-Curve.
# These two models will then be used to project to the past time-slices of PaleoClim.
# First version 2022 Aug 17
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
occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp') # only presence data, dropping absences
occ_test <- rgdal::readOGR('data/processed/shapefiles/test.shp')

# Model Build #####
if (!dir.exists("data/processed/final-model-build/model-object/")) dir.create("data/processed/final-model-build/model-object/", recursive = TRUE) # Create this folder for the outputs

# The data is de same as in script 03_Model-Build.R, let's read it
d_occ <- sdm::read.sdm("data/processed/model-build/model-object/model-data.sdd")

# Build the model: here's the decision part. 

# SVM and MaxEnt had the best AUC and TSS scores, which are reliable because we used presence/absence values as test data. 

# On the other hand, BioClim and SVM had the best AOcCs (`figs/aocc/01_model-comparison.png`).

# Yet, BioClim seems to be overfitting the models when looking at the map predictions (`figs/aocc/bioclim_aocc_map.png` and comparing to the others, e.g. `figs/aocc/maxent_aocc_map.png`) itself.

# So, the retained algorithms are SVM and MaxEnt :)

m_occ <- sdm(formula = charinus~.,data = d_occ,
             methods = c('svm', 'maxent'),
             replication = c('bootstrapping'), n=25) # Create model
# And save it, we'll use it later

sdm::write.sdm(m_occ, "data/processed/final-model-build/model-object/model", overwrite = T) # Save the model object into RDS format, extension.sdm

# gui(m_occ) # if you want to see model results


# Create a folder for predictions
if (!dir.exists("data/processed/final-model-build/predictions/")) dir.create("data/processed/final-model-build/predictions/", recursive = TRUE)

p_occ <- predict(m_occ, newdata = envpres, # new data is the environment in which we want to predict
                 filename = 'data/processed/final-model-build/predictions/predictions.present-nonames.tif',
                 mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_occ_stack <- raster::stack(p_occ) #convert rasterBrick to rasterStack
p_occ_spatraster <- terra::rast(p_occ_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_occ_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.present-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names


# when you read it, make sure to so as:
# pocc <- terra::rast(x = 'data/processed/final-model-build/predictions/predictions.present-all-algorithms.tif')
# pocc <- raster::stack()




# And that's it for this script. Will project for past time slices in another one.