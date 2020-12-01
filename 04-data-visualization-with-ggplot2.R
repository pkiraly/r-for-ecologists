#' Data visualization with ggplot2
#' https://datacarpentry.org/R-ecology-lesson/04-visualization-ggplot2.html

# activate tidyverse
library(tidyverse)

# read the survey
surveys_complete <- read_csv("data/surveys_complete.csv")

#' Plotting with ggplot2
#' - plotting package
#' - like data in the 'long' format
#'   - a column for every dimension
#'   - a row for every observation.
#' - graphics are built step by step by adding new elements (layers)
#' 
#' ggplot(data = <DATA>, mapping = aes(<MAPPINGS>)) +  <GEOM_FUNCTION>()

# add data
ggplot(data = surveys_complete)

# define an aesthetic mapping
ggplot(data = surveys_complete,
       mapping = aes(x = weight,
                     y = hindfoot_length))

#' add 'geoms' – graphical representations of the data in the plot
#'  (points, lines, bars):
#' - geom_point() for scatter plots, dot plots, etc.
#' - geom_boxplot() for, well, boxplots!
#' - geom_line() for trend lines, time series, etc.
#' + operator
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point()

# or
# Assign plot to a variable
surveys_plot <- ggplot(data = surveys_complete, 
                       mapping = aes(x = weight, y = hindfoot_length))

# Draw the plot
surveys_plot + 
  geom_point()

# + should be add at the end of line
# this will not add the new layer and will return an error message
surveys_plot
+ geom_point()

#' Challenge (optional)
#' Scatter plots can be useful exploratory tools for small datasets.
#' For data sets with large numbers of observations, such as the
#' surveys_complete data set, overplotting of points can be a
#' limitation of scatter plots. One strategy for handling such
#' settings is to use hexagonal binning of observations. The plot
#' space is tessellated into hexagons. Each hexagon is assigned a
#' color based on the number of observations that fall within its
#' boundaries. To use hexagonal binning with ggplot2, first install
#' the R package hexbin from CRAN:

install.packages("hexbin")
library(hexbin)

#' Then use the geom_hex() function:

surveys_plot +
  geom_hex()

#' What are the relative strengths and weaknesses of a hexagonal
#' bin plot compared to a scatter plot? Examine the above scatter
#' plot and compare it with the hexagonal bin plot that you created.

#' Building your plots iteratively
#' 
#' start by 
#' - defining the dataset,
#' - lay out the axes,
#' - choose a geom

ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point()

#' add transparency (alpha) to avoid overplotting:
ggplot(data = surveys_complete, aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1)

#' add colors for all the points:
ggplot(data = surveys_complete,
       mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, color = "blue")

#' color each species in the plot differently
ggplot(data = surveys_complete,
       mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, aes(color = species_id))

#' Challenge
#' 
#' Use what you just learned to create a scatter plot of *weight*
#' over *species_id* with the *plot types* showing in different colors.
#' Is this a good way to show this type of data?

#' Boxplot
#' to visualize the distribution of weight within each species:
ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = weight)) +
  geom_boxplot()

#' adding points to the boxplot
ggplot(data = surveys_complete,
       mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "tomato")

#' What do you need to change in the code to put the boxplot
#' in front of the points such that it's not hidden?

#' Challenges
#' Boxplots are useful summaries, but hide the shape of the
#' distribution. For example, if there is a bimodal distribution,
#' it would not be observed with a boxplot. An alternative to the
#' boxplot is the violin plot (sometimes known as a beanplot), where
#' the shape (of the density of points) is drawn.
#' 
#' 1. Replace the box plot with a violin plot; see geom_violin()
#' 
#' In many types of data, it is important to consider the scale of
#' the observations. For example, it may be worth changing the scale
#' of the axis to better distribute the observations in the space of
#' the plot. Changing the scale of the axes is done similarly to
#' adding/modifying other components (i.e., by incrementally adding
#' commands). Try making these modifications:
#' 
#' 2. Represent weight on the log10 scale; see scale_y_log10()
#' 
#' So far, we've looked at the distribution of weight within species.
#' Try making a new plot to explore the distribution of another
#' variable within each species.
#' 
#' 3. Create boxplot for hindfoot_length. Overlay the boxplot layer
#'    on a jitter layer to show actual measurements.
#'    
#' 4. Add color to the data points on your boxplot according to the
#'    plot from which the sample was taken (plot_id).
#'    
#' Hint: Check the class for plot_id. Consider changing the class
#' of plot_id from integer to factor. Why does this change how R
#' makes the graph?

#' Plotting time series data
#' calculate number of counts per year for each genus
yearly_counts <- surveys_complete %>%
  count(year, genus)

#' line plot with years on the x-axis and counts on the y-axis:
ggplot(data = yearly_counts, aes(x = year, y = n)) +
  geom_line()

#' draw a line for each genus (group)
ggplot(data = yearly_counts, aes(x = year, y = n, group = genus)) +
  geom_line()

#' add colors (color also automatically groups the data):
ggplot(data = yearly_counts, aes(x = year, y = n, color = genus)) +
  geom_line()

#' Integrating the pipe operator with ggplot2
#' pipe operator passes the data argument
yearly_counts %>% 
  ggplot(mapping = aes(x = year, y = n, color = genus)) +
  geom_line()

#' link data manipulation with consequent data visualization.
yearly_counts_graph <- surveys_complete %>%
  count(year, genus) %>% 
  ggplot(mapping = aes(x = year, y = n, color = genus)) +
  geom_line()

yearly_counts_graph

#' Faceting
#' faceting that allows the user to split one plot into multiple
#' plots based on a factor included in the dataset.
ggplot(data = yearly_counts, aes(x = year, y = n)) +
  geom_line() +
  facet_wrap(facets = vars(genus))

#' split the line in each plot by the sex
yearly_sex_counts <- surveys_complete %>%
  count(year, genus, sex)

ggplot(data = yearly_sex_counts,
       mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(facets =  vars(genus))

#' facet both by sex and genus:
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_grid(rows = vars(sex), cols =  vars(genus))

#' organise the panels only by rows (or only by columns):

# One column, facet by rows
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_grid(rows = vars(genus))

# One row, facet by column
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_grid(cols = vars(genus))

#' ggplot2 themes
#' pre-loaded themes available
ggplot(data = yearly_sex_counts, 
       mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  theme_bw()

#' themes: https://ggplot2.tidyverse.org/reference/ggtheme.html
#' theme_minimal() and theme_light() are popular
#' theme_void() a starting point to create a new hand-crafted theme
#' ggthemes package

#' Challenge
#' Use what you just learned to create a plot that depicts how
#' the average weight of each species changes through the years.

#' Customization
#' ggplot2 cheat sheet:
#' https://github.com/rstudio/cheatsheets/raw/master/data-visualization-2.1.pdf

#' change names of axes and add a title
ggplot(data = yearly_sex_counts, aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  labs(title = "Observed genera through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw()

#' increasing the font size
ggplot(data = yearly_sex_counts,
       mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  labs(title = "Observed genera through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(text=element_text(size = 16))

#' change the fonts
#' (on Windows, you may have to install the extrafont package)
#' change the orientation of the labels
ggplot(data = yearly_sex_counts,
       mapping = aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  labs(title = "Observed genera through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(axis.text.x = element_text(colour = "grey20", size = 12,
                                   angle = 90, hjust = 0.5,
                                   vjust = 0.5),
        axis.text.y = element_text(colour = "grey20", size = 12),
        strip.text = element_text(face = "italic"),
        text = element_text(size = 16))

#' save the theme
grey_theme <- theme(
  axis.text.x = element_text(colour="grey20", size = 12,
                             angle = 90, hjust = 0.5, vjust = 0.5),
  axis.text.y = element_text(colour = "grey20", size = 12),
  text=element_text(size = 16)
)

ggplot(surveys_complete, aes(x = species_id, y = hindfoot_length)) +
  geom_boxplot() +
  grey_theme

#' Challenge
#' 
#' With all of this information in hand, please take another five
#' minutes to either improve one of the plots generated in this
#' exercise or create a beautiful graph of your own. Use the
#' RStudio ggplot2 cheat sheet for inspiration.
#' 
#' Here are some ideas:
#' 
#' - See if you can change the thickness of the lines.
#' - Can you find a way to change the name of the legend? What
#'   about its labels?
#' - Try using a different color palette (see
#'   http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/).

#' Arranging plots
#' patchwork: combine separate ggplots into a single figure
install.packages("patchwork")

library(patchwork)

plot1 <- ggplot(data = surveys_complete,
                aes(x = species_id, y = weight)) +
  geom_boxplot() +
  labs(x = "Species", y = expression(log[10](Weight))) +
  scale_y_log10()

plot2 <- ggplot(data = yearly_counts,
                aes(x = year, y = n, color = genus)) +
  geom_line() + 
  labs(x = "Year", y = "Abundance")

plot1 / plot2 + plot_layout(heights = c(3, 2))

#' Exporting plots
#' ggsave() function
library(gridExtra)

my_plot <- ggplot(data = yearly_sex_counts, 
                  aes(x = year, y = n, color = sex)) +
  geom_line() +
  facet_wrap(vars(genus)) +
  labs(title = "Observed genera through time",
       x = "Year of observation",
       y = "Number of individuals") +
  theme_bw() +
  theme(
    axis.text.x = element_text(colour = "grey20", size = 12,
                               angle = 90, hjust = 0.5, vjust = 0.5),
        axis.text.y = element_text(colour = "grey20", size = 12),
        text = element_text(size = 16))

ggsave("fig/name_of_file.png", my_plot, width = 15, height = 10)

## This also works for grid.arrange() plots
combo_plot <- grid.arrange(
  plot1, plot2,
  ncol = 2, widths = c(4, 6))
ggsave("fig/combo_plot_abun_weight.png", combo_plot,
       width = 10, dpi = 300)
