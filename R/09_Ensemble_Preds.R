# --------------------------------------------------#
# Ensembling Predictions
# CharinusENM
#
# In this script we'll ensemble the predictions for all time slices,
# then we'll apply a threshold of 0.4 to them to get presence/absence maps,
# and finally we'll save those maps as polygons to plot them easily in the next scripts
#
# First version: 2022 Aug 17
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
library(sdm)
library(raster)
# Data #####
# Here we only need to load all models and environmental layers for every time slice
## Final Model #####
model <- sdm::read.sdm("data/processed/final-model-build/model-object/model.sdm") 

## Environmental Layers #####
#### Present - Historical - 1970 - 2000
envpres <- dir(path = 'data/processed/envcropped/Present/', pattern = ".tif$", full.names = T)
envpres <- raster::stack(envpres)
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

# To make this easier, we'll assign names(envpres) to names(envALL).

# And now pass the names:
names(envlh) <- names(envpres)
names(envmh) <- names(envpres)
names(enveh) <- names(envpres)
names(envyds) <- names(envpres)
names(envba) <- names(envpres)
names(envhs1) <- names(envpres)
names(envlgm) <- names(envpres)


# Ensemble #####
# Let's create a folder before anything else to pass the outputs to
if (!dir.exists('data/processed/final-model-build/ensemble')) dir.create('data/processed/final-model-build/ensemble')

# And ensemble by AUC weight, as well as apply a threshold to turn into a presence/absence layer for every timestep

##### Present - Historical - 1970-2000 ####
en.pres <- ensemble(model, envpres, 
                    filename =  'data/processed/final-model-build/ensemble/ensemble-present.tif',
                    setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold
pa.pres <- raster(en.pres)
pa.pres[] <- ifelse(en.pres[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.pres, filename = 'data/processed/final-model-build/ensemble/ensemble-present-04threshold.tif',overwrite=T)

##### LH - Late Holocene - 4.2 - 0.3ky ####
en.lh <- ensemble(model, envlh, 
                    filename =  'data/processed/final-model-build/ensemble/ensemble-lh.tif',
                    setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold: 
pa.lh <- raster(en.lh)
pa.lh[] <- ifelse(en.lh[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.lh, filename = 'data/processed/final-model-build/ensemble/ensemble-lh-04threshold.tif',overwrite=T)

##### MH - Mid Holocene - 8.326 - 4.2ky ####
en.mh <- ensemble(model, envmh, 
                  filename =  'data/processed/final-model-build/ensemble/ensemble-mh.tif',
                  setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold: 
pa.mh <- raster(en.mh)
pa.mh[] <- ifelse(en.mh[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.mh, filename = 'data/processed/final-model-build/ensemble/ensemble-mh-04threshold.tif',overwrite=T)
##### EH - Early Holocene - 11.7 - 8.326ky ####
en.eh <- ensemble(model, enveh, 
                  filename =  'data/processed/final-model-build/ensemble/ensemble-eh.tif',
                  setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold: 
pa.eh <- raster(en.eh)
pa.eh[] <- ifelse(en.eh[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.mh, filename = 'data/processed/final-model-build/ensemble/ensemble-eh-04threshold.tif',overwrite=T)
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky ####
en.yds <- ensemble(model, envyds, 
                  filename =  'data/processed/final-model-build/ensemble/ensemble-yds.tif',
                  setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold: 
pa.yds <- raster(en.yds)
pa.yds[] <- ifelse(en.yds[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.mh, filename = 'data/processed/final-model-build/ensemble/ensemble-yds-04threshold.tif',overwrite=T)
##### BA -  Bølling-Allerød - 14.7 - 12.9ky ####
en.ba <- ensemble(model, envba, 
                  filename =  'data/processed/final-model-build/ensemble/ensemble-ba.tif',
                  setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold: 
pa.ba <- raster(en.ba)
pa.ba[] <- ifelse(en.ba[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.mh, filename = 'data/processed/final-model-build/ensemble/ensemble-ba-04threshold.tif',overwrite=T)
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky ####
en.hs1 <- ensemble(model, envhs1, 
                  filename =  'data/processed/final-model-build/ensemble/ensemble-hs1.tif',
                  setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold: 
pa.hs1 <- raster(en.hs1)
pa.hs1[] <- ifelse(en.hs1[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.mh, filename = 'data/processed/final-model-build/ensemble/ensemble-hs1-04threshold.tif',overwrite=T)
##### LGM - Last Glacial Maximum - 130ky ####
en.lgm <- ensemble(model, envlgm, 
                  filename =  'data/processed/final-model-build/ensemble/ensemble-lgm.tif',
                  setting = list(method = 'mean-weighted', stat = 'AUC'),overwrite=T)
# to get pres/abs maps apply a threshold: 
pa.lgm <- raster(en.lgm)
pa.lgm[] <- ifelse(en.lgm[] >= 0.4, 1, 0) # 0.4 as threshold

writeRaster(pa.mh, filename = 'data/processed/final-model-build/ensemble/ensemble-lgm-04threshold.tif',overwrite=T)

# Polygonize Presence/Absence Ensembles #####
# In this next section we'll make Polygons out of the rasters where we applied a threshold, and save the outputs
if (!dir.exists('data/processed/final-model-build/ensemble-shapefiles')) dir.create('data/processed/final-model-build/ensemble-shapefiles')

#### Present - Historical - 1970 - 2000 ####
pol_pres <- rasterToPolygons(pa.pres,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_pres, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/present-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)

##### LH - Late Holocene - 4.2 - 0.3ky ####
pol_lh <- rasterToPolygons(pa.lh,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_lh, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/lh-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)

##### MH - Mid Holocene - 8.326 - 4.2ky ####
pol_mh <- rasterToPolygons(pa.mh,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_mh, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/mh-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)

##### EH - Early Holocene - 11.7 - 8.326ky ####
pol_eh <- rasterToPolygons(pa.eh,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_eh, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/eh-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)

##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky ####
pol_yds <- rasterToPolygons(pa.yds,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_yds, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/yds-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)

##### BA -  Bølling-Allerød - 14.7 - 12.9ky ####
pol_ba <- rasterToPolygons(pa.ba,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_ba, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/ba-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)

##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky ####
pol_hs1 <- rasterToPolygons(pa.hs1,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_hs1, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/hs1-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)

##### LGM - Last Glacial Maximum - 130ky ####
pol_lgm <- rasterToPolygons(pa.lgm,fun = function(x){x==1},dissolve = T)
rgdal::writeOGR(pol_lgm, 
                dsn="data/processed/final-model-build/ensemble-shapefiles/lgm-04threshold.shp",
                layer='layer', 
                driver="ESRI Shapefile",
                overwrite_layer = T)



# And Finally, Done!