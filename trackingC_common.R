
# Settings used by both trackingC_setup.Rmd and trackingC.Rmd

# Read in ini file, initiate new core
ssp245 <- system.file("input/hector_ssp245.ini", package = "hector") 
core <- newcore(ssp245)

# Extract LUC emissions data
run(core)
luc <- fetchvars(core, core$strtdate:core$enddate, LUC_EMISSIONS())


# Number of model runs to perform
N_RUNS <- 1000

# We use GitHub Actions to make sure this RMarkdown knits successfully
# But if running there, only do a small number of Hector simulations
if(Sys.getenv("CI") == "true") {
  N_RUNS <- 100
}

# Set range of years for output data
OUTPUT_YEARS <- 1950:2200

# Define name and units of all parameters
name_vector <- c("BETA" = BETA(), "Q10_RH" = Q10_RH(), 
                 "ECS" = ECS(), "NPP_FLUX0" = NPP_FLUX0(),
                 "AERO_SCALE" = AERO_SCALE(), "DIFFUSIVITY" = DIFFUSIVITY(),
                 "LUC_SCALAR" = "LUC_SCALAR"
)

units_vector <- c("BETA" = "(unitless)", "Q10_RH" = "(unitless)", 
                  "ECS" = "degC", "NPP_FLUX0" = "Pg C/yr",
                  "AERO_SCALE" = "(unitless)", "DIFFUSIVITY" = "cm2/s",
                  "LUC_SCALAR" = "(unitless)"
)

scalar <- "LUC_SCALAR"
