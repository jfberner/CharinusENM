# --------------------------------------------------#
# Creating the Interactive Map
# CharinusENM
# 
# In this script we'll create an interactive map containing 
# all the layers of ensembled present and past predictions, 
# as well as the occurrence records (both train presence/only
# and test presence/absence)
# 
# First version: 2022 Aug 17
# Author: João Frederico Berner
# --------------------------------------------------#

# Libs #####
library(mapdata)
library(oz)
library(ggmap)
library(gridExtra)
library(terra)
library(raster)
library(leaflet)
library(dplyr)
library(sf)
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
centroid_lon <- round(coordinates(as(extent(shape_pres), "SpatialPolygons"))[1],digits = 2) # get the longitude of centroid of pred object
centroid_lat <- round(coordinates(as(extent(shape_pres), "SpatialPolygons"))[2],digits = 2) # get the latitude of centroid of pred object

map <- leaflet() %>% 
  addTiles() %>% 
  setView( lng = centroid_lon, lat = centroid_lat, zoom = 6) %>% 
  addProviderTiles("Esri.WorldImagery") %>%
  addPolygons(data = shape_pres,
              label = 'Present Suitable Area',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#fde725",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Present - Historical - 1970 - 2000") %>%
  addPolygons(data = shape_lh,
              label = 'Late Holocene Suitable Area (4.2 - 0.3ky)',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#a0da39",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Late Holocene - 4.2 - 0.3ky") %>%
  addPolygons(data = shape_mh,
              label = 'Mid Holocene Suitable Area (8.326 - 4.2ky)',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#4ac16d",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Mid Holocene - 8.326 - 4.2ky") %>%
  addPolygons(data = shape_eh,
              label = 'Early Holocene Suitable Area (11.7 - 8.326ky)',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#1fa187",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Early Holocene - 11.7 - 8.326ky") %>%
  addPolygons(data = shape_yds,
              label = 'Younger Dryas Stadial Suitable Area (12.9 - 11.7ky)',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#277f8e",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Younger Dryas Stadial - 12.9 - 11.7ky") %>%  
  addPolygons(data = shape_ba,
              label = 'Bølling-Allerød Suitable Area (14.7 - 12.9ky)',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#365c8d",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Bølling-Allerød - 14.7 - 12.9ky") %>%  
  addPolygons(data = shape_hs1,
              label = 'Heirich Stadial 1 Suitable Area (17.0 - 14.7ky)',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#46327e",
              fillOpacity = 0.7,
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Heirich Stadial 1 - 17.0 - 14.7ky") %>%  
  addPolygons(data = shape_lgm,
              label = 'Last Glacial Maximum Suitable Area (130ky)',
              color = "white", 
              weight = 0.75, 
              smoothFactor = 0.5,
              opacity = 1.0, 
              fillColor = "#440154",
              highlightOptions = highlightOptions(color = "white", weight = 2,
                                                  bringToFront = TRUE),
              group = "Last Glacial Maximum - 130ky") %>%  
  addCircleMarkers(data = shape_train, 
                   label = 'Presence Train Data', 
                   fillColor = '#f0f921',
                   fillOpacity = 1,
                   stroke = T, color = 'white', weight = 2,
                   group = "Train Data - Presence") %>%
  addCircleMarkers(data = shape_test, 
                   label = c('Presence Test Data', 'Absence Test Data'), 
                   fillColor = c('#f89540','#cc4778'),
                   fillOpacity = 1,
                   stroke = T, color = 'white', weight = 2,
                   group = "Test Data Presence/Absence")  %>%  
  addCircleMarkers(data = shape_train, 
                   label = 'Presence Train Data', 
                   fillColor = c('#7e03a8'),
                   fillOpacity = 1,
                   stroke = T, color = 'white', weight = 2,
                   group = "Train Data - Presence") %>%
  addCircleMarkers(data = shape_raw, 
                   label = c('Presence Raw Data', 'Absence Raw Data'), 
                   fillColor = c('#6497b1','#b3cde0'),
                   fillOpacity = 1,
                   stroke = T, color = 'white', weight = 2,
                   group = "Raw Data Presence/Absence") %>%
  addLayersControl(overlayGroups = c("Present - Historical - 1970 - 2000", 
                                     "Late Holocene - 4.2 - 0.3ky",
                                     "Mid Holocene - 8.326 - 4.2ky",
                                     "Early Holocene - 11.7 - 8.326ky",
                                     "Younger Dryas Stadial - 12.9 - 11.7ky",
                                     "Bølling-Allerød - 14.7 - 12.9ky",
                                     "Heirich Stadial 1 - 17.0 - 14.7ky",
                                     "Last Glacial Maximum - 130ky"),
                   baseGroups = c("Train Data - Presence",
                                  "Test Data Presence/Absence",
                                  'Raw Data Presence/Absence',
                                  'None'),
                   options = layersControlOptions(collapsed = T)) %>%
  htmlwidgets::onRender("
        function() {
            $('.leaflet-control-layers-overlays').prepend('<label style=\"text-align:center\">Charinus Suitable Area</label>');
            $('.leaflet-control-layers-base').prepend('<label style=\"text-align:center\">Charinus Occurrences</label>');
        }
    ")
  
map
