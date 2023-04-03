# Settings used by all workflow files.

# Define name and units of all parameters
name_vector <- c("BETA" = BETA(),
                 "Q10_RH" = Q10_RH(), 
                 "ECS" = ECS(), 
                 "NPP_FLUX0" = NPP_FLUX0(),
                 "AERO_SCALE" = AERO_SCALE(), 
                 "DIFFUSIVITY" = DIFFUSIVITY(),
                 "LUC_SCALE" = "LUC_SCALE",
                 "TT" = TT(),
                 "TU" = TU(),
                 "TWI" = TWI(),
                 "TID" = TID())

units_vector <- c("BETA" = "(unitless)",
                  "Q10_RH" = "(unitless)", 
                  "ECS" = "degC",
                  "NPP_FLUX0" = "Pg C/yr",
                  "AERO_SCALE" = "(unitless)",
                  "DIFFUSIVITY" = "cm2/s",
                  "LUC_SCALE" = "(unitless)",
                  "TT" = "m3/s",
                  "TU" = "m3/s",
                  "TWI" = "m3/s",
                  "TID" = "m3/s")

scalar_vector <- "LUC_SCALE"

# Number of runs for each SSP scenario
SSP_runs <- c("ssp126" = 3750,
              "ssp245" = 3750,
              "ssp370" = 3750,
              "ssp585" = 3750)

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

# Labels for plotting
ssp_labels <- c("SSP126", "SSP245", "SSP370", "SSP585")

names(ssp_labels) <- c(names(SSP_runs))

pool_labels <- c("Atmosphere", "Deep ocean", "Detritus", "Anthropogenic emissions",
                 "High-lat ocean", "Intermed. ocean",
                 "Low-lat ocean", "Soil", "Vegetation")

names(pool_labels) <- c("atmos_co2", "deep", "detritus_c", "earth_c", "HL", "intermediate",
                        "LL", "soil_c", "veg_c")

# Ordered pool labels
o_pool_labels <- c("Atmosphere", "Soil", "Vegetation",  "Detritus",
                   "High-lat ocean", "Low-lat ocean",
                   "Intermed. ocean", "Deep ocean")

names(o_pool_labels) <- c("atmos_co2", "soil_c", "veg_c",  "detritus_c",
                          "HL", "LL", "intermediate", "deep")

