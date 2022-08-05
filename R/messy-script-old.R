# Charinus ENM
# Joao Frederico Berner
# 8 jan 2022

path <- "~/Documents/Charinus_SDM"
setwd(path)
##### Libraries #####
library(raster)
library(RStoolbox)
library(rgeos)
library(rgdal)
library(sdm)
library(tidyr)
library(tidyverse)
#####  #####
#### Load Envs ####
# environmental variables manually downloaded http://www.paleoclim.org/
# variables retained: bio1,bio4,bio12,bio15
# on jan-8-2022
setwd('env')
setwd('PaleoClim')
##### LH - Late Holocene - 4.2 - 0.3ky
setwd('LH_v1_2_5m')
envlh <- dir(pattern="tif$")
envlh <- raster::stack(envlh)
##### MH - Mid Holocene - 8.326 - 4.2ky
setwd('..')
setwd('MH_v1_2_5m')
envmh <- dir(pattern="tif$")
envmh <- raster::stack(envmh)
##### EH - Early Holocene - 11.7 - 8.326ky
setwd('..')
setwd('EH_v1_2_5m')
enveh <- dir(pattern="tif$")
enveh <- raster::stack(enveh)
##### YDS - Younger Dryas Stadial - 12.9 - 11.7ky
setwd('..')
setwd('YDS_v1_2_5m')
envyds <- dir(pattern="tif$")
envyds <- raster::stack(envyds)
##### BA -  Bølling-Allerød - 14.7 - 12.9ky
setwd('..')
setwd('BA_v1_2_5m')
envba <- dir(pattern="tif$")
envba <- raster::stack(envba)
##### HS1 - Heirich Stadial 1 - 17.0 - 14.7ky
setwd('..')
setwd('HS1_v1_2_5m')
envhs1 <- dir(pattern="tif$")
envhs1 <- raster::stack(envhs1)
##### LGM - Last Glacial Maximum - 130ky
setwd('..')
setwd('chelsa_LGM_v1_2B_r2_5m')
envlgm <- dir(pattern="tif$")
envlgm <- raster::stack(envlgm)
##### LIG - Last Interglacial - 130ky
setwd('..')
setwd('LIG_v1_2_5m')
envlig <- dir(pattern="tif$")
envlig <- raster::stack(envlig)
##### MIS19 - MIS19 - 787ky
setwd('..')
setwd('MIS19_v1_r2_5m')
envmis19 <- dir(pattern="tif$")
envmis19 <- raster::stack(envmis19)
##### MPWP - Mid-Pliocene warm period - 3.205My
setwd('..')
setwd('mPWP_v1_r2_5m')
envmpwp <- dir(pattern="tif$")
envmpwp <- raster::stack(envmpwp)
##### M2 - M2 - 3.3My
setwd('..')
setwd('M2_v1_r2_5m')
envm2 <- dir(pattern="tif$")
envm2 <- raster::stack(envm2)
##### Env present
setwd('..')
setwd('CHELSA_cur_V1_2B_r2_5m')
envpres <- dir(pattern="tif$")
envpres <- raster::stack(envpres)

'envlh <-
envmh <- 
enveh <- 
envyds <- 
envba <- 
envhs1 <-
envlgm <- 
envlig <-
envmis19 <-
envmpwp <-
envm2 <-
envpres <-
' 'to copy and paste'
##### Occurrence Data Load + buffers #####
setwd(path)

occ <- read.csv('presence_absence.csv')
coordinates(occ) <- ~long + lat
proj4string(occ) <- projection(raster())

occ.buffer <- gBuffer(spgeom = occ, byid = T, # sm = small M
                         width = 3, quadsegs = 100, # radius = 1 = 100km
                         capStyle = 'ROUND' , joinStyle = 'ROUND')

##### EnvCrop to OccBuffer #####
envlh <- raster::crop(envlh,occ.buffer)
envmh <- raster::crop(envmh,occ.buffer)
enveh <- raster::crop(enveh,occ.buffer)
envyds <- raster::crop(envyds,occ.buffer)
envba <- raster::crop(envba,occ.buffer)
envhs1 <- raster::crop(envhs1,occ.buffer)
envlgm <- raster::crop(envlgm,occ.buffer)
envlig <- raster::crop(envlig,occ.buffer)
envmis19 <- raster::crop(envmis19,occ.buffer)
envmpwp <- raster::crop(envmpwp,occ.buffer)
envm2 <- raster::crop(envm2,occ.buffer)
envpres <- raster::crop(envpres,occ.buffer)
##### SDM #####
setwd(path)
dir.create('output-preds')
setwd('output-preds')
d.occ <- sdmData(formula=charinus~.,train=occ, predictors = envpres)
m.occ <- sdm(formula = charinus~.,data = d.occ, methods = c('svm','maxent'),
            replication = c('cv'), n=10) 

p.pres <- predict(m.occ, envpres, 'predictions.present.img', mean = T, overwrite = T)
p.envlh <- predict(m.occ, envlh, 'predictions.LH.img', mean = T, overwrite = T)
p.envmh <- predict(m.occ, envmh, 'predictions.MH.img', mean = T, overwrite = T)
p.enveh <- predict(m.occ, enveh, 'predictions.EH.img', mean = T, overwrite = T)
p.envyds <- predict(m.occ, envyds, 'predictions.YDS.img', mean = T, overwrite = T)
p.envba <- predict(m.occ, envba, 'predictions.BA.img', mean = T, overwrite = T)
p.envhs1 <- predict(m.occ, envhs1, 'predictions.HS1.img', mean = T, overwrite = T)
p.envlgm <- predict(m.occ, envlgm, 'predictions.LGM.img', mean = T, overwrite = T)
p.envlig <- predict(m.occ, envlig, 'predictions.LIG.img', mean = T, overwrite = T)
p.envmis19 <- predict(m.occ, envmis19, 'predictions.MIS19.img', mean = T, overwrite = T)
p.envmpwp <- predict(m.occ, envmpwp, 'predictions.MPWP.img', mean = T, overwrite = T)
p.envm2 <- predict(m.occ, envm2, 'predictions.M2.img', mean = T, overwrite = T)

