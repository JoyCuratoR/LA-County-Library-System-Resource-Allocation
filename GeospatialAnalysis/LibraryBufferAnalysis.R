library(sf)
library(tidyverse)
library(tidygeocoder)
library(tmap)
library(mapview)


# STEP 1: read in data
libraryLocs <- st_read("data/libraryLocs.shp")
busLocs <- st_read("data/LA_PubTransport/LA_Bus_Stop_Benches/Bus_Stop_Benches.shp")
communityLocs <- st_read("data/LA_PubTransport/LA_Community_DASH_Stops/Community_DASH_Stops.shp")
downtownLocs <- st_read("data/LA_PubTransport/LA_Downtown_DASH_Stops/Downtown_DASH_Stops.shp")
railLocs <- st_read("data/LA_PubTransport/LA_Metro_Rail_Lines_Stops/Metro_Rail_Lines_Stops.shp")

cityBoundary <- st_read("data/LosAngelesCountyBound.geojson")
# check if false
st_is_valid(cityBoundary)
# fixing false
cityBoundary <- st_make_valid(cityBoundary)

zips <- st_read("data/LA_ZipCodes/Zip_Codes_(LA_County).shp")
# checking for a false
st_is_valid(zips)
# fixing the false
zips <- st_make_valid(zips)


# STEP 2: create overlay map
tmap_mode("plot") # view data in static format

tm_shape(zips) + tm_borders(alpha = 0.4) + # 1st layer
  tm_shape(libraryLocs) + tm_dots(col = "gold") + # 2nd layer
  tm_shape(busLocs) + tm_dots(col = "darkgreen")

# there's something wrong with it

# STEP 3: transform crs with a crs that preserves distance

# PART 1: checking crs
# metadata has to be the same for both points and areas
st_crs(libraryLocs)
st_crs(busLocs)
st_crs(communityLocs)
st_crs(downtownLocs)
st_crs(railLocs)
st_crs(zips)
# result: they aren't encoded the same way 

# PART 2: transforming so crs matches
CRS.new <- st_crs("EPSG: 3435")

libraryLocs.3435 <- st_transform(libraryLocs, CRS.new)
busLocs.3435 <- st_transform(busLocs, CRS.new)
downtownLocs.3435 <- st_transform(downtownLocs, CRS.new)
communityLocs.3435 <- st_transform(communityLocs, CRS.new)
railLocs.3435 <- st_transform(railLocs, CRS.new)
zips.3435 <- st_transform(zips, CRS.new)

head(libraryLocs.3435)
head(zips.3435)
# both crs are the same

# STEP 4: adding buffers to the library locations and visualizing
libraryLoc_Buffer <- st_buffer(libraryLocs.3435, 5280)

unionBuffers <- st_union(libraryLoc_Buffer)

# interactive map
tm_shape(unionBuffers) + tm_fill(col = "purple", alpha = .2) + tm_borders(col = "purple") +
  tm_shape(libraryLocs.3435) + tm_dots(col = "gold") +
    tm_shape(busLocs.3435) + tm_dots(col = "gray") +
    tm_shape(communityLocs.3435) + tm_dots(col = "gray") +
    tm_shape(downtownLocs.3435) + tm_dots(col = "gray") +
    tm_shape(railLocs.3435) + tm_dots(col = "gray")


