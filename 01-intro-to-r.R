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