# Settings used by all workflow files.

library(hector)

# Define name and units of all parameters
name_vector <- c("BETA" = BETA(),
                 "Q10_RH" = Q10_RH(), 
                 "ECS" = ECS(), 
                 "NPP_FLUX0" = NPP_FLUX0(),
                 "AERO_SCALE" = AERO_SCALE(), 
                 "DIFFUSIVITY" = DIFFUSIVITY(),
                 "LUC_SCALE" = "LUC_SCALE")

units_vector <- c("BETA" = "(unitless)",
                  "Q10_RH" = "(unitless)", 
                  "ECS" = "degC",
                  "NPP_FLUX0" = "Pg C/yr",
                  "AERO_SCALE" = "(unitless)",
                  "DIFFUSIVITY" = "cm2/s",
                  "LUC_SCALE" = "(unitless)")

scalar_vector <- "LUC_SCALE"

# Number of runs for each SSP scenario
SSP_runs <- c(#"ssp119" = 100,
              "ssp126" = 2500,
              "ssp245" = 2500,
              "ssp370" = 2500,
              #"ssp434" = 100,
              #"ssp460" = 2000,
              #"ssp534-over" = 100,
              "ssp585" = 2500)

# We use GitHub Actions to make sure this RMarkdown knits successfully
# But if running there, only do a small number of Hector simulations
# We need at least twice as many runs as the number of parameters,
# so that calc.relimp() can do its thing later
MIN_RUNS <- length(name_vector) * 2
if(Sys.getenv("CI") == "true") {
  SSP_runs[SSP_runs > MIN_RUNS] <- MIN_RUNS 
}

SSP_files <- system.file(paste0("input/hector_", names(SSP_runs), ".ini"), 
                         package = "hector")
names(SSP_files) <- names(SSP_runs)

MAIN_SCENARIO <- "ssp245"

# Set range of years for output data
OUTPUT_YEARS <- 1750:2300

TRACKING_START <- 1750

# To reduce file size and memory footprint, we only retain
# every SAVE_EVERY_YEARS years; this can be 1 to retain all data
SAVE_EVERY_YEARS <- 1