# Parameter analysis round 2
# Leeya Pressburger
# January 2022

# TO DO
# Work on data visualizations, 3 ways

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
  run_number = 1:10,
  "BETA" = rnorm(10, mean = 0.36, sd = 0.036),
  "Q10_RH" = rnorm(10, mean = 2.0, sd = 0.2)
)

# Name and units of parameters
name_vector <- c("BETA" = BETA(), "Q10_RH" = Q10_RH())
units_vector <- c("BETA" = "(unitless)", "Q10_RH" = "(unitless)")

# Function to set parameter values, run Hector, and record tracking data output
# Might modify to just set params and run Hector, tdata separate
run_hector <- function(pdata, c) {
  for(p in colnames(pdata)) {
    message("Setting ", p)
    setvar(c, NA, do.call(p, list()), pdata[p][[1]], units_vector[p])
  }
  setvar(c, NA, TRACKING_DATE(), 1750, NA)
  run(c)
  tdata <- get_tracking_data(c)
  tdata %>% filter(year %in% c(2100:2200))
  
}

# Run function for each row of the runlist
output <- list()

system.time({
  for(row in seq_len(nrow(runlist))) {
    output[[runlist$run_number[row]]] <- run_hector(runlist[row,][-1], core)
  }  
})

# Get output dataframe
output <- bind_rows(output, .id = "run_number")

# Can left join with runlist to get param values
# Make sure data is same class
output$run_number <- as.integer(output$run_number)
output <- left_join(output, runlist)

#Data visualization
#geom_bin for one year 2 vars, line per run

# Part 1: Single pool, variability in runs
atmos <- filter(output, pool_name == "atmos_c")

ggplot(atmos, aes(year, source_fraction, color = run_number, group = run_number)) +
  geom_line() +
  facet_wrap(~source_name, scales = "free") +
  labs(x = "Year",
       y = "Source fraction",
       title = "atmos_c pool") +
  stat_summary(fun=mean, geom = "line", group = "run_number", 
               color = "red", show.legend = TRUE)


# Part 2
# Single pool, time vs source percentage, mean and confidence interval
soil <- atmos %>% 
  filter(source_name == "soil_c") %>%
  group_by(source_name, year) %>%
  mutate(per = quantile(source_fraction, 0.95))

# How to plot mean and 95% percentile
ggplot(soil) +
  geom_line(aes(year, source_fraction, color = run_number, group = run_number)) +
  geom_line(aes(year, per)) +
  labs(x = "Year",
       y = "Source fraction",
       title = "atmos_c pool, soil_c source")


# Not working - need identifier for different beta/q10 values to split up data
ggplot(output, aes(year, source_fraction, fill = source_name)) +
  geom_area() +
  facet_wrap(~pool_name, scales = "free")


# Shutdown core
shutdown(core)


# Notes
# record timings - compare
# set core inside loop
systemtime1 <- c("user" = 35.70, "system" = 0.56, "elapsed" = 36.28)
# set core outside loop
systemtime2 <- c("user" = 16.79, "system" = 0.05, "elapsed" = 16.84)
