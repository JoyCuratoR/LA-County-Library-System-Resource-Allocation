library(tidyverse)
library(janitor)
library(readxl)

# transforming excel file to csv
read <- read_excel("data/CirculationFY20-21.xlsx")

write.csv(read, "data/Circulation.csv")

# loading in data for merging
circulation <- read_csv("data/Circulation.csv")
AllData <- read_csv("data/All-DataFY20-21.csv")

# checking for duplicates
duplicated(circulation)|>
  sum(duplicated(circulation))

# joining
circ_merged <- circulation |>
  left_join(select(AllData, Location, `1.35 County`), by = "Location")

# subsetting
circ_merged <- circ_merged |>
  filter(`1.35 County` == "Los Angeles")

circ_merged <- clean_names(circ_merged)
colnames(circ_merged)[20] <- "county"

# exporting for sql 
write.csv(circ_merged, "data/LA_circulation.csv")
