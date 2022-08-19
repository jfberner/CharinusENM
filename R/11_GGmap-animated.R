# --------------------------------------------------#
# GG Map - Animated Timeseries Present -> LGM
# CharinusENM
# In this script, we'll create an animated map of Charinus
# suitable area from present to the Last Glacial Maximum
# First version sysDate()
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
library(ggplot2)
library(gganimate)
library(mapdata)
library(oz)
library(ggmap)
library(gridExtra)
library(terra)
library(raster)
library(leaflet)
library(dplyr)
library(sf)
# Load Data #####
# Data #####
# In this script we need to load all of our shapefiles:
# occurrences and all ensembles. Since we'll be working with 
# the leaflet package, everything needs to be in sf format

## Occurrence Data #####
occ_train <- sf::read_sf('data/processed/shapefiles/train.shp') # only presence data
shape_train <- st_transform(occ_train, CRS("+proj=longlat +datum=WGS84 +no_defs"))

occ_test <- sf::read_sf('data/processed/shapefiles/test.shp') # presence/absence data
shape_test <- st_transform(occ_test, CRS("+proj=longlat +datum=WGS84 +no_defs"))

occ_raw <- sf::read_sf('data/processed/shapefiles/raw.shp') # presence/absence data
shape_raw <- st_transform(occ_raw, CRS("+proj=longlat +datum=WGS84 +no_defs"))

## Ensembled Predictions #####
# Since we'll be working with ggplot, ggmap and gganimate, we need things in the st/sf format instead of RasterStacks, RasterBricks and SpatialPolygons or SpatialPoints
#### Present - Historical - 1970 - 2000
ens_pres <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/present-04threshold.shp') # only presence data
shape_pres <- st_transform(ens_pres, CRS("+proj=longlat +datum=WGS84 +no_defs"))
##### LH - Late Holocene - 4.2 - 0.3ky
ens_lh <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/lh-04threshold.shp') # only presence data
shape_lh <- st_transform(ens_lh, CRS("+proj=longlat +datum=WGS84 +no_defs"))
##### MH - Mid Holocene - 8.326 - 4.2ky
ens_mh <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/mh-04threshold.shp') # only presence data
shape_mh <- st_transform(ens_mh, CRS("+proj=longlat +datum=WGS84 +no_defs"))
##### EH - Early Holocene - 11.7 - 8.326ky
ens_eh <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/eh-04threshold.shp') # only presence data
shape_eh <- st_transform(ens_eh, CRS("+proj=longlat +datum=WGS84 +no_defs"))
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky
ens_yds <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/yds-04threshold.shp') # only presence data
shape_yds <- st_transform(ens_yds, CRS("+proj=longlat +datum=WGS84 +no_defs"))
##### BA -  Bølling-Allerød - 14.7 - 12.9ky
ens_ba <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/ba-04threshold.shp') # only presence data
shape_ba <- st_transform(ens_ba, CRS("+proj=longlat +datum=WGS84 +no_defs"))
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky
ens_hs1 <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/hs1-04threshold.shp') # only presence data
shape_hs1 <- st_transform(ens_hs1, CRS("+proj=longlat +datum=WGS84 +no_defs"))
##### LGM - Last Glacial Maximum - 130ky
ens_lgm <- sf::read_sf('data/processed/final-model-build/ensemble-shapefiles/lgm-04threshold.shp') # only presence data
shape_lgm <- st_transform(ens_lgm, CRS("+proj=longlat +datum=WGS84 +no_defs"))


# Get the map ####