# --------------------------------------------------#
# Final Model Evaluation
# CharinusENM
# We'll get the information acquired in scripts 04_Model-evaluation.R and
# 05_AUC_values.R just so we can store it. Since it's just two algorithms this
# time, we'll get both information in a single script
# First version: 2022 Aug 17
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
library(raster)
library(sdm)
library(tidyr)

# Functions #####
# We'll need two functions to transform the sdm data into the format readable by the accum.occ and the comp.acc functions, and we'll also need those. To load them:
source('R/sdm_to_occ.pnts.R')
source('R/sdm_to_output.mod.R')
source('R/Accum_curve_occ.R')
source('R/compare_models.R')

# Data #####
# We'll need three things to get the AOcCs: occurrence data, environmental data used in predict() and the prediction output.

# For the AUC values, we need two objects: the sdm model saved with sdm::write.sdm() and the raster with the predicted values

## Occurrence data ####
# We'll only use the train data for the AOcCs
occ_train <- rgdal::readOGR('data/processed/shapefiles/train.shp')

## Environmental Data #####
envpres <- dir(path = 'data/processed/envcropped/Present/', pattern = ".tif$", full.names = T)
envpres <- raster::stack(envpres)

## Prediction Data #####
pred_pres <- terra::rast(x = 'data/processed/final-model-build/predictions/predictions.present-all-algorithms.tif') # remember to read with terra:: to retain layer names
pred_pres <- raster::stack(pred_pres) # and then turn them into RasterStacks

## sdm object #####
model <- sdm::read.sdm("data/processed/final-model-build/model-object/model.sdm")

# AUC values #####
# Evaluation #####

# We already get the information we need when running model, all we need to do is to get it in a single object so we can check on it whenever we want

evaluation <- sdm::getEvaluation(x = model, p = pred_pres, wtest = 'test.dep', replication = c('svm', 'maxent', 'bioclim', 'dismo'), distribution = 'gaussian', stat = NULL)

# Unfortunatelly it doesn't return the mean of each method, so we'll have to do this:
ev_svm <- evaluation[1:25,]
ev_maxent <- evaluation[26:50,]

final_eval <- data.frame(colMeans(ev_svm), colMeans(ev_maxent))

# And we give it some final touches to make it pretty so we can export it
names(final_eval) <- c('SVM', 'MaxEnt')
final_eval %>% t()
# And we spit it out:
if (!dir.exists('data/processed/final-model-build/evaluation/')) dir.create('data/processed/final-model-build/evaluation/')

write.csv(x = final_eval,file = 'data/processed/final-model-build/evaluation/evaluation.csv')


# AOcCs #####
if (!dir.exists('figs/aocc-final/')) dir.create('figs/aocc-final/')
occ.pnts <- sdm_to_occ.pnts(env = envpres, 
                            occ = occ_train,
                            algorithms = c('svm', 'maxent'),
                            predict_object = pred_pres)

output.mod <- sdm_to_output.mods(env = envpres,
                                 algorithms = c('svm', 'maxent'),
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
dev.print(png, file = "figs/aocc-final/svm_aocc_aocc.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc-final/svm_aocc_map.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc-final/svm_aocc_env.png", width=8, height=8, units="in", res=300);dev.off()

# rinse and repeat for the next algorithm
aocc_maxent <- accum.occ(sp.name = 'Charinus', 
                         output.mod = output.mod[[2]],
                         occ.pnts = occ.pnts[[2]],
                         null.mod = "hypergeom",
                         conlev = 0.05, bios = 0)

dev.print(png, file = "figs/aocc-final/maxent_aocc_aocc.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc-final/maxent_aocc_map.png", width=8, height=8, units="in", res=300);dev.off()

dev.print(png, file = "figs/aocc-final/maxent_aocc_env.png", width=8, height=8, units="in", res=300);dev.off()

## Comparing Models #####
# Last, we make plots comparing the models' AOcCs

# For that, we need a list of accum.occ objects
aocc_list <- list(aocc_svm, aocc_maxent)
model_comp <- comp.accplot(mods = aocc_list, 
                           nocc = length(occ_train), 
                           ncells = raster::ncell(envpres), 
                           sp.name = 'Charinus',
                           mods.names = c('svm', 'maxent'), alpha = 0.05)

# And save this final one:
dev.print(png, file = "figs/aocc-final/01_final-model-comparison.png", width=8, height=8, units="in", res=300);dev.off()