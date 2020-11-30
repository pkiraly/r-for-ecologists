#' Starting with data
#' https://datacarpentry.org/R-ecology-lesson/02-starting-with-data.html
#' 
#' Loading the survey data
download.file(
  url = "https://ndownloader.figshare.com/files/2292169",
  destfile = "data_raw/portal_data_joined.csv"
)

#' Reading the data into R

## load the tidyverse packages, incl. dplyr
library(tidyverse)

# read CSV
surveys <- read_csv("data_raw/portal_data_joined.csv")

# read the top n records (n = 6 by default)
head(surveys)

# get a sample to test computation intensive things
surveys_sample <- head(surveys, 100)

# read the last n rows
tail(surveys)

# view in a speadsheet-like interface
view(surveys)

# alternative read functions
read_csv2()  # different parameters for the decimal and the field separators
read_tsv()   # for tab separated data
read_delim() # for less common formats
?read_csv

#' What are data frames?
#' - special data type data.frame
#' - tibble is an extension (see https://tibble.tidyverse.org/)
#' - de facto data structure for most tabular data
#' - columns are vectors that all have the same length

str(surveys)

#' Inspecting data frames

# Size
#' a vector with the number of rows in the first element, and 
#' the number of columns as the second element (the dimensions of the object)
dim(surveys)
# the number of rows
nrow(surveys)
# the number of columns
ncol(surveys)

# Content:
# shows the first 6 rows
head(surveys)
# shows the last 6 rows
tail(surveys)

# Names:
# the column names (synonym of colnames() for data.frame objects)
names(surveys)
# the row names
rownames(surveys)

# Summary:
# structure of the object and information about the class, length and 
# content of each column
str(surveys)
# summary statistics for each column
summary(surveys)

#' Challenge
#' Based on the output of str(surveys), can you answer the following questions?
#' 1. What is the class of the object surveys?
#' 2. How many rows and how many columns are in this object?

#' Indexing and subsetting data frames
#' Row numbers first, followed by column numbers

# first element in the first column of the data frame (as a vector)
surveys[1, 1]
# first element in the 6th column (as a vector)
surveys[1, 6]
# first column of the data frame (as a vector)
surveys[, 1]
# first column of the data frame (as a data.frame)
surveys[1]
# first three rows of the 6th column (as a vector)
surveys[1:3, 6]
# the 3rd row of the data frame (as a data.frame)
surveys[3, ]
# equivalent to head_surveys <- head(surveys)
head_surveys <- surveys[1:6, ]

#' : is a special function that creates numeric vectors of integers in 
#' increasing or decreasing order
1:10
10:1

# The whole data frame, except the first column
surveys[, -1]

# Equivalent to head(surveys)
surveys[-(7:34786), ]

# subset with column names
surveys["species_id"]       # Result is a data.frame
surveys[, "species_id"]     # Result is a vector
surveys[["species_id"]]     # Result is a vector
surveys$species_id          # Result is a vector

#' Challenge
#' 
#' 1. Create a data.frame (surveys_200) containing only the data in row 200
#'    of the surveys dataset.
#'    
#' 2. Notice how nrow() gave you the number of rows in a data.frame?
#'    - Use that number to pull out just that last row in the data frame.
#'    - Compare that with what you see as the last row using tail() to make
#'      sure it's meeting expectations.
#'    - Pull out that last row using nrow() instead of the row number.
#'    - Create a new data frame (surveys_last) from that last row.
#'    
#' 3. Use nrow() to extract the row that is in the middle of the data frame.
#'    Store the content of this row in an object named surveys_middle.
#'    
#' 4. Combine nrow() with the - notation above to reproduce the behavior of
#'    head(surveys), keeping just the first through 6th rows of the surveys
#'    dataset.

#' Factors
#' - columns genus, species, sex, plot_type, ... are of the class character.
#' - these columns contain categorical data, that is, they can only take on
#'   a limited number of values
#' - factor: special class for working with categorical data
#' - can only contain a pre-defined set of values, known as levels
#' - stored as integers associated with labels
#' - ordered or unordered

# factor() function - convert a character vector to factors
summary(surveys$sex)
surveys$sex <- factor(surveys$sex)
summary(surveys$sex)

sex <- factor(c("male", "female", "female", "male"))
# 1 to the level "female" and 2 to the level "male"
# list of levels
levels(sex)
# the number of levels
nlevels(sex)
sex

# reoder
sex <- factor(sex, levels = c("male", "female"))
sex

#' Challenge
#' 
#' 1. Change the columns taxa and genus in the surveys data frame into a factor.
#' 
#' 2. Using the functions you learned before, can you find out...
#'    - How many rabbits were observed?
#'    - How many different genera are in the genus column?

#' Converting factors
as.character(sex)

as.numeric(sex)

year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)               # Wrong! And there is no warning...
as.numeric(as.character(year_fct)) # Works...
as.numeric(levels(year_fct))[year_fct]    # The recommended way.
# explanation:
# obtain all the factor levels
levels(year_fct)
# convert these levels to numeric values
as.numeric(levels(year_fct))
# access these numeric values using the underlying integers of the vector 
# year_fct inside the square brackets
as.numeric(levels(year_fct))[year_fct]

# Renaming factors
## bar plot of the number of females and males captured during the experiment:
plot(surveys$sex)

# turn the missing values into a factor level with the addNA() function
sex <- surveys$sex
levels(sex)

sex <- addNA(sex)
levels(sex)

head(sex)
# rename the 3rd factor
levels(sex)[3] <- "undetermined"
levels(sex)
head(sex)

# plot again
plot(sex)

#' Challenge
#' 
#' 1. Rename "F" and "M" to "female" and "male" respectively.
#' 
#' 2. Now that we have renamed the factor level to "undetermined", can you
#'    recreate the barplot such that "undetermined" is first (before "female")?

#' Challenge
#' 1. We have seen how data frames are created when using read_csv(), but they
#'    can also be created by hand with the data.frame() function. There are a
#'    few mistakes in this hand-crafted data.frame. Can you spot and fix them?
#'    Don't hesitate to experiment!

animal_data <- data.frame(
  animal = c(dog, cat, sea cucumber, sea urchin),
  feel = c("furry", "squishy", "spiny"),
  weight = c(45, 8 1.1, 0.8)
)

#' 2. Can you predict the class for each of the columns in the following example?
#'    Check your guesses using str(country_climate):
#'    - Are they what you expected? Why? Why not?
#'    - What would you need to change to ensure that each column had the
#'      accurate data type?

country_climate <- data.frame(
    country = c("Canada", "Panama", "South Africa", "Australia"),
    climate = c("cold", "hot", "temperate", "hot/temperate"),
    temperature = c(10, 30, 18, "15"),
    northern_hemisphere = c(TRUE, TRUE, FALSE, "FALSE"),
    has_kangaroo = c(FALSE, FALSE, FALSE, 1)
  )

#' Formatting dates
str(surveys)

library(lubridate)

# created date with ymd()
my_date <- ymd("2015-01-01")
str(my_date)

# sep indicates the character to use to separate each component
my_date <- ymd(paste("2015", "1", "1", sep = "-"))
str(my_date)

# concatenate column values
paste(surveys$year, surveys$month, surveys$day, sep = "-")

# add ymd()
ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))

# save to a new column
surveys$date <- ymd(paste(surveys$year, surveys$month, surveys$day, sep = "-"))
str(surveys)
summary(surveys$date)

# get the missing dates
missing_dates <- surveys[is.na(surveys$date), c("year", "month", "day")]
head(missing_dates)
