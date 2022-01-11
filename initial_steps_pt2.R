library(hector)
library(dplyr)

rcp45 <- file.path("C:\\Users\\pres520\\Documents\\GitHub\\hector\\inst\\input\\hector_rcp45.ini")

set.seed(...)

runlist <- tibble(
  run_number = 1:10,
  "BETA()" = rnorm(10, mean = 0.36, sd = 0.036),
  "Q10_RH()" = rnorm(10, mean = 2.0, sd = 0.2)
)

units <- tibble(
  "BETA()_units" = "(unitless)",
  "Q10_RH()_units" = "(unitless)"
)

run_hector <- function(pdata) {
  core <- newcore(rcp45)
  for(p in pdata) {
    for(u in colnames(pdata)) {
      unit <- select(units, paste0(u, "_units"))
      name <- u
    }
    browser()
    setvar(core, NA, name, p, unit[[1]])
  }
  setvar(core, NA, TRACKING_DATE(), 1750, NA)
  run(core)
  tdata <- get_tracking_data(core)
  tdata$name <- data
  tdata
}

output <- list()

#for(row in seq_len(nrow(runlist))) {
#  output[[run]] <- run_hector(runlist[row,][-1])
#}

run_hector(runlist[1,][-1])


