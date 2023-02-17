library(tidyverse)
library(janitor)
library(readxl)
library(tidygeocoder)


# STEP 1: cleaning orginal csv from all numbers in columns

# PART 1: transform files to csv
ProgramsFY20_21 <- read_excel("data/ProgramsFY20-21.xlsx")
ProgramAttendanceFY20_21 <- read_excel("data/ProgramAttendanceFY20-21.xlsx")

write.csv(ProgramAttendanceFY20_21, "data/ProgramAttendence.csv")
write.csv(ProgramsFY20_21,"data/Programs.csv")

# PART 2: loading in csv files
ProgramAttendence <- read_csv("data/ProgramAttendence.csv")
Programs <- read_csv("data/Programs.csv")
AllData <- read_csv("data/All-DataFY20-21.csv")

dim(ProgramAttendence) # counts the number of rows, columns in df
dim(Programs)

# checking for duplicates
duplicated(ProgramAttendence)|>
  sum(duplicated(ProgramAttendence))

duplicated(Programs)|>
  sum(duplicated(Programs))

# PART 3: merge with All Data to get county locations for each library
Pro_merged <- Programs |>
  left_join(select(AllData, Location, `1.35 County`), by = "Location")

Attend_merged <- ProgramAttendence |>
  left_join(select(AllData, Location, `1.35 County`), by = "Location")

# PART 4: subsetting the dataframe for only Los Angeles Library Locations
LA_programs <- Pro_merged |> 
  filter(`1.35 County` == "Los Angeles") 

LA_attend <- Attend_merged |>
  filter(`1.35 County` == "Los Angeles")

# I realize in both subsets there's only 34/35 locations

# Programs
test <- AllData |>
  filter(`1.35 County` == "Los Angeles")

test2 <- Pro_merged |> 
  filter(`1.35 County` == "Los Angeles")

missing <- anti_join(test, test2, by = "Location")

# inglewood library is missing

AllData |>
  select(`1.11 City`) |>
  filter(`1.11 City` == "INGLEWOOD") |>
  count()

Programs |>
  select(Location) |>
  filter(Location == "INGLEWOOD PUBLIC LIBRARY") |>
  count()

ProgramAttendence |>
  select(Location) |>
  filter(Location == "INGLEWOOD PUBLIC LIBRARY") |>
  count()

# the CSVs for Programs and ProgramAttendence don't have Inglewood
#So the subsets I downloaded from Cal Lib is messy and incomplete


# PART 5: cleaning column names and writing it out as a cleaned csv

# use substr to extract the portion of the string starting from the 5th character

# Programs
colnames(LA_programs) <- substr(colnames(LA_programs), 5, nchar(colnames(LA_programs)))

# correcting column names
colnames(LA_programs) <- gsub("#", paste0("Num"), colnames(LA_programs))
colnames(LA_programs) <- gsub("^a", paste0(""), colnames(LA_programs))
colnames(LA_programs) <- gsub("^b", paste0(""), colnames(LA_programs))

colnames(LA_programs)[1] <- "ID"
colnames(LA_programs)[2] <- "location"
colnames(LA_programs)[13] <- "total_num_of_programs"

LA_programs <- clean_names(LA_programs)

# write out as cleaned csv
cleaned <- as.data.frame(LA_programs)
write.csv(cleaned, 'data/LA_programs.csv')

# Attendance
colnames(LA_attend)[1] <- "ID"
colnames(LA_attend)[17] <- "County"

LA_attend <- clean_names(LA_attend)

cleaned2 <- as.data.frame(LA_attend)
write.csv(cleaned2, 'data/LA_attend.csv')
