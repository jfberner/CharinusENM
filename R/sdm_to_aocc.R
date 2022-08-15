
sdm_to_aocc <- function(sdm_object, predict_object, spname){
  m.data.frame <- as.data.frame(sdm_object)
  p.data.frame <- as.data.frame(predict_object)
  method.names <- names(sdmobj@spname)
  
  occ.pnts <- 
  output.mods <- 
  return(list(output1, output2))
}


bd.bio.sm <- as.data.frame(bio.sm, row.names=NULL, na.rm=F,xy=F,long=F)
pd.bio.sm <- as.data.frame(p.bio.sm, row.names=NULL, na.rm=F, xy=T, long=F)

names(pd.bio.sm)<- c("long","lat","GLM","SVM","RF","BRT","MARS","MAXENT","MAXLIKE","GLMNET")

pd.bio.sm.glm<-dplyr::select(pd.bio.sm, long, lat, GLM)
output.mod.bio.sm.glm<-cbind(pd.bio.sm.glm, bd.bio.sm)
occ.p_env.bio.sm <- raster::extract(bio.sm, sp,
                                    as.data.frame=T)

occ.p_preds.bio.sm.glm <- raster::extract(p.bio.sm[[1]],
                                          sp,
                                          as.data.frame=T)
occ.coords.bio.sm <- sp@coords
occ.pnts.bio.sm.glm <- cbind(occ.coords.bio.sm, 
                             occ.p_preds.bio.sm.glm, 
                             occ.p_env.bio.sm)
occ.pnts.bio.sm.glm <- as.data.frame(occ.pnts.bio.sm.glm)
occ.pnts.bio.sm.glm <-drop_na(occ.pnts.bio.sm.glm)

acc.bio.sm.glm<-accum.occ(sp.name='Heterophrynus',
                          output.mod = output.mod.bio.sm.glm,
                          occ.pnts = occ.pnts.bio.sm.glm,
                          null.mod = "hypergeom",
                          conlev = 0.05, bios = 0)