# --------------------------------------------------#
# Compile AUC Values
# CharinusENM
# In this script we will get a table with the AUC values for the mean of all model replicas of the algorithms used in model build
# First version sysDate()
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
library(sdm)
library(tidyr)
# Data #####
# For this script, we need two objects: the sdm model saved with sdm::write.sdm() and the raster with the predicted values

## sdm object #####
model <- sdm::read.sdm("data/processed/model-build/model-object/model.sdm")
## Predicted values raster #####
pred_pres <- terra::rast(x = 'data/processed/model-build/predictions/predictions.present-all-algorithms.tif') # remember to read with terra:: to retain layer names
pred_pres <- raster::stack(pred_pres) # and then turn them into RasterStacks

# Evaluation #####

# We already get the information we need when running model, all we need to do is to get it in a single object so we can check on it whenever we want

evaluation <- sdm::getEvaluation(x = model, p = pred_pres, wtest = 'test.dep', replication = c('svm', 'maxent', 'bioclim', 'dismo'), distribution = 'gaussian', stat = NULL)

# Unfortunatelly it doesn't return the mean of each method, so we'll have to do this:
ev_svm <- evaluation[1:5,]
ev_maxent <- evaluation[6:10,]
ev_bioclim <- evaluation[11:15,]
ev_dismo <- evaluation[16:20,]

final_eval <- data.frame(colMeans(ev_svm), colMeans(ev_maxent), colMeans(ev_bioclim), colMeans(ev_dismo))

# And we give it some final touches to make it pretty so we can export it
names(final_eval) <- c('SVM', 'MaxEnt', 'BioClim', 'Dismo')
final_eval %>% t()
# And we spit it out:
if (!dir.exists('data/processed/model-build/evaluation/')) dir.create('data/processed/model-build/evaluation/')

write.csv(x = final_eval,file = 'data/processed/model-build/evaluation/evaluation.csv')
