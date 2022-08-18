# --------------------------------------------------#
# Occ to SHP
# Charinus ENM project
#
# In this script we'll take the csv with occurrence points
# and we'll create three separate shp files: one complete
# to generate M, one for model train with only occurrence records,
# and one for model test with the absence records (+the same
# number of presences as absences)
#
# First version: 2022 Aug 15
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
library(terra)
library(dplyr)
library(raster)
library(rgdal)
# Load Data #####
occ_raw <- read.csv('data/raw/occ/presence_absence.csv')

occ_train <- occ_raw[1:17,] # Presence data, leaving 6 presences behind, dropping absences
occ_test <- occ_raw[18:29,] # 6 presences, 6 absences


# Turn the objects into a SpatialPointsDataFrames ####
coordinates(occ_raw) <- ~long + lat
proj4string(occ_raw) <- projection(raster())

coordinates(occ_train) <- ~long + lat
proj4string(occ_train) <- projection(raster())

coordinates(occ_test) <- ~long + lat
proj4string(occ_test) <- projection(raster())

# Save shapefiles #####
if (!dir.exists('/data/processed/shapefiles/')) dir.create("data/processed/shapefiles/", recursive = TRUE)


writeOGR(obj=occ_raw, dsn="data/processed/shapefiles/raw.shp", layer=c("species"), driver="ESRI Shapefile", overwrite_layer = T)

writeOGR(obj=occ_train, dsn="data/processed/shapefiles/train.shp", layer=c("species"), driver="ESRI Shapefile", overwrite_layer = T)

writeOGR(obj=occ_test, dsn="data/processed/shapefiles/test.shp", layer=c("species"), driver="ESRI Shapefile", overwrite_layer = T)
