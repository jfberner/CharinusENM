#--------------------------------------------# 
# Cropping Environmental Rasters Based on Occurence Records
# Charinus ENM project
# Author: João Frederico Berner
# First script version: 2022 Aug 13
# This script will generate a Bounding Box around the occurrence
# records and crop the environmental rasters with this limit.
# This script is outlined
#--------------------------------------------#

path <- '~/Documents/CharinusENM' # Miss Jenny, please don't set my computer on fire, I can't make raster::stack work if I'm not in the folder

# Libraries #####
library(raster)
library(terra)

# Load Data #####
## Environmental Layers ####
# There's a folder for each time period, so we'll grab the tif files of each of the folders

##### LH - Late Holocene - 4.2 - 0.3ky
setwd('data/raw/env/PaleoClim/LH_v1_2_5m')
envlh <- dir(pattern="tif$")
envlh <- raster::stack(envlh)
##### MH - Mid Holocene - 8.326 - 4.2ky
setwd(path)
setwd('data/raw/env/PaleoClim/MH_v1_2_5m')
envmh <- dir(pattern="tif$")
envmh <- raster::stack(envmh)
##### EH - Early Holocene - 11.7 - 8.326ky
setwd(path)
setwd('data/raw/env/PaleoClim/EH_v1_2_5m')
enveh <- dir(pattern="tif$")
enveh <- raster::stack(enveh)
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky
setwd(path)
setwd('data/raw/env/PaleoClim/YDS_v1_2_5m')
envyds <- dir(pattern="tif$")
envyds <- raster::stack(envyds)
##### BA -  Bølling-Allerød - 14.7 - 12.9ky
setwd(path)
setwd('data/raw/env/PaleoClim/BA_v1_2_5m')
envba <- dir(pattern="tif$")
envba <- raster::stack(envba)
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky
setwd(path)
setwd('data/raw/env/PaleoClim/HS1_v1_2_5m')
envhs1 <- dir(pattern="tif$")
envhs1 <- raster::stack(envhs1)
##### LGM - Last Glacial Maximum - 130ky
setwd(path)
setwd('data/raw/env/PaleoClim/chelsa_LGM_v1_2B_r2_5m')
envlgm <- dir(pattern="tif$")
envlgm <- raster::stack(envlgm)
##### Present - WorldClim v2 1970-2000 average
setwd(path)
setwd('data/raw/env/BioClim/')
envpres <- dir(pattern="tif$")
envpres <- raster::stack(envpres)
setwd(path)

## Occurrence records ####
# Read the csv
occ_raw <- read.csv('data/raw/occ/presence_absence.csv')
occ_pres <- occ_raw %>% filter(charinus == 1) # only presence data, dropping absences

# Turn the object into a SpatialPoints dataframe
coordinates(occ_pres) <- ~long + lat
proj4string(occ_pres) <- projection(raster())

# Generate Bounding Box around Occurrence Records ####
occ_buffer <- gBuffer(spgeom = occ_pres, byid = T,
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
raster::writeRaster(envlh, filename = 'data/processed/envcropped/LH/lh.tif', prj = T, overwrite = T)

##### MH - Mid Holocene - 8.326 - 4.2ky
if (!dir.exists("data/processed/envcropped/MH")) dir.create("data/processed/envcropped/MH", recursive = TRUE)
raster::writeRaster(envmh, filename = 'data/processed/envcropped/MH/mh.tif', prj = T, overwrite = T)

##### EH - Early Holocene - 11.7 - 8.326ky
if (!dir.exists("data/processed/envcropped/EH")) dir.create("data/processed/envcropped/EH", recursive = TRUE)
raster::writeRaster(enveh, filename = 'data/processed/envcropped/EH/eh.tif', prj = T, overwrite = T)

##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky
if (!dir.exists("data/processed/envcropped/YDS")) dir.create("data/processed/envcropped/YDS", recursive = TRUE)
raster::writeRaster(envyds, filename = 'data/processed/envcropped/YDS/yds.tif', prj = T, overwrite = T)

##### BA -  Bølling-Allerød - 14.7 - 12.9ky
if (!dir.exists("data/processed/envcropped/BA")) dir.create("data/processed/envcropped/BA", recursive = TRUE)
raster::writeRaster(envba, filename = 'data/processed/envcropped/BA/ba.tif', prj = T, overwrite = T)

##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky
if (!dir.exists("data/processed/envcropped/HS1")) dir.create("data/processed/envcropped/HS1", recursive = TRUE)
raster::writeRaster(envhs1, filename = 'data/processed/envcropped/HS1/hs1.tif', prj = T, overwrite = T)

##### LGM - Last Glacial Maximum - 130ky
if (!dir.exists("data/processed/envcropped/LGM")) dir.create("data/processed/envcropped/LGM", recursive = TRUE)
raster::writeRaster(envlgm, filename = 'data/processed/envcropped/LGM/lgm.tif', prj = T, overwrite = T)

##### Present - WorldClim v2 1970-2000 average
if (!dir.exists("data/processed/envcropped/Present")) dir.create("data/processed/envcropped/Present", recursive = TRUE)
raster::writeRaster(envpres, filename = 'data/processed/envcropped/Present/present.tif', prj = T, overwrite = T)