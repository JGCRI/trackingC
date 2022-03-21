library(tidyr)

# Create runlist of parameters of interest

# Function to access lognorm parameters with a desired mean and standard deviation
# Reference: https://msalganik.wordpress.com/2017/01/21/making-sense-of-the-rlnorm-function-in-r/
lognorm <- function(m, sd){
  location <- log(m^2 / sqrt(sd^2 + m^2))
  shape <- sqrt(log(1+ (sd^2 / m^2)))
  v <- c(location, shape)
}

N_RUNS <- 1000

# We use GitHub Actions to make sure this RMarkdown knits successfully
# But if running there, only do a small number of Hector simulations
if(Sys.getenv("CI") == "true") {
  N_RUNS <- 100
}

# Access number of nodes (if local, will be blank)
if(Sys.getenv("nodes") == ""){
  node <- 1
} else {
  node <- as.numeric(Sys.getenv("nodes"))
}

# Runlist contains run number, job number, parameter, and a random distribution
runlist <- tibble(
  run_number = 1:N_RUNS,
  job_number = rep(1:node, length.out = N_RUNS),
  "BETA" = rnorm(N_RUNS, mean = 0.54, sd = 0.03),
  "Q10_RH" = rlnorm(N_RUNS, lognorm(2, 1.0)[1], lognorm(2, 1.0)[2]),
  # Hector default - note joint with diffusivity
  "ECS" = rlnorm(N_RUNS, lognorm(3, 1.0)[1], lognorm(3, 1.0)[2]),
  "NPP_FLUX0" = rnorm(N_RUNS, mean = 56.2, sd = 5.62),
  # Hector default
  "AERO_SCALE" = rnorm(N_RUNS, mean = 1.0, sd = 0.1),
  # Hector default - note joint with ECS
  "DIFFUSIVITY" = rnorm(N_RUNS, mean = 2.3, sd = 0.23),
)

# Save output with job id
slurm_id <- Sys.getenv("SLURM_JOBID")
write.csv(x = as.data.frame(runlist), file = paste0("./output/runlist_", slurm_id, ".csv"))
