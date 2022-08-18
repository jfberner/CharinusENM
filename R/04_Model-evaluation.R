# --------------------------------------------------#
# Model Evaluation
# CharinusENM
# In this script we'll evaluate the models based on both their performance given their Accumulation of Occurrence Curves (Jiménez & Soberón 2020).
# First version: 2022 Aug 17
# Author: João Frederico Berner
# --------------------------------------------------#

if (!dir.exists("figs/aocc/")) dir.create("figs/aocc", recursive = TRUE) # Create this folder for the output figs

# Libs #####
library(raster)

# Functions #####
# We'll need two functions to transform the sdm data into the format readable by the accum.occ and the comp.acc functions, and we'll also need those. To load them:
source('R/sdm_to_occ.pnts.R')
source('R/sdm_to_output.mod.R')
source('R/Accum_curve_occ.R')
source('R/compare_models.R')

# Load data #####
# We'll need three things to get the AOcCs: occurrence data, environmental data used in predict() and the prediction output.

## Occurrence data ####
# We'll only use the train data for the AOcCs
occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp')

## Environmental Data #####
envpres <- dir(path = 'data/processed/envcropped/Present/', pattern = ".tif$", full.names = T)
envpres <- raster::stack(envpres)

## Prediction Data #####
pred_pres <- terra::rast(x = 'data/processed/model-build/predictions/predictions.present-all-algorithms.tif') # remember to read with terra:: to retain layer names
pred_pres <- raster::stack(pred_pres) # and then turn them into RasterStacks

# AOcCs of models #####
# Prepare the data to pass it onto the function:
occ.pnts <- sdm_to_occ.pnts(env = envpres, 
                            occ = occ_train,
                            algorithms = c('svm', 'maxent', 'bioclim', 'domain'),
                            predict_object = pred_pres)

output.mod <- sdm_to_output.mods(env = envpres,
                                 algorithms = c('svm', 'maxent', 'bioclim', 'domain'),
                                 predict_object = pred_pres)


# The accum.occ function is annoying and creates three different plots in three different devices. To save them we'll use dev.print() in the reverse order in which they appear. I could automatize this part of the script but I don't have time for that, I'm sorry dear reader.
dev.new() ; dev.control('enable') ; dev.off() # Just enabling device control

# WARNING: Before running this next section of the script, make sure nothing is plotted and no devices are open with dev.list()
aocc_svm <- accum.occ(sp.name = 'Charinus', 
                      output.mod = output.mod[[1]],
                      occ.pnts = occ.pnts[[1]],
                      null.mod = "hypergeom",
                      conlev = 0.05, bios = 0)

# To save the plots, we have to do it in the reverse order as they were plotted:
dev.print(png, file = "figs/aocc/svm_aocc_aocc.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/svm_aocc_map.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/svm_aocc_env.png", width=8, height=8, units="in", res=300);dev.off()

# rinse and repeat for the next algorithm
aocc_maxent <- accum.occ(sp.name = 'Charinus', 
                      output.mod = output.mod[[2]],
                      occ.pnts = occ.pnts[[2]],
                      null.mod = "hypergeom",
                      conlev = 0.05, bios = 0)

dev.print(png, file = "figs/aocc/maxent_aocc_aocc.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/maxent_aocc_map.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/maxent_aocc_env.png", width=8, height=8, units="in", res=300);dev.off()

# rinse and repeat for the next algorithm
aocc_bioclim <- accum.occ(sp.name = 'Charinus', 
                      output.mod = output.mod[[3]],
                      occ.pnts = occ.pnts[[3]],
                      null.mod = "hypergeom",
                      conlev = 0.05, bios = 0)

dev.print(png, file = "figs/aocc/bioclim_aocc_aocc.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/bioclim_aocc_map.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/bioclim_aocc_env.png", width=8, height=8, units="in", res=300);dev.off()

# rinse and repeat for the next algorithm
aocc_domain <- accum.occ(sp.name = 'Charinus', 
                      output.mod = output.mod[[4]],
                      occ.pnts = occ.pnts[[4]],
                      null.mod = "hypergeom",
                      conlev = 0.05, bios = 0)

dev.print(png, file = "figs/aocc/domain_aocc_aocc.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/domain_aocc_map.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc/domain_aocc_env.png", width=8, height=8, units="in", res=300);dev.off()

# Comparing Models #####
# Last, we make plots comparing the models' AOcCs

# For that, we need a list of accum.occ objects
aocc_list <- list(aocc_svm, aocc_maxent, aocc_bioclim, aocc_domain)
model_comp <- comp.accplot(mods = aocc_list, 
                           nocc = length(occ_train), 
                           ncells = raster::ncell(envpres), 
                           sp.name = 'Charinus',
                           mods.names = c('svm', 'maxent', 'bioclim', 'domain'), alpha = 0.05)

# And save this final one:
dev.print(png, file = "figs/aocc/01_model-comparison.png", width=8, height=8, units="in", res=300);dev.off()
