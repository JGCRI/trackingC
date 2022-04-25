# Parameter analysis round 2
# Leeya Pressburger
# January 2022

library(hector)
library(dplyr)
library(ggplot2)

# Read in ini file, initiate new core
rcp45 <- system.file("input/hector_rcp45.ini", package = "hector") 
core <- newcore(rcp45)

# Random number generator to allow for reproducibility 
set.seed(10)

# Create runlist of parameters of interest
runlist <- tibble(
  run_number = 1:100,
  "BETA" = rnorm(100, mean = 0.36, sd = 0.036),
  "Q10_RH" = rlnorm(100, meanlog = log(2.0), sdlog = 0.2),
  "ECS" = rlnorm(100, meanlog = log(3.0), sdlog = 0.3)
)

# Name and units of parameters
name_vector <- c("BETA" = BETA(), "Q10_RH" = Q10_RH(), "ECS" = ECS())
units_vector <- c("BETA" = "(unitless)", "Q10_RH" = "(unitless)", "ECS" = "degC")

# Function to set parameter values, run Hector, and record tracking data output
# Might modify to just set params and run Hector, tdata separate
run_hector <- function(pdata, c) {
  for(p in colnames(pdata)) {
    message("Setting ", p)
    setvar(c, NA, do.call(p, list()), pdata[p][[1]], units_vector[p])
  }
  setvar(c, NA, TRACKING_DATE(), 1750, NA)
  reset(c)
  run(c)
  tdata <- get_tracking_data(c)
  tdata %>% filter(year %in% c(2100:2200))
  
}

# Run function for each row of the runlist
output <- list()
output_500 <- list()
output_1000 <- list()

system.time({
  for(row in seq_len(nrow(runlist))) {
    output[[runlist$run_number[row]]] <- run_hector(runlist[row,][-1], core)
  }  
})

# Get output dataframe
output <- bind_rows(output, .id = "run_number")
output_500 <- bind_rows(output_500, .id = "run_number")
output_1000 <- bind_rows(output_1000, .id = "run_number")

# Can left join with runlist to get param values
# Make sure data is same class
output$run_number <- as.integer(output$run_number)
output <- left_join(output, runlist)

# Max lines display option
# If there are over 100 observations per time point, we want to use 
# slice_sample() to randomly select rows to plot.
# We want to create a check that accomplishes this.
# max_lines_display <- options(max_lines_display = if(length(unique(output_1000$run_number)) > 101) slice_sample(output_1000, n = 100) -> output_slice)

# Note to self - make sure output dataframe is correctly referenced here
# This is what will go in the ggplot call
max_display <- if(length(unique(output_1000$run_number)) > 101) slice_sample(output_1000, n = 100)

### Data visualization

# Part 1: Single pool, variability in runs
atmos <- output %>%
  filter(pool_name == "atmos_c")
ggplot(atmos, aes(year, source_fraction, color = as.factor(run_number), 
                  group = run_number)) +
  geom_line(size = 0.5, show.legend = FALSE) +
  facet_wrap(~source_name, scales = "free") +
  labs(x = "Year",
       y = "Source fraction",
       title = "atmos_c pool") +
  scale_color_grey(start = 0.7, end = 0.7) +
  # How to get this to appear on legend?
  stat_summary(color = "black",
               fun = median, 
               geom = "line", 
               group = "run_number",
               size = 0.7) +
  theme_light()

# Compute coefficient of variability
atmos2100 <- atmos %>%
  filter(year == "2100") %>%
  group_by(source_name) %>%
  mutate(sdev = sd(source_fraction)) %>%
  mutate(mean = mean(source_fraction)) %>%
  mutate(cv = sdev / mean)

run_colors <- rep("grey60", length(unique(output$run_number)))

ggplot(atmos2100, aes(source_fraction, cv, group = source_name, color = source_name)) +
  geom_point() +
  labs(x = "Source fraction",
       y = "CV",
       title = "atmos_c pool") +
  theme_light()


# Part 2
# Single pool, time vs source percentage, mean and confidence interval
soil <- atmos %>% 
  filter(source_name == "soil_c") %>%
  group_by(year) %>%
  summarize(sf_sd = sd(source_fraction), 
            sf_min = min(source_fraction),
            sf_max = max(source_fraction),
            sf_median = median(source_fraction))


# How to plot mean and 95% percentile - confidence interval
ggplot(soil, aes(year, source_fraction, color = as.factor(run_number), group = run_number)) +
  geom_line(size = 0.5, show.legend = FALSE) +
  scale_color_grey(start = 0.7, end = 0.7) +
  labs(x = "Year",
       y = "Source fraction",
       title = "atmos_c pool, soil_c source") +
  stat_summary(fun = mean, 
               geom = "line", 
               group = "run_number", 
               color = "black",
               size = 0.7)

ggplot(soil, aes(year)) +
  geom_line(aes(y = sf_median)) +
  geom_ribbon(aes(ymin = sf_min, ymax = sf_max), alpha = 0.2) +
  geom_ribbon(aes(ymin = sf_median - sf_sd, ymax = sf_median + sf_sd), alpha = 0.2) +
  labs(x = "Year",
       y = "Source fraction",
       title = "atmos_c pool, soil_c source")

# Part 3
# Single time point, pool, and source - how is the parameter space linked to output?

single <- output_1000 %>%
  filter(pool_name == "atmos_c") %>%
  filter(source_name == "soil_c") %>%
  filter(year == 2100)

ggplot(single, aes(BETA, Q10_RH, color = source_fraction)) +
  geom_point() +
  scale_color_viridis_c() +
  labs(x = "beta",
       y = "Q10",
       title = "Parameter relationship (n = 1000)")

# Trying contours
ggplot(single, aes(x = BETA, y = Q10_RH, color = source_fraction)) +
  geom_density_2d() +
  scale_color_viridis_c() +
  labs(x = "beta",
       y = "Q10",
       title = "Parameter relationship (n = 1000)")

ggsave(plot = three, "param_relationship.jpg", height = 6, width = 9, units = "in")

# Shutdown core
shutdown(core)

# Where does carbon end up?
# We have pool_name, source_name, source_fraction
# Step 1: compute source_quantity = pool_value * source_fraction
# Step 2: for each year and source_name, compute destination_fraction
# group_by(year, source_name) %>% mutate(destination_fraction = source_quantity / sum(source_quantity))

test <- output %>%
  filter(year == 2100) %>%
  mutate(source_quantity = pool_value * source_fraction) %>%
  group_by(year, source_name) %>%
  mutate(destination_fraction = source_quantity / sum(source_quantity))
  
# Notes
# record timings - compare
# set core inside loop
systemtime1 <- c("user" = 35.70, "system" = 0.56, "elapsed" = 36.28)
# set core outside loop
systemtime2 <- c("user" = 16.79, "system" = 0.05, "elapsed" = 16.84)
# run function/loop for 1000 runs - 27.6 minutes
systemtime3 <- c("user" = 1652.38, "system" = 3.28, "elapsed" = 1658.04)
# run function/loop for 1000 runs, 3 params - 35.41 minutes
systemtime4 <- c("user" = 2118.00, "system" = 5.71, "elapsed" = 2124.45)
