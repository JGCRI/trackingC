
# Settings used by both trackingC_setup.Rmd and trackingC.Rmd

# Read in ini file, initiate new core
ssp245 <- system.file("input/hector_ssp245.ini", package = "hector") 
core <- newcore(ssp245)

# Number of model runs to perform
N_RUNS <- 1000

# We use GitHub Actions to make sure this RMarkdown knits successfully
# But if running there, only do a small number of Hector simulations
if(Sys.getenv("CI") == "true") {
  N_RUNS <- 100
}

# Set range of years for output data
OUTPUT_YEARS <- 1950:2200
