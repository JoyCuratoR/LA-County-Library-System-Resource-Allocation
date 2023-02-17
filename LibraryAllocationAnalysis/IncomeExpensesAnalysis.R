library(tidyverse)
library(janitor)
library(readxl)

# reading in excel files and transforming into csv
read <- read_excel("data/LibraryExpendituresFY20-21.xlsx")
read2 <- read_excel("data/LibraryIncomeFY20-21.xlsx")

write.csv(read, "data/LibraryExpenses.csv")
write.csv(read2, "data/LibraryIncome.csv")

# loading all needed csv files
expense <- read_csv("data/LibraryExpenses.csv")
income <- read_csv("data/LibraryIncome.csv")
AllData <- read_csv("data/AllData.csv")

# cleaning both datasets
expense <- clean_names(expense)
income <- clean_names(income)

# merging
Expense_merged <- expense |>
  left_join(select(AllData, location, county), by = "location")

Income_merged <- income |>
  left_join(select(AllData, location, county), by = "location")

# filtering for only LA
Expense_merged <- Expense_merged |>
  filter(county == "Los Angeles")

Income_merged <- Income_merged |>
  filter(county == "Los Angeles")


write.csv(Expense_merged, "data/LA_Expenses.csv")
write.csv(Income_merged, "data/LA_Income.csv")

# cleaning the visits file
visits <- read_excel("data/VisitsFY20-21.xlsx")

visits <- clean_names(visits)

visits <- visits |>
  filter(county == "Los Angeles")

visits$library_visits <- ifelse(visits$library_visits == -1, NA, 
                                visits$library_visits)

visits$hours_open_all <- c(782,	3612,	188,	344,	560,	1634,	456,	0,	78,	94,
                           175,	383,	4802,	1318,	684,	216, 403,	27280,	4092,
                           22142,	2459,	168,	670,	6266,	3054,	1102,	748,	1767,
                           3000,	114,	427,	0,	204,	3168,	517)

write.csv(visits, "data/LA_Visits.csv")
