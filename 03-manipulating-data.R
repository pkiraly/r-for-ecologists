#' Manipulating, analyzing and exporting data with tidyverse
#' https://datacarpentry.org/R-ecology-lesson/03-dplyr.html

library(tidyverse)

#' dplyr
#' - the most common data manipulation tasks
#' - https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-transformation.pdf
#' tidyr
#' - reshape your data
#' - https://raw.githubusercontent.com/rstudio/cheatsheets/main/data-import.pdf

surveys <- read_csv("data_raw/portal_data_joined.csv")

## inspect the data
str(surveys)

## preview the data
view(surveys)

#' dplyr functions:
#' - select(): subset columns
#' - filter(): subset rows on conditions
#' - mutate(): create new columns by using information from other columns
#' - group_by() and summarize(): create summary statistics on grouped data
#' - arrange(): sort results
#' - count(): count discrete values

#' Selecting columns and filtering rows
#' select()
#' first argument: the data frame (surveys),
#' the subsequent arguments: the columns to keep
select(surveys, plot_id, species_id, weight)

# select all columns except certain ones: "-"
select(surveys, -record_id, -species_id)

# choose rows based on a specific criterion, use filter():
filter(surveys, year == 1995)

#' Pipes
#' temporary data frames
surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

# nesting
surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)

# Pipe!
# %>% via the magrittr package
# Ctrl + Shift + M
surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

# save to new object
surveys_sml <- surveys %>%
  filter(weight < 5) %>%
  select(species_id, sex, weight)

surveys_sml

#' Challenge
#' 1. Using pipes, subset the surveys data to include animals collected
#'    before 1995 and retain only the columns year, sex, and weight.

#' Mutate
#' create new columns
surveys %>%
  mutate(weight_kg = weight / 1000)

# reuse
surveys %>%
  mutate(weight_kg = weight / 1000,
         weight_lb = weight_kg * 2.2)

# add more pipes
surveys %>%
  mutate(weight_kg = weight / 1000) %>%
  head()

# even more
surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight / 1000) %>%
  head()

#' Challenge
#' 1. Create a new data frame from the surveys data that meets the following
#'    criteria: contains only the species_id column and a new column called
#'    hindfoot_cm containing the hindfoot_length values converted to centimeters.
#'    In this hindfoot_cm column, there are no NAs and all values are less than 3.
#'    Hint: think about how the commands should be ordered to produce this 
#'    data frame!

#' Split-apply-combine data analysis and the summarize() function
#' 1. split the data into groups, 
#' 2. apply some analysis to each group,
#' 3. combine the results

surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE))

# group by multiple columns
surveys %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE)) %>% 
  tail()

# combine with filter
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight))

# print(n = )
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight)) %>%
  print(n = 15)

# summarize multiple variables
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight))

# rearrange (sort) the result
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(min_weight)

# descending order
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            min_weight = min(weight)) %>%
  arrange(desc(mean_weight))

# Counting
surveys %>%
  count(sex) 

# equivalent of
surveys %>%
  group_by(sex) %>%
  summarise(count = n())

# with sort
surveys %>%
  count(sex, sort = TRUE) 

# count combination of factors
surveys %>%
  count(sex, species) 

# sort
surveys %>%
  count(sex, species) %>%
  arrange(species, desc(n))

#' Challenge
#' 
#' 1. How many animals were caught in each plot_type surveyed?
#' 
#' 2. Use group_by() and summarize() to find the mean, min, and max hindfoot
#'    length for each species (using species_id). Also add the number of
#'    observations (hint: see ?n).
#'    
#' 3. What was the heaviest animal measured in each year? Return the columns
#'    year, genus, species_id, and weight.

#' Reshaping with pivot_longer and pivot_wider
#' tidy dataset:
#' - Each variable has its own column
#' - Each observation has its own row
#' - Each value must have its own cell
#' - Each type of observational unit forms a table

#' Pivoting from long to wide format
#' pivot_wider() takes three principal arguments:
#' - the data
#' - the key column variable whose *values* will become new *column names*
#' - the value column variable whose *values* will fill the new *column variables*

surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))

str(surveys_gw)
surveys_gw

# and now pivot_wider()
surveys_wide <- surveys_gw %>%
  pivot_wider(key = genus, value = mean_weight)

str(surveys_wide)
surveys_wide

# fill in the missing values
surveys_gw %>%
  pivot_wider(genus, mean_weight, fill = 0) %>%
  head()

#' Pivoting from wide to long format
#' pivot_longer() takes four principal arguments:
#' - the data
#' - the key column variable we wish to create from column names.
#' - the values column variable we wish to create and fill with values
#'   associated with the key.
#' - the names of the columns we use to fill the key variable (or to drop).

surveys_long <- surveys_wide %>%
  pivot_longer(key = "genus", value = "mean_weight", -plot_id)

str(surveys_long)

# specify columns
surveys_wide %>%
  pivot_longer(key = "genus", value = "mean_weight", Baiomys:Spermophilus) %>%
  head()

#' Challenge
#' 
#' 1. Spread the surveys data frame with year as columns, plot_id as rows,
#'    and the number of genera per plot as the values. You will need to
#'    summarize before reshaping, and use the function n_distinct() to get
#'    the number of unique genera within a particular chunk of data. It's
#'    a powerful function! See ?n_distinct for more.
#'
#' 2. Now take that data frame and pivot_longer() it again, so each row is a unique
#'    plot_id by year combination.
#'
#' 3. The surveys data set has two measurement columns: hindfoot_length and
#'    weight. This makes it difficult to do things like look at the relationship
#'    between mean values of each measurement per year in different plot types.
#'    Let's walk through a common solution for this type of problem. First, use
#'    pivot_longer() to create a dataset where we have a key column called measurement
#'    and a value column that takes on the value of either hindfoot_length or
#'    weight. Hint: You'll need to specify which columns are being gathered.
#'
#' 4. With this new data set, calculate the average of each measurement in each
#'    year for each different plot_type. Then pivot_wider() them into a data set with
#'    a column for hindfoot_length and weight. Hint: You only need to specify
#'    the key and value columns for pivot_wider().

#' Exporting data
#' write_csv()
surveys_complete <- surveys %>%
  filter(!is.na(weight),           # remove missing weight
         !is.na(hindfoot_length),  # remove missing hindfoot_length
         !is.na(sex))              # remove missing sex

surveys_complete

## Extract the most common species_id
species_counts <- surveys_complete %>%
  count(species_id) %>% 
  filter(n >= 50)

species_counts

## Only keep the most common species
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)

surveys_complete

# save data
write_csv(surveys_complete, file = "data/surveys_complete.csv")
