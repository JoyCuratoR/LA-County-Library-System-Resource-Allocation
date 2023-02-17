# guide: https://geodacenter.github.io/opioid-environment-toolkit/centroid-access-tutorial.html

# calculating distance between library and bus stops

library(sf)
library(tmap)
library(units)

# load in data
libraryLocs <- st_read("data/libraryLocs.shp")
busLocs <- st_read("data/LA_PubTransport/LA_Bus_Stop_Benches/Bus_Stop_Benches.shp")
communityLocs <- st_read("data/LA_PubTransport/LA_Community_DASH_Stops/Community_DASH_Stops.shp")
downtownLocs <- st_read("data/LA_PubTransport/LA_Downtown_DASH_Stops/Downtown_DASH_Stops.shp")
railLocs <- st_read("data/LA_PubTransport/LA_Metro_Rail_Lines_Stops/Metro_Rail_Lines_Stops.shp")
zips <- st_read("data/LA_ZipCodes/Zip_Codes_(LA_County).shp")

# STEP 2: calculating centroids of each zip code 

# PART 1: transforming projection
laZips <- st_transform(zips, 3435)

laZips

# PART 2: centroids
laCentroids <- st_centroid(laZips)

# STEP 3: visualize and confirm
tm_shape(laZips) +
  tm_borders() +
  tm_shape(laCentroids) +
  tm_dots()

# STEP 4: standardize crs
newCRS <- st_crs(laCentroids)
newCRS

libLocs <- st_transform(libraryLocs, newCRS)

# STEP 5: calculate distance
nearestLibrary_indexes <- st_nearest_feature(laCentroids, libLocs)

nearestLibrary <- libLocs[nearestLibrary_indexes,]

minDist <- st_distance(laCentroids, nearestLibrary, by_element = TRUE)

minDist_mi <- set_units(minDist, "mi")

# STEP 6: merging data
minDistSf <- cbind(laZips, minDist_mi)

tmap_mode("view")

tm_shape(minDistSf) +
  tm_polygons("minDist_mi", style = 'quantile', n = 5,
              title = "Minimum Distance (mi)") +
  tm_shape(libLocs) +
  tm_dots() +
  tm_layout(main.title = "Minimum Distance from Zip Centroid\n to Library",
            main.title.position = "center",
            frame = FALSE,
            main.title.size = 1) +
  tmap_options(check.and.fix = TRUE)
