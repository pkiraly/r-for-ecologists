#' R
#' - the programming language
#' - the software that interprets the scripts written in that language
#' 
#' RStudio
#' - to write your R scripts
#' - to interact with the R software
#' 
#' Why learn R?
#' - learning curve might be steeper
#' - do not rely on remembering a succession of pointing and clicking,
#'   but instead on a series of written commands
#' - the code can be inspected by someone else (for feedback or reproducibility)
#' 
#' Reproducibility
#' - someone else (including your future self) can obtain the same results 
#'   from the same dataset when using the same analysis.
#' - requirement of journals and funding agencies
#' 
#' interdisciplinary and extensible
#' - 10,000+ packages
#' - many scientific disciplines
#' 
#' data of all shapes and sizes
#' - scalable data size
#' - handling of missing data and statistical factors
#' - connect to spreadsheets, databases, other data formats
#' 
#' and
#' - high-quality graphics
#' - community
#' - free, open-source and cross-platform
#' 
#' 4 "Panes"
#' - Source for your scripts and documents (top-left),
#' - Environment/History (top-right) 
#'   - shows all the objects in your working space (Environment)
#'   - command history (History)
#' - Files/Plots/Packages/Help/Viewer (bottom-right)
#' - R Console (bottom-left) 
#' - shortcuts, autocompletion, and highlighting

#' Getting set up
#' 1. File > New Project > Choose New Directory > New Project
#' 2. Enter a name for this new folder, choose a location. 
#'    (this will be the "working directory" e.g., ~/data-carpentry.
#' 3. Create Project
#' 4. Download code: https://datacarpentry.org/R-ecology-lesson/code-handout.R
#'    place it in working directory and rename it (e.g., data-carpentry-script.R)
url <- 'https://datacarpentry.org/R-ecology-lesson/code-handout.R'
destfile <- 'data-carpentry-script.R'
download.file(url, destfile)
#' 5. (Optional) Set Preferences to 'Never' save workspace in RStudio.

#' File strutcure

#' raw data
dir.create('data_raw')

#' intermediate datasets
dir.create('data')

#' outlines, drafts, and other text.
dir.create('documents')

#' your R scripts for different analyses
dir.create('scripts')

#' the figures that we will create
dir.create('fig')

#' Working directory
getwd()
wd <- getwd()
wd
setwd(wd)
#' or File pane > navigate to a dir > "More" > "Set As Working Directory"

#' Executing command
#'  Ctrl + Enter
#'  or "->Run" on the top right corner of this pane

