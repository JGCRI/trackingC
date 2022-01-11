#comments
#geom_bin for one year 2 vars, line per run
library(hector)
library(dplyr)

# change to system.file
rcp45 <- file.path("C:\\Users\\pres520\\Documents\\GitHub\\hector\\inst\\input\\hector_rcp45.ini")

set.seed(10)

runlist <- tibble(
  run_number = 1:10,
  "BETA" = rnorm(10, mean = 0.36, sd = 0.036),
  "Q10_RH" = rnorm(10, mean = 2.0, sd = 0.2)
)

name_vector <- c("BETA" = BETA(), "Q10_RH" = Q10_RH())
units_vector <- c("BETA" = "(unitless)", "Q10_RH" = "(unitless)")

run_hector <- function(pdata) {
  core <- newcore(rcp45) # move outside, core param, reset core in loop, shutdown outside loop
  for(p in colnames(pdata)) {
    message("Setting ", p)
    #do.call(p, list()) to get rid of name_vector
    setvar(core, NA, name_vector[p], pdata[p][[1]], units_vector[p])
  }
  setvar(core, NA, TRACKING_DATE(), 1750, NA)
  run(core)
  get_tracking_data(core)
}

output <- list()
system.time({
  for(row in seq_len(nrow(runlist))) {
    output[[row]] <- run_hector(runlist[row,][-1])
  }  
})


# run_hector(runlist[1,][-1])

# record timings - compare
