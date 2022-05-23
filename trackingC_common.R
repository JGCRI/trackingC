# Settings used by both trackingC_setup.Rmd and trackingC.Rmd

library(hector)

# Number of runs for each SSP scenario
SSP_runs <- c("ssp119" = 500,
              "ssp370" = 500,
              "ssp245" = 1000,
              "ssp460" = 500,
              "ssp585" = 500)

# We use GitHub Actions to make sure this RMarkdown knits successfully
# But if running there, only do a small number of Hector simulations
# Set to a maximum of 100 runs per scenario - some code chunks need at least 100 runs
if(Sys.getenv("CI") == "true") {
  SSP_runs[SSP_runs > 100] <- 100  
}

SSP_files <- system.file(paste0("input/hector_", names(SSP_runs), ".ini"), package = "hector")
names(SSP_files) <- names(SSP_runs)

MAIN_SCENARIO <- "ssp245"

# Set range of years for output data
OUTPUT_YEARS <- 1750:2300

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
