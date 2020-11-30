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
