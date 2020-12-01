#' Creating objects in R
3 + 5
12 / 7

# assign values to objects
weight_kg <- 55

#' key for "<-"
#' win, linux: Alt + -
#' mac: Option + -

#' naming conventions
#' - be explicit and not too long
#' - cannot start with a number (2x is not valid, but x2 is)
#' - case sensitive (weight_kg != Weight_kg)
#' - do not use reserved names (e.g., if, else, for ...). 
#' - do not use other function names
#' - avoid dots (.)
#' - use nouns for object names
#' - use verbs for function names
#' - be consistent in the styling of your code

# doesn't print anything
weight_kg <- 55
# but putting parenthesis around the call prints the value of `weight_kg`
(weight_kg <- 55)
# and so does typing the name of the object
weight_kg

# convert weight into pounds
2.2 * weight_kg

# change an object's value by assigning it a new one
weight_kg <- 57.5
2.2 * weight_kg

# assigning a value to one object does not change the values of other objects
weight_lb <- 2.2 * weight_kg
weight_kg <- 100

# What do you think is the current content of the object weight_lb? 126.5 or 220?

# Saving your code
# create new script: Ctrl + Shift + N
# save your work: Ctrl + S

# Comments
# Ctrl + Shift + C

# Challenge: What are the values after each statement in the following?
mass <- 47.5            # mass?
age  <- 122             # age?
mass <- mass * 2.0      # mass?
age  <- age - 20        # age?
mass_index <- mass/age  # mass_index?

# Functions and their arguments
weight_kg <- sqrt(10)
weight_kg

round(3.14159)

# get the arguments of a function
args(round)

# get help
?round

# explicit parameters
round(3.14159, digits = 2)

# parameters in fixed order
round(3.14159, 2)

# explicit parameters in mixed order
round(digits = 2, x = 3.14159)

# Vectors and data types

weight_g <- c(50, 60, 65, 82)
weight_g

# vector can also contain characters:
animals <- c("mouse", "rat", "dog")
animals

# get the size
length(weight_g)
length(animals)

# what kind of objects are the elements?
class(weight_g)
class(animals)

# structure of an object and its elements
str(weight_g)
str(animals)

# add other elements
weight_g <- c(weight_g, 90) # add to the end of the vector
weight_g <- c(30, weight_g) # add to the beginning of the vector
weight_g

#' atomic vector is the simplest R data type
#' "character"
#' "numeric" (or "double")
#' "logical" for TRUE and FALSE (the boolean data type)
#' "integer" for integer numbers (e.g., 2L, the L indicates to R that it's an integer)
#' "complex" to represent complex numbers with real and imaginary parts (e.g., 1 + 4i)
#' "raw" for bitstreams
#' 
#' check with typeof()
typeof(weight_g)
typeof(animals)

#' complex data types (data structures):
#' lists (list)
#' matrices (matrix)
#' data frames (data.frame)
#' factors (factor)
#' arrays (array)

#' Challenge
#' 
#' 1. We’ve seen that atomic vectors can be of type character, numeric
#'    (or double), integer, and logical. But what happens if we try to mix
#'    these types in a single vector?
#'    
#' 2. What will happen in each of these examples? (hint: use class() to check the
#'    data type of your objects):
num_char <- c(1, 2, 3, "a")
num_logical <- c(1, 2, 3, TRUE)
char_logical <- c("a", "b", "c", TRUE)
tricky <- c(1, 2, 3, "4")
#'    Why do you think it happens?
#'    
#' 3. How many values in combined_logical are "TRUE" (as a character) in the
#'    following example (reusing the 2 ..._logicals from above):
combined_logical <- c(num_logical, char_logical)

#' 4. You've probably noticed that objects of different types get converted 
#'    into a single, shared type within a vector. In R, we call converting 
#'    objects from one class into another class *coercion*. These conversions 
#'    happen according to a hierarchy, whereby some types get preferentially 
#'    coerced into other types. Can you draw a diagram that represents the 
#'    hierarchy of how these data types are coerced?

#' Subsetting vectors
animals <- c("mouse", "rat", "dog", "cat")
animals[2]

#' select more
animals[c(3, 2)]

#' with repetitions
more_animals <- animals[c(1, 2, 3, 2, 1, 4)]
more_animals

#' Conditional subsetting
weight_g <- c(21, 34, 39, 54, 55)
weight_g[c(TRUE, FALSE, FALSE, TRUE, TRUE)]

# select only the values above 50
# 1. return logicals with TRUE for the indices that meet 
#    the condition
weight_g > 50

# 2. select only the values above 50
weight_g[weight_g > 50]

#' combine multiple tests 
#' & (both conditions are true, AND) or 
#' | (at least one of the conditions is true, OR):
weight_g[weight_g > 30 & weight_g < 50]
weight_g[weight_g <= 30 | weight_g == 55]

# nonsense condition
weight_g[weight_g >= 30 & weight_g == 21]

#' operators
#' 
#' > for "greater than",
#' < stands for "less than",
#' <= for "less than or equal to",
#' >= for "greater than or equal to",
#' == for "equal to"

#' %in% test if any of the elements of a search vector
#' are found:
animals <- c("mouse", "rat", "dog", "cat", "cat")

# return both rat and cat
animals[animals == "cat" | animals == "rat"] 

# get logical vector
animals %in% c("rat", "cat", "dog", "duck", "goat")

# get the values
animals[animals %in% c("rat", "cat", "dog", "duck", "goat")]

#' Challenge (optional)
#' Can you figure out why "four" > "five" returns TRUE?

#' Missing data
#' Missing data are represented in vectors as NA
#' na.rm = TRUE
heights <- c(2, 4, 4, NA, 6)
mean(heights)
max(heights)
mean(heights, na.rm = TRUE)
max(heights, na.rm = TRUE)

# is.na(), na.omit(), and complete.cases()

## Extract those elements which are not missing values.
heights[!is.na(heights)]

# Returns the object with incomplete cases removed. 
# The returned object is an atomic vector of type `"numeric"`
# (or #`"double"`).
o <- na.omit(heights)
o
str(o)
class(o)
typeof(o)
attributes(o)
attr(o, "na.action")
attr(attr(o, "na.action"), "class")
attributes(o) <- NULL
o

## Extract those elements which are complete cases. 
#The returned object is an atomic vector of type `"numeric"` (or #`"double"`).
heights[complete.cases(heights)]

#' Challenge

#' 1. Using this vector of heights in inches, create a new vector, 
#'    heights_no_na, with the NAs removed.
heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65,
             64, 70, 63, 65)

#' 2. Use the function median() to calculate the median of the heights vector.
#' 
#' 3. Use R to figure out how many people in the set are taller than 67 inches.
heights_no_na <- heights[!is.na(heights)]
large_people <- heights_no_na[heights_no_na > 67]
length(large_people)
