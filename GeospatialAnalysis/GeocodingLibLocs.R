library(tidyverse)
library(janitor)

# STEP 1: reading in library locations
file <- read_csv("D:/R_Studio/Project_Vault/OP_Library/data/All-DataFY20-21.csv") 
dim(file) # counts the number of rows, columns in df

# checking for duplicates
duplicated(file)
sum(duplicated(file))

# checking for Sacramento libraries in the df 
file |> 
  select(`1.35 County`) |>
  filter(`1.35 County` == "Sacramento")

file |> 
  select(`1.35 County`) |>
  filter(`1.35 County` == "Los Angeles") |>
  count()

# subsetting the dataframe for only Los Angeles Library Locations
file <- file |> 
  filter(`1.35 County` == "Los Angeles")

# cleaning column names and writing it out as a cleaned csv
file <- clean_names(file)

cleaned <- as.data.frame(file)
write.csv(cleaned, 'AllData.csv')

## STEP 2: geocoding library locations and writing geojson for salesforce layer

# PART 1: Converting zipcodes to coordinates
library(tidygeocoder)

# test the service
test <- geo("125 W. Vine St. Redlands, CA",
            lat = latitude, long = longitude, method = 'cascade')
test

# preparing input parameters for multi-geocoding
str(file)
file$fullAdd <- paste(as.character(file$`1.10 Street Address`), 
                                  as.character(file$`1.11 City`),
                                  as.character(file$`1.12 Zip`))
# turn all to character type to avoid issues with factors
head(file)

# batch geocoding
geoCoded <- file |>
  geocode(address = 'fullAdd', lat = latitude, long = longitude, method = 'cascade')

geoCoded$longitude

# PART 2: convert to spatial data
# first omit NAs so you can make an sf object
gcCleaned <- geoCoded[!is.na(geoCoded$latitude) & !is.na(geoCoded$longitude), ]

library(sf)
librarySf <- st_as_sf(gcCleaned, coords = c("longitude", "latitude"),
                        crs = 4326)

head(data.frame(librarySf))

st_write(librarySf, "data/libraryLocs.shp")

# PART 3: write to GeoJSON file
st_write(librarySf, "data/library.geojson")

## STEP 3: Mapping
library(tmap)
library(mapview)

tmap_mode("view") # switch to viewing mode

tm_shape(librarySf) +
  tm_dots() +
  tm_basemap("OpenStreetMap")

mapview(librarySf$geometry)

mapview(librarySf, xcol = "longitude", ycol = "latitude",
        crs = 4326, grid = F)


# STEP 4: repeating steps 1-3 for bus stop locations
# PART 1: read in the shapefile and convert it to sf object

# Read in the rail stops shapefile
bus_stops_sf <- st_read("data/LA_PubTransport/LA_Bus_Stop_Benches/Bus_Stop_Benches.shp") %>% 
  st_as_sf(coords = c("longitude", "latitude"),
           crs = 4326)

# Read in the bus stops shapefile
dash_community_stops_sf <- st_read("data/LA_PubTransport/LA_Community_DASH_Stops/Community_DASH_Stops.shp") %>% 
  st_as_sf(coords = c("longitude", "latitude"),
           crs = 4326)

#Read in the dash downtown stops shapefile
dash_downtown_stops_sf <- st_read("data/LA_PubTransport/LA_Downtown_DASH_Stops/Downtown_DASH_Stops.shp") %>% 
  st_as_sf(coords = c("longitude", "latitude"),
           crs = 4326)

# Read in the dash community stops shapefile
rail_stops_sf <- st_read("data/LA_PubTransport/LA_Metro_Rail_Lines_Stops/Metro_Rail_Lines_Stops.shp") %>% 
  st_as_sf(coords = c("longitude", "latitude"),
           crs = 4326)

head(data.frame(rail_stops_sf))

# writing out as shape files
st_write(bus_stops_sf, "data/busStops.shp")
st_write(dash_community_stops_sf, "data/communityStops.shp")
st_write(dash_downtown_stops_sf, "data/downtownStops.shp")
st_write(rail_stops_sf, "data/railStops.shp")

# PART 2: mapping the second layer
tmap_mode("view") # switch to viewing mode

# combine the layers
tm_shape(rail_stops_sf) + tm_dots(col = "green", title = "Rail stops") +
  tm_shape(bus_stops_sf) + tm_dots(col = "green", title = "Bus stops")+
  tm_shape(dash_downtown_stops_sf) + tm_dots(col = "green", title = "Dash downtown stops")+
  tm_shape(dash_community_stops_sf) + tm_dots(col = "green", title = "Dash community stops")+
  tm_shape(librarySf) + tm_dots(col = "gold", title = "Library Locations") +
  tm_facets()+
  tm_basemap("OpenStreetMap")


sf_objects <- list(librarySf, rail_stops_sf, bus_stops_sf, dash_community_stops_sf, 
                   dash_downtown_stops_sf)
mapview(sf_objects, xcol = "longitude", ycol = "latitude", crs = 4326, grid = F)
