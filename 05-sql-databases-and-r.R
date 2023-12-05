#' SQL databases and R
#' https://datacarpentry.org/R-ecology-lesson/05-r-and-databases.html

#' Excursion - install only if it is not installed

# 1. install
install.packages("dbplyr", "RSQLite")

# 2. check if it is already installed
installed_packages <- rownames(installed.packages())

if (!"dbplyr" %in% installed_packages) {
  install.packages("dbplyr")
}

if (!"RSQLite" %in% installed_packages) {
  install.packages("RSQLite")
}

# 3. eliminate code repetition
to_install <- c("dbplyr", "RSQLite")
for (package in to_install) {
  if (! package %in% installed_packages) {
    install.packages(package)
  }
}

#' --- Excursion ends here

if (!dir.exists("data_raw")) {
  dir.create("data_raw", showWarnings = FALSE)
}

download.file(
  url = "https://ndownloader.figshare.com/files/2292171",
  destfile = "data_raw/portal_mammals.sqlite", mode = "wb")

#' Connecting to databases
library(dplyr)
library(dbplyr)

# connect to the SQLite
# mammals will be the local name of the DB
mammals <- DBI::dbConnect(RSQLite::SQLite(), "data_raw/portal_mammals.sqlite")

# get info about the connected database
src_dbi(mammals)

#' there are three tables
#' - plots
#' - species
#' - surveys

#' Querying the database with the SQL syntax

# run an SQL query in mammals DB
tbl(mammals, sql("SELECT year, species_id, plot_id FROM surveys"))

#' Querying the database with the dplyr syntax
surveys <- tbl(mammals, "surveys")

# run dplyr function
surveys %>%
  select(year, species_id, plot_id)

# run a data.frame function
head(surveys, n = 10)

# how many rows are there?

nrow(surveys)

#' SQL translation
#' 
#' SQL command to get the first 10 rows from the surveys table:
#' SELECT *
#' FROM `surveys`
#' LIMIT 10
#' 
#' dplyr:
#' - translates R code into SQL
#' - submits it to the database
#' - translates the database's response into an R data frame
#' 
#' R never gets to see the full surveys table!

show_query(head(surveys, n = 10))

#' Simple database queries

surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

#' Laziness
#' 
#' dplyr tries to be as lazy as possible:
#' - It never pulls data into R unless you explicitly ask for it.
#' - It delays doing any work until the last possible moment - it
#'   collects together everything you want to do and then sends it
#'   to the database in one step.

data_subset <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

data_subset %>%
  select(-sex)

#' Only the final result is retrieved and displayed!

#' to stop being lazy: collect()

data_subset <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight) %>%
  collect()

data_subset

#' Complex database queries

plots <- tbl(mammals, "plots")
plots

# check survey data
surveys

#' plot_id is listed in both tables -- connect (join) tables with it
#' - inner_join(): all rows from X where there are matching values
#'                 in Y, and all columns from X and Y.
#' - left_join():  all rows from X, and all columns from X and Y.
#'                 Rows in X with no match in Y will have NA values
#'                 in the new columns.

plots %>%
  filter(plot_id == 1) %>%
  inner_join(surveys) %>%
  collect()

#' #> Joining, by = "plot_id" 
#' R figured out the connecting field

#' Challenge
#' 
#' Write a query that returns the number of rodents observed in each plot
#' in each year.
#' Hint: Connect to the species table and write a query that joins the
#' species and survey tables together to exclude all non-rodents. The query
#' should return counts of rodents by year.

#' tally(): the number of individuals in a group (df %>% summarise(n = n()))
#' n_distinct(): the number of unique values found in a column

#' 
#' Optional: Write a query in SQL that will produce the same result. You can
#' join multiple tables together using the following syntax where foreign
#' key refers to your unique id (e.g., species_id):
#' 
#' SELECT table.col, table.col
#' FROM table1
#' JOIN table2 ON table1.key = table2.key
#' JOIN table3 ON table2.key = table3.key

#' Challenge
#' 
#' Write a query that returns the total number of rodents in each genus
#' caught in the different plot types.
#' 
#' Hint: Write a query that joins the species, plot, and survey tables
#' together. The query should return counts of genus by plot type.


species <- tbl(mammals, "species")
unique_genera <- left_join(surveys, plots) %>%
  left_join(species) %>%
  group_by(plot_type) %>%
  summarize(
    n_genera = n_distinct(genus)
  ) %>%
  collect()
unique_genera

#' Creating a new SQLite database

download.file("https://ndownloader.figshare.com/files/3299483",
              "data_raw/species.csv")
download.file("https://ndownloader.figshare.com/files/10717177",
              "data_raw/surveys.csv")
download.file("https://ndownloader.figshare.com/files/3299474",
              "data_raw/plots.csv")

library(tidyverse)

species <- read_csv("data_raw/species.csv")
surveys <- read_csv("data_raw/surveys.csv")
plots <- read_csv("data_raw/plots.csv")

#' create a database
my_db_file <- "data/portal-database-output.sqlite"
my_db <- src_sqlite(my_db_file, create = TRUE)
my_db

#' add tables, we copy the existing data.frames into the database one by one:
copy_to(my_db, surveys)
copy_to(my_db, plots)
my_db

#' Challenge
#' 
#' Add the remaining species table to the my_db database and run some of
#' your queries from earlier in the lesson to verify that you have faithfully
#' recreated the mammals database.

#' close the connection
#'   discards all pending work and frees resources, e.g. memory
DBI::dbDisconnect(mammals)
