# --------------------------------------------------#
# Predictions for Other Time Periods
# CharinusENM
# In this script we'll project our FinalModel to past time periods, obtained
# from PaleoClim
# First version: 2022 Aug 17
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
library(sdm)
library(raster)

# Data #####
# For this script, we need the final model and the past environmental layers.
## Final Model #####
model <- sdm::read.sdm("data/processed/final-model-build/model-object/model.sdm") 

## Environmental Layers #####

##### LH - Late Holocene - 4.2 - 0.3ky
envlh <-dir(path = 'data/processed/envcropped/LH/', pattern = ".tif$", full.names = T)
envlh <- raster::stack(envlh)
##### MH - Mid Holocene - 8.326 - 4.2ky
envmh <- dir(path = 'data/processed/envcropped/MH/', pattern=".tif$", full.names = T)
envmh <- raster::stack(envmh)
##### EH - Early Holocene - 11.7 - 8.326ky
enveh <- dir(path = 'data/processed/envcropped/EH/', pattern=".tif$", full.names = T)
enveh <- raster::stack(enveh)
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky
envyds <- dir(path = 'data/processed/envcropped/YDS/', pattern=".tif$", full.names = T)
envyds <- raster::stack(envyds)
##### BA -  Bølling-Allerød - 14.7 - 12.9ky
envba <- dir(path = 'data/processed/envcropped/BA/', pattern=".tif$", full.names = T)
envba <- raster::stack(envba)
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky
envhs1 <- dir(path = 'data/processed/envcropped/HS1/', pattern=".tif$", full.names = T)
envhs1 <- raster::stack(envhs1)
##### LGM - Last Glacial Maximum - 130ky
envlgm <- dir(path = 'data/processed/envcropped/LGM/', pattern=".tif$", full.names = T)
envlgm <- raster::stack(envlgm)

# Before the next section works, we need to make the layer names equal, as they are right now they're called by 'timeslice_BioX', and we need the names to be just 'BioX' so the model can recognize them as equal. Since in model build the layers were called 'present_BioX', we'll have to rename them all to this format.

# To make this easier, we'll load envpres (used in model build) and assign names(envpres) to names(envALL).
envpres <- dir(path = 'data/processed/envcropped/Present/', pattern = ".tif$", full.names = T)
envpres <- raster::stack(envpres)

# And now pass the names:
names(envlh) <- names(envpres)
names(envmh) <- names(envpres)
names(enveh) <- names(envpres)
names(envyds) <- names(envpres)
names(envba) <- names(envpres)
names(envhs1) <- names(envpres)
names(envlgm) <- names(envpres)

# Predictions #####
##### LH - Late Holocene - 4.2 - 0.3ky ####
p_lh <- predict(model, newdata = envlh, # new data is the environment in which we want to predict
                 filename = 'data/processed/final-model-build/predictions/predictions.lh-nonames.tif',
                 mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_lh_stack <- raster::stack(p_lh) #convert rasterBrick to rasterStack
p_lh_spatraster <- terra::rast(p_lh_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_lh_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.lh-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names

##### MH - Mid Holocene - 8.326 - 4.2ky ####
p_mh <- predict(model, newdata = envmh, # new data is the environment in which we want to predict
                filename = 'data/processed/final-model-build/predictions/predictions.mh-nonames.tif',
                mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_mh_stack <- raster::stack(p_mh) #convert rasterBrick to rasterStack
p_mh_spatraster <- terra::rast(p_mh_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_mh_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.mh-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names

##### EH - Early Holocene - 11.7 - 8.326ky ####
p_eh <- predict(model, newdata = enveh, # new data is the environment in which we want to predict
                filename = 'data/processed/final-model-build/predictions/predictions.eh-nonames.tif',
                mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_eh_stack <- raster::stack(p_eh) #convert rasterBrick to rasterStack
p_eh_spatraster <- terra::rast(p_eh_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_eh_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.eh-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky ####
p_yds <- predict(model, newdata = envyds, # new data is the environment in which we want to predict
                filename = 'data/processed/final-model-build/predictions/predictions.yds-nonames.tif',
                mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_yds_stack <- raster::stack(p_yds) #convert rasterBrick to rasterStack
p_yds_spatraster <- terra::rast(p_yds_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_yds_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.yds-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names
##### BA -  Bølling-Allerød - 14.7 - 12.9ky ####
p_ba <- predict(model, newdata = envba, # new data is the environment in which we want to predict
                filename = 'data/processed/final-model-build/predictions/predictions.ba-nonames.tif',
                mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_ba_stack <- raster::stack(p_ba) #convert rasterBrick to rasterStack
p_ba_spatraster <- terra::rast(p_ba_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_ba_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.ba-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky ####
p_hs1 <- predict(model, newdata = envhs1, # new data is the environment in which we want to predict
                filename = 'data/processed/final-model-build/predictions/predictions.hs1-nonames.tif',
                mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_hs1_stack <- raster::stack(p_hs1) #convert rasterBrick to rasterStack
p_hs1_spatraster <- terra::rast(p_hs1_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_hs1_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.hs1-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names
##### LGM - Last Glacial Maximum - 130ky ####
p_lgm <- predict(model, newdata = envlgm, # new data is the environment in which we want to predict
                filename = 'data/processed/final-model-build/predictions/predictions.lgm-nonames.tif',
                mean = T, prj = T, overwrite = T, nc = 5) 

# This creates a file in the specified folder BUT the file doesn't retain the layer names, which will be super important for us to distinguish among methods. To do so:

p_lgm_stack <- raster::stack(p_lgm) #convert rasterBrick to rasterStack
p_lgm_spatraster <- terra::rast(p_lgm_stack) #convert rasterStack to SpatRaster

terra::writeRaster(x = p_lgm_spatraster, 
                   filename = 'data/processed/final-model-build/predictions/predictions.lgm-all-algorithms.tif',
                   overwrite = TRUE) # Using terra package because it retains layer names

# And we're done! :)