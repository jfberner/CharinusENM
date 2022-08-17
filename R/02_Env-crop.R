#--------------------------------------------# 
# Cropping Environmental Rasters Based on Occurence Records Distribution
# Charinus ENM project
# Author: João Frederico Berner
# First script version: 2022 Aug 13
# This script will generate a Bounding Box around the occurrence
# records and crop the environmental rasters with this limit.
# This script is outlined
#--------------------------------------------#

# Libraries #####
library(raster)
library(terra)
library(rgdal)

# Load Data #####
## Environmental Layers ####
# There's a folder for each time period, so we'll grab the tif files of each of the folders

##### LH - Late Holocene - 4.2 - 0.3ky
envlh <- dir(path = 'data/raw/env/PaleoClim/LH_v1_2_5m', pattern=".tif$", full.names = T)
envlh <- raster::stack(envlh)
##### MH - Mid Holocene - 8.326 - 4.2ky
envmh <- dir(path = 'data/raw/env/PaleoClim/MH_v1_2_5m', pattern=".tif$", full.names = T)
envmh <- raster::stack(envmh)
##### EH - Early Holocene - 11.7 - 8.326ky
enveh <- dir(path = 'data/raw/env/PaleoClim/EH_v1_2_5m', pattern=".tif$", full.names = T)
enveh <- raster::stack(enveh)
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky
envyds <- dir(path = 'data/raw/env/PaleoClim/YDS_v1_2_5m', pattern=".tif$", full.names = T)
envyds <- raster::stack(envyds)
##### BA -  Bølling-Allerød - 14.7 - 12.9ky
envba <- dir(path = 'data/raw/env/PaleoClim/BA_v1_2_5m', pattern=".tif$", full.names = T)
envba <- raster::stack(envba)
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky
envhs1 <- dir(path = 'data/raw/env/PaleoClim/HS1_v1_2_5m', pattern=".tif$", full.names = T)
envhs1 <- raster::stack(envhs1)
##### LGM - Last Glacial Maximum - 130ky
envlgm <- dir(path = 'data/raw/env/PaleoClim/chelsa_LGM_v1_2B_r2_5m', pattern=".tif$", full.names = T)
envlgm <- raster::stack(envlgm)
##### Present - WorldClim v2 1970-2000 average
envpres <- dir(path = 'data/raw/env/BioClim/', pattern=".tif$", full.names = T)
envpres <- raster::stack(envpres)

## Occurrence records ####
# Read the csv
occ_raw <- readOGR('data/processed/shapefiles/raw.shp')

# Generate Bounding Box around Occurrence Records ####
occ_buffer <- rgeos::gBuffer(spgeom = occ_raw, byid = T,
                      width = 2, quadsegs = 100, # radius = 1 = 100km
                      capStyle = 'ROUND' , joinStyle = 'ROUND')
# Crop Environmental Layers #####
envlh <- raster::crop(envlh,occ_buffer)
envmh <- raster::crop(envmh,occ_buffer)
enveh <- raster::crop(enveh,occ_buffer)
envyds <- raster::crop(envyds,occ_buffer)
envba <- raster::crop(envba,occ_buffer)
envhs1 <- raster::crop(envhs1,occ_buffer)
envlgm <- raster::crop(envlgm,occ_buffer)
envpres <- raster::crop(envpres,occ_buffer)

# Save Environmental Layers #####
# Create the Folders if they do not exist yet
if (!dir.exists("data/processed/envcropped/")) dir.create("data/processed/envcropped/", recursive = TRUE)

##### LH - Late Holocene - 4.2 - 0.3ky
if (!dir.exists("data/processed/envcropped/LH")) dir.create("data/processed/envcropped/LH", recursive = TRUE)

raster::writeRaster(envlh, filename = 'data/processed/envcropped/LH/lh.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))
##### MH - Mid Holocene - 8.326 - 4.2ky
if (!dir.exists("data/processed/envcropped/MH")) dir.create("data/processed/envcropped/MH", recursive = TRUE)

raster::writeRaster(envmh, filename = 'data/processed/envcropped/MH/mh.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))
##### EH - Early Holocene - 11.7 - 8.326ky
if (!dir.exists("data/processed/envcropped/EH")) dir.create("data/processed/envcropped/EH", recursive = TRUE)

raster::writeRaster(enveh, filename = 'data/processed/envcropped/EH/eh.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky
if (!dir.exists("data/processed/envcropped/YDS")) dir.create("data/processed/envcropped/YDS", recursive = TRUE)

raster::writeRaster(envyds, filename = 'data/processed/envcropped/YDS/yds.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))
##### BA -  Bølling-Allerød - 14.7 - 12.9ky
if (!dir.exists("data/processed/envcropped/BA")) dir.create("data/processed/envcropped/BA", recursive = TRUE)

raster::writeRaster(envba, filename = 'data/processed/envcropped/BA/ba.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky
if (!dir.exists("data/processed/envcropped/HS1")) dir.create("data/processed/envcropped/HS1", recursive = TRUE)

raster::writeRaster(envhs1, filename = 'data/processed/envcropped/HS1/hs1.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))
##### LGM - Last Glacial Maximum - 130ky
if (!dir.exists("data/processed/envcropped/LGM")) dir.create("data/processed/envcropped/LGM", recursive = TRUE)

raster::writeRaster(envlgm, filename = 'data/processed/envcropped/LGM/lgm.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))
##### Present - WorldClim v2 1970-2000 average
if (!dir.exists("data/processed/envcropped/Present")) dir.create("data/processed/envcropped/Present", recursive = TRUE)

raster::writeRaster(envpres, filename = 'data/processed/envcropped/Present/present.tif', 
                    prj = T, overwrite = T, bylayer = T, suffix = c('Bio1', 'Bio2', 'Bio12', 'Bio15'))